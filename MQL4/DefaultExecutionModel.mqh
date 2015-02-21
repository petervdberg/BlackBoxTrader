#include "ExecutionModel.mqh";

class DefaultExecutionModel : public ExecutionModel
{
   private:
      int P;
      
      void OpenOrder(Trade * trade, double lotsNeeded)
      {
         int Ticket = OrderSend(Symbol(), trade.GetOperation(), lotsNeeded, trade.GetOpenPrice(), trade.GetSlippage(), trade.GetStopLoss(), trade.GetTakeProfit());
         if(Ticket > 0)
         {
            if (!OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES))
            {
               Print("Error opening SELL order : ", GetLastError());
            }
         }
      }

      void ModifyOrder(Trade * trade)
      {
         OrderModify(trade.GetTicket(), trade.GetOpenPrice(), trade.GetStopLoss(), trade.GetTakeProfit(), 0);
      }
      void CloseOrder(Trade * trade, double lotsToSell)
      {
         double closePrice = (trade.GetOperation() == OP_SELL ? Ask : Bid);
         OrderClose(trade.GetTicket(), lotsToSell, closePrice, trade.GetSlippage());
      }
      
   public:
      DefaultExecutionModel()
      {
         if(Digits == 5 || Digits == 3 || Digits == 1)
         {
            P = 10;
         }
         else
         {
            P = 1; 
         }
      }

      void Execute(Portfolio * currentPortfolio, Portfolio * newPortfolio)
      {
         for(int i = 0; i < newPortfolio.Size(); i++)
         {
            bool orderExists = False;
            Trade * newTrade = newPortfolio.GetTrade(i);
            Trade * currentTrade;
            if(currentPortfolio.TryGetTrade(newTrade.GetSymbol(), newTrade.GetOperation(), currentTrade))
            {
               orderExists = True;
               double lotsNeeded = newTrade.GetVolume() - currentTrade.GetVolume();
               if(lotsNeeded < 0)
               {
                  CloseOrder(newTrade, -lotsNeeded);
                  continue;
               }
               if(lotsNeeded > 0)
               {
                  if (AccountFreeMargin() < lotsNeeded * (newTrade.GetOpenPrice() + (newTrade.GetSlippage() * P * Point)))
                  {
                     Print(i + ": " + AccountFreeMargin()+" < "+lotsNeeded+" * ("+newTrade.GetOpenPrice()+" + ("+newTrade.GetSlippage()+" * "+P+" * "+Point+"))");
                  }
                  else
                  {
                     OpenOrder(newTrade, lotsNeeded);
                  }
                  continue;
               }
               if(newTrade.GetStopLoss() != currentTrade.GetStopLoss() || newTrade.GetTakeProfit() != currentTrade.GetTakeProfit())
               {
                  ModifyOrder(newTrade);
                  continue;
               }
            }
            
            if(!orderExists && newTrade.GetVolume() > 0)
            {
               OpenOrder(newTrade, newTrade.GetVolume());
            }
         }
      }
};