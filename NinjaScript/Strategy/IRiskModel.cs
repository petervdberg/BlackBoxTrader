using NinjaTrader.Cbi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    interface IRiskModel
    {
        Dictionary<Instrument, RiskForecast> ForecastRisks();
    }
}
