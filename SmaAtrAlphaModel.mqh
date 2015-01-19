#include "AlphaModel.mqh";

class SmaAtrAlphaModel : public AlphaModel
{
   private:
      int shortSmaPeriod;
      int longSmaPeriod;
      int atrPeriod;
      int shiftDistance;
      
      bool ShortCrossover()
      {
         return iMA(NULL, 0, longSmaPeriod, 0, MODE_SMA, PRICE_CLOSE, 2)  > iMA(NULL, 0, shortSmaPeriod, 0, MODE_SMA, PRICE_CLOSE, 2) 
             && iMA(NULL, 0, shortSmaPeriod, 0, MODE_SMA, PRICE_CLOSE, 1) >= iMA(NULL, 0, longSmaPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
      }

      bool LongCrossover()
      {
         return iMA(NULL, 0, shortSmaPeriod, 0, MODE_SMA, PRICE_CLOSE, 2) > iMA(NULL, 0, longSmaPeriod, 0, MODE_SMA, PRICE_CLOSE, 2) 
             && iMA(NULL, 0, longSmaPeriod, 0, MODE_SMA, PRICE_CLOSE, 1)  >= iMA(NULL, 0, shortSmaPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
      }
      
      bool GrowingVolatility()
      {
         return iATR(NULL, 0, atrPeriod, 1) > iATR(NULL, 0, atrPeriod, 1 + shiftDistance);
      }

   public:
      SmaAtrAlphaModel(int shortSmaPeriod, int longSmaPeriod, int atrPeriod, int shiftDistance)
      {
         this.shortSmaPeriod = shortSmaPeriod;
         this.longSmaPeriod = longSmaPeriod;
         this.atrPeriod = atrPeriod;
         this.shiftDistance = shiftDistance;
      }
      
      Forecast * CreateForecast()
      {
         Direction direction;         
         if(GrowingVolatility() && ShortCrossover())
         {
            direction = dUP;
         }
         else if(GrowingVolatility() && LongCrossover())
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