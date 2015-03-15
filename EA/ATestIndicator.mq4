//+------------------------------------------------------------------+
//|                                                      MAcross.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Yellow
#property indicator_color3 White
#property indicator_color4 Red
//--- input parameters
extern int       bigMA=10;
extern int       smallMA=5;
//--- buffers
double UpTrendLineBuffer[];
double DownTrendLineBuffer[];
double HighArrowBuffer[];
double LowArrowBuffer[];
//+------------------------------------------------------------------+
//| Global Init Indicator Functions                              |
//+------------------------------------------------------------------+
void InitIndicator()
{
  SetIndexStyle(0,DRAW_LINE);
  SetIndexBuffer(0,UpTrendLineBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,DownTrendLineBuffer);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,217);
   SetIndexBuffer(2,HighArrowBuffer);
   SetIndexEmptyValue(2,0.0);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,218);
   SetIndexBuffer(3,LowArrowBuffer);
   SetIndexEmptyValue(3,0.0);
}


//+------------------------------------------------------------------+
//| Global Variables                              |
//+------------------------------------------------------------------+
int GlobalStatisicWindowSize = 120;
int GlobalComputingWindowSize = 24;
int GlobalTraceIndex = 1;

//+------------------------------------------------------------------+
//| Global Functions                              |
//+------------------------------------------------------------------+
double MathAverageInterpolation(double startnum, double endnum, int startindex, int endindex , int index)
{
  int length = MathAbs( startindex - endindex );
  double valdistance = MathAbs( startnum - endnum );

  double averagedistance = valdistance / length;

  if(index == startindex) return(startnum);

  if(index == endindex) return(endnum);

  double res = startnum - averagedistance * MathAbs(startindex - index);

  return(res);

}

void CleanVideoDataBuffer()
{
  for(int clean_i = 0; clean_i<120; clean_i++)
    {
      HighArrowBuffer[clean_i] = 0;
      LowArrowBuffer[clean_i] = 0;

      DownTrendLineBuffer[clean_i] = 0;
      UpTrendLineBuffer[clean_i] = 0;
    }

}
//help function fina a max value in a array



//find the max trend in a section
int FindMaxObviousTrend(int startindex,int windowsize)
{
  //first find down trend   highest open & lowest close
  //begin
  int highestopenprice_index = ArrayMaximum( Open, windowsize, startindex );

  //end
  int lowestcloseprice_index = ArrayMinimum( Close, windowsize, startindex );



  if( lowestcloseprice_index <  highestopenprice_index)
  {
    //find a obvious down trend
    return(-1);
  }

  //if not have a obvious down trend, try to find a up trend

  //find up Up trend,  lowest open & highest close
  //begin 
  int lowestopenprice_index = ArrayMinimum( Open, windowsize, startindex );
  //end
  int highestcloseprice_index = ArrayMaximum( Close, windowsize, startindex );

  if(highestcloseprice_index < lowestopenprice_index)
  {
    return(1);
  }

}

//initialize 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
    double marketspread = MarketInfo( Symbol(), MODE_SPREAD );
    double marketpoint = MarketInfo( Symbol(), MODE_POINT );
    Print( "version 1.2 marketspread = ", marketspread);
    Print( "version 1.2 marketpoint = ", marketpoint);
//---- indicators
   InitIndicator();
//----






   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom function                              |
//+------------------------------------------------------------------+
void FindMostHighAndLowPos(int index)
{
      int i = index;
      int pastindex = i + 1;
      int pastpastindex = pastindex + 1;

      double lowval = Low[i];
      double pastlowval = Low[pastindex];
      double pastpastlowval = Low[pastpastindex];


      double highval = High[i];
      double pasthighval = High[pastindex];
      double pastpasthighval = High[pastpastindex];

      if((pasthighval > highval) && (pasthighval > pastpasthighval))
      {
        //find a high
        HighArrowBuffer[pastindex] = High[pastindex];

      }

      if((pastlowval < lowval) && (pastlowval < pastpastlowval))
      {
        //fina a low
        LowArrowBuffer[pastindex] = Low[pastindex];
      }
}



//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
    
/**
    //find high and low
    //clean buffer
    for(int j = 0; j< 120; j++)
    {
      HighArrowBuffer[j] = 0;
      LowArrowBuffer[j] = 0;
    }



    for(int i = 0; i< 120; i++)
    {
      int timeframe = 0;
   
      FindMostHighAndLowPos(i);
      
    }
*/
    //====================================================
    //clean arrow buffer
    CleanVideoDataBuffer();
    //====================================================

    //find highest open and lowest close
    //used for downside
    double downside_highes_open = 0;
    double downside_lowest_close = 1000;
    //save pos index
    int downside_highes_open_pos = 0;
    int downside_lowest_close_pos = 0;

    for(int i = 1; i < GlobalComputingWindowSize; i++)
    {
      //find open
      double temp_open = Open[i];
      if(temp_open > downside_highes_open) {
        downside_highes_open = temp_open;
        downside_highes_open_pos = i;
      }

      double temp_close = Close[i];
      if(temp_close < downside_lowest_close) {
        downside_lowest_close = temp_close;
        downside_lowest_close_pos = i;
      }



    }

    //show the highest opena and lowest close
    HighArrowBuffer[downside_highes_open_pos] = downside_highes_open + 50 * Point;
    LowArrowBuffer[downside_lowest_close_pos] = downside_lowest_close -  50 * Point;

    bool have_down_side = downside_lowest_close_pos < downside_highes_open_pos;

    if(have_down_side)
    {
      //mark the down trend
      int start_index = downside_highes_open_pos;
      int end_index = downside_lowest_close_pos;

      double start_num = downside_highes_open;
      double end_num = downside_lowest_close;


      for(int mpos = end_index; mpos <= start_index; mpos++ )
      {
        DownTrendLineBuffer[mpos] = MathAverageInterpolation(start_num, end_num, start_index, end_index, mpos);
      }

      


    }else{
      //draw up trend

    }






   
//----
   return(0);
  }
//+------------------------------------------------------------------+