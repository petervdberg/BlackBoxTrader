#include "PortfolioModel.mqh";

class ForexPortfolioModel : public PortfolioModel
{
   private:
      int P; // What is P??
      
      Portfolio * CunstructPortfolioFromPrediction(Portfolio * currentPortfolio)
      {
         Portfolio * newPortfolio;
         Forecast * forecast = alphaModel.ForecastMarket();
         
         Trade * currentTrade;
         Trade * newTrade; //No block scope..?
         if(forecast.GetDirection() == dUP || forecast.GetDirection() == dDOWN)
         {
            newPortfolio = new Portfolio();
            if(currentPortfolio.TryGetTrade(Symbol(), (forecast.GetDirection() == dUP ? OP_SELL : OP_BUY), currentTrade))
            {
               newTrade = new Trade(currentTrade.GetSymbol(), currentTrade.GetOperation(), 0.0, currentTrade.GetTicket());
               newPortfolio.AddTrade(newTrade);               
            }
            newTrade = new Trade(Symbol(), (forecast.GetDirection() == dUP ? OP_BUY : OP_SELL), 1.0);
            newPortfolio.AddTrade(newTrade);
         }
         else
         {
            newPortfolio = currentPortfolio.Clone();
         }
         
         delete forecast;
         
         return newPortfolio;
      }

   public:
      ForexPortfolioModel(AlphaModel * alphaModel, RiskModel * riskModel, CostModel * costModel)
         : PortfolioModel(alphaModel, riskModel, costModel)
      {
      }
      
      Portfolio * ConstructPortfolio()
      {
         Portfolio * currentPortfolio = Portfolio::GetCurrent();
         Portfolio * newPortfolio = CunstructPortfolioFromPrediction(currentPortfolio);
         riskModel.AlterPortfolioBasedOnRisk(currentPortfolio, newPortfolio);
         delete currentPortfolio;
         
         return newPortfolio;
      }
};