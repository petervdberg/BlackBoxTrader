#include "BlackBoxTrader.mqh"
#include "SmaAlphaModel.mqh"
#include "DefaultRiskModel.mqh"
#include "NoCostModel.mqh"
#include "ForexPortfolioModel.mqh"
#include "ForexExecutionModel.mqh"

BlackBoxTrader * trader;

void OnInit()
{
   AlphaModel * alphaModel = new SmaAlphaModel(10, 40);
   RiskModel * riskModel = new DefaultRiskModel(30, 30);
   CostModel * costModel = new NoCostModel(3);
   PortfolioModel * portfolioModel = new ForexPortfolioModel(alphaModel, riskModel, costModel);
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