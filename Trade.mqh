class Trade
{
   protected:
      string symbol;
      int operation;
      double volume;
      double stopLoss;
      double takeProfit;
      int slippage;
      double openPrice;
      int ticket;

   public:
      Trade(string symbol, int operation, double volume, int ticket = 0, double stopLoss = 0.0, double takeProfit = 0.0, int slippage = 0, double openPrice = 0.0)
      {
         this.symbol = symbol;
         this.operation = operation;
         this.volume = volume;
         this.stopLoss = stopLoss;
         this.takeProfit = takeProfit;
         this.slippage = slippage;
         this.openPrice = openPrice;
         this.ticket = ticket;
      }
      
      string GetSymbol()
      {
         return symbol;
      }
      
      int GetOperation()
      {
         return operation;
      }
      
      double GetVolume()
      {
         return volume;
      }
      
      void SetVolume(double value)
      {
         volume = value;
      }
      
      double GetStopLoss()
      {
         return stopLoss;
      }
      
      void SetStopLoss(double value)
      {
         stopLoss = value;
      }
      
      double GetTakeProfit()
      {
         return takeProfit;
      }
      
      void SetTakeProfit(double value)
      {
         takeProfit = value;
      }
      
      int GetSlippage()
      {
         return slippage;
      }
      
      void SetSlippage(int value)
      {
         slippage = value;
      }
      
      double GetOpenPrice()
      {
         return openPrice;
      }
      
      double GetTicket()
      {
         return ticket;
      }
};