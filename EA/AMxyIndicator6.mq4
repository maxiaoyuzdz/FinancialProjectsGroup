//+------------------------------------------------------------------+
//|                                                          TTT.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

#import "MT4Indicator2DLL.dll"

int AnalyzeTrend(
  int recnumoflargetrend,
  int windowsize,
  double openarr[],
  double closearr[],
  double higharr[],
  double lowarr[],
  int& biguptrendindexbuffer[],
  int& bigdowntrendindexbuffer[],
  int& backparemeters[]
  );

void TimeTestStart();
void TimeTestEnd();

#import

//--- input parameters
extern int       windowsize=4;
//extern int       totalbars=480;
extern int       recnumoflargetrend=20;

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

//////////////////////////////////////////////////////////////
int backparemeters[2];
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
  double sp = Open[si];
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
  double sp = Open[si];
  int et = Time[ei];
  double ep = Close[ei];
  string linename = GetDownTrendLineName(linenum);

  ObjectSet( linename, OBJPROP_TIME1, st );
  ObjectSet( linename, OBJPROP_PRICE1, sp );
  ObjectSet( linename, OBJPROP_TIME2, et );
  ObjectSet( linename, OBJPROP_PRICE2, ep );

}

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
    backparemeters
    );

  //copy res value
    numofbiguptrend = backparemeters[0];
    numofbigdowntrend = backparemeters[1];


}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
  InitLineObjectArray();
//----
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
   int    counted_bars=IndicatorCounted();
//----
   FlushData();
    
    //ComputingTrend();

    DLLComputingTrend();

  //  TimeTestEnd();

    DisplayBigUpTrend();
    DisplayBigDownTrend();
//----
   return(0);
  }
//+------------------------------------------------------------------+