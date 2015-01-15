#include "Portfolio.mqh";

class RiskModel
{
   private:
   public:
      virtual void AlterPortfolioBasedOnRisk(Portfolio * currentPortfolio, Portfolio * newPortfolio)
      {
      }
};