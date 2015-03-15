//+------------------------------------------------------------------+
//|                                           ForexTradingMaster.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#include <http51.mqh>
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+

int httpstatus[1];

int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {

   
   string res = httpGET("http://127.0.0.1:8080/A"+Ask+"A"+Bid, httpstatus);
   
   Comment(res+" "+httpstatus[0]);
    
   
//----
   return(0);
  }
//+------------------------------------------------------------------+