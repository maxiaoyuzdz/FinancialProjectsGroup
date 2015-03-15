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

/**
  if( global_bars_M15 != iBars( Symbol(), PERIOD_M15 ) )
  {
    global_bars_M15 = iBars( Symbol(), PERIOD_M15 );
    global_hasnewbar_M15 = true;
  }
  else
  {
    global_hasnewbar_M15 = false;
  }
*/  
}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
int global_sys_status = 0;
void AssesOrderSend2()
{
  if(  
    global_hasnewbar_M5
    )
  {
    double macd_1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
    double macd_2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
    double macd_3 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,3);
    double macd_4 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,4);
    double macd_5 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,5);
    
    double macdsignal_1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
    double macdsignal_2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,2);
    double macdsignal_3 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,3);

    

    

  }

}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void AssessOrderClose2()
{

}

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void AssesOrderSend()
{
  if( global_hasnewbar_M5 
    )
  {
    double macd_0 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
    double macd_1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
    double macd_2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
    double macdsignal_0 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
    double macdsignal_1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
    double macdsignal_2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,2);
    /////////////////////////////////////////////////////////////////
    double ema_5_high_0 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 0 );
    double ema_5_high_1 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 1 );
    double ema_5_high_2 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 2 );
    double ema_5_low_0 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 0 );
    double ema_5_low_1 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 1 );
    double ema_5_low_2 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 2 );
    /////////////////////////////////////////////////////////////////
    double atr = iATR( NULL, 0, 14, 0 );
    /////////////////////////////////////////////////////////////////
    //sell order
    if( 
      ( macd_1 > macd_2 && macd_1 > macd_0 )
      && ( macd_0 > 0 && macd_1 > 0 && macd_2 > 0 )
      && ( macdsignal_0 > macdsignal_1 && macdsignal_1 > macdsignal_2 )
      && ( macdsignal_0 > 0 && macdsignal_1 > 0 && macdsignal_2 > 0 )
      && ( Open[0] > ema_5_high_0 
        || Open[1] > ema_5_high_1 || Open[2] > ema_5_high_2 
        )
      && atr >= 0.0005
         )
    {

      OpenOrders("sell");

    }
    /////////////////////////////////////////////////////////////////
    //buy order
    if( 
      ( macd_1 < macd_2 && macd_1 < macd_0 )
      && ( macd_0 < 0 && macd_1 < 0 && macd_2 < 0 )
      && ( macdsignal_0 < macdsignal_1 && macdsignal_1 < macdsignal_2 )
      && ( macdsignal_0 < 0 && macdsignal_1 < 0 && macdsignal_2 < 0 )
      && ( Open[0] < ema_5_low_0 
        || Open[1] < ema_5_low_1 || Open[2] < ema_5_low_2 
        )
      && atr >= 0.0005
         )
    {

      OpenOrders("buy");

    }


  }

}


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+

void AssessOrderClose()
{
  if( global_hasnewbar_M5 
    )
  {
    double macd_0 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
    double macd_1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
    double macd_2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
    double macdsignal_0 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
    double macdsignal_1 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
    double macdsignal_2 = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,2);
    /////////////////////////////////////////////////////////////////
    double ema_5_high_0 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 0 );
    double ema_5_high_1 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 1 );
    double ema_5_high_2 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 2 );
    double ema_5_low_0 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 0 );
    double ema_5_low_1 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 1 );
    double ema_5_low_2 = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 2 );
    /////////////////////////////////////////////////////////////////
    //close buy order
    if( 
      ( macd_1 > macd_0 &&  macd_1 > macd_2 )
      && ( macd_0 > 0 && macd_1 > 0 && macd_2 > 0 )
      && ( macdsignal_0 > macdsignal_1 && macdsignal_1 > macdsignal_2 )
      && ( macdsignal_0 > 0 && macdsignal_1 > 0 && macdsignal_2 > 0 )
     )
    {
      for( int i = OrdersTotal(); i >= 0; i-- )
      {
        if( OrderSelect( i, SELECT_BY_POS) == true )
        {
          if( OrderType() == OP_BUY )
          {
            if( OrderProfit() > 0 )
            {
              OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 );
            }
          }
        }
      }

    }
    /////////////////////////////////////////////////////////////////
    //close sell order
    if( 
      ( macd_1 < macd_2 && macd_1 < macd_0 )
      && ( macd_0 < 0 && macd_1 < 0 && macd_2 < 0 )
      && ( macdsignal_0 < macdsignal_1 && macdsignal_1 < macdsignal_2 )
      && ( macdsignal_0 < 0 && macdsignal_1 < 0 && macdsignal_2 < 0 )
         )
    {
      for( int i = OrdersTotal(); i >= 0; i-- )
      {
        if( OrderSelect( i, SELECT_BY_POS) == true )
        {
          if( OrderType() == OP_SELL )
          {
            if( OrderProfit() > 0 )
            {
              OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 );
            }
          }
        }
      }
    }



  }
  else
  {

  }



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
    AssessOrderClose2();

    //then process the sending of new order
    AssesOrderSend2();

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
