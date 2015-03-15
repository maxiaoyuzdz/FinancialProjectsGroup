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


#define SYS_WAITTING_SEND 0
#define SYS_WAITTING_CLOSE 1

#define FIBNOCCI_V 68.76 //0.236
#define PI 3.14159265

int systemstatus = 0;



int CalculateKType(
  double open,
  double high,
  double low,
  double close
  )
{
    int res_ana = 0;

    double openv = open * 100;
    double highv = high * 100;
    double lowv = low * 100;
    double closev= close * 100;


    double pos_a, a,b,c, rate_x, rate_y;

    bool issun = ( closev >= openv )?true:false;

    if( issun )
    {
      pos_a = closev - MathAbs( (closev - openv) / 2 ) ;
    }
    else
    {
      pos_a = openv - MathAbs( ( closev - openv ) / 2 ) ;
    }

    a = MathAbs( (closev - openv) / 2 ) ;

    if(a < 0.00000001 || a == 0) a = 0.00000001;

    b = MathAbs( highv - pos_a );

    c = MathAbs( lowv - pos_a );

    rate_x = atan( b / a ) * 180 / PI;

    rate_y = atan( c / a ) * 180 / PI;

    int bodyvalue = ( issun )?30:60;

    if(rate_x < 0.00000001 || rate_x == 0) rate_x = 0.00000001;
    if(rate_y < 0.00000001 || rate_y == 0) rate_y = 0.00000001;
    
    
    
    if( rate_x > FIBNOCCI_V || rate_y > FIBNOCCI_V )
    {
      res_ana = 5;
      //long high
      if( rate_x > FIBNOCCI_V &&  rate_y < FIBNOCCI_V )
      {
        
        res_ana = bodyvalue + 5;

      }
      //long low
      if( rate_x < FIBNOCCI_V &&  rate_y > FIBNOCCI_V )
      {
        
        res_ana = bodyvalue - 5;
      }

      //check is blance doji
      if( MathAbs(rate_x - rate_y) < 0.00000001 )
      {
        res_ana = 20;
      }

      if( MathAbs(rate_x - rate_y) < 1 && rate_x > FIBNOCCI_V && rate_y > FIBNOCCI_V )
      {
        res_ana == 10;
      }



    }
    
    if( res_ana == 5 || res_ana == 10)
    {

      double headv, legv, bodyv, rate_head, rate_leg;

      headv = MathAbs( highv - closev );
      legv = MathAbs( lowv - openv );
      bodyv = MathAbs(closev - openv);

      if(bodyv < 0.00000001 || bodyv == 0) bodyv = 0.00000001;


      rate_head = (double)headv/bodyv;
      rate_leg = (double)legv/bodyv;


      res_ana = 10;

      if( rate_head * 10 > rate_leg * 10 )
      {
        res_ana = res_ana + 5;
      }
      if( rate_head * 10 < rate_leg * 10 )
      {
        res_ana = res_ana - 5;
      }
    }

    if( res_ana == 0 )
    {
      res_ana = bodyvalue;

      if( MathAbs( rate_x - 45.0 ) < 0.00000001  && MathAbs( FIBNOCCI_V - rate_y ) > 0.0001 )
      {
        res_ana = res_ana - 2;
      }

      if( MathAbs( rate_y - 45.0 ) < 0.00000001  && MathAbs( FIBNOCCI_V - rate_x ) > 0.0001 )
      {
        res_ana = res_ana + 2;
      }

      if( rate_x <  rate_y)
      {
        res_ana = res_ana - 2;
      }

      if( rate_x >  rate_y)
      {
        res_ana = res_ana + 2;
      }

      if( rate_x ==  rate_y)
      {
        res_ana = res_ana * 10;
      }

      //
    }

    return res_ana;

}


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
int global_bars_M5 = 0;

bool hasnewbar = false;

void UpdateHasNewData()
{
  if(global_bars_M5 != Bars)
  {
    global_bars_M5 = Bars;

    hasnewbar = true;
  }
  else
  {
    hasnewbar = false;
  }
}


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+

int order_ticket = -2;
double order_price = 0;
double order_type = 0;
void AnalyzeSend()
{
  double marketinfo_spread = MarketInfo( Symbol(), MODE_SPREAD );
  //Print( marketinfo_spread * 0.00001 );
  //--- get minimum stop level
  double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
  // Print("Minimum Stop Level=",minstoplevel," points");
  //--- calculated SL and TP prices must be normalized
  double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
  double takeprofit=NormalizeDouble(Ask+minstoplevel*Point,Digits);

// has new bar process

  if( hasnewbar )
  {
    bool hasorderres = false;
    int generate_ordertype = 0;
    //
    double ema5_0_high = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 0 );
    double ema5_0_low = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 0 );
    double ema5_0_close = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_CLOSE, 0 );


    double ema5_1_high = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 1 );
    double ema5_1_low = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 1 );
    double ema5_1_close = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_CLOSE, 1 );

    //
    //double rsi_0_open = iCCI( NULL, 0, 14, PRICE_TYPICAL, 1 );
    //
    double dis_ema_hc = MathAbs( ema5_0_high - ema5_0_close );
    double dis_ema_lc = MathAbs( ema5_0_low - ema5_0_close );
    //
    //bar1 type
    
    int bar1_type = CalculateKType( 
      Open[1],
      High[1],
      Low[1],
      Close[1]
     );
    
    //
    bool main_sell_conn = false;

    if( Bid >  ema5_0_high )
    {
      main_sell_conn = true;
    }

    bool main_buy_conn = false;
    if( Ask < ema5_0_low )
    {
      main_buy_conn = true;
    }
    //


    ///////////////////////////////////////////////////////////////////////////

    //conn 1
    if( main_sell_conn && !hasorderres )
    {
      if( Open[1] > ema5_1_high && Close[1] > ema5_1_high )
      {
        if( dis_ema_hc >= dis_ema_lc )
        {
          Alert("1");
          //send sell order
          generate_ordertype = -1;

          hasorderres = true;

        }
      }
    }

    if( main_buy_conn && !hasorderres )
    {
      //send buy order
      if( Open[1] < ema5_1_low && Close[1] < ema5_1_low )
      {
        if( dis_ema_hc <= dis_ema_lc )
        {
          Alert("2");
          //send sell order
          generate_ordertype = 1;

          hasorderres = true;

        }
      }
    }
    ///////////////////////////////////////////////////////////////////////////
    //conn 2
    if( main_sell_conn && !hasorderres )
    {
      if( Open[1] > ema5_1_high || Close[1] > ema5_1_high )
      {
        if( bar1_type == 35 || bar1_type == 15 || bar1_type == 65)
        {
          Alert("3");
          generate_ordertype = -1;

          hasorderres = true;
        }
      }
    }

    if( main_buy_conn && !hasorderres )
    {
      if( Open[1] < ema5_1_low || Close[1] < ema5_1_low )
      {
        if( bar1_type == 25 || bar1_type == 5 || bar1_type == 55 )
        {
          Alert("4");
           generate_ordertype = 1;

           hasorderres = true;
        }

      }
      
    }


    ///////////////////////////////////////////////////////////////////////////
    //conn 3
    if( main_sell_conn && !hasorderres )
    {
      if( dis_ema_hc >= dis_ema_lc )
        {
          Alert("5");
          //send sell order
          generate_ordertype = -1;

          hasorderres = true;

        }
    }

    if( main_buy_conn && !hasorderres )
    {
      if( dis_ema_hc <= dis_ema_lc )
        {
          Alert("6");
          //send sell order
          generate_ordertype = 1;

          hasorderres = true;

        }
      
    }


    ///////////////////////////////////////////////////////////////////////////

    // order send operation
    if( hasorderres && generate_ordertype != 0 )
    {
      if( generate_ordertype == 1 )
      {
        //buy order
        order_ticket = OrderSend( Symbol(), OP_BUY, 0.01, Ask, 2, 0.0, 0.0);
        if( order_ticket != -1 )
        {
          order_price = Ask;
          order_type = 1;

          systemstatus = SYS_WAITTING_CLOSE;
        }
      }

      if( generate_ordertype == -1 )
      {
        //sell order
        order_ticket = OrderSend( Symbol(), OP_SELL, 0.01, Bid, 2, 0.0, 0.0);
        if( order_ticket != -1 )
        {
          order_price = Bid;
          order_type = -1;

          systemstatus = SYS_WAITTING_CLOSE;
        }
      }

    }
  }

  // new bar process end

}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void AnalyzeClose()
{
  bool res = false;
  if( order_type == -1 )
  {
    if( ( order_price - Ask ) >= 0.00005 )
    {
      res = OrderClose( order_ticket, 0.01, Ask, 2 );
    }
  }


  if( order_type == 1 )
  {
    if( ( Bid - order_price ) >= 0.00005 )
    {
      res = OrderClose( order_ticket, 0.01, Bid, 2 );
    }
  }

  if( res )
  {
    systemstatus = SYS_WAITTING_SEND;
  }

}

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+


void AnalyzeFlowProcessStart()
{
  switch( systemstatus )
  {
    case SYS_WAITTING_SEND:
    AnalyzeSend();
    break;
    case SYS_WAITTING_CLOSE:
    AnalyzeClose();
    break;
  }


}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
double oldask,oldbid;
void OnTimer()
  {
//---
      if( !IsStopped() )
      {
        //do logic
        

        RefreshRates();

        if( oldbid != Bid || oldask != Ask )
        {
          oldbid = Bid;
          oldask = Ask;

          //Print( "new price do calculate" );
          UpdateHasNewData();

          //ComposeParameters();

          AnalyzeFlowProcessStart();

          //do the logic operation
          

          

        }
        

      }
    

   
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
