#include "AlphaModel.mqh";

class RsiAlphaModel : public AlphaModel
{
   private:
      int shortPeriod;
      int longPeriod;
      
      bool RsiInSellZone()
      {
         return (iRSI(NULL,0,14,0,1) > 70 && iRSI(NULL,0,14,0,2) <= 70);
      }
      
      bool RsiInBuyZone()
      {
         return (iRSI(NULL,0,14,0,1) < 30 && iRSI(NULL,0,14,0,2) >= 30);
      }

   public:
      RsiAlphaModel()
      {
         shortPeriod = 10;
         longPeriod = 40;
      }
      
      Forecast * ForecastMarket()
      {
         Direction direction;
         if(RsiInBuyZone())
         {
            direction = dUP;
         }
         else if(RsiInSellZone())
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