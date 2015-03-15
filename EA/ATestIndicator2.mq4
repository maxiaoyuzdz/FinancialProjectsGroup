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
//extern int       bigMA=10;
//extern int       smallMA=5;
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

bool HaveUpTrend(int startindex,int windowsize)
{
  //find up Up trend,  lowest open & highest close
  //begin 
  int lowestopenprice_index = ArrayMinimum( Open, windowsize, startindex );
  //end
  int highestcloseprice_index = ArrayMaximum( Close, windowsize, startindex );

  return(highestcloseprice_index < lowestopenprice_index);

}

bool HaveDownTrend(int startindex,int windowsize)
{
  //begin
  int highestopenprice_index = ArrayMaximum( Open, windowsize, startindex );
  //end
  int lowestcloseprice_index = ArrayMinimum( Close, windowsize, startindex );

  return( lowestcloseprice_index <  highestopenprice_index);
}

//get the distance between end of section and end of trend
int GetDisEndofTrend(int ending, int size)
{
  //first find down trend   highest open & lowest close
  //begin
  int highestopenprice_index = ArrayMaximum( Open, size, ending );
  //end
  int lowestcloseprice_index = ArrayMinimum( Close, size, ending );



  if( lowestcloseprice_index <=  highestopenprice_index)
  {
    //find a obvious down trend
    return(lowestcloseprice_index - ending);
  }

  //if not have a obvious down trend, try to find a up trend

  //find up Up trend,  lowest open & highest close
  //begin 
  int lowestopenprice_index = ArrayMinimum( Open, size, ending );
  //end
  int highestcloseprice_index = ArrayMaximum( Close, size, ending );

  if(highestcloseprice_index <= lowestopenprice_index)
  {
    return(highestcloseprice_index - ending);
  }


}

void SaveUpTrend(int start, int end)
{
  //int size = start - end + 1;

  double startprice = Open[start];
  double endprice = Close[end];

  for(int i = start; i <= end; i--)
  {
    double currentprice = MathAverageInterpolation(startprice, endprice, start, end, i);
    UpTrendLineBuffer[i] = currentprice;
  }

}

void SaveDownTrend(int start, int end)
{
  //int size = start - end + 1;

  double startprice = Open[start];
  double endprice = Close[end];

  for(int i = start; i <= end; i--)
  {
    double currentprice = MathAverageInterpolation(startprice, endprice, start, end, i);
    DownTrendLineBuffer[i] = currentprice;
  }
}

//save the obvious trend
int SaveTrendInSection(int end, int size)
{
  int savedsize = 0;

  int trendtype = 0;

  //judge the trend type
  //begin
  int highestopenprice_index = ArrayMaximum( Open, size, end );
  //end
  int lowestcloseprice_index = ArrayMinimum( Close, size, end );

  //begin 
  int lowestopenprice_index = ArrayMinimum( Open, size, end );
    //end
  int highestcloseprice_index = ArrayMaximum( Close, size, end );

  if(size > 1)
  {

    if( lowestcloseprice_index <  highestopenprice_index)
    {
      //find a obvious down trend
      trendtype = -1;

      savedsize = highestopenprice_index - lowestcloseprice_index + 1;

    }

    //if not have a obvious down trend, try to find a up trend

    //find up Up trend,  lowest open & highest close
    

    if(highestcloseprice_index < lowestopenprice_index)
    {
      trendtype = 1;

      savedsize = lowestopenprice_index - highestcloseprice_index + 1;

    }

  }
  else if(size == 1)
  {

    //keep 1 bar
    savedsize = 1;

    if(Close[end] > Open[end])
    {
      trendtype = 1;
    }
    else
    {
      trendtype = -1;
    }
  }

  if(trendtype > 0)
  {
    //save up trend
    SaveUpTrend(lowestopenprice_index, highestcloseprice_index);
  }
  else
  {
    //save down trend
    SaveDownTrend(highestopenprice_index, lowestcloseprice_index);
  }


  //return the trend size
  return(savedsize);

}

//initialize this is do the check all initialize data
extern int       windowsize=24;
extern int       tatalbars=120;
void InitializeTrendData()
{
  int numofprocessedbars = 0;

  int endofsection = 0;

  bool processend = false;
  //initialize the size of window in the first time
  int localwindowsize = windowsize;

  //process all section
  while( !processend ) {
    //get process parameters

    int sectionenddingindex = endofsection;
    int sectionbeginningindex = sectionenddingindex + localwindowsize - 1;

    //judge main trend
    //1 get the dis between end of trend and end of section
    int dis = GetDisEndofTrend(sectionenddingindex, localwindowsize);

    if(dis ==  0)
    {
      //this section has a complete trend
      int numofbarsintrend = SaveTrendInSection(sectionenddingindex, localwindowsize);

      numofprocessedbars = numofprocessedbars + numofbarsintrend;

    }
    else
    {
      
      //there is a small section including back or oppsitie trend
      //adjust window size
      localwindowsize = dis;

    }


    // process end
    if(numofprocessedbars >= tatalbars)
    {
      processend = true;
    }
  }



}


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
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
    

    //====================================================
    //clean arrow buffer
    CleanVideoDataBuffer();
    //====================================================
    InitializeTrendData();



    






   
//----
   return(0);
  }
//+------------------------------------------------------------------+