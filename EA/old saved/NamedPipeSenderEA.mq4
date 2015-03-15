//+------------------------------------------------------------------+
//|                                            NamedPipeSenderEA.mq4 |
//|                      Copyright ? 2009, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ? 2009, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#include <NamedPipeClient.mqh>
#property show_inputs

extern string  ServerName = "PipeTest";
extern string  Message = "Hello!";
extern int     RetryForSeconds = 0;


//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
//create connnection
   Print("create connection");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   //close connection
   Print("close connection");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

int start()
  {
   if (!IsDllsAllowed()) {
   
      MessageBox("You need to turn on \'Allow DLL imports\'");
   } 
   else 
   {
      if (SendPipeMessage(ServerName, Message, RetryForSeconds)) {
         Print("Message succeeded (but may not have been processed by the server yet)");
      } else {
         Print("Message failed!");
      }
   }

   return(0);
  }
//+------------------------------------------------------------------+