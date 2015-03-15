//+------------------------------------------------------------------+
//|                                                 TestComplexe.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int temp_time[60];

int numofbars = 0;

int init()
  {
//----
Comment("open0 = "+ Period());
temp_time[0] = Time[1];
Comment("time0 = "+ temp_time[0]);

    numofbars = Bars;
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
//----
//Comment("ask = "+Ask+" , bid = "+Bid+ " time =  "+ Time[0]);

Comment("open0 = "+ Period());


/**
   if(!IsStopped())
   {
      Comment("running "+ "ask2 = "+Ask+" , bid2 = "+Bid + ", bars = "+ Bars+ " ,Period = "+Period()+" timevalue = "+ Time[0]);
   
   }
   else
   {
      Comment("pause");
   }
*/
/**
   while(!IsStopped())
   {
      if(RefreshRates())
      {
         Comment("ask2 = "+Ask+" , bid2 = "+Bid + ", bars = "+ Bars+ " ,Period = "+Period()+" timevalue = "+ Time[0]);
      }
      
      
      
      Sleep(1);
   }
   */
//----
   return(0);
  }
//+------------------------------------------------------------------+