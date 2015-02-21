using NinjaTrader.Cbi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class TradingPosition : Position
    {
        public double StopLoss;
        public string SignalName
        {
            get
            {
                return MarketPosition.ToString() + "_" + Instrument.FullName;
            }
        }

        public TradingPosition(TradingPosition position)
            : this(position.Account, position.Instrument, position.MarketPosition, position.Quantity, position.Currency, position.AvgPrice, position.StopLoss)
        {
        }

        public TradingPosition(Account account, Instrument instrument, MarketPosition marketPosition, int quantity, Currency currency, double avgPrice)
            : this(account, instrument, marketPosition, quantity, currency, avgPrice, 0.0d)
        {
        }

        public TradingPosition(Account account, Instrument instrument, MarketPosition marketPosition, int quantity, Currency currency, double avgPrice, double stopLoss)
            : base(account, instrument, marketPosition, quantity, currency, avgPrice)
        {
            StopLoss = stopLoss;
        }

        public void AssignFrom(Position position)
        {
            Account = position.Account;
            Instrument = position.Instrument;
            MarketPosition = position.MarketPosition;
            Quantity = position.Quantity;
            Currency = position.Currency;
            AvgPrice = position.AvgPrice;
        }
    }
}
