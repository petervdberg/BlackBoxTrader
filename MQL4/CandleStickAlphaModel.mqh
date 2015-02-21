#include "AlphaModel.mqh";

class CandleStickAlphaModel : public AlphaModel
{
   private:
      Direction GetCurrentTrend()
      {
         if(Close[1] < Close[2] && Close[2] < Close[3] && Open[2] < Close[3])
         {
            return dDOWN;
         }
         else if(Close[1] > Close[2] && Close[2] > Close[3] && Open[2] > Close[3])
         {
            return dUP;
         }
         else
         {
            return dNONE;
         }
      }

   public:      
      Forecast * CreateForecast()
      {      
         Direction currentTrend = GetCurrentTrend();
         double upShadow = High[1] - MathMax(Open[1], Close[1]);
         double downShadow = MathMin(Open[1], Close[1]) - Low[1];
         double body = MathAbs(Close[1] - Open[1]);
         if(currentTrend == dUP)
         {
            if(upShadow > 2 * body && downShadow < body)
            {
               return new Forecast(dDOWN, 1);
            }
         }
         else if(currentTrend == dDOWN)
         {
            if(downShadow > 2 * body && upShadow < body)
            {
               return new Forecast(dUP, 1);
            }
         }
         
         return new Forecast(GetCurrentTrend(), 0);
      }
};