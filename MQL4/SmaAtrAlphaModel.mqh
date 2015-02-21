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
      
      double VolatilityDifference()
      {
         double result = iATR(NULL, 0, atrPeriod, 1) - iATR(NULL, 0, atrPeriod, 1 + shiftDistance);
         if(result < 0)
         {
            result = -1;
         }
         return result;
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
         double magnitude;      
         if(ShortCrossover())
         {
            direction = dUP;
            magnitude = VolatilityDifference();
         }
         else if(LongCrossover())
         {
            direction = dDOWN;
            magnitude = VolatilityDifference();
         }
         else
         {
            direction = dNONE;
            magnitude = -1;            
         }
         
         return new Forecast(direction, magnitude);
      }
};