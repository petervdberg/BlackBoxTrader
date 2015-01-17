#include "AlphaModel.mqh";

class RsiAlphaModel : public AlphaModel
{
   private:
      int upperThreshold;
      int lowerLowerThreshold;
      
      bool RsiInUpperZone()
      {
         return (iRSI(NULL,0,14,0,1) > upperThreshold && iRSI(NULL,0,14,0,2) <= upperThreshold);
      }
      
      bool RsiInLowerZone()
      {
         return (iRSI(NULL,0,14,0,1) < lowerLowerThreshold && iRSI(NULL,0,14,0,2) >= lowerLowerThreshold);
      }

   public:
      RsiAlphaModel()
      {
         upperThreshold = 70;
         lowerLowerThreshold = 30;
      }
      
      Forecast * ForecastMarket()
      {
         Direction direction;
         if(RsiInUpperZone())
         {
            direction = dUP;
         }
         else if(RsiInLowerZone())
         {
            direction = dDOWN;
         }
         else
         {
            direction = dNONE;
         }
         
         return new Forecast(direction);
      }
};