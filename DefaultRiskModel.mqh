#include "RiskModel.mqh";

class DefaultRiskModel : public RiskModel
{
   private:
      double risk;
      bool isYenPair;
      int stopLoss;
      int trailingStop;
      int P; // What is this??
      
      double GetStopLoss(int operation)
      {
         if(stopLoss == 0.0)
         {
            return 0.0;
         }
         else if(operation == OP_BUY)
         {
            return Ask - stopLoss * Point * P;
         }
         else
         { 
            return Bid + stopLoss * Point * P;
         }
      }

      double GetNewStopLoss(int operation)
      {
         if(trailingStop == 0.0)
         {
            return 0.0;
         }
         else if(operation == OP_BUY)
         {
            return Bid - trailingStop * Point * P;
         }
         else
         {
            return Ask + trailingStop * Point * P;
         }
      }
      
      double GetTakeProfit(int operation, int takeProfit)
      {
         if(takeProfit == 0.0)
         {
            return 0.0;
         }
         else if(operation == OP_BUY)
         {
            return Ask + takeProfit * Point * P;
         }
         else
         { 
            return Bid - takeProfit * Point * P;
         }
      }

      bool MustResetStopLoss(Trade * trade)
      {
         double newStopLoss = GetNewStopLoss(trade.GetOperation());
         if(trade.GetOperation() == OP_BUY)
         {
            return trade.GetOpenPrice() < newStopLoss && trade.GetStopLoss() < newStopLoss;
         }
         else
         {
            return trade.GetOpenPrice() > newStopLoss && ((trade.GetStopLoss() > newStopLoss) || (trade.GetStopLoss() == 0));
         }
      }
      
      double GetVolumeBasedOnRisk()
      {
         double pipValueOfInstrument = MarketInfo(Symbol(), MODE_LOTSIZE);
         double stopLossInPips = stopLoss * P * Point;
         double result = risk * AccountBalance() / (stopLossInPips * pipValueOfInstrument);
         if(isYenPair) 
         {
            result *= 100;
         }
         
         return NormalizeDouble(result, 2);      
      }
      
   public:
      DefaultRiskModel(double risk, int stopLoss, int trailingStop)
      {
         this.risk = risk;
         this.stopLoss = stopLoss;
         this.trailingStop = trailingStop;
         if(Digits == 5 || Digits == 3 || Digits == 1)
         {
            P = 10;
         }
         else
         {
            P = 1; 
         }
         if(Digits == 3 || Digits == 2) 
         {
            isYenPair = true;
         }
         else
         {
            isYenPair = false;
         }
      }

      void AlterPortfolioBasedOnRisk(Portfolio * currentPortfolio, Portfolio * newPortfolio)
      {
         double stopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) + MarketInfo(Symbol(), MODE_SPREAD);
      
         if (stopLoss < stopLevel)
         {
            stopLoss = stopLevel;
         }
         
         for(int i = 0; i < newPortfolio.Size(); i++)
         {
            Trade * newTrade = newPortfolio.GetTrade(i);
            if(newTrade.GetVolume() > 0)
            {
               newTrade.SetVolume(GetVolumeBasedOnRisk());
               int operation = newTrade.GetOperation();
               string symbol = newTrade.GetSymbol();
               Trade * currentTrade;
               if(currentPortfolio.TryGetTrade(symbol, operation, currentTrade))
               {
                  if(MustResetStopLoss(currentTrade))
                  {
                     newTrade.SetStopLoss(GetNewStopLoss(operation));
                  }
                  else
                  {
                     newTrade.SetStopLoss(currentTrade.GetStopLoss());
                  }
               }
               else
               {
                  newTrade.SetStopLoss(GetStopLoss(operation));
               }
            }
         }
      }
};