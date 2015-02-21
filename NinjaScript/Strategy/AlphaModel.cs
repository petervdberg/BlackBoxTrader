using NinjaTrader.Cbi;
using NinjaTrader.Data;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class AlphaModel : IAlphaModel
    {
        private readonly Strategy strategy;
        private const int shortPeriod = 10;
        private const int longPeriod = 25;

        public AlphaModel(Strategy strategy)
        {
            this.strategy = strategy;
            strategy.SMA(shortPeriod).Plots[0].Pen.Color = Color.Orange;
            strategy.SMA(longPeriod).Plots[0].Pen.Color = Color.Green;
            ((BlackBoxStrategy)strategy).AddIndicator(strategy.SMA(shortPeriod));
            ((BlackBoxStrategy)strategy).AddIndicator(strategy.SMA(longPeriod));
        }

        public Dictionary<Instrument, SignalForecast> ForecastSignals()
        {
            var forecast = new Dictionary<Instrument, SignalForecast>();
            foreach (Bars bars in strategy.BarsArray)
            {
                if (strategy.CrossAbove(strategy.SMA(bars, shortPeriod), strategy.SMA(bars, longPeriod), 1))
                {
                    forecast.Add(bars.Instrument, new SignalForecast(Signal.EnterLong));
                }
                else if (strategy.CrossBelow(strategy.SMA(bars, shortPeriod), strategy.SMA(bars, longPeriod), 1))
                {
                    forecast.Add(bars.Instrument, new SignalForecast(Signal.EnterShort));
                }
                else
                {
                    forecast.Add(bars.Instrument, new SignalForecast(Signal.None));
                }
            }

            return forecast;
        }
    }
}
