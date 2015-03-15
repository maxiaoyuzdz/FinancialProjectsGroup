//+------------------------------------------------------------------+
//|                                                 TestTemplete.mq4 |
//|                                                         Maxiaoyu |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#import "MT4EA3DLL.dll"
void PrintTest();
void ArrayTest(double &arr[][], int &marr[][]);
#import
/**
int matrix[10][10];

void PrintArray2D(int &arr[][])
{
  for(int i = 0; i< 10; i++)
  {
    arr[i][0] = 99;
  }

}
*/
#define NUMOFROW 2000
#define NUMOFCLOUM 2


#define FIBNOCCI_V 68.76 //0.236
#define PI 3.14159265
double ohlc_matrix_h1[NUMOFROW][NUMOFCLOUM];
int mark_matrix_h1[NUMOFROW][NUMOFCLOUM];


int GetKType(
  double openv,
  double highv,
  double lowv,
  double closev
  )
{
  double headv, legv, bodyv, rate_head, rate_leg;
  int res = 0;
  //not doji
  // a sun bar
  if( closev * 10 > openv * 10 )
  {
    res = 30;
    
    headv = MathAbs( highv - closev );
    legv = MathAbs( lowv - openv );
    bodyv = MathAbs(closev - openv);
    rate_head = (double)headv/bodyv;
    rate_leg = (double)legv/bodyv;
    //up shadow
    if( ( headv * 10 ) > ( legv * 10 ) )
    {
      //up shdow long = long head
      //judge the size is satisfy the conditions
      if( 
        ( rate_head * 10 > 15 && rate_leg * 10 < 2 )
        ||
        ( rate_head * 10 > 10 && rate_leg * 10 < 3 )
        ||
        ( rate_head * 10 > 20 && legv == 0 )
        ||
        ( rate_head * 10 > 20 && rate_leg * 10 < 1 )
        ||
        ( rate_head * 10 > 30 && rate_leg * 10 <= 10 )
        ||
        ( rate_head * 10 > 15 && rate_leg * 10 <= 6 )
        ||
        ( rate_head * 10 > 60 && rate_leg * 10 < 20 )
        ||
        ( rate_head * 10 > 26 && rate_leg * 10 < 7 )
        ||
        ( rate_head * 10 > 8 && rate_leg * 10 < 0.5 )
        )
      {
        //find a white body, up shadow hammer
        res = res + 5;
      }

      
    }
    //both have the same shadow or nothing
    if( ( headv * 10 ) == ( legv * 10 ) )
    {
      // same long, do nothing
      //this is a very special situation
    }
    //down shadow long
    if( ( headv * 10 ) < ( legv * 10 ) )
    {
      if( 
        ( rate_leg * 10 > 15 && rate_head * 10 < 2 )
        ||
        ( rate_leg * 10 > 10 && rate_head * 10 < 3 )
        ||
        ( rate_leg * 10 > 20 && headv == 0 )
        ||
        ( rate_leg * 10 > 20 && rate_head * 10 < 1 )
        ||
        ( rate_leg * 10 > 30 && rate_head * 10 <= 10 )
        ||
        ( rate_leg * 10 > 15 && rate_head * 10 <= 6 )
        ||
        ( rate_leg * 10 > 60 && rate_head * 10 < 20 )
        ||
        ( rate_leg * 10 > 26 && rate_head * 10 < 7 )
        ||
        ( rate_leg * 10 > 8 && rate_head * 10 < 0.5 )

        )
      {
        //find a white body, up shadow hammer
        //int len2 = swprintf(logbuf, 200, L"mt4 rate_head = %f, rate_leg = %f\n", rate_head, rate_leg);
        //OutputDebugString(logbuf);
        res = res - 5;
      }
    }

  }
  // a dark bar
  if( closev * 10 < openv * 10 )
  {
    res = 60;

    headv = MathAbs( highv - openv );
    legv = MathAbs( lowv - closev );
    bodyv = MathAbs(closev - openv);
    rate_head = (double)headv/bodyv;
    rate_leg = (double)legv/bodyv;


    
    // up shadow
    if( ( headv * 10 ) > ( legv * 10 ) )
    {
      //up shdow long = long head
      //judge the size is satisfy the conditions
      if( 
        ( rate_head * 10 > 15 && rate_leg * 10 < 2 )
        ||
        ( rate_head * 10 > 10 && rate_leg * 10 < 3 )
        ||
        ( rate_head * 10 > 20 && legv == 0 )
        ||
        ( rate_head * 10 > 20 && rate_leg * 10 < 1 )
        ||
        ( rate_head * 10 > 30 && rate_leg * 10 <= 10 )
        ||
        ( rate_head * 10 > 15 && rate_leg * 10 <= 6 )
        ||
        ( rate_head * 10 > 60 && rate_leg * 10 < 20 )
        ||
        ( rate_head * 10 > 26 && rate_leg * 10 < 7 )
        ||
        ( rate_head * 10 > 8 && rate_leg * 10 < 0.5 )


        )
      {
        //find a white body, up shadow hammer
        res = res + 5;
      }

    }

    //
    if( ( headv * 10 ) == ( legv * 10 ) )
    {
      // same long, do nothing
      //this is a very special situation
    }

    // down shadow
    if( ( headv * 10 ) < ( legv * 10 ) )
    {
      if( 
        ( rate_leg * 10 > 15 && rate_head * 10 < 2 )
        ||
        ( rate_leg * 10 > 10 && rate_head * 10 < 3 )
        ||
        ( rate_leg * 10 > 20 && headv == 0 )
        ||
        ( rate_leg * 10 > 20 && rate_head * 10 < 1 )
        ||
        ( rate_leg * 10 > 30 && rate_head * 10 <= 10 )
        ||
        ( rate_leg * 10 > 15 && rate_head * 10 <= 6 )
        ||
        ( rate_leg * 10 > 60 && rate_head * 10 < 20 )
        ||
        ( rate_leg * 10 > 26 && rate_head * 10 < 7 )
        ||
        ( rate_leg * 10 > 8 && rate_head * 10 < 0.5 )

        )
      {
        //find a white body, up shadow hammer
        //int len2 = swprintf(logbuf, 200, L"mt4 rate_head = %f, rate_leg = %f\n", rate_head, rate_leg);
        //OutputDebugString(logbuf);
        res = res - 5;
      }
    }

  }


  if( ( openv == closev )
    ||
    ( (rate_head * 10 + rate_leg * 10 ) > 200 )
   )
  {
    //doji
    res = 10;

    if( rate_head * 10 > rate_leg * 10 )
    {
      res = res + 5;
    }
    if( rate_head * 10 < rate_leg * 10 )
    {
      res = res - 5;
    }


  }


  return res;
}

int CheckDOJI(
  double openv,
  double highv,
  double lowv,
  double closev)
{
  double headv, legv, bodyv, rate_head, rate_leg;
  int res = 0;

  headv = MathAbs( highv - closev );
  legv = MathAbs( lowv - openv );
  bodyv = MathAbs(closev - openv);

  if(bodyv < 0.00000001 || bodyv == 0) bodyv = 0.00000001;


  rate_head = (double)headv/bodyv;
  rate_leg = (double)legv/bodyv;


  res = 90;

  if( rate_head * 10 > rate_leg * 10 )
  {
    res = res + 5;
  }
  if( rate_head * 10 < rate_leg * 10 )
  {
    res = res - 5;
  }


  return res;
}



void YieldOHLCdata_h1()
{
  for(int i = 0; i< NUMOFROW; i++)
  {
    double openv = iOpen( Symbol(), 0, i ) * 100;
    double highv = iHigh( Symbol(), 0, i ) * 100;
    double lowv = iLow( Symbol(), 0, i ) * 100;
    double closev= iClose( Symbol(), 0, i ) * 100;


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
    
    //ho  x
    ohlc_matrix_h1[i][0] = rate_x;// highv - openv;
    //lo  y
    ohlc_matrix_h1[i][1] = rate_y;//lowv - openv;
    //co
    //ohlc_matrix_h1[i][2] = closev - openv;
    //ohlc_matrix_h1[i][3]
    int res_ana = 0;

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


    mark_matrix_h1[i][0] = res_ana;
    
    mark_matrix_h1[i][1] = GetKType(openv, highv, lowv, closev);


  }


  Print( "ini ok" );
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   //PrintTest();
   /**
   PrintArray2D(matrix);
   ArrayTest(matrix);

    for(int i = 0; i< 10; i++)
    {
      Print( "v = ", matrix[i][0] );
    }
    */
    YieldOHLCdata_h1();
    ArrayTest(ohlc_matrix_h1, mark_matrix_h1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
