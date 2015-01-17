#include "CostModel.mqh";

class NoCostModel : public CostModel
{
   private:
      int slippage;
      
   public:
      NoCostModel(int slippage)
      {
         this.slippage = slippage;
      }
      
      void AlterPortfolioBasedOnCosts(Portfolio * portfolio)
      {
         for(int i = 0; i < portfolio.Size(); i++)
         {
            Trade * trade = portfolio.GetTrade(i);
            trade.SetSlippage(slippage);
         }
      }
};