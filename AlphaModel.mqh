#include "Forecast.mqh";

class AlphaModel
{
   public:
      virtual Forecast * CreateForecast()
      {
         return NULL;
      }
};