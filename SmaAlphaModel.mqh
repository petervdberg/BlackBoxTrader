#include "AlphaModel.mqh";

class SmaAlphaModel : public AlphaModel
{
   private:
      int shortPeriod;
      int longPeriod;
      
      bool ShortCrossover()
      {
         return iMA(NULL, 0, longPeriod, 0, MODE_SMA, PRICE_CLOSE, 2)  > iMA(NULL, 0, shortPeriod, 0, MODE_SMA, PRICE_CLOSE, 2) 
             && iMA(NULL, 0, shortPeriod, 0, MODE_SMA, PRICE_CLOSE, 1) >= iMA(NULL, 0, longPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
      }

      bool LongCrossover()
      {
         return iMA(NULL, 0, shortPeriod, 0, MODE_SMA, PRICE_CLOSE, 2) > iMA(NULL, 0, longPeriod, 0, MODE_SMA, PRICE_CLOSE, 2) 
             && iMA(NULL, 0, longPeriod, 0, MODE_SMA, PRICE_CLOSE, 1)  >= iMA(NULL, 0, shortPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
      }

   public:
      SmaAlphaModel(int shortPeriod, int longPeriod)
      {
         shortPeriod = shortPeriod;
         longPeriod = longPeriod;
      }
      
      Forecast * ForecastMarket()
      {
         Direction direction;
         if(ShortCrossover())
         {
            direction = dUP;
         }
         else if(LongCrossover())
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