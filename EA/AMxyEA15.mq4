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

double global_con_macd_m5[5];
double global_con_macdsignal_m5[5];
//////////////////////////////////////////////////////////////////////
//int counttotallevel;
//int global_lastcounttotallevel;
//////////////////////////////////////////////////////////////////////
double global_variancesupport;
double global_varianceresistent;



double global_avesupport = 0;
double global_averesistent = 0;

double global_supportdivresistent = 0;

int global_variancecomparers = 0;
string global_str_currentcurvetype;
//////////////////////////////////////////////////////////////////////
bool global_supportisdoublecheck = false;
bool global_resistentisdoublecheck = false;

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

int global_ordertype = 0;
//////////////////////////////////////////////////////////////////////
#define UNKNOWNRS 0
#define SRSR -1
#define RSRS 1

int global_currentcurvetype = UNKNOWNRS;
//////////////////////////////////////////////////////////////////////
double global_grid_top = 0;
double global_grid_bottom = 0;
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
double global_pipvalue = 0;
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
#define LEVELORDERNUM 6
int global_levelorderarr[LEVELORDERNUM];
//////////////////////////////////////////////////////////////////////
double global_ema150[LEVELORDERNUM];
double global_stoch[LEVELORDERNUM];
double global_rsi[LEVELORDERNUM];
//////////////////////////////////////////////////////////////////////
double global_buyordertakeprice = 0;
double global_buyorderstoploss = 0;

double global_sellordertakeprice = 0;
double global_sellorderstoploss = 0;
//////////////////////////////////////////////////////////////////////
double global_currentema150 = 0;

double global_market_stoplevel = 0;
double global_market_spread = 0;
double global_market_freezelevel = 0;
//////////////////////////////////////////////////////////////////////
int global_recognizedcode = -100;
//////////////////////////////////////////////////////////////////////
double global_temp_down_buystopprice = 0;
double global_temp_up_sellstopprice = 0;
double global_temp_range_buystopprice = 0;
double global_temp_range_sellstopprice = 0;

double global_last_range_price = 0;
//////////////////////////////////////////////////////////////////////
double global_edgeprice[6];
int global_edgepos[6];
//////////////////////////////////////////////////////////////////////
#define RANGE_SELLSTOP_MAGICCODE 20
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
#define FIBNOCCI_V 68.76 //0.236
#define PI 3.14159265
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
#define MIDDLEPOS 2
#define NUMOFLEVEL 6
#define MACDLENGTH 5
void EnvarimentVariablesUpdate()
{
    global_market_stoplevel = MarketInfo( Symbol(), MODE_STOPLEVEL );
    global_market_spread = MarketInfo( Symbol(), MODE_SPREAD );
    global_market_freezelevel = MarketInfo( Symbol(), MODE_FREEZELEVEL );



    FlushMACD(global_con_macd_m5, global_con_macdsignal_m5, MACDLENGTH, 0);
    //clear old data
    for(int i = 0; i< LEVELNUM; i++)
    {
        levelarray[i].clear();
    }

    
    int counttotallevel = 0;
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
            counttotallevel++;
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
    for( int i = 0; i < counttotallevel; i++ )
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

    }

    
    ////////////////////////////////////////////////////////////////
    //filter leve data
    int outstart = 0;
    //find 4
    for(int w = 0; w<LEVELORDERNUM; w++)
    {
          
          int i = outstart;
          //int t = levelarray[i].leveltype;
          int endp = outstart;
          for(int j = i + 1; j < counttotallevel; j++)
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
    //check same vpos
    


    /////////////////////////////////////////////////////////////////
    //find curve type
    if( levelarray[0].leveltype == 1 )
    {

        global_currentcurvetype = RSRS;
        global_str_currentcurvetype = "RSRS";
    }
    if( levelarray[0].leveltype == -1 )
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
    if( global_currentcurvetype == SRSR )
    {
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
        if( CheckDuplicate( eh1, el1, eh3 , el3) 
            //|| CheckPriceIsClose(ep1, ep3  ) 
            )
        {
            global_supportisdoublecheck = true;
        }
        else
        {
            global_supportisdoublecheck = false;
        }

        //0  2 is resistent
        //global_resistentisdoublecheck = CheckDuplicate(eh0 , el0, eh2, el2) || CheckPriceIsClose( ep0, ep2 );

        if( 
          CheckDuplicate(eh0 , el0, eh2, el2) 
          //|| CheckPriceIsClose( ep0, ep2 ) 
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
        if( CheckDuplicate( eh1, el1, eh3 , el3) || CheckPriceIsClose( ep1, ep3 ) )
        {
            global_resistentisdoublecheck = true;
        }
        else
        {
            global_resistentisdoublecheck = false;
        }

    }
    //double check end

    //computing ema150 sto rsi
    for(int i = 0; i < LEVELORDERNUM; i++)
    {
        global_ema150[i] = iMA( NULL, 0, 150, 0, MODE_EMA, PRICE_CLOSE, levelarray[ global_levelorderarr[i] ].vpos );
        //global_stoch[i] = iStochastic( NULL, 0, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, levelarray[ global_levelorderarr[i] ].vpos );
        global_rsi[i] = iRSI( NULL, 0, 9, PRICE_CLOSE, levelarray[ global_levelorderarr[i] ].vpos );
    }

    for(int i = 0; i< LEVELORDERNUM; i++)
    {
        int type = levelarray[ global_levelorderarr[i] ].leveltype;
        int pos = levelarray[ global_levelorderarr[i] ].vpos;
        double sto = 0;
        double temp[3];
        temp[0] = iStochastic( NULL, 0, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, pos - 1);
        temp[1] = iStochastic( NULL, 0, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, pos);
        temp[2] = iStochastic( NULL, 0, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, pos + 1);

        if( type == 1 )
        {
            //support, find lowest stoch
            sto = temp[ ArrayMinimum( temp, WHOLE_ARRAY, 0 ) ];
        }

        if( type == -1 )
        {
            //resistent, find highest stoch
            sto = temp[ ArrayMaximum( temp, WHOLE_ARRAY, 0 ) ];
        }
        global_stoch[i] = sto;
    }

    global_currentema150 = iMA( NULL, 0, 150, 0, MODE_EMA, PRICE_CLOSE, 0 );

    for(int i = 0; i< 6; i++)
    {
        global_edgeprice[i] = levelarray[ global_levelorderarr[i] ].edgeprice;
        global_edgepos[i] = levelarray[ global_levelorderarr[i] ].vpos;
    }


}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
int RecognizeCurrentStatus()
{
    int res = -100;
    


    //send in range signal  2
    double inrange = false;

    double temp_c = 0;
    if( global_currentcurvetype == RSRS )
    {
        if( global_ema150[0] > global_edgeprice[0] && global_ema150[0] < global_edgeprice[1] ) 
        {
            temp_c++;
        }
            

        if( global_ema150[1] > global_edgeprice[0] && global_ema150[1] > global_edgeprice[2] && global_ema150[1] < global_edgeprice[1] ) 
        {
            temp_c++;
        }
            

        if( global_ema150[2] > global_edgeprice[2] && global_ema150[2] < global_edgeprice[1] && global_ema150[2] < global_edgeprice[3] )
        {
            temp_c++;
        }

        if( global_ema150[3] > global_edgeprice[2] && global_ema150[3] > global_edgeprice[4] && global_ema150[3] < global_edgeprice[3] )
        {
            temp_c++;
        }


        if( global_ema150[4] > global_edgeprice[4] && global_ema150[4] < global_edgeprice[3] && global_ema150[4] < global_edgeprice[5] )
        {
            temp_c++;
        }

        if( global_ema150[5] > global_edgeprice[4] && global_ema150[5] < global_edgeprice[5] ) 
        {
            temp_c++;
        }


    }

    if( global_currentcurvetype == SRSR )
    {
        if( global_ema150[0] > global_edgeprice[1] && global_ema150[0] < global_edgeprice[0] ) 
        {
            temp_c++;
        }
            

        if( global_ema150[1] > global_edgeprice[1] && global_ema150[1] < global_edgeprice[0] && global_ema150[1] < global_edgeprice[2] ) 
        {
            temp_c++;
        }
            

        if( global_ema150[2] > global_edgeprice[1] && global_ema150[2] > global_edgeprice[3] && global_ema150[2] < global_edgeprice[2] )
        {
            temp_c++;
        }

        if( global_ema150[3] > global_edgeprice[3] && global_ema150[3] < global_edgeprice[2] && global_ema150[3] < global_edgeprice[4] )
        {
            temp_c++;
        }


        if( global_ema150[4] < global_edgeprice[4] && global_ema150[4] > global_edgeprice[3] && global_ema150[4] > global_edgeprice[5] )
        {
            temp_c++;
        }

        if( global_ema150[5] < global_edgeprice[4] && global_ema150[5] > global_edgeprice[5] ) 
        {
            temp_c++;
        }
    }


    if( temp_c >= 5 
      //&& global_supportisdoublecheck == true && global_resistentisdoublecheck == true 
      )
    {
        res = 2;

        inrange = true;
    }


    
    //absolute down
    if( 
            global_edgeprice[0] < global_ema150[0] 
            && global_edgeprice[1] < global_ema150[1]
            && global_edgeprice[2] < global_ema150[2]
            && global_edgeprice[3] < global_ema150[3]
            && global_edgeprice[4] < global_ema150[4]
            && global_edgeprice[5] < global_ema150[5]

            && global_ema150[0] < global_ema150[5] && ArrayMinimum( global_ema150, WHOLE_ARRAY, 0 ) == 0 
            && global_currentema150 < global_ema150[0] 
            && Ask < global_currentema150
            
     )
    {
        res = 3;
        if( global_currentcurvetype == SRSR )
        {
            /**
            && ( 
                  ( global_edgeprice[0] < global_edgeprice[2] ) 
                  ||  
                  global_resistentisdoublecheck == true  
                )
            */

        }

        if( global_currentcurvetype == RSRS )
        {

        }

    }

    //absolute up
    if( 
            global_edgeprice[0] > global_ema150[0] 
            && global_edgeprice[1] > global_ema150[1]
            && global_edgeprice[2] > global_ema150[2]
            && global_edgeprice[3] > global_ema150[3]
            && global_edgeprice[4] > global_ema150[4]
            && global_edgeprice[5] > global_ema150[5]
            && global_ema150[0] > global_ema150[5] && ArrayMaximum( global_ema150, WHOLE_ARRAY, 0 ) == 0 
            && global_currentema150 > global_ema150[0]
            && Bid > global_currentema150
     )
    {
        res = 4;
        if( global_currentcurvetype == RSRS )
        {
            /**
            ( 
              ( global_edgeprice[0] > global_edgeprice[2] ) 
              ||  
              global_supportisdoublecheck == true  
            )

            */

        }

        if( global_currentcurvetype == SRSR )
        {

        }
    }

    //up acroess
    if(  
            global_currentcurvetype == SRSR
            && global_edgeprice[0] > global_ema150[0] 
            && global_edgeprice[1] < global_ema150[1]
            && global_edgeprice[2] < global_ema150[2]
            && global_edgeprice[3] < global_ema150[3]
            && global_edgeprice[4] < global_ema150[4]
            && global_edgeprice[5] < global_ema150[5]
            && global_ema150[1] < global_ema150[5] 
            //&& ( ArrayMinimum( global_ema150, WHOLE_ARRAY, 0 ) == 0 ||  ArrayMinimum( global_ema150, WHOLE_ARRAY, 0 ) == 1 )
            //&& global_currentema150 > global_ema150[0] 
            //&& Bid > global_currentema150

      )
    {
        res = 5;

    }

    if(  
            global_currentcurvetype == RSRS
            && global_edgeprice[0] < global_ema150[0] 
            && global_edgeprice[1] > global_ema150[1]
            && global_edgeprice[2] > global_ema150[2]
            && global_edgeprice[3] > global_ema150[3]
            && global_edgeprice[4] > global_ema150[4]
            && global_edgeprice[5] > global_ema150[5]
            && global_ema150[1] > global_ema150[5] 
            //&& ( ArrayMaximum( global_ema150, WHOLE_ARRAY, 0 ) == 0 ||  ArrayMaximum( global_ema150, WHOLE_ARRAY, 0 ) == 1 )
            //&& global_currentema150 < global_ema150[0] 
            //&& Ask < global_currentema150
      )
    {
        res = 6;
    }


    return res;

}

int RecognizeWave()
{
    int res = 0; 
    if( global_currentcurvetype == RSRS )
    {
        if( 
          global_edgeprice[0] <= global_edgeprice[2] 
          && global_stoch[0] > global_stoch[2]
          && global_stoch[2] < 20
          && global_stoch[0] > 20
          )
        {
            res = 1;
        }

        //0 2 4

        if( 
          global_edgeprice[0] <= global_edgeprice[4] 
          && global_stoch[0] > global_stoch[4]
          && global_stoch[4] < 20
          && global_stoch[0] > 20
          && res != 1
          )
        {
            res = 3;
        }


        if( 
          global_edgeprice[0] >= global_edgeprice[2] 
          && global_stoch[0] < global_stoch[2]
          && global_stoch[2] > 20
          && global_stoch[0] < 20
          && res !=1 && res != 3
          )
        {
            res = 5;
        }

        if( 
          global_edgeprice[0] >= global_edgeprice[4] 
          && global_stoch[0] < global_stoch[4]
          && global_stoch[4] > 20
          && global_stoch[0] < 20
          && res !=1 && res != 3 && res != 5
          )
        {
            res = 7;
        }


    }

    if( global_currentcurvetype == SRSR )
    {
        if(
          global_edgeprice[0] >= global_edgeprice[2]
          && global_stoch[0] < global_stoch[2]
          && global_stoch[2] > 80
          && global_stoch[0] < 80
          )
        {
            res = 2;
        }

        if(
          global_edgeprice[0] >= global_edgeprice[4]
          && global_stoch[0] < global_stoch[4]
          && global_stoch[4] > 80
          && global_stoch[0] < 80
          && res != 2
          )
        {
            res = 4;
        }

        if(
          global_edgeprice[0] <= global_edgeprice[2]
          && global_stoch[0] > global_stoch[2]
          && global_stoch[2] < 80
          && global_stoch[0] > 80
          && res != 2 && res != 4
          )
        {
            res = 6;
        }

        if(
          global_edgeprice[0] <= global_edgeprice[4]
          && global_stoch[0] > global_stoch[4]
          && global_stoch[4] < 80
          && global_stoch[0] > 80
          && res != 2 && res != 4 && res != 6
          )
        {
            res = 8;
        }
    }



    return res;
}


void WorkingProcess()
{
    EnvarimentVariablesUpdate();

    

    //collect data

    int cb = 0;
    double tbl = 0;

    int cs = 0;
    double tsl = 0;

    double tl = 0;
    int to = 0;
    int tpo = 0;//totoal pening order

    int cbl = 0, cbs = 0, csl = 0, css = 0;

    double pr = 0;
    double ProfitPot = 0;

    double pb = 0;
    double ps = 0;


    bool allbuyorderprofitispositive = false;
    bool allsellorderprofitispositive = false;

    //double CurrentTP = 0;

    for (int i = 0; i < OrdersTotal(); i++)
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_BUY && OrderMagicNumber() == global_magic )
            {


                cb++;
                pr = pr + OrderProfit() + OrderSwap() + OrderCommission();
                pb = pb + OrderProfit() + OrderSwap() + OrderCommission();
                tbl = tbl + OrderLots();
                ProfitPot = ProfitPot + OrderSwap() + OrderCommission() + OrderLots()*global_pipvalue*(((OrderTakeProfit() - OrderOpenPrice())/Point));

                //CurrentTP = OrderTakeProfit();
            }

            if( OrderType()==OP_SELL && OrderMagicNumber() == global_magic )
            {
                cs++;
                pr = pr + OrderProfit() + OrderSwap() + OrderCommission();
                ps = ps + OrderProfit() + OrderSwap() + OrderCommission();
                tsl = tsl + OrderLots();
                ProfitPot = ProfitPot + OrderSwap() + OrderCommission() + OrderLots()*global_pipvalue*(((OrderOpenPrice() - OrderTakeProfit())/Point));
                //CurrentTP = OrderTakeProfit();
            }

            if( OrderType()==OP_BUYLIMIT && OrderMagicNumber() == global_magic ) cbl++;
            if( OrderType()==OP_BUYSTOP && OrderMagicNumber() == global_magic ) cbs++;
            if( OrderType()==OP_SELLLIMIT && OrderMagicNumber() == global_magic ) csl++;
            if( OrderType()==OP_SELLSTOP && OrderMagicNumber() == global_magic ) css++;
        }

    }



    tl = tbl + tsl;
    to = cb + cs;
    tpo = cbl + cbs + csl + css;


    ProfitPot = NormalizeDouble(ProfitPot,2);
    pr        = NormalizeDouble(pr,2);


    for( int i = 0; i < OrdersTotal(); i++ )
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_BUY && OrderMagicNumber() == global_magic )
            {
                if( OrderProfit() > 0 )
                {
                    allbuyorderprofitispositive = true;
                }
                else
                {
                    allbuyorderprofitispositive = false;
                    break;
                }
            }

        }
    }

    for( int i = 0; i < OrdersTotal(); i++ )
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_SELL && OrderMagicNumber() == global_magic )
            {
                if( OrderProfit() > 0 )
                {
                    allsellorderprofitispositive = true;
                }
                else
                {
                    allsellorderprofitispositive = false;
                    break;
                }
            }
        }
    }

    //for sending order
    //
    int recogniazeres = RecognizeCurrentStatus();

    global_inttest = RecognizeWave();
    global_recognizedcode = recogniazeres;
    //TAG P
    //SRSR
    if( recogniazeres == -1 )
    {
        double startprice = global_edgeprice[0] + global_market_spread * Point + global_market_stoplevel * Point + global_market_freezelevel * Point;

        global_buyorderstoploss = global_edgeprice[1];// - global_market_spread * Point - global_market_stoplevel * Point - global_market_freezelevel * Point;
        //global_buyordertakeprice = startprice + ( global_market_spread * Point + Point * 15) * 10;
        
        //delete and resend new order
        int mindex = 0;
        if( cbs > 0 && global_edgeprice[0] != global_temp_down_buystopprice )
        {
            
            //send new bs
            /**
            for(int i = 0; i< 5; i++)
            {
                double orderprice = startprice + ( global_market_spread * Point + Point * 15) * i;

                
                int ticket = OrderSend( Symbol(), OP_BUYSTOP, 0.01, orderprice, global_market_spread, 0, global_buyordertakeprice , "bs", global_magic);

                if( ticket == -1)
                {
                    Alert("buy stop order error, code = ", GetLastError());
                }
                
            }
            */
            global_temp_down_buystopprice = global_edgeprice[0];

            
        }

        //if no cbs, send new cbs
        if( cbs == 0 )
        {
            
            //send cbs
            /**
            for(int i = 0; i< 5; i++)
            {
                double orderprice = startprice + ( global_market_spread * Point + Point * 15) * i;
                
                int ticket = OrderSend( Symbol(), OP_BUYSTOP, 0.01, orderprice, global_market_spread, 0, global_buyordertakeprice , "bs", global_magic);

                if( ticket == -1)
                {
                    Alert("buy stop order error, code = ", GetLastError());
                    
                }
                
            }
            */
            global_temp_down_buystopprice = global_edgeprice[0];

        }


    }

    if( recogniazeres == 1 )
    {
        double startprice = global_edgeprice[0] - global_market_spread * Point - global_market_stoplevel * Point - global_market_freezelevel * Point;

        global_sellorderstoploss = global_edgeprice[1];// + global_market_spread * Point + global_market_stoplevel * Point + global_market_freezelevel * Point;
        //global_sellordertakeprice = startprice - ( global_market_spread * Point + Point * 15) * 10;

        int mindex = 0;
        if( css > 0 &&  global_edgeprice[0] != global_temp_up_sellstopprice )
        {
           
            
            //send new bs
            /**
            for(int i = 0; i< 5; i++)
            {
                double orderprice = startprice - ( global_market_spread * Point + Point * 15) * i;
                
                int ticket = OrderSend( Symbol(), OP_SELLSTOP, 0.01, orderprice, global_market_spread, 0, global_sellordertakeprice , "ss", global_magic);

                if( ticket == -1)
                {
                    Alert("sell stop order error, code = ", GetLastError());
                }
                
            }
            */
            global_temp_up_sellstopprice = global_edgeprice[0];

            
        }

        //if no cbs, send new cbs
        if( css == 0 )
        {
            
            //send cbs
            /**
            for(int i = 0; i< 5; i++)
            {
                double orderprice = startprice - ( global_market_spread * Point + Point * 15) * i;
                
                int ticket = OrderSend( Symbol(), OP_SELLSTOP, 0.01, orderprice, global_market_spread, 0, global_sellordertakeprice , "ss", global_magic);

                if( ticket == -1)
                {
                    Alert("sell stop order error, code = ", GetLastError());
                }
                
            }
            */
            global_temp_up_sellstopprice = global_edgeprice[0];

        }

    }

    if( recogniazeres == 2 )
    {
        if( cbs == 0 && cbl == 0 && cb == 0 && css == 0 && csl == 0 && cs == 0 )
        {
            //no order, so send order
            //sell stop
            double ssbase = global_edgeprice[  ArrayMinimum( global_edgeprice, WHOLE_ARRAY, 0 )  ];
            double bsbase = global_edgeprice[  ArrayMaximum( global_edgeprice, WHOLE_ARRAY, 0 )  ];

            double ssstartprice = ssbase - global_market_spread * Point - global_market_stoplevel * Point - global_market_freezelevel * Point;

            double bsstartprice = bsbase + global_market_spread * Point + global_market_stoplevel * Point + global_market_freezelevel * Point;

            for(int i = 0; i< 1; i++)
            {
                double orderprice = ssstartprice - ( global_market_spread * Point + Point * 15) * i;
                
                int ticket = OrderSend( Symbol(), OP_SELLSTOP, 0.01, orderprice, global_market_spread, 0, 0 , "ss", global_magic);

                if( ticket == -1)
                {
                    Alert("sell stop order error, code = ", GetLastError());
                }
                
            }

            //buy
            for(int i = 0; i< 1; i++)
            {
                double orderprice = bsstartprice + ( global_market_spread * Point + Point * 15) * i;
                
                int ticket = OrderSend( Symbol(), OP_BUYSTOP, 0.01, orderprice, global_market_spread, 0, 0 , "bs", global_magic);

                if( ticket == -1)
                {
                    Alert("buy stop order error, code = ", GetLastError());
                    
                }
                
            }

        }

        if( cb > 0 )
        {

        }

        if( cs > 0 )
        {

        }

    }

    //force to close
    if( recogniazeres == 20 )
    {
        //has buy order
        if( cb > 0 )
        {
            if( pb > 0 )
            {
                //close all buy
                CloseAllBuyOrder();
            }

        }

        //has sell order
        if( cs > 0 )
        {
            if( ps > 0 )
            {
                //close all sell order
                CloseAllSellOrder();
            }

        }
    }

    //trace buy order stop loss

    



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


      
      WorkingProcess();


      
      
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
//|  function                                                   |
//+------------------------------------------------------------------+
void DeleteAllBuyStopOrder()
{
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_BUYSTOP && OrderMagicNumber() == global_magic )
            {
                //OrderDelete(OrderTicket());
                if(  !OrderDelete( OrderTicket() ) )
                {
                    Alert("delete buy stop order error, code = ", GetLastError());
                }
            }
        }
    }
}

void DeleteAllSellStopOrder()
{
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_SELLSTOP && OrderMagicNumber() == global_magic )
            {
                //OrderDelete(OrderTicket());
                if(  !OrderDelete( OrderTicket() ) )
                {
                    Alert("delete sell stop order error, code = ", GetLastError());
                }
            }
        }
    }
}

void DeleteAllBuyLimitOrder()
{
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_BUYLIMIT && OrderMagicNumber() == global_magic )
            {
                //OrderDelete(OrderTicket());
                if(  !OrderDelete( OrderTicket() ) )
                {
                    Alert("delete buy limit order error, code = ", GetLastError());
                }
            }
        }
    }
}
void DeleteAllSellLimitOrder()
{
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_SELLLIMIT && OrderMagicNumber() == global_magic )
            {
                //OrderDelete(OrderTicket());
                if(  !OrderDelete( OrderTicket() ) )
                {
                    Alert("delete sell limit order error, code = ", GetLastError());
                }
            }
        }
    }
}
//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
void CloseAllBuyOrder()
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

}

void CloseAllSellOrder()
{
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if( OrderSelect (i, SELECT_BY_POS, MODE_TRADES) )
        {
            if( OrderType()==OP_SELL && OrderMagicNumber() == global_magic )
            {
                OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(), 2, Red);
            }
        }
    }
}

//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+
bool CheckDuplicate(double eh0, double el0, double eh2, double el2)
{
    if( 
        (( eh0 <= eh2 ) && ( eh0 >= el2 ))
        ||
        (( el0 <= eh2 ) && ( el0 >= el2))
        ||
        (eh2 <= eh0 && eh2 >= el0)
        ||
        (el2 <= eh0 && el2 >= el0)
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
void InitLineObject()
{
    //ini 
    for(int i = 0; i< 6; i++)
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




    }

    //arrow
    for( int i = 0; i< 3; i++ )
    {
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


    //need 5 to change
    for(int i = 0; i<5; i++)
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

    //second choice
    for(int i = 0; i< 6; i++)
    {
        string trendlinename = "level2"+ IntegerToString(i);
        if(!ObjectCreate(0, trendlinename ,OBJ_TREND,0, Time[0], 0, Time[0], 0))
        {
            Print(__FUNCTION__,
                  ": failed to create a trend line! Error code = ",GetLastError());
        }

        ObjectSetInteger( 0, trendlinename , OBJPROP_COLOR, White);
        ObjectSetInteger( 0, trendlinename , OBJPROP_STYLE, STYLE_SOLID );
        ObjectSetInteger( 0, trendlinename , OBJPROP_WIDTH, 5);
        ObjectSetInteger( 0, trendlinename , OBJPROP_BACK, false);
        ObjectSetInteger( 0, trendlinename , OBJPROP_RAY, false);
    }


    //test
    
    if(!ObjectCreate(0 , "buyordertp", OBJ_HLINE, 0,0,0))
    {
        Print(__FUNCTION__,
              ": failed to create a horizontal line! Error code = ",GetLastError());
    }

    ObjectSetInteger(0, "buyordertp", OBJPROP_STYLE, STYLE_SOLID);
    ObjectSetInteger(0, "buyordertp", OBJPROP_WIDTH, 1 );
    ObjectSetInteger(0, "buyordertp", OBJPROP_BACK, false );
    ObjectSetInteger(0, "buyordertp", OBJPROP_RAY, false );
    ObjectSetInteger(0, "buyordertp", OBJPROP_COLOR, White);
    



}




//+------------------------------------------------------------------+
//|  function                                              |
//+------------------------------------------------------------------+

void DisplayLevelElements()
{

    //display level label and level line
    for(int i = 0 ; i < 6; i++)
    {
        int p = global_levelorderarr[i];
        double price  = levelarray[p].edgeprice; //price
        int ti = levelarray[p].vpos; // time
        double type = levelarray[p].leveltype; //type

        string levellinename = "levelline" +  IntegerToString(i);
        string labelname = "levellabel"+IntegerToString(i);
        ObjectSetString(0, labelname, OBJPROP_TEXT, levellinename);


        if( type == 1 )
        {
            //ObjectSetInteger(0, levellinename, OBJPROP_COLOR, clrPaleGreen );


            if(!ObjectMove(0, labelname, 0, Time[ti], price - 45 *Point ))
            {
                Print(__FUNCTION__,
                      ": 6 failed to move the anchor point! Error code = ",GetLastError());
            }

        }
        else
        {
            //ObjectSetInteger(0, levellinename, OBJPROP_COLOR, clrYellow );

            if(!ObjectMove(0, labelname, 0,Time[ti], price + 60 * Point ))
            {
                Print(__FUNCTION__,
                      ": 7 failed to move the anchor point! Error code = ",GetLastError());
            }
        }



        string level2name = "level2"+ IntegerToString(i);

        if( type == 1 )
        {
            //clrLime
            ObjectSetInteger(0, level2name, OBJPROP_COLOR, clrLime );

        }
        else
        {
            ObjectSetInteger(0, level2name, OBJPROP_COLOR, clrDeepPink );

        }

        if(!ObjectMove( 0 , level2name, 0 , Time[ ti - 1 ]  , price ))
        {
            Print(__FUNCTION__,
                  ": 80 failed to move the anchor point! Error code = ",GetLastError());
        }

        if(!ObjectMove( 0 , level2name, 1 , Time[ ti + 1 ]  , price ))
        {
            Print(__FUNCTION__,
                  ": 90 failed to move the anchor point! Error code = ",GetLastError());
        }



    }
    //display arrow
    for(int i = 0; i < 3; i++)
    {
        string levelresistentarrow_up = "levelresistentarrow_up" + IntegerToString(i);
        string levelresistentarrow_down = "levelresistentarrow_down" + IntegerToString(i);

        int m = i * 2;
        int n = i * 2 + 1;

        int pm = global_levelorderarr[m];
        int pn = global_levelorderarr[n];

        double pricem = levelarray[pm].edgeprice;
        double pricen = levelarray[pn].edgeprice;

        int tim = levelarray[pm].vpos;
        int tin = levelarray[pn].vpos;

        double typem = levelarray[pm].leveltype;
        double typen = levelarray[pn].leveltype;

        if( typem > 0 )
        {
            //support
            if(!ObjectMove( 0, levelresistentarrow_up, 0, Time[tim], pricem - 30 * Point) )
            {
                Print(__FUNCTION__,
                      ": failed to move the levelresistentarrow_up! Error code = ",GetLastError());
            }

            if(!ObjectMove(0, levelresistentarrow_down, 0, Time[ tin ], pricen + 5 * Point ) )
            {
                Print(__FUNCTION__,
                      ": failed to move the levelresistentarrow_down! Error code = ",GetLastError());
            }

        }
        else
        {
            if(!ObjectMove(0, levelresistentarrow_down, 0, Time[ tim ], pricem + 5 * Point ) )
            {
                Print(__FUNCTION__,
                      ": failed to move the levelresistentarrow_down! Error code = ",GetLastError());
            }

            if(!ObjectMove( 0, levelresistentarrow_up, 0, Time[tin], pricen - 30 * Point) )
            {
                Print(__FUNCTION__,
                      ": failed to move the levelresistentarrow_up! Error code = ",GetLastError());
            }
        }



    }

    

    for(int i = 0 ; i < 5 ; i++)
    {

        int j = i + 1;

        int startp = global_levelorderarr[i];
        int endp = global_levelorderarr[j];

        string trendlinename = "trend"+ IntegerToString(i);

        if(!ObjectMove( 0 , trendlinename, 0 , Time[ levelarray[startp].vpos ]  , levelarray[startp].edgeprice ))
        {
            Print(__FUNCTION__,
                  ": 8 failed to move the anchor point! Error code = ",GetLastError());
        }

        if(!ObjectMove( 0 , trendlinename, 1 , Time[ levelarray[endp].vpos ]  , levelarray[endp].edgeprice ))
        {
            Print(__FUNCTION__,
                  ": 9 failed to move the anchor point! Error code = ",GetLastError());
        }

    }

    //set buy and sell tp and sl line
    /**
    if(!ObjectMove(0, "levelline999", 0, 0, global_sellordertakeprice ))
    {
        Print(__FUNCTION__,
              ": 22 failed to move the horizontal line! Error code = ",GetLastError());
    }
    */


    

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


          //"counttotallevel = %G\n"+
          //"support = %G\n"+
          //"resistent = %G\n"+
          //"count support = %d\n"+
          //"count resistent= %d\n"+


          //"global_variancesupport = %G\n"+
          //"global_varianceresistent = %G\n"+
          //"compare rs1 support > resistent = %d\n"+
          
          "curve type = "+ global_str_currentcurvetype + "\n"+
          "test dll int = %d\n"+
          //"pos0 = %d,  pos1 = %d,  pos2 = %d, pos3 = %d, pos4 = %d, pos5 = %d \n"+
          "support is double check = %d \n"+
          "resistent is double check = %d \n"+
          "global_recognizedcode = %d\n" //+
          //"global_currentcurvetype = %d\n"
          ,


          //global_test,



          //counttotallevel,
          //global_avesupport,
          //global_averesistent,
          //global_countsupport,

          //global_countresistent,


          //global_variancesupport,
          //global_varianceresistent,
          //global_variancecomparers,
          
          //global_variancecomparers,
          global_inttest,
          //global_levelorderarr[0],
          //global_levelorderarr[1],
          //global_levelorderarr[2],
          //global_levelorderarr[3],
          //global_levelorderarr[4],
          //global_levelorderarr[5],
          global_supportisdoublecheck,
          global_resistentisdoublecheck,
            global_recognizedcode//,
            //global_currentcurvetype
          )
    );

}


