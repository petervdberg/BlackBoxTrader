using NinjaTrader.Cbi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    struct RiskForecast
    {
        public readonly double Volitality;
        public readonly Dictionary<Instrument, double> Dispersion;

        public RiskForecast(double volitality, Dictionary<Instrument, double> dispersion)
        {
            Volitality = volitality;
            Dispersion = dispersion;
        }
    }
}
