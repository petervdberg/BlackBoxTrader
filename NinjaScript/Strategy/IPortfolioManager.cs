using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    interface IPortfolioManager
    {
        void OnBarUpdate();
        Portfolio CurrentPortfolio { get; }
        Portfolio NewPortfolio { get; }
    }
}
