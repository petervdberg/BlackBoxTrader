#include "Trade.mqh";

class Portfolio
{
   private:
      Trade * trades[];

   public:
      Portfolio()
      { 
         ArrayResize(trades, 0);
      }
      
      ~Portfolio()
      {
         int tradeSize = Size();
         for(int i = tradeSize - 1; i >= 0; i--)
         {
            delete trades[i];
         }
      }
      
      static Portfolio * GetCurrent()
      {
         Portfolio * result = new Portfolio();
         
         for (int i = 0; i < OrdersTotal(); i ++)
         {
            OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
            Trade * trade = new Trade(OrderSymbol(), OrderType(), OrderLots(), OrderTicket(), OrderStopLoss(), OrderTakeProfit(), 0, OrderOpenPrice());     
            result.AddTrade(trade); 
         }
         
         return result;
      }
      
      Portfolio * Clone()
      {
         Portfolio * result = new Portfolio();
         
         for (int i = 0; i < Size(); i ++)
         {
            Trade * trade = GetTrade(i);
            Trade * resultTrade = new Trade(trade.GetSymbol(), trade.GetOperation(), trade.GetVolume(), trade.GetTicket(), trade.GetStopLoss(), trade.GetTakeProfit(), trade.GetSlippage(), trade.GetOpenPrice());
            result.AddTrade(resultTrade); 
         }
         
         return result;
      }
      
      void AddTrade(Trade * trade)
      {
         int tradeSize = Size();
         ArrayResize(trades, tradeSize + 1);
         trades[tradeSize] = trade; 
      }
      
      Trade * GetTrade(int i)
      {
         return trades[i];
      }
      
      int Size()
      {
         return ArraySize(trades);
      }
      
      bool HasTrade(string symbol, int operation)
      {
         bool result = False;
         for(int i = 0; i < Size(); i++)
         {
            Trade * trade = GetTrade(i);
            if(trade.GetSymbol() == symbol && trade.GetOperation() == operation)
            {
               result = True;
            }
         }
         return result;
      }
      
      bool TryGetTrade(string symbol, int operation, Trade *& outTrade)
      {
         bool result = False;
         for(int i = 0; i < Size(); i++)
         {
            Trade * trade = GetTrade(i);
            if(trade.GetSymbol() == symbol && trade.GetOperation() == operation)
            {
               outTrade = trade;
               result = True;
            }
         }
         
         return result;
      }
};