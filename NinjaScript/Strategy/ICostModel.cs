using NinjaTrader.Cbi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    interface ICostModel
    {
        Dictionary<Instrument, CostForecast> ForecastCosts();
    }
}
