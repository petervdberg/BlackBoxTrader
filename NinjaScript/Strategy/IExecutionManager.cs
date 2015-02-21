using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    interface IExecutionManager
    {
        void OnBarUpdate(Portfolio currentPortfolio, Portfolio newPortfolio);
    }
}
