#include "BlackBoxTrader.mqh"
#include "SmaAtrAlphaModel.mqh"
#include "DefaultRiskModel.mqh"
#include "NoCostModel.mqh"
#include "DirectionBasedPortfolioModel.mqh"
#include "ForexExecutionModel.mqh"

BlackBoxTrader * trader;

void OnInit()
{
   AlphaModel * alphaModel = new SmaAtrAlphaModel(10, 40, 20, 10);
   RiskModel * riskModel = new DefaultRiskModel(30, 30);
   CostModel * costModel = new NoCostModel(3);
   PortfolioModel * portfolioModel = new DirectionBasedPortfolioModel(alphaModel, riskModel, costModel);
   ExecutionModel * executionModel = new ForexExecutionModel();
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