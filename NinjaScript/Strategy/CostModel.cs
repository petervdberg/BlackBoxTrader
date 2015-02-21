using NinjaTrader.Cbi;
using NinjaTrader.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class CostModel : ICostModel
    {
        private readonly Strategy strategy;

        public CostModel(Strategy strategy)
        {
            this.strategy = strategy;
        }

        public Dictionary<Instrument, CostForecast> ForecastCosts()
        {
            var forecast = new Dictionary<Instrument, CostForecast>();
            foreach (Bars bars in strategy.BarsArray)
            {
                //No costs are forecasted yet
            }

            return forecast;
        }
    }
}
