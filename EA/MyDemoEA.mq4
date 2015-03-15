//+------------------------------------------------------------------+
//|                                                MT4PipeClient.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| Global Display Functions                                 |
//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {

    double marketspread = MarketInfo( Symbol(), MODE_SPREAD );
    double marketpoint = MarketInfo( Symbol(), MODE_POINT );
    double marketstoplevel = MarketInfo( Symbol(), MODE_STOPLEVEL );
    Print( "version 1.2 marketspread = ", marketspread);
    Print( "version 1.2 marketpoint = ", marketpoint);
    Print( "version 1.2 marketstoplevel = ", marketstoplevel);

   

   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {

   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

int start()
  {
//----
	
	
//----
   return(0);
}
//+------------------------------------------------------------------+