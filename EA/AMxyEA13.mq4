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
int global_lastcounttotallevel;
//////////////////////////////////////////////////////////////////////
double global_variancesupport;
double global_varianceresistent;

int global_countsupport = 0;
int global_countresistent = 0;

double global_avesupport = 0;
double global_averesistent = 0;


int global_variancecomparers = 0;
string global_str_variancecomparers;
//////////////////////////////////////////////////////////////////////
#define SYS_STATUS_ANALYZE 1
#define SYS_STATUS_SEND 2
#define SYS_STATUS_WAIT 3
#define SYS_STATUS_CLOSE 4

int global_systemstatus = SYS_STATUS_ANALYZE;
//////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////
#define UNKNOWNRS 0
#define SRSR 1
#define RSRS 2

int global_currentcurvetype = UNKNOWNRS;

double global_grid_top = 0;
double global_grid_bottom = 0;

//////////////////////////////////////////////////////////////////////
int global_countbuy = 0;
int global_countbuystop = 0;
int global_countbuylimit = 0;

int global_countsell = 0;
int global_countsellstop = 0;
int global_countselllimit = 0;
//////////////////////////////////////////////////////////////////////
double global_pipvalue = 0;
//////////////////////////////////////////////////////////////////////
double global_Profitpot = 0;

double global_totalbuylots = 0;
double global_totalselllots = 0;


double global_test = 0;
int global_inttest = 0;

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
  }
} levelarray[LEVELNUM];

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
#define MIDDLEPOS 2
#define NUMOFLEVEL 6
#define MACDLENGTH 5
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void SystemStateMachine(int status)
{

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
    CloseAllOrder();
    break;

  }
}


//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void AnalyzeMarketSea()
{
    

    global_lastcounttotallevel = global_counttotallevel;

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
      if( levelarray[i].leveltype == 1 )
      {
        //support
        levelarray[i].col = Green;
      }
      else
      {
        levelarray[i].col = clrYellow;

      }
      //////////////////////////////////////////////////////////////////////////
    }


    //compute variavce
    global_countsupport = 0;
    global_countresistent = 0;
    double sumsupport = 0;
    double sumresistent = 0;
    global_avesupport = 0;
    global_averesistent = 0;

    for(int i = 0; i < global_counttotallevel; i++)
    {
      if( levelarray[i].leveltype == 1 )
      {
        global_countsupport++;
        sumsupport = sumsupport + levelarray[i].edgeprice;
      }
      else
      {
        global_countresistent++;
        sumresistent = sumresistent + levelarray[i].edgeprice;
      }

    }

    if( global_countsupport > 0 && global_countresistent > 0 )
    {
      global_avesupport = ( sumsupport / global_countsupport );
      global_averesistent = (sumresistent /  global_countresistent);

      double ts = 0;
      double tr = 0;
      for(int i = 0; i < global_counttotallevel; i++)
      {
        if(  levelarray[i].leveltype == 1 )
        {
          ts = ts + ( levelarray[i].edgeprice - global_avesupport ) * ( levelarray[i].edgeprice - global_avesupport );

        }
        else
        {
          tr = tr + ( levelarray[i].edgeprice - global_averesistent ) * ( levelarray[i].edgeprice - global_averesistent );

        }
      }

      global_variancesupport = ts / global_countsupport;
      global_varianceresistent = tr / global_countresistent;


    }

    

    if( global_variancesupport > global_varianceresistent )
    {
      global_variancecomparers = 1;
    }
    else
    {
      global_variancecomparers = -1;
    }

    
    /////////////////////////////////////////////////////////////////
    //find curve type
    if( levelarray[0].leveltype == 1 )
    {
      global_currentcurvetype = RSRS;
      global_str_variancecomparers = "RSRS";
    }
    else
    {
      global_currentcurvetype = SRSR;
      global_str_variancecomparers = "SRSR";
    }


    ////////////////////////////////////////////////////////////////
    //find grid's top and bottom
    global_grid_top = 0;
    global_grid_bottom = 0;

    if( levelarray[0].leveltype == 1 )
    {
      //support
      global_grid_bottom = levelarray[0].edgeprice;

      for(int i = 1; i< global_counttotallevel; i++)
      {
        if( levelarray[i].leveltype == -1)
        {
          global_grid_top = levelarray[i].edgeprice;
          break;
        }
      }
    }
    else
    {
      //resistent
      global_grid_top = levelarray[0].edgeprice;
      for(int i = 1; i< global_counttotallevel; i++)
      {
        if( levelarray[i].leveltype == 1)
        {
          global_grid_bottom = levelarray[i].edgeprice;
          break;
        }
      }

    }


    ////////////////////////////////////////////////////////////////
    // compare the dis, make sure the current dis is not the biggest
    double abs_current_dis = MathAbs( global_grid_bottom - global_grid_top );


    bool findbiggerdis = false;

    //int starttype = 0;
    for(int i = 0; i< global_counttotallevel; i++)
    {
      //starttype = levelarray[i].leveltype;
      if( i > 0 )
      {
        if( levelarray[i].leveltype != levelarray[i - 1].leveltype )
        {
          double dis = MathAbs( levelarray[i].edgeprice - levelarray[i - 1].edgeprice );

          if( dis > abs_current_dis )
          {
            findbiggerdis = true;
            break;
          }

        }
      }
    }

    // after make sure the dis the not the biggest, so check the price
    //is between the top and bottom
    bool priceisintherange = false;
    if( findbiggerdis )
    {
      if( Bid > global_grid_bottom && Ask < global_grid_top )
      {
        priceisintherange = true;
      }
    }

    if( priceisintherange )
    {
      //start to send gridnet
      global_systemstatus = SYS_STATUS_SEND;
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
  //send buy stop above grid top
  double tempprice = 0;
  double market_stoplevel = MarketInfo( Symbol(), MODE_STOPLEVEL );
  int marketspread = MarketInfo( Symbol(), MODE_SPREAD );

  double top = global_grid_top + market_stoplevel + Point * 5;
  double bottom = global_grid_bottom - market_stoplevel - Point * 5;

  int count_error_bs = 0;

  int count_error_ss = 0;


  for(int i = 0; i< STOPORDERNUM; i++)
  {
    //ask
    double orderprice = top + Point * 15 * i;

    int ticket = OrderSend( Symbol(), OP_BUYSTOP, BASICLOT, orderprice, marketspread, 0, 0, "bs", global_magic);

    if( ticket == -1)
    {
      Alert("buy order error, code = ", GetLastError());
      count_error_bs++;
    }

  }

  //send sell top below grid bottom

  for(int i = 0; i< STOPORDERNUM; i++)
  {
    //ask
    double orderprice = bottom - Point * 15 * i;

    int ticket = OrderSend( Symbol(), OP_SELLSTOP, BASICLOT, orderprice, marketspread, 0, 0, "ss", global_magic);

    if( ticket == -1)
    {
      Alert("buy order error, code = ", GetLastError());
      count_error_ss++;
    }

  }

  if( count_error_bs > 0 )
  {
    //there are some bs order is not send corectly
  }

  if( count_error_ss > 0 )
  {

  }


  int count_bs = 0;
  int count_ss = 0;

  for( int i = OrdersTotal(); i >= 0; i-- )
  {
    if( OrderSelect( i, SELECT_BY_POS) == true )
    {
      if( OrderType() == OP_BUYSTOP )
      {
        count_bs++;
      }

      if( OrderType() == OP_SELLSTOP )
      {
        count_ss++;
      }
    }


  }

  if( count_bs > 0 || count_ss > 0 )
  {
    global_systemstatus = SYS_STATUS_WAIT;
  }

}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+

void WatchingGridNetMoving()
{
  //global_Profitpot = 0;
  //global_countbuy = 0;

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

  //+------------------------------------------------------------------+
  //| Calculate Total Profits, Profit Potential and Total Orders       |
  //+------------------------------------------------------------------+ 

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

  //+------------------------------------------------------------------+
  //| Adjust TP if ProfitPot is < 0                                    |
  //+------------------------------------------------------------------+

  if( ProfitPot < 0.0 )
  {
    //adjust buy order
    if( cb > 0 )
    {
      //get the current tp

      //calculate a new tp

      //modify all order with the new tp

    }

    //adjust sell order
    if( cs > 0 )
    {



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
void WorkingProcess()
{

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


    //WorkingProcess();
    //global_inttest++;




    //global_systemstatus = SYS_STATUS_WAIT;


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

    if( levelarray[i].leveltype == 1 )
    {
      //support
      if(!ObjectMove(0, levelresistentarrow_up,0,Time[ 0 ],0))
      {
        Print(__FUNCTION__,
              ": failed to move the levelresistentarrow_up! Error code = ",GetLastError());
      }
    }
    else
    {
      //resistent
      if(!ObjectMove(0, levelresistentarrow_down,0,Time[ 0 ],0))
      {
        Print(__FUNCTION__,
              ": failed to move the levelresistentarrow_down! Error code = ",GetLastError());
      }
    }
  }

  for(int i = 0; i < global_counttotallevel ; i++)
  {
    string levellinename = "levelline" +  IntegerToString(i);
    //label
    string labelname = "levellabel"+IntegerToString(i);
    ObjectSetString(0, labelname, OBJPROP_TEXT, levellinename);
    


    //level line
    ObjectSetInteger(0, levellinename, OBJPROP_COLOR, levelarray[i].col );
    if(!ObjectMove(0, levellinename,0,0,levelarray[i].edgeprice))
    {
      Print(__FUNCTION__,
            ": failed to move the horizontal line! Error code = ",GetLastError());
    }

    

    //arrow and label
    string levelresistentarrow_up = "levelresistentarrow_up" + IntegerToString(i);
    string levelresistentarrow_down = "levelresistentarrow_down" + IntegerToString(i);
    if( levelarray[i].leveltype == 1 )
    {
      //support
      if(!ObjectMove(0, levelresistentarrow_up,0,Time[ levelarray[i].vpos ],levelarray[i].edgeprice - 30 *Point))
      {
        Print(__FUNCTION__,
              ": failed to move the levelresistentarrow_up! Error code = ",GetLastError());
      }

      if(!ObjectMove(0, labelname, 0,Time[levelarray[i].vpos], levelarray[i].edgeprice - 45 *Point ))
      {
        Print(__FUNCTION__,
              ": failed to move the anchor point! Error code = ",GetLastError());
      }

    }
    else
    {
      //resistent
      if(!ObjectMove(0, levelresistentarrow_down,0,Time[ levelarray[i].vpos ],levelarray[i].edgeprice + 5*Point))
      {
        Print(__FUNCTION__,
              ": failed to move the levelresistentarrow_down! Error code = ",GetLastError());
      }

      if(!ObjectMove(0, labelname, 0,Time[levelarray[i].vpos], levelarray[i].edgeprice + 60 * Point ))
      {
        Print(__FUNCTION__,
              ": failed to move the anchor point! Error code = ",GetLastError());
      }
    }


  }



}
//+------------------------------------------------------------------+
//|  function                                              |
//+------------------------------------------------------------------+
void DisplayComment()
{
  //double market_stoplevel = MarketInfo( Symbol(), MODE_STOPLEVEL );

  double res1 = global_variancesupport / global_varianceresistent;
  double res2 = global_varianceresistent / global_variancesupport ;
  
  //int res = GetInt();
  Comment(StringFormat("Show information\n"+
      //"global_test = %G\n"+


      //"global_counttotallevel = %G\n"+
      //"support = %G\n"+
      //"resistent = %G\n"+
      //"count support = %d\n"+
      //"count resistent= %d\n"+


      "global_variancesupport = %G\n"+
      "global_varianceresistent = %G\n"+
      "compare rs1 support / resistent = %G\n"+
      "compare rs2 resistent / support = %G\n"+
      "curve type = "+ global_str_variancecomparers + "\n" +"",
      //"test dll int = %d\n",


      //global_test,



      //global_counttotallevel,
      //global_avesupport,
      //global_averesistent,
      //global_countsupport,

      //global_countresistent,


      global_variancesupport,
      global_varianceresistent,
      res1,
      res2,
      global_variancecomparers
      
      ));

}


