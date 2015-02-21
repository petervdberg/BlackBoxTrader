using NinjaTrader.Cbi;
using NinjaTrader.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class PortfolioManager : IPortfolioManager
    {
        private readonly Strategy strategy;
        private readonly IAlphaModel alphamodel;
        private readonly IRiskModel riskModel;
        private readonly ICostModel costModel;
        private readonly List<Portfolio> portfolios = new List<Portfolio>();

        public PortfolioManager(Strategy strategy, IAlphaModel alphamodel, IRiskModel riskModel, ICostModel costModel)
        {
            this.strategy = strategy;
            this.alphamodel = alphamodel;
            this.riskModel = riskModel;
            this.costModel = costModel;
            portfolios.Add(new Portfolio());
            portfolios.Add(new Portfolio());
        }

        public void OnBarUpdate()
        {
            portfolios.Last().UpdateWithFactualData(strategy.Positions);
            portfolios.Add(ConstructNewPortfolio());
        }

        private Portfolio ConstructNewPortfolio()
        {
            Portfolio newPortfolio = portfolios.Last().Clone(strategy);

            Dictionary<Instrument, SignalForecast> forecastedSignals = alphamodel.ForecastSignals();
            Dictionary<Instrument, RiskForecast> forecastedRisks = riskModel.ForecastRisks();
            Dictionary<Instrument, CostForecast> forecastedCosts = costModel.ForecastCosts();
            foreach (Bars bars in strategy.BarsArray)
            {
                if (forecastedSignals[bars.Instrument].Signal != Signal.None)
                {
                    TradingPosition position;
                    if(!newPortfolio.TryGetPosition(bars.Instrument, out position))
                    {
                        AddNewPostion(newPortfolio, forecastedSignals[bars.Instrument].Signal, bars);
                    }
                    else if ((int)position.MarketPosition != (int)forecastedSignals[bars.Instrument].Signal)
                    {
                        newPortfolio.RemovePosition(position);
                        AddNewPostion(newPortfolio, forecastedSignals[bars.Instrument].Signal, bars);
                    }
                }
            }

            return newPortfolio;
        }

        private void AddNewPostion(Portfolio portfolio, Signal signal, Bars bars)
        {
            int quantity = 1;
            MarketPosition position;
            double price;

            switch (signal)
            {
                case Signal.EnterLong:
                    position = MarketPosition.Long;
                    price = bars.CurrentAsk;
                    break;
                case Signal.EnterShort:
                    position = MarketPosition.Short;
                    price = bars.CurrentAsk;
                    break;
                case Signal.ExitLong:
                    position = MarketPosition.Long;
                    price = bars.CurrentBid;
                    break;
                case Signal.ExitShort:
                    position = MarketPosition.Short;
                    price = bars.CurrentBid;
                    break;
                default:
                    throw new InvalidOperationException(string.Format("The signal '{0}' is not supported.", signal.ToString()));
            }

            portfolio.AddPosition(new TradingPosition(
                strategy.Account,
                bars.Instrument,
                position,
                quantity,
                bars.Instrument.MasterInstrument.Currency,
                price));
        }

        public Portfolio NewPortfolio
        {
            get
            {
                return portfolios[portfolios.Count - 1];
            }
        }

        public Portfolio CurrentPortfolio
        {
            get
            {
                return portfolios[portfolios.Count - 2];
            }
        }
    }
}
