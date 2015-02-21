using NinjaTrader.Cbi;
using NinjaTrader.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class ExecutionManager : IExecutionManager
    {
        private readonly Strategy strategy;

        public ExecutionManager(Strategy strategy)
        {
            this.strategy = strategy;
        }

        public void OnBarUpdate(Portfolio currentPortfolio, Portfolio newPortfolio)
        {
            IEnumerable<TradingPosition> exitPositions = currentPortfolio.Positions.Except(newPortfolio.Positions);
            IEnumerable<TradingPosition> enterPositions = newPortfolio.Positions.Except(currentPortfolio.Positions);
            IEnumerable<TradingPosition> updatePositions = newPortfolio.Positions.Except(enterPositions).Except(exitPositions);

            foreach (TradingPosition position in exitPositions)
            {
                ExitPosition(position);
            }

            foreach (TradingPosition position in enterPositions)
            {
                EnterPosition(position);
            }

            foreach (TradingPosition position in updatePositions)
            {
                int quantityDifference = position.Quantity - currentPortfolio.GetPosition(position.Instrument).Quantity;
                UpdatePosition(position, quantityDifference);
            }
        }

        private void ExitPosition(TradingPosition position)
        {
            if (position.MarketPosition == MarketPosition.Long)
            {
                strategy.ExitLong(GetBarsIndex(position.Instrument), position.Quantity, position.SignalName, position.SignalName);
            }
            else if (position.MarketPosition == MarketPosition.Short)
            {
                strategy.ExitShort(GetBarsIndex(position.Instrument), position.Quantity, position.SignalName, position.SignalName);
            }
            else
            {
                throw new InvalidOperationException(string.Format("The market position '{0}' is not supported.", position.MarketPosition));
            }
        }

        private void EnterPosition(TradingPosition position)
        {
            if (position.MarketPosition == MarketPosition.Long)
            {
                strategy.EnterLong(GetBarsIndex(position.Instrument), position.Quantity, position.SignalName);
            }
            else if (position.MarketPosition == MarketPosition.Short)
            {
                strategy.EnterShort(GetBarsIndex(position.Instrument), position.Quantity, position.SignalName);
            }
            else
            {
                throw new InvalidOperationException(string.Format("The market position '{0}' is not supported.", position.MarketPosition));
            }
        }

        private void UpdatePosition(TradingPosition position, int quantityDifference)
        {
            TradingPosition deltaPosition = new TradingPosition(position);
            deltaPosition.Quantity = Math.Abs(quantityDifference);
            if (quantityDifference > 0)
            {
                EnterPosition(deltaPosition);
            }
            else if(quantityDifference < 0)
            {
                ExitPosition(deltaPosition);
            }
            else
            {
                //Noop when there is no quantity difference
            }
        }

        private int GetBarsIndex(Instrument instrument)
        {
            for (int i = 0; i < strategy.BarsArray.Count(); i++)
            {
                if (strategy.BarsArray[i].Instrument == instrument)
                {
                    return i;
                }
            }

            throw new InvalidOperationException(string.Format("There is no valid bars index for the intrument '{0}'.", instrument.FullName));
        }
    }
}
