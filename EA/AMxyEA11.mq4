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

//bool global_hasnewbar_M15 = false;
//int global_bars_M15 = 0;
//////////////////////////////////////////////////////////////////////
//double global_total_profit = 0;

//////////////////////////////////////////////////////////////////////
const string filename = "mxyealog.txt";
//////////////////////////////////////////////////////////////////////
//double global_macd_m5[2][5];
double global_macd_m5[5];
double global_macdsignal_m5[5];

#define MACDLENGTH 5
//////////////////////////////////////////////////////////////////////

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void FlushMACD(double &macd[], double &macdsignal[],  int size, int shift)
{
  for(int i = 0; i<size; i++)
  {
    macd[i] = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+shift);
    macdsignal[i] = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,i+shift);
  }
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

  if( type == "buy" 
    //& current_num_buyorder < global_maximun_buyorder
    )
  {
    int ticket = 0;
    ticket = OrderSend( Symbol(), OP_BUY, global_basic_open_lots, Ask, marketspread, 0, 0, "buy", 5);

    if( ticket == -1)
    {
      Alert("buy order error, code = ", GetLastError());
    }
  }

  if( type == "sell" 
    //&& current_num_sellorder < global_maximun_sellorder 
    )
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
#define MIDDLEPOS 2
void AssesOrderSend()
{
  if(  
    global_hasnewbar_M5
    )
  {
    FlushMACD(global_macd_m5, global_macdsignal_m5, MACDLENGTH, 1);


    int pos_min_macd = ArrayMinimum(global_macd_m5);
    if( pos_min_macd == MIDDLEPOS )
    {
      //2 + 1 = real pos
      //if( global_macd_m5[pos_min_macd] < 0  )
      //{

        // 1
        bool hasopenlessema = false;
        for(int i = 0; i < 5; i++)
        {
          double ema_5_low = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, i + 1 );
          double op = Open[ i + 1 ];

          if( op <= ema_5_low )
          {
            hasopenlessema = true;
            break;
          }
        }

        if( hasopenlessema )
        {
          //
          OpenOrders("buy");

        }
      //}

    }

    int pos_max_macd = ArrayMaximum(global_macd_m5);
    if( pos_max_macd == MIDDLEPOS )
    {
      //if( global_macd_m5[pos_min_macd] > 0 )
      //{
        bool hasopenbiggerema = false;
        for( int i = 0; i < 5; i++ )
        {
          double ema_5_high = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, i + 1 );
          double op = Open[ i + 1 ];

          if( op >= ema_5_high )
          {
            hasopenbiggerema = true;
            break;
          }
        }

        if( hasopenbiggerema )
        {
          OpenOrders("sell");
        }
      //}
    }


    

  }

}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void AssessOrderClose()
{
  for( int i = OrdersTotal(); i >= 0; i-- )
  {
    if( OrderSelect( i, SELECT_BY_POS) == true )
    {
      if( OrderProfit() >= global_basic_profit_door )
      {
        OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 );
      }
      if( OrderProfit() < global_basic_loss_door )
      {
        OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 );
      }
    }
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
    AssessOrderClose();

    //then process the sending of new order
    AssesOrderSend();


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
