using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    struct SignalForecast
    {
        public readonly Signal Signal;
        public readonly double Magnitude;
        public readonly int Duration;
        public readonly double Probability;

        public SignalForecast(Signal signal)
            : this(signal, 0.0d, 0, 0.0d)
        {
        }

        public SignalForecast(Signal signal, double magnitude, int duration, double probability)
        {
            Signal = signal;
            Magnitude = magnitude;
            Duration = duration;
            Probability = probability;
        }
    }
}
