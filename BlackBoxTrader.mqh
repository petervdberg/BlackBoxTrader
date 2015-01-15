#include "PortFolioModel.mqh";
#include "ExecutionModel.mqh";

class BlackBoxTrader
{
   private:
      PortfolioModel * portfolioModel;
      ExecutionModel * executionModel;
	  
   public:
      BlackBoxTrader(PortfolioModel * portfolioModel, ExecutionModel * executionModel)
      {
         this.portfolioModel = portfolioModel;
         this.executionModel = executionModel;
      }
      
      ~BlackBoxTrader()
      {
         delete portfolioModel;
         delete executionModel;
      }
      
	   void OnTick()
      {
         Portfolio * currentPortfolio = Portfolio::GetCurrent();
         Portfolio * newPortfolio = portfolioModel.ConstructPortfolio();
         executionModel.Execute(currentPortfolio, newPortfolio);
         
         delete currentPortfolio;
         delete newPortfolio;
      
      };
};