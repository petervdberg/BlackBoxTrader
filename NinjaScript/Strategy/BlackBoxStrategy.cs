using NinjaTrader.Indicator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class BlackBoxStrategy : Strategy
    {
        BlackBoxTrader trader;
        protected override void Initialize()
        {
            trader = new BlackBoxTrader(this);
            ExitOnClose = false;
        }

        protected override void OnBarUpdate()
        {   
            trader.OnBarUpdate();
        }

        public void AddIndicator(IndicatorBase indicator)
        {
            Add(indicator);
        }
    }
}
