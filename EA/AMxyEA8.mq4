//+------------------------------------------------------------------+
//|                                                 TestTemplete.mq4 |
//|                                                         Maxiaoyu |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
/**
#import "MT4EA3DLL.dll"
void PrintTest();
void ArrayTest(double &arr[][], int &marr[][]);
void AnalyzeFunction( double &parameters[][], 
  bool isnewbar,
  int& cm[],
  double& cmp[]
  );
#import
*/



//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+

input double global_basic_open_lots = 0.01;
input double global_basic_profit_door = 0.5;
input double global_basic_loss_door = 3;

input int global_maximun_sellorder = 500;
input int global_maximun_buyorder = 500;
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
bool global_hasnewbar_M5 = false;
int global_bars_M5 = 0;

bool global_hasnewbar_M15 = false;
int global_bars_M15 = 0;
//////////////////////////////////////////////////////////////////////
//double global_total_profit = 0;



//////////////////////////////////////////////////////////////////////


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
double CalculateMaxLots()
{
  double lots = AccountEquity() / MarketInfo( Symbol(), MODE_MARGINREQUIRED );
  double tl =  lots * 0.05;
  return NormalizeDouble( tl, 2 ); //5.0
}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void InitializeGlobalValables()
{
  //global_max_lots = CalculateMaxLots();

}


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void OpenOrders( string type )
{
  int marketspread = MarketInfo( Symbol(), MODE_SPREAD );

  int current_num_sellorder = 0;
  int current_num_buyorder = 0;

  for( int i = OrdersTotal(); i >= 0; i--)
  {
    if( OrderSelect( i, SELECT_BY_POS) == true )
    {
      if( OrderType() == OP_BUY )
      {
        current_num_buyorder++;
      }
      if( OrderType() == OP_SELL )
      {
        current_num_sellorder++;
      }
    }

  }

  if( type == "buy" && current_num_buyorder < global_maximun_buyorder)
  {
    int ticket = 0;
    ticket = OrderSend( Symbol(), OP_BUY, global_basic_open_lots, Ask, marketspread, 0, 0, "buy", 5);

    if( ticket == -1)
    {
      Alert("buy order error, code = ", GetLastError());
    }
  }

  if( type == "sell" && current_num_sellorder < global_maximun_sellorder )
  {
    int ticket = 0;
    ticket = OrderSend( Symbol(), OP_SELL, global_basic_open_lots, Bid, marketspread, 0, 0, "sell", 5);

    if( ticket == -1)
    {
      Alert("sell order error, code = ", GetLastError());
    }
  }

}




//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void UpdateHasNewData()
{
  if(global_bars_M5 != Bars)
  {
    global_bars_M5 = Bars;

    global_hasnewbar_M5 = true;
  }
  else
  {
    global_hasnewbar_M5 = false;
  }

/***/
  if( global_bars_M15 != iBars( Symbol(), PERIOD_M15 ) )
  {
    global_bars_M15 = iBars( Symbol(), PERIOD_M15 );
    global_hasnewbar_M15 = true;
  }
  else
  {
    global_hasnewbar_M15 = false;
  }
  
}


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
#define USEM15
#define DISLIMIT1
bool SellConn_M5_1_OK()
{
  double ema_5_0_high_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 0 );
  double ema_5_1_high_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 1 );

  double ema_15_0_close_m5 = iMA( NULL, 0, 15, 0, MODE_EMA, PRICE_CLOSE, 0 );
  double ema_5_0_low_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 0 );


  double ema_150_0_close_m5 = iMA( NULL, 0, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );

  double dis = MathAbs(Bid - ema_150_0_close_m5);

  //h1
  //double ema_150_0_close_h1 = iMA( Symbol(), PERIOD_H1 , 150, 0, MODE_EMA, PRICE_CLOSE, 0 );
  //double ema_15_0_close_h1 = iMA( Symbol(), PERIOD_H1 , 15, 0, MODE_EMA, PRICE_CLOSE, 0 );
  //m15
  double open_0_m15 = iOpen( Symbol(), PERIOD_M15, 0 );
  double ema_5_0_high_m15 = iMA( Symbol(), PERIOD_M15, 5, 0, MODE_EMA, PRICE_HIGH, 0 );

  double ema_5_0_low_m15 = iMA( Symbol(), PERIOD_M15, 5, 0, MODE_EMA, PRICE_LOW, 0 );
  double ema_15_0_close_m15 = iMA( Symbol(), PERIOD_M15, 15, 0, MODE_EMA, PRICE_CLOSE, 0 );

  double ema_150_0_close_m15 = iMA( Symbol(), PERIOD_M15, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );
    //
  double MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
  double MacdPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
  double SignalCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
  double SignalPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);


  if( Open[0] >= ema_5_0_high_m5
    //
    && (  MacdCurrent  > 0 && MacdPrevious > 0 && SignalCurrent > 0 && SignalPrevious > 0 
        && MacdCurrent <= MacdPrevious && SignalCurrent > SignalPrevious
      )
    //
    && Open[1] > ema_5_1_high_m5
    && Close[1] > Open[1]
    &&  ema_15_0_close_m5 < ema_5_0_low_m5 
    //
#ifdef USEM15
    && open_0_m15 > ema_5_0_high_m15
    && ema_5_0_low_m15 > ema_15_0_close_m15
    && ema_15_0_close_m15 > ema_150_0_close_m15
#endif
    //
#ifdef DISLIMIT
    && dis >= 0.005
#endif
    )
  {
    return true;
  }
  else
  {
    return false;
  }


}


bool SellConn_M5_2_OK()
{
  //
  double ema_5_0_high_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 0 );

  double ema_5_1_close_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_CLOSE, 1 );
  double ema_5_1_high_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 1 );

  double ema_15_0_close_m5 = iMA( NULL, 0, 15, 0, MODE_EMA, PRICE_CLOSE, 0 );
  double ema_5_0_low_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 0 );

  double ema_150_0_close_m5 = iMA( NULL, 0, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );
  double dis = MathAbs(Bid - ema_150_0_close_m5);

  //h1
  //double ema_150_0_close_h1 = iMA( Symbol(), PERIOD_H1 , 150, 0, MODE_EMA, PRICE_CLOSE, 0 );
  //double ema_15_0_close_h1 = iMA( Symbol(), PERIOD_H1 , 15, 0, MODE_EMA, PRICE_CLOSE, 0 );
  //m15
  double open_0_m15 = iOpen( Symbol(), PERIOD_M15, 0 );
  double ema_5_0_high_m15 = iMA( Symbol(), PERIOD_M15, 5, 0, MODE_EMA, PRICE_HIGH, 0 );

  double ema_5_0_low_m15 = iMA( Symbol(), PERIOD_M15, 5, 0, MODE_EMA, PRICE_LOW, 0 );
  double ema_15_0_close_m15 = iMA( Symbol(), PERIOD_M15, 15, 0, MODE_EMA, PRICE_CLOSE, 0 );

  double ema_150_0_close_m15 = iMA( Symbol(), PERIOD_M15, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );


  double MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
  double MacdPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
  double SignalCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
  double SignalPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);

  if(
    Open[0] >= ema_5_0_high_m5 
    //
    && (  MacdCurrent  > 0 && MacdPrevious > 0 && SignalCurrent > 0 && SignalPrevious > 0 
        && MacdCurrent <= MacdPrevious && SignalCurrent > SignalPrevious
      )
    //

    && Open[1] < ema_5_1_close_m5
    && Close[1] > ema_5_1_high_m5
    && ema_15_0_close_m5 < ema_5_0_low_m5
    //
#ifdef USEM15
    && open_0_m15 > ema_5_0_high_m15
    && ema_5_0_low_m15 > ema_15_0_close_m15
    && ema_15_0_close_m15 > ema_150_0_close_m15
#endif
    //
#ifdef DISLIMIT
    && dis >= 0.005
#endif
      )
  {
    return true;
  }
  else
  {
    return false;
  }
    
}

bool BuyConn_M5_1()
{
  double ema_5_0_low_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 0 );
  double ema_5_1_low_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 1 );

  double ema_15_0_close_m5 = iMA( NULL, 0, 15, 0, MODE_EMA, PRICE_CLOSE, 0 );
  double ema_5_0_high_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 0 );


  double ema_150_0_close_m5 = iMA( NULL, 0, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );
  double dis = MathAbs(Bid - ema_150_0_close_m5);

  //h1
  //double ema_150_0_close_h1 = iMA( Symbol(), PERIOD_H1 , 150, 0, MODE_EMA, PRICE_CLOSE, 0 );
  //double ema_15_0_close_h1 = iMA( Symbol(), PERIOD_H1 , 15, 0, MODE_EMA, PRICE_CLOSE, 0 );
  //m15
  double open_0_m15 = iOpen( Symbol(), PERIOD_M15, 0 );
  double ema_5_0_low_m15 = iMA( Symbol(), PERIOD_M15, 5, 0, MODE_EMA, PRICE_LOW, 0 );

  double ema_5_0_high_m15 = iMA( Symbol(), PERIOD_M15, 5, 0, MODE_EMA, PRICE_HIGH, 0 );
  double ema_15_0_close_m15 = iMA( Symbol(), PERIOD_M15, 15, 0, MODE_EMA, PRICE_CLOSE, 0 );

  double ema_150_0_close_m15 = iMA( Symbol(), PERIOD_M15, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );


  double MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
  double MacdPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
  double SignalCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
  double SignalPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);



  if( 
    Open[0] < ema_5_0_low_m5
    //
    && (  MacdCurrent  < 0 && MacdPrevious < 0 && SignalCurrent < 0 && SignalPrevious < 0 
        && MacdCurrent >= MacdPrevious && SignalCurrent < SignalPrevious
      )
    //

    && Open[1] < ema_5_1_low_m5
    && Close[1] < Open[1]
    && ema_15_0_close_m5 > ema_5_0_high_m5

    //
#ifdef USEM15
    && open_0_m15 < ema_5_0_low_m15
    && ema_5_0_high_m15 < ema_15_0_close_m15
    && ema_15_0_close_m15 < ema_150_0_close_m15
#endif
    //
#ifdef DISLIMIT
    && dis >= 0.005
#endif
       )
  {

    

    return true;

  }
  else
  {
    return false;
  }
    
}

bool BuyConn_M5_2()
{
  double ema_5_0_low_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 0 );

  double ema_5_1_close_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_CLOSE, 1 );
  double ema_5_1_low_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 1 );

  double ema_15_0_close_m5 = iMA( NULL, 0, 15, 0, MODE_EMA, PRICE_CLOSE, 0 );
  double ema_5_0_high_m5 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 0 );

  double ema_150_0_close_m5 = iMA( NULL, 0, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );
  double dis = MathAbs(Bid - ema_150_0_close_m5);

  //h1
  //double ema_150_0_close_h1 = iMA( Symbol(), PERIOD_H1 , 150, 0, MODE_EMA, PRICE_CLOSE, 0 );
  //double ema_15_0_close_h1 = iMA( Symbol(), PERIOD_H1 , 15, 0, MODE_EMA, PRICE_CLOSE, 0 );
  //m15
  double open_0_m15 = iOpen( Symbol(), PERIOD_M15, 0 );
  double ema_5_0_low_m15 = iMA( Symbol(), PERIOD_M15, 5, 0, MODE_EMA, PRICE_LOW, 0 );

  double ema_5_0_high_m15 = iMA( Symbol(), PERIOD_M15, 5, 0, MODE_EMA, PRICE_HIGH, 0 );
  double ema_15_0_close_m15 = iMA( Symbol(), PERIOD_M15, 15, 0, MODE_EMA, PRICE_CLOSE, 0 );

  double ema_150_0_close_m15 = iMA( Symbol(), PERIOD_M15, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );


  double MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
  double MacdPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
  double SignalCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
  double SignalPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);


  if( 
    Open[0] < ema_5_0_low_m5
    //
    && (  MacdCurrent  < 0 && MacdPrevious < 0 && SignalCurrent < 0 && SignalPrevious < 0 
        && MacdCurrent >= MacdPrevious && SignalCurrent < SignalPrevious
      )
    //

    && Open[1] > ema_5_1_close_m5
    && Close[1] < ema_5_1_low_m5
    && ema_15_0_close_m5 > ema_5_0_high_m5 
    //
#ifdef USEM15
    && open_0_m15 < ema_5_0_low_m15
    && ema_5_0_high_m15 < ema_15_0_close_m15
    && ema_15_0_close_m15 < ema_150_0_close_m15
#endif
    //
#ifdef DISLIMIT
    && dis >= 0.005
#endif
      )
  {
    return true;
  }
  else
  {
    return false;
  }
    
}

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void AssesOrderSend()
{
  if( global_hasnewbar_M5 
    && global_hasnewbar_M15 
    )
  {
    
    if(  SellConn_M5_1_OK() 
      || SellConn_M5_2_OK()  
      )
    {
      OpenOrders("sell");
      
    }

    /////////////////////////////////////////////////////////////////
    
    if(  BuyConn_M5_1() 
      || BuyConn_M5_2()  
      )
    {
      OpenOrders("buy");
      
    }

    /////////////////////////////////////////////////////////////////
  }

}

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
#define CM1
#define USESL1
void AssessOrderClose()
{

#ifdef CM1
  for( int i = OrdersTotal(); i >= 0; i-- )
  {
    if( OrderSelect( i, SELECT_BY_POS) == true )
    {
      if( OrderProfit() >= global_basic_profit_door )
      {
        OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 );
      }
#ifdef USESL
      if( OrderProfit() < global_basic_loss_door )
      {
        OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 );
      }
#endif
    }
  }
#endif

}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+

void OnTimer()
  {
//---

   
  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetMillisecondTimer(5);

   UpdateHasNewData();
   UpdateHasNewData();

   InitializeGlobalValables();
   
   Print("version 1.0");
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
// operation here
//---
    //update to check wether there is a new bar been generated
    UpdateHasNewData();
    
    //close order firstly
    AssessOrderClose();
    //update the max order num

    //then process the sending of new order
    AssesOrderSend();

  }

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
