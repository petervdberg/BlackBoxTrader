using NinjaTrader.Cbi;
using NinjaTrader.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class RiskModel : IRiskModel
    {
        private readonly Strategy strategy;

        public RiskModel(Strategy strategy)
        {
            this.strategy = strategy;
        }
        
        public Dictionary<Instrument, RiskForecast> ForecastRisks()
        {
            var forecast = new Dictionary<Instrument, RiskForecast>();
            foreach (Bars bars in strategy.BarsArray)
            {
                //No risks are forecasted yet
            }

            return forecast;
        }
    }
}
