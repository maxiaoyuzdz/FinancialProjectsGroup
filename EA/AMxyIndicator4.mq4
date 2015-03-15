//+------------------------------------------------------------------+
//|                                                           t1.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"
//DLL Import
#import "MT4EA1DLL.dll"

int AnalyzeTrend(
  int recnumoflargetrend,
  int windowsize,
  double openarr[],
  double closearr[],
  double higharr[],
  double lowarr[],
  int& biguptrendindexbuffer[],
  int& bigdowntrendindexbuffer[],
  int& smalluptrendindexbuffer[],
  int& smalldowntrendindexbuffer[],
  int& backparemeters[]
  );

void TimeTestStart();
void TimeTestEnd();

#import

//--- input parameters
extern int       windowsize=8;
//extern int       totalbars=480;
extern int       recnumoflargetrend=20;

#define ARRAYRANGEFORBUFFER 640
#define EMAFAST 8
#define EMASLOW 30

//+------------------------------------------------------------------+
//| Custom Extern Parameters                         |
//+------------------------------------------------------------------+


#property indicator_chart_window

#define DATABUFSIZE 2000
//data buf for c++
double openarr[DATABUFSIZE];
double closearr[DATABUFSIZE];
double higharr[DATABUFSIZE];
double lowarr[DATABUFSIZE];

//#define ARRAYRANGEFORBUFFER 640
#define TRENDNUMBUFFER 256  //128 trend
#define NUMOFLINES 128    //but only 128 lins to use
//used for lines object
string uptrendlinenamearray[NUMOFLINES];
string downtrendlinenamearray[NUMOFLINES];

//////////////////////////////////////////////////////////////

//for big trend
int biguptrendindexbuffer[TRENDNUMBUFFER];
int bigdowntrendindexbuffer[TRENDNUMBUFFER];

int biguptrendindex = 0;
int bigdowntrendindex = 0;

int numofbiguptrend = 0;
int numofbigdowntrend = 0;

//for small trend
int smalluptrendindexbuffer[TRENDNUMBUFFER];
int smalldowntrendindexbuffer[TRENDNUMBUFFER];

int smalluptrendindex = 0;
int smalldowntrendindex = 0;

int numofsmalluptrend = 0;
int numofsmalldowntrend = 0;
//////////////////////////////////////////////////////////////
int backparemeters[4];

//+------------------------------------------------------------------+
//| custom function                                   |
//+------------------------------------------------------------------+

int global_bars = 0;

void FlushData()
{
  if(global_bars != Bars)
  {
    int cs = 
    ArrayCopy( openarr, Open, 0, 0, DATABUFSIZE );
    cs = 
    ArrayCopy( closearr, Close, 0, 0, DATABUFSIZE );
    cs = 
    ArrayCopy( higharr, High, 0, 0, DATABUFSIZE );
    cs = 
    ArrayCopy( lowarr, Low, 0, 0, DATABUFSIZE );
    global_bars = Bars;
  }
  else
  {
    openarr[0] = Open[0];
    closearr[0] = Close[0];
    higharr[0] = High[0];
    lowarr[0] = Low[0];
  }
  
}

//+------------------------------------------------------------------+
//| custom function                                   |
//+------------------------------------------------------------------+
void InitLineObjectArray()
{
  for( int i = 0; i < NUMOFLINES; i++ ){
    string upname = "up"+i;
    string downname = "down"+i;
    uptrendlinenamearray[i] = upname;
    downtrendlinenamearray[i] = downname;
    //upline

    int upst = Time[0];
    double upsp = 0;
      ObjectCreate( upname, OBJ_TREND, 0, upst, upsp);//
      ObjectSet( upname, OBJPROP_COLOR, Red );
    ObjectSet( upname, OBJPROP_STYLE, STYLE_SOLID );

    ObjectSet( upname, OBJPROP_WIDTH, 1 );
    ObjectSet( upname, OBJPROP_BACK, false );
    ObjectSet( upname, OBJPROP_RAY, false );

    //downline
      ObjectCreate( downname, OBJ_TREND, 0, upst, upsp);//
      ObjectSet( downname, OBJPROP_COLOR, Yellow );
    ObjectSet( downname, OBJPROP_STYLE, STYLE_SOLID );

    ObjectSet( downname, OBJPROP_WIDTH, 1 );
    ObjectSet( downname, OBJPROP_BACK, false );
    ObjectSet( downname, OBJPROP_RAY, false );

  }
}
void DeleteAllObjectInThisWindow()
{

  ObjectsDeleteAll();

}
string GetUpTrendLineName(int index)
{
  return(uptrendlinenamearray[index]);
}
string GetDownTrendLineName(int index)
{
  return(downtrendlinenamearray[index]);
}
void MoveUpTrendLine(int linenum, int si, int ei)
{
  

  int st = Time[si];
  double sp = Close[si];
  int et = Time[ei];
  double ep = Close[ei];
  string linename = GetUpTrendLineName(linenum);

  ObjectSet( linename, OBJPROP_TIME1, st );
  ObjectSet( linename, OBJPROP_PRICE1, sp );
  ObjectSet( linename, OBJPROP_TIME2, et );
  ObjectSet( linename, OBJPROP_PRICE2, ep );

}

void MoveDownTrendLine(int linenum, int si, int ei)
{
  
  int st = Time[si];
  double sp = Close[si];
  int et = Time[ei];
  double ep = Close[ei];
  string linename = GetDownTrendLineName(linenum);

  ObjectSet( linename, OBJPROP_TIME1, st );
  ObjectSet( linename, OBJPROP_PRICE1, sp );
  ObjectSet( linename, OBJPROP_TIME2, et );
  ObjectSet( linename, OBJPROP_PRICE2, ep );

}


//+------------------------------------------------------------------+
//| analyze function                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
void DisplayBigUpTrend()
{
  for(int i = 0; i< numofbiguptrend; i++)
  {
    int linenum = i;
    int startindexpos = linenum * 2 + 1;
    int endindexpos = linenum * 2;

    int startindex =  biguptrendindexbuffer[startindexpos];
    int endindex =    biguptrendindexbuffer[endindexpos];


    MoveUpTrendLine(linenum, startindex, endindex);

  }
}

void DisplayBigDownTrend()
{
  for(int i = 0; i< numofbigdowntrend; i++)
  {
    int linenum = i;
    int startindexpos = linenum * 2 + 1;
    int endindexpos = linenum * 2;

    int startindex =  bigdowntrendindexbuffer[startindexpos];
    int endindex =    bigdowntrendindexbuffer[endindexpos];
    MoveDownTrendLine(linenum, startindex, endindex);

  }
}

void DisplaySmallUpTrend()
{
  for(int i = 0; i< numofsmalluptrend; i++)
  {
    int linenum = i;
    int startindexpos = linenum * 2 + 1;
    int endindexpos = linenum * 2;

    int startindex =  smalluptrendindexbuffer[startindexpos];
    int endindex =    smalluptrendindexbuffer[endindexpos];


    MoveUpTrendLine(linenum, startindex, endindex);

  }
}

void DisplaySmallDownTrend()
{
  for(int i = 0; i< numofsmalldowntrend; i++)
  {
    int linenum = i;
    int startindexpos = linenum * 2 + 1;
    int endindexpos = linenum * 2;

    int startindex =  smalldowntrendindexbuffer[startindexpos];
    int endindex =    smalldowntrendindexbuffer[endindexpos];
    MoveDownTrendLine(linenum, startindex, endindex);

  }
}

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| analyze function                                   |
//+------------------------------------------------------------------+
int DLLComputingTrend()
{
  AnalyzeTrend(
    recnumoflargetrend,
    windowsize,
    openarr,
    closearr,
    higharr,
    lowarr,
    biguptrendindexbuffer,
    bigdowntrendindexbuffer,
    smalluptrendindexbuffer,
    smalldowntrendindexbuffer,
    backparemeters
    );
    numofbiguptrend = backparemeters[0];
    numofbigdowntrend = backparemeters[1];

    numofsmalluptrend = backparemeters[2];
    numofsmalldowntrend = backparemeters[3];

    //Print( "su = ",numofsmalluptrend," sd = ", numofsmalldowntrend);

}

//+------------------------------------------------------------------+
//| Custom indicator initialization function                       |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   InitLineObjectArray();


   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   DeleteAllObjectInThisWindow();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

    while( !IsStopped() ) 
    {
      RefreshRates();
    //  TimeTestStart();
    //  TimeTestStart();
      FlushData();
    
    //ComputingTrend();

    DLLComputingTrend();

  //  TimeTestEnd();

    DisplayBigUpTrend();
    DisplayBigDownTrend();

    //DisplaySmallUpTrend();
    //DisplaySmallDownTrend();

      Sleep(5);            
    }

//----
   return(0);
  }
//+------------------------------------------------------------------+