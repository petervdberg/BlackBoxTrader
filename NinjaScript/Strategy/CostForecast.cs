using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    struct CostForecast
    {
        public readonly double Commission;
        public readonly double Slippage;
        public readonly double MarketImpact;

        public CostForecast(double commission, double slippage, double marketImpact)
        {
            Commission = commission;
            Slippage = slippage;
            MarketImpact = marketImpact;
        }
    }
}
