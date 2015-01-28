#include "PortfolioModel.mqh";

class DirectionBasedPortfolioModel : public PortfolioModel
{
   private:
      int P; // What is P??
      
      Portfolio * CunstructPortfolioFromPrediction(Portfolio * currentPortfolio)
      {
         Portfolio * newPortfolio;
         Forecast * forecast = alphaModel.CreateForecast();
         int operation = (forecast.GetDirection() == dUP ? OP_BUY : OP_SELL);
         int inverseOperation = (forecast.GetDirection() == dUP ? OP_SELL : OP_BUY);
         
         if(!currentPortfolio.HasTrade(Symbol(), operation) && forecast.GetDirection() != dNONE)
         {
            newPortfolio = new Portfolio();
            Trade * currentTrade;
            if(currentPortfolio.TryGetTrade(Symbol(), inverseOperation, currentTrade))
            {
               newPortfolio.AddTrade(new Trade(currentTrade.GetSymbol(), currentTrade.GetOperation(), 0.0, currentTrade.GetOpenPrice(), currentTrade.GetTicket()));               
            }
            
            if(forecast.GetMagnitude() > 0)
            {
               newPortfolio.AddTrade(new Trade(Symbol(), operation, 1.0, (forecast.GetDirection() == dUP ? Ask : Bid)));
            }
         }
         else
         {
            newPortfolio = currentPortfolio.Clone();
         }
         
         delete forecast;
         
         return newPortfolio;
      }

   public:
      DirectionBasedPortfolioModel(AlphaModel * alphaModel, RiskModel * riskModel, CostModel * costModel)
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