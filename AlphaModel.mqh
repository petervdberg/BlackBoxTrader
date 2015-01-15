#include "Forecast.mqh";

class AlphaModel
{
   public:
      virtual Forecast * ForecastMarket()
      {
         return NULL;
      }
};