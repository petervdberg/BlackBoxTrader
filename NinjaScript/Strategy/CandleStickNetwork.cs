using NeuronDotNet.Core;
using NeuronDotNet.Core.Backpropagation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NinjaTrader.Data;
using NinjaTrader.Cbi;

namespace NinjaTrader.Strategy
{
    class CandleStickNetwork
    {
        private BackpropagationNetwork network;
        private int candleSticks;
        private int totalRounds;
        private double min;
        private double max;
        private int round;
        IDataSeries open;
        IDataSeries close;
        IDataSeries low;
        IDataSeries high;
        IDataSeries volume;
        double tickSize;
        int precision;

        public CandleStickNetwork(
            int candleSticks, 
            int totalRounds, 
            IDataSeries open, 
            IDataSeries close, 
            IDataSeries low, 
            IDataSeries high, 
            IDataSeries volume, 
            double tickSize, 
            double min, 
            double max, 
            TrainingSampleEventHandler EndSampleEvent)
        {
            this.candleSticks = candleSticks;
            this.totalRounds = totalRounds;
            this.min = min;
            this.max = max;
            this.open = open;
            this.close = close;
            this.low = low;
            this.high = high;
            this.volume = volume;
            this.tickSize = tickSize;
            precision = (int)Math.Abs(Math.Log(tickSize));
            round = 1;
            LinearLayer inputLayer = new LinearLayer(4 * candleSticks);
            SineLayer hiddenLayer = new SineLayer(candleSticks);
            SineLayer outputLayer = new SineLayer(1);
            new BackpropagationConnector(inputLayer, hiddenLayer);
            new BackpropagationConnector(hiddenLayer, outputLayer);
            network = new BackpropagationNetwork(inputLayer, outputLayer);
            network.EndSampleEvent += EndSampleEvent;
            network.SetLearningRate(0.25d);
        }

        public double Open
        {
            get
            {
                return open[round];
            }
        }

        public double Close
        {
            get
            {
                return close[round];
            }
        }
        
        public double ExpectedOutput
        {
            get 
            {
                double maxValue = 0;
                double minValue = 0;
                for (int i = 0; i < candleSticks; i++)
                {
                    double body = close[round + i] - open[round + i];
                    maxValue = Math.Max(maxValue, body);
                    minValue = Math.Min(minValue, body);
                }
                if (maxValue >= Math.Abs(minValue))
                {
                    return Math.Round(Math.Min(1, maxValue / (tickSize * 10)), precision);
                }
                else
                {
                    return Math.Round(Math.Max(-1, minValue / (tickSize * 10)), precision);
                }
            }
        }

        public void Learn()
        {
            if (round >= candleSticks * 3)
            {
                double[] inputVector = new double[4 * candleSticks];
                for (int i = 0; i < candleSticks; i++)
                {
                    int candleStick = round + candleSticks + i;

                    inputVector[i] = high[candleStick];
                    inputVector[i + candleSticks] = low[candleStick];
                    inputVector[i + candleSticks * 2] = close[candleStick];
                    inputVector[i + candleSticks * 3] = open[candleStick];
                }
                TrainingSample sample = new TrainingSample(inputVector, new double[1] { ExpectedOutput });
                network.Learn(sample, round - candleSticks, totalRounds - (candleSticks - 1));
            }
            round++;
        }

        public double[] Output
        {
            get
            {
                return network.OutputLayer.GetOutput();
            }
        }

        public double Error
        {
            get
            {
                return network.MeanSquaredError;
            }
        }

        public int CandleSticks
        {
            get
            {
                return candleSticks;
            }
        }
    }
}
