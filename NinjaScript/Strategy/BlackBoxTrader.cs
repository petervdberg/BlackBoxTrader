using NinjaTrader.Cbi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NinjaTrader.Strategy
{
    class BlackBoxTrader
    {
        private readonly IPortfolioManager portfolioManager;
        private readonly IExecutionManager executionManager;

        public BlackBoxTrader(Strategy strategy)
        {
            portfolioManager = new PortfolioManager(strategy, new AlphaModel(strategy), new RiskModel(strategy), new CostModel(strategy));
            executionManager = new ExecutionManager(strategy);
        }

        internal void OnBarUpdate()
        {
            portfolioManager.OnBarUpdate();
            executionManager.OnBarUpdate(portfolioManager.CurrentPortfolio, portfolioManager.NewPortfolio);
        }
    }
}
