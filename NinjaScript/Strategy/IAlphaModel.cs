using NinjaTrader.Cbi;
using NinjaTrader.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    interface IAlphaModel
    {
        Dictionary<Instrument, SignalForecast> ForecastSignals();
    }
}
