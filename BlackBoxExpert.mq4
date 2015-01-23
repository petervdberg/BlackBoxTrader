#include "BlackBoxTrader.mqh"
#include "SmaAtrAlphaModel.mqh"
#include "DefaultRiskModel.mqh"
#include "DefaultCostModel.mqh"
#include "DirectionBasedPortfolioModel.mqh"
#include "DefaultExecutionModel.mqh"

BlackBoxTrader * trader;

void OnInit()
{
   AlphaModel * alphaModel = new SmaAtrAlphaModel(10, 40, 20, 10);
   RiskModel * riskModel = new DefaultRiskModel(30, 30);
   CostModel * costModel = new DefaultCostModel(3);
   PortfolioModel * portfolioModel = new DirectionBasedPortfolioModel(alphaModel, riskModel, costModel);
   ExecutionModel * executionModel = new DefaultExecutionModel();
   trader = new BlackBoxTrader(portfolioModel, executionModel);
}

void OnDeinit(const int reason)
{
   delete trader;
}

void OnTick()
{
   trader.OnTick();
}