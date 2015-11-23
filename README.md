# BlackBoxTrader
In his book "Inside the black box" Rishi Narang describes a general framework for quantitative trading. Following his description, I created this framwork such that it can be used to implement any trading strategy, really.

I have created more or less equivalent implementations in two different languages:
 - One in MQL4 for MetaTrader 4
 - One in NinjaScript (C#) for NinjaTrader

The black box trader consists of:
 - An alpha model
 - A risk model
 - A cost model
 - A portfolio manager
 - An execution manager
