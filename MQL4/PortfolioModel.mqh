#include "AlphaModel.mqh"
#include "RiskModel.mqh"
#include "CostModel.mqh"
#include "Portfolio.mqh";

class PortfolioModel
{
   protected:
      AlphaModel * alphaModel;
      RiskModel * riskModel;
      CostModel * costModel;
   
   public:
      PortfolioModel(AlphaModel * alphaModel, RiskModel * riskModel, CostModel * costModel)
      {
         this.alphaModel = alphaModel;
         this.riskModel = riskModel;
         this.costModel = costModel;
      }

      ~PortfolioModel()
      {
         delete alphaModel;
         delete riskModel;
         delete costModel;
      }

      virtual Portfolio * ConstructPortfolio()
      {
         return NULL;
      }
};