//+------------------------------------------------------------------+
//|                                                 TestTemplete.mq4 |
//|                                                         Maxiaoyu |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
/***/
#import "MT4EA3DLL.dll"
int GetInt();
/**
void PrintTest();
void ArrayTest(double &arr[][], int &marr[][]);
void AnalyzeFunction( double &parameters[][], 
  bool isnewbar,
  int& cm[],
  double& cmp[]
  );
*/
#import




//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
/**
input double global_basic_open_lots = 0.01;
input double global_basic_profit_door = 0.5;
input double global_basic_loss_door = 3;

input int global_maximun_sellorder = 500;
input int global_maximun_buyorder = 500;
*/
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
//////////////////////////////////////////////////////////////////////
const int global_magic = 123456;
//////////////////////////////////////////////////////////////////////
bool global_hasnewbar = false;
int global_bars = 0;
//////////////////////////////////////////////////////////////////////
//const string filename = "mxyealog.txt";
//////////////////////////////////////////////////////////////////////
//double global_macd_m5[2][5];
double global_macd_m5[5];
double global_macdsignal_m5[5];
//////////////////////////////////////////////////////////////////////
int global_counttotallevel;
//int global_lastcounttotallevel;
//////////////////////////////////////////////////////////////////////
double global_variancesupport;
double global_varianceresistent;



double global_avesupport = 0;
double global_averesistent = 0;

double global_supportdivresistent = 0;


int global_variancecomparers = 0;
string global_str_currentcurvetype;

bool global_supportisdoublecheck = false;
bool global_resistentisdoublecheck = false;

double global_supportdoublecheckprice = 0;
double global_resistentdoublecheckprice = 0;
//////////////////////////////////////////////////////////////////////
#define SYS_STATUS_ANALYZE 1
#define SYS_STATUS_SEND 2
#define SYS_STATUS_WAIT 3
#define SYS_STATUS_CLOSE 4

int global_systemstatus = SYS_STATUS_ANALYZE;
//////////////////////////////////////////////////////////////////////

int global_ordertype = 0;
//////////////////////////////////////////////////////////////////////
#define UNKNOWNRS 0
#define SRSR 1
#define RSRS 2

int global_currentcurvetype = UNKNOWNRS;
int global_lastcurvetype = UNKNOWNRS;
//////////////////////////////////////////////////////////////////////
double global_grid_top = 0;
double global_grid_bottom = 0;
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
double global_pipvalue = 0;
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
#define ORDER_CATEGORY_DOUBLECHECKBREAKOUT_BS 1
int global_ordercatgory = 0;
int global_lastordercategory = 0;
//////////////////////////////////////////////////////////////////////
#define LEVELORDERNUM 6
int global_levelorderarr[LEVELORDERNUM];
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////

#define LEVELNUM 20
struct LevelPos{
    int middlepos;
    int leveltype;
    //double middleprice;
    color col;
    double highedge;
    double lowedge;

    int vpos;

    double edgeprice;

    void clear()
    {
        middlepos = 0;
        leveltype = 0;
        highedge = 0;
        lowedge = 0;
        vpos = 0;
        edgeprice = 0;
    }

} levelarray[LEVELNUM];

//////////////////////////////////////////////////////////////////////
//for test
double global_test = 0;
int global_inttest = 0;
double global_dt1 = 0;
double global_dt2 = 0;

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void SystemStateMachine(int status)
{

  EnvarimentVariablesUpdate();

  switch(status)
  {
    case SYS_STATUS_ANALYZE:
    AnalyzeMarketSea();
    break;

    case SYS_STATUS_SEND:
    SendGridNet();
    break;

    case SYS_STATUS_WAIT:
    WatchingGridNetMoving();
    break;


    case SYS_STATUS_CLOSE:
    //CloseAllOrder();
    break;

  }
}


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
#define MIDDLEPOS 2
#define NUMOFLEVEL 6
#define MACDLENGTH 5
void EnvarimentVariablesUpdate()
{

    for(int i = 0; i< LEVELNUM; i++)
    {
        levelarray[i].clear();
    }

    for(int i = 0; i< LEVELNUM; i++)
    {
        if( levelarray[i].edgeprice != 0 )
          global_inttest = 99;
    }
    
    global_counttotallevel = 0;
    int countnoduplicatelevel = 0;
    int macdshift = 1;
    int levelindex = 0;

    while( true )
    {
        FlushMACD(global_macd_m5, global_macdsignal_m5, MACDLENGTH, macdshift);
        int minipos = ArrayMinimum(global_macd_m5);
        int maxipos = ArrayMaximum(global_macd_m5);

        if( minipos == MIDDLEPOS || maxipos == MIDDLEPOS )
        {
            global_counttotallevel++;
            levelarray[levelindex].middlepos = macdshift + MIDDLEPOS;
            if( minipos == MIDDLEPOS && maxipos != MIDDLEPOS )
            {
                //find a support
                levelarray[levelindex].leveltype = 1;
            }

            if( maxipos == MIDDLEPOS && minipos != MIDDLEPOS )
            {
                //find a resistent          
                levelarray[levelindex].leveltype = -1;
            }

            if( levelindex > 0 )
            {
                if( levelarray[levelindex].leveltype != levelarray[levelindex-1].leveltype )
                {
                    countnoduplicatelevel++;
                }
            }

            levelindex++;

        }
        
        macdshift++;

        if( countnoduplicatelevel == (NUMOFLEVEL - 1) )
        {
            break;
        }

    }



    //filter the data
    //generate some useful data, each edge price
    for( int i = 0; i < global_counttotallevel; i++ )
    {
        int start = levelarray[i].middlepos - MIDDLEPOS;

        double edgehigh = 0;
        double edgelow = 0;
        double dp = 0;

        int p = 0;

        if( levelarray[i].leveltype == 1 )
        {
            //support
            double lowopen = Open[ iLowest( NULL, 0, MODE_OPEN, MACDLENGTH, start ) ];
            double lowclose = Close[ iLowest( NULL, 0, MODE_CLOSE, MACDLENGTH, start ) ];

            if( lowopen < lowclose  )
            {
                edgehigh = lowopen;
            }
            else
            {
                edgehigh = lowclose;
            }

            p = iLowest( NULL, 0, MODE_LOW, MACDLENGTH, start );

            edgelow = Low[ p ];

            dp = edgelow;
        }
        else
        {
            //resistent
            double highopen = Open[ iHighest( NULL, 0, MODE_OPEN, MACDLENGTH, start ) ];
            double highclose = Close[ iHighest( NULL, 0, MODE_CLOSE, MACDLENGTH, start ) ];

            if( highopen > highclose )
            {
                edgelow = highopen;
            }
            else
            {
                edgelow = highclose;
            }

            p = iHighest( NULL, 0, MODE_HIGH, MACDLENGTH, start );

            edgehigh = High[ p ];
            dp = edgehigh;

        }

        levelarray[i].highedge = edgehigh;
        levelarray[i].lowedge = edgelow;

        levelarray[i].edgeprice = dp;
        //used for time
        levelarray[i].vpos = p;

        //////////////////////////////////////////////////////////////////////////
        //color setting
        /**
        if( levelarray[i].leveltype == 1 )
        {
            //support
            levelarray[i].col = clrPaleGreen;
        }
        else
        {
            levelarray[i].col = clrYellow;
        }
        */
        //////////////////////////////////////////////////////////////////////////
    }

    
    ////////////////////////////////////////////////////////////////
    //filter leve data
    int outstart = 0;
    //find 4
    for(int w = 0; w<LEVELORDERNUM; w++)
    {
          
          int i = outstart;
          int t = levelarray[i].leveltype;
          int endp = outstart;
          for(int j = i + 1; j < global_counttotallevel; j++)
          {
              if( levelarray[j].leveltype != levelarray[i].leveltype )
              {
                  endp = j;
                  break;
              }

          }
          outstart = endp;

          int finalp = i;
          //start = i end = endp
          if( levelarray[i].leveltype == 1 )
          {
              double lowv = 999;
              int lowp = -1;
              //support
              for( int q = i; q < endp; q++)
              {
                  if( levelarray[q].edgeprice < lowv )
                  {
                      lowv = levelarray[q].edgeprice;
                      lowp = q;
                  }

              }

              finalp = lowp;

              if( i == endp )
              {
                  finalp = i;
              }
          }
          else
          {
              //resistent
              double highv = 0;
              int highp = -1;
              for( int q = i; q < endp; q++ )
              {
                  if( levelarray[q].edgeprice > highv )
                  {
                      highv = levelarray[q].edgeprice;
                      highp = q;
                  }
              }

              finalp = highp;

              if( i == endp )
              {
                  finalp = i;
              }

          }

          global_levelorderarr[w] = finalp;

    }
    //filter end
    /////////////////////////////////////////////////////////////////
    //find curve type
    if( levelarray[0].leveltype == 1 )
    {
        global_currentcurvetype = RSRS;
        global_str_currentcurvetype = "RSRS";
    }
    else
    {
        global_currentcurvetype = SRSR;
        global_str_currentcurvetype = "SRSR";
    }


    //////////////////////////////////////////////////////////////////////////
    //compute variavce


    double sumsupport = 0;
    double sumresistent = 0;
    global_avesupport = 0;
    global_averesistent = 0;

    for(int i = 0; i< LEVELORDERNUM; i++)
    {
        int p = global_levelorderarr[i];
        if(  levelarray[ p ].leveltype == 1 )
        {
            sumsupport = sumsupport + levelarray[ p ].edgeprice;
        }
        else
        {
            sumresistent = sumresistent + levelarray[ p ].edgeprice;
        }
    }


    global_supportdivresistent = 0;

    global_avesupport = ( sumsupport / ( LEVELORDERNUM / 2 ) );
    global_averesistent = (sumresistent /  ( LEVELORDERNUM / 2 ) );

    double ts = 0;
    double tr = 0;

    for(int i = 0; i< LEVELORDERNUM; i++)
    {
        int p = global_levelorderarr[i];
        if(  levelarray[ p ].leveltype == 1 )
        {
            ts = ts + MathPow( ( levelarray[p].edgeprice - global_avesupport ) , 2 );
        }
        else
        {
            tr = tr + MathPow( ( levelarray[p].edgeprice - global_averesistent ) , 2 );
        }

    }

    global_variancesupport =    ts / ( LEVELORDERNUM / 2 );
    global_varianceresistent =  tr / ( LEVELORDERNUM / 2 );
    global_supportdivresistent = global_variancesupport / global_varianceresistent;

    //compute variavce end


    //////////////////////////////////////////////////////////////////////////
    //compare the two variance

    if( global_variancesupport > global_varianceresistent )
    {
        global_variancecomparers = 1;
    }
    else
    {
        global_variancecomparers = -1;
    }

    //////////////////////////////////////////////////////////////////////////
    //find grid's top and bottom
    global_grid_top = 0;
    global_grid_bottom = 0;

    if( global_currentcurvetype == RSRS )
    {
        global_grid_top = levelarray[ global_levelorderarr[1] ].edgeprice;
        global_grid_bottom = levelarray[ global_levelorderarr[0] ].edgeprice;
    }
    else
    {
        //SRSR
        global_grid_top = levelarray[ global_levelorderarr[0] ].edgeprice;
        global_grid_bottom = levelarray[ global_levelorderarr[1] ].edgeprice;
    }




    //////////////////////////////////////////////////////////////////////////
    //check 0 and 2 is the same level, have some reduliacated area
    int p0 = global_levelorderarr[0];
    int p1 = global_levelorderarr[1];
    int p2 = global_levelorderarr[2];
    int p3 = global_levelorderarr[3];
    double eh0 = levelarray[p0].highedge;
    double el0 = levelarray[p0].lowedge;
    double ep0 = levelarray[p0].edgeprice;

    double eh2 = levelarray[p2].highedge;
    double el2 = levelarray[p2].lowedge;
    double ep2 = levelarray[p2].edgeprice;

    double eh1 = levelarray[p1].highedge;
    double el1 = levelarray[p1].lowedge;
    double ep1 = levelarray[p1].edgeprice;

    double eh3 = levelarray[p3].highedge;
    double el3 = levelarray[p3].lowedge;
    double ep3 = levelarray[p3].edgeprice;

    global_supportisdoublecheck = false;
    global_resistentisdoublecheck = false;


    if( global_currentcurvetype == SRSR )
    {
        //1  3 is support
        //global_supportisdoublecheck = CheckDuplicate( eh1, el1, eh3 , el3) || CheckPriceIsClose(ep1, ep3  );

        //0  2 is resistent
        //global_resistentisdoublecheck = CheckDuplicate(eh0 , el0, eh2, el2) || CheckPriceIsClose( ep0, ep2 );

        if( 
          CheckDuplicate(eh0 , el0, eh2, el2) 
          || CheckPriceIsClose( ep0, ep2 ) 
          )
        {
            global_resistentisdoublecheck = true;
        }
        else
        {
            global_resistentisdoublecheck = false;
        }

    }
    else
    {
        //RSRS
        //0  2 is support
        //global_supportisdoublecheck = CheckDuplicate(eh0 , el0, eh2, el2) || CheckPriceIsClose( ep0, ep2 );

        if( 
          CheckDuplicate(eh0 , el0, eh2, el2) 
          || CheckPriceIsClose( ep0, ep2 ) 
          )
        {
            global_supportisdoublecheck = true;
        }
        else
        {
            global_supportisdoublecheck = false;
        }

        //1  3 is resistent
        //global_resistentisdoublecheck = CheckDuplicate( eh1, el1, eh3 , el3) || CheckPriceIsClose( ep1, ep3 );

    }
    //double check end


}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+

void AnalyzeMarketSea()
{
    
    if( 
      global_resistentisdoublecheck
      &&
      ( Ask < global_grid_top && Bid > global_grid_bottom )
      )
    {
        
        global_systemstatus = SYS_STATUS_SEND;
        global_ordercatgory = ORDER_CATEGORY_DOUBLECHECKBREAKOUT_BS;
        SystemStateMachine(global_systemstatus);
    }

}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
#define STOPORDERNUM 5
#define DISEACHORDER 15
#define BASICLOT 0.01
void SendGridNet()
{
    double tempprice = 0;
    double market_stoplevel = MarketInfo( Symbol(), MODE_STOPLEVEL );
    int marketspread = MarketInfo( Symbol(), MODE_SPREAD );

    double top = global_grid_top + market_stoplevel + Point * 5;
    double bottom = global_grid_bottom - market_stoplevel - Point * 5;

    int count_error_bs = 0;
    //int count_error_ss = 0;

    int count_successful_bs = 0;
    //int count_successful_ss = 0;

    if( global_ordercatgory == ORDER_CATEGORY_DOUBLECHECKBREAKOUT_BS )
    {
        //send buy stop order above grid top
        for(int i = 0; i< STOPORDERNUM; i++)
        {
            
            double orderprice = top + Point * 15 * i;

            double tp = top + Point * 15 *  STOPORDERNUM  + marketspread;

            int ticket = OrderSend( Symbol(), OP_BUYSTOP, BASICLOT, orderprice, marketspread, 0, tp , "bs", global_magic);

            if( ticket == -1)
            {
                Alert("buy order error, code = ", GetLastError());
                count_error_bs++;
            }
            else
            {
                count_successful_bs++;
            }

        }

        if( count_successful_bs > 0 )
        {
            global_systemstatus = SYS_STATUS_WAIT;
            //wait next tick
        }

    }



}


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void CloseAllOrder()
{

}

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void WatchingGridNetMoving()
{
    int cb = 0;
    int cbs = 0;

    double profit = 0;

    for (int i = 0; i < OrdersTotal(); i++)
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_BUY && OrderMagicNumber() == global_magic )
            {
                cb++;

                profit = profit + OrderProfit();
            }
            if( OrderType()==OP_BUYSTOP && OrderMagicNumber() == global_magic )
            {
                cbs++;
            }
        }
    }


    if( cbs == 0 && cb > 0 && profit > 0)
    {
        for (int i = 0; i < OrdersTotal(); i++)
        {
            if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
            {
                if( OrderType()==OP_BUY && OrderMagicNumber() == global_magic )
                {
                    OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(), 2, Red); 
                }
            }
        }

        global_systemstatus = SYS_STATUS_ANALYZE;
    }



}

void WorkingProcess2()
{
    int cb = 0;
    double tbl = 0;

    int cs = 0;
    double tsl = 0;

    double tl = 0;
    int to = 0;

    int cbl,cbs,csl,css = 0;

    double pr = 0;
    double ProfitPot = 0;

    double CurrentTP = 0;



    for (int i = 0; i < OrdersTotal(); i++)
    {
      if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
      {
        if( OrderType()==OP_BUY && OrderMagicNumber() == global_magic )
        {
          cb++;
          pr=pr + OrderProfit() + OrderSwap() + OrderCommission();
          tbl = tbl + OrderLots();
          ProfitPot = ProfitPot + OrderSwap() + OrderCommission() + OrderLots()*global_pipvalue*(((OrderTakeProfit() - OrderOpenPrice())/Point));
          CurrentTP = OrderTakeProfit();
        }

        if( OrderType()==OP_SELL && OrderMagicNumber() == global_magic )
        {
          cs++;
          pr = pr + OrderProfit() + OrderSwap() + OrderCommission();
          tsl = tsl + OrderLots();
          ProfitPot = ProfitPot + OrderSwap() + OrderCommission() + OrderLots()*global_pipvalue*(((OrderOpenPrice() - OrderTakeProfit())/Point));
          CurrentTP = OrderTakeProfit();
        }

        if( OrderType()==OP_BUYLIMIT && OrderMagicNumber() == global_magic ) cbl++;
        if( OrderType()==OP_BUYSTOP && OrderMagicNumber() == global_magic ) cbs++;
        if( OrderType()==OP_SELLLIMIT && OrderMagicNumber() == global_magic ) csl++;
        if( OrderType()==OP_SELLSTOP && OrderMagicNumber() == global_magic ) css++;
      }

    }
    tl = tbl + tsl;
    to = cb + cs;


    ProfitPot = NormalizeDouble(ProfitPot,2);
    pr        = NormalizeDouble(pr,2);


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


    
    SystemStateMachine(global_systemstatus);


    
    
    DisplayLevelElements();

    DisplayComment();


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

   InitLineObject();

   global_pipvalue = MarketInfo(Symbol(),MODE_TICKVALUE);



   Print("version 1.0 ");
      
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

   ObjectsDeleteAll();
      
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
//|  function                                              |
//+------------------------------------------------------------------+
void InitLineObject()
{
    //ini 
    for(int i = 0; i< LEVELNUM; i++)
    {
      

        //create level label
        string labename = "levellabel"+IntegerToString(i);
        if(!ObjectCreate(0 ,labename,OBJ_TEXT,0,Time[0],0))
        {
            Print(__FUNCTION__,
                  ": failed to create \"Text\" object! Error code = ",GetLastError());
        }
        ObjectSetString(0, labename, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, labename, OBJPROP_FONTSIZE, 10);
        ObjectSetInteger(0, labename, OBJPROP_COLOR, White);





        //create level line
        string levellinename = "levelline" +  IntegerToString(i);
        if(!ObjectCreate(0 , levellinename, OBJ_HLINE, 0,0,0))
        {
            Print(__FUNCTION__,
                  ": failed to create a horizontal line! Error code = ",GetLastError());
        }

        ObjectSetInteger(0, levellinename, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(0, levellinename, OBJPROP_WIDTH, 1 );
        ObjectSetInteger(0, levellinename, OBJPROP_BACK, false );
        ObjectSetInteger(0, levellinename, OBJPROP_RAY, false );



        //create arrow
        string levelresistentarrow_up = "levelresistentarrow_up" + IntegerToString(i);
        string levelresistentarrow_down = "levelresistentarrow_down" + IntegerToString(i);
        
        if(!ObjectCreate(0,levelresistentarrow_up,OBJ_ARROW_UP,0,TimeCurrent(),0))
        {
            Print(__FUNCTION__,
                  ": failed to create a levelresistentarrow_up! Error code = ",GetLastError());
        }


        //--- set anchor type
         ObjectSetInteger(0,levelresistentarrow_up,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
      //--- set a sign color
         ObjectSetInteger(0,levelresistentarrow_up,OBJPROP_COLOR,White);
      //--- set the border line style
         ObjectSetInteger(0,levelresistentarrow_up,OBJPROP_STYLE,STYLE_SOLID);
      //--- set the sign size
         ObjectSetInteger(0,levelresistentarrow_up,OBJPROP_WIDTH,3);
      //--- display in the foreground (false) or background (true)
         ObjectSetInteger(0,levelresistentarrow_up,OBJPROP_BACK,false);

         ObjectSetInteger(0,levelresistentarrow_up,OBJPROP_ZORDER,0);



        if(!ObjectCreate(0,levelresistentarrow_down,OBJ_ARROW_DOWN,0,TimeCurrent(),0))
        {
            Print(__FUNCTION__,
                  ": failed to create a levelresistentarrow_down! Error code = ",GetLastError());
        }

        //--- set anchor type
         ObjectSetInteger(0,levelresistentarrow_down,OBJPROP_ANCHOR,ANCHOR_BOTTOM);
      //--- set a sign color
         ObjectSetInteger(0,levelresistentarrow_down,OBJPROP_COLOR,White);
      //--- set the border line style
         ObjectSetInteger(0,levelresistentarrow_down,OBJPROP_STYLE,STYLE_SOLID);
      //--- set the sign size
         ObjectSetInteger(0,levelresistentarrow_down,OBJPROP_WIDTH,3);
      //--- display in the foreground (false) or background (true)
         ObjectSetInteger(0,levelresistentarrow_down,OBJPROP_BACK,false);

         ObjectSetInteger(0,levelresistentarrow_down,OBJPROP_ZORDER,0);


    }

    for(int i = 0; i<6; i++)
    {
        string trendlinename = "trend"+ IntegerToString(i);
        if(!ObjectCreate(0, trendlinename ,OBJ_TREND,0, Time[0], 0, Time[0], 0))
        {
            Print(__FUNCTION__,
                  ": failed to create a trend line! Error code = ",GetLastError());
        }

        ObjectSetInteger( 0, trendlinename , OBJPROP_COLOR, White);
        ObjectSetInteger( 0, trendlinename , OBJPROP_STYLE, STYLE_SOLID );
        ObjectSetInteger( 0, trendlinename , OBJPROP_WIDTH, 1);
        ObjectSetInteger( 0, trendlinename , OBJPROP_BACK, false);
        ObjectSetInteger( 0, trendlinename , OBJPROP_RAY, false);


    }


  

}

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
bool CheckDuplicate(const double& eh0, const double& el0, const double& eh2, const double& el2)
{
    if( 
        eh0 <= eh2 && eh0 >= el2 
        ||
        el0 <= eh2 && el0 >= el2
        ||
        eh2 <= eh0 && eh2 >= el0
        ||
        el2 <= eh0 && el2 >= el0
       )
      {
        return true;
      }
      else
      {
        return false;
      }

}

bool CheckPriceIsClose(const double& p1, const double& p2)
{
    if( ( MathAbs(p1 - p2) )/Point <= 10 )
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
void UpdateHasNewData()
{
    if(global_bars != Bars)
    {
        global_bars = Bars;

        global_hasnewbar = true;
    }
    else
    {
        global_hasnewbar = false;
    }

}

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
//|  function                                              |
//+------------------------------------------------------------------+

void DisplayLevelElements()
{
    //reset 
    for(int i = 0; i < LEVELNUM; i++)
    {
      //label
        string labelname = "levellabel"+IntegerToString(i);
        if(!ObjectMove(0, labelname, 0,Time[0], 0))
        {
            Print(__FUNCTION__,
                  ": failed to move the anchor point! Error code = ",GetLastError());
        }


        //level line
        string levellinename = "levelline" +  IntegerToString(i);
        if(!ObjectMove(0, levellinename,0,0,0))
        {
            Print(__FUNCTION__,
                  ": failed to move the horizontal line! Error code = ",GetLastError());
        }
        //arrow
        string levelresistentarrow_up = "levelresistentarrow_up" + IntegerToString(i);
        string levelresistentarrow_down = "levelresistentarrow_down" + IntegerToString(i);

        if(!ObjectMove(0, levelresistentarrow_up,0,Time[ 0 ],0))
        {
            Print(__FUNCTION__,
                  ": failed to move the levelresistentarrow_up! Error code = ",GetLastError());
        }

        if(!ObjectMove(0, levelresistentarrow_down,0,Time[ 0 ],0))
        {
            Print(__FUNCTION__,
                  ": failed to move the levelresistentarrow_down! Error code = ",GetLastError());
        }

    }

    
    for(int i = 0 ; i < LEVELORDERNUM - 1; i++)
    {

        int j = i + 1;

        int startp = global_levelorderarr[i];
        int endp = global_levelorderarr[j];

        string trendlinename = "trend"+ IntegerToString(i);

        if(!ObjectMove( 0 , trendlinename, 0 , Time[ 0 ]  , 0 ))
        {
            Print(__FUNCTION__,
                  ": failed to move the anchor point! Error code = ",GetLastError());
        }

        if(!ObjectMove( 0 , trendlinename, 1 , Time[ 0 ]  , 0 ))
        {
            Print(__FUNCTION__,
                  ": failed to move the anchor point! Error code = ",GetLastError());
        }

    }
    

    //reset end

    


    

    /***/
    for(int i = 0 ; i < LEVELORDERNUM; i++)
    {
        int p = global_levelorderarr[i];
        double price  = levelarray[p].edgeprice;
        int ti = levelarray[p].vpos;
        double type = levelarray[p].leveltype;

        //display label
        string levellinename = "levelline" +  IntegerToString(i);
        string labelname = "levellabel"+IntegerToString(i);
        ObjectSetString(0, labelname, OBJPROP_TEXT, levellinename);


        //display level line
        if( type == 1 )
        {
            ObjectSetInteger(0, levellinename, OBJPROP_COLOR, clrPaleGreen );
        }
        else
        {
            ObjectSetInteger(0, levellinename, OBJPROP_COLOR, clrYellow );
        }
        
        if(!ObjectMove(0, levellinename, 0, 0, price ))
        {
            Print(__FUNCTION__,
                  ": failed to move the horizontal line! Error code = ",GetLastError());
        }




        //display arrow and label
        if( type == 1 )
        {
            //support
            string levelresistentarrow_up = "levelresistentarrow_up" + IntegerToString(i);
            if(!ObjectMove( 0, levelresistentarrow_up, 0, Time[ti], price - 30 *Point))
            {
                Print(__FUNCTION__,
                      ": failed to move the levelresistentarrow_up! Error code = ",GetLastError());
            }

            if(!ObjectMove(0, labelname, 0, Time[ti], price - 45 *Point ))
            {
                Print(__FUNCTION__,
                      ": failed to move the anchor point! Error code = ",GetLastError());
            }

        }
        else
        {
            //resistent
            string levelresistentarrow_down = "levelresistentarrow_down" + IntegerToString(i);

            if(!ObjectMove(0, levelresistentarrow_down, 0, Time[ ti ], price + 5*Point))
            {
                Print(__FUNCTION__,
                      ": failed to move the levelresistentarrow_down! Error code = ",GetLastError());
            }

            if(!ObjectMove(0, labelname, 0,Time[ti], price + 60 * Point ))
            {
                Print(__FUNCTION__,
                      ": failed to move the anchor point! Error code = ",GetLastError());
            }

        }


    }
    

    /***/
    for(int i = 0 ; i < LEVELORDERNUM - 1; i++)
    {

        int j = i + 1;

        int startp = global_levelorderarr[i];
        int endp = global_levelorderarr[j];

        string trendlinename = "trend"+ IntegerToString(i);

        if(!ObjectMove( 0 , trendlinename, 0 , Time[ levelarray[startp].vpos ]  , levelarray[startp].edgeprice ))
        {
            Print(__FUNCTION__,
                  ": failed to move the anchor point! Error code = ",GetLastError());
        }

        if(!ObjectMove( 0 , trendlinename, 1 , Time[ levelarray[endp].vpos ]  , levelarray[endp].edgeprice ))
        {
            Print(__FUNCTION__,
                  ": failed to move the anchor point! Error code = ",GetLastError());
        }

    }
    

}
//+------------------------------------------------------------------+
//|  function                                              |
//+------------------------------------------------------------------+
void DisplayComment()
{
  //double market_stoplevel = MarketInfo( Symbol(), MODE_STOPLEVEL );

  //int test = MathPow( 2, 2 );
  
  //int res = GetInt();
  Comment(
          StringFormat(
          "Show information\n"+
          //"global_test = %G\n"+


          //"global_counttotallevel = %G\n"+
          //"support = %G\n"+
          //"resistent = %G\n"+
          //"count support = %d\n"+
          //"count resistent= %d\n"+


          "global_variancesupport = %G\n"+
          "global_varianceresistent = %G\n"+
          "compare rs1 support > resistent = %d\n"+
          
          "curve type = "+ global_str_currentcurvetype + "\n"+
          "test dll int = %d\n"+
          "pos0 = %d,  pos1 = %d,  pos2 = %d, pos3 = %d, pos4 = %d, pos5 = %d \n"+
          "support is double check = %d \n"+
          "resistent is double check = %d \n"
          
          ,


          //global_test,



          //global_counttotallevel,
          //global_avesupport,
          //global_averesistent,
          //global_countsupport,

          //global_countresistent,


          global_variancesupport,
          global_varianceresistent,
          global_variancecomparers,
          
          //global_variancecomparers,
          global_inttest,
          global_levelorderarr[0],
          global_levelorderarr[1],
          global_levelorderarr[2],
          global_levelorderarr[3],
          global_levelorderarr[4],
          global_levelorderarr[5],
          global_supportisdoublecheck,
          global_resistentisdoublecheck
     
          )
    );

}


