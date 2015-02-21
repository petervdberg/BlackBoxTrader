#include "Portfolio.mqh";

class CostModel
{
   public:
      virtual void AlterPortfolioBasedOnCosts(Portfolio * portfolio) 
      {
      }
};