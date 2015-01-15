class Forecast
{
   private:
      enum Direction
      {
         dUP,
         dDOWN,
         dNONE
      };
      Direction direction;
      double magnitude;
      int duration;
      double probability;
      
   public:      
      Forecast(Direction direction, double magnitude = -1, int duration = -1, double probability = -1)
      {
         this.direction = direction;
         this.magnitude = magnitude;
         this.duration = duration;
         this.probability = probability;
      };
      
      Direction GetDirection()
      {
         return direction;
      }
      
      double GetMagnitude()
      {
         return magnitude;
      }
      
      int GetDuration()
      {
         return duration;
      }
      
      double GetProbability()
      {
         return probability;
      }
};