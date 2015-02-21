#include "Portfolio.mqh";

class ExecutionModel
{
   public:
      virtual void Execute(Portfolio * currentPortfolio, Portfolio * newPortfolio)
      {
      }
};