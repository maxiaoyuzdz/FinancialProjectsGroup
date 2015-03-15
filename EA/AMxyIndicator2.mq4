//+------------------------------------------------------------------+
//|                                                           t1.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"




#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Red
#property indicator_color2 Yellow
#property indicator_color3 White
#property indicator_color4 Blue

#property indicator_color5 Red
//--- buffers
//up trend buffer
double ExtMapBuffer1[];
//down trend buffer
double ExtMapBuffer2[];
//arrow buffer
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//support or resistent line
double ExtMapBuffer5[];
//+------------------------------------------------------------------+
//| Custom Extern Parameters                         |
//+------------------------------------------------------------------+
extern int       basicend=0;
extern int       windowsize=8;
extern int       totalbars=480;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void InitIndicatorBuffers()
{
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,217);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexEmptyValue(2,0.0);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,218);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexEmptyValue(3,0.0);

   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,ExtMapBuffer5);
}

double MathTrendInterpolation( int startindex, int endindex ,double startnum, double endnum, int index, int trendtype)
{
  int length = MathAbs( startindex - endindex );
  double valdistance = MathAbs( endnum - startnum );
  double averagedistance = valdistance / length;

  if(index == startindex) return(startnum);

  if(index == endindex) return(endnum);

  double res = 0;

  if(trendtype > 0)
  {
    //up trend
    res = endnum - (index - endindex)* averagedistance;
  }
  else
  {

    res = endnum + (index - endindex)* averagedistance;

  }

  return(res);

}


void DisplayUpTrend(int start, int end, double startprice, double endprice)
{
  //direction is from right to left
  //from 0 to N
  for(int i = end; i <= start; i++)
  {
    ExtMapBuffer1[i] = MathTrendInterpolation(start,end, startprice, endprice, i, 1); 
  }

}
void DisplayDownTrend(int start, int end, double startprice, double endprice)
{
  for(int i = end; i <= start; i++)
  {
    ExtMapBuffer2[i] = MathTrendInterpolation(start,end, startprice, endprice, i, -1);
  }
}


//+------------------------------------------------------------------+
//| Custom functions                              |
//+------------------------------------------------------------------+
void CleanVideoDataBuffer()
{
  for(int clean_i = 0; clean_i<(totalbars + 20); clean_i++)
    {
      ExtMapBuffer1[clean_i] = 0;
      ExtMapBuffer2[clean_i] = 0;

      ExtMapBuffer3[clean_i] = 0;
      ExtMapBuffer4[clean_i] = 0;
    }

}

bool IsUpBar(int pos)
{
  return(Close[pos] > Open[pos]);
}
bool IsDownBar(int pos)
{
  return(Close[pos] < Open[pos]);
}
//return day bar index
int FindHighestUpBar(int end, int size)
{
  int highupbarindex = -1;
  
  int startp = end + size;

  double tempclose = 0;


  for(int i = end; i < startp; i++)
  {
    //is a up trend bar
    if(IsUpBar(i))
    {

      //compare close price
      
      if(Close[i] > tempclose)
      {
        tempclose = Close[i];

        highupbarindex = i;

      }

    }
  }

  return(highupbarindex);


}
//
int FindLowestUpBar(int endindex, int size)
{
  int lowestupbarindex = -1;
  int startindex = endindex + size;

  double tempopen = 999;

  for(int i = endindex; i< startindex; i++ )
  {
    if(IsUpBar(i))
    {
      if(Open[i] < tempopen)
      {
        tempopen = Open[i];
        lowestupbarindex = i;
      }
    }
  }

  return(lowestupbarindex);

}

int FindHighestDownBar(int endindex, int size)
{
  int highestdownbarindex = -1;

  int startindex = endindex + size;

  double tempopen = 0;

  for(int i = endindex; i< startindex; i++)
  {
    if(IsDownBar(i))
    {
      if(Open[i] > tempopen)
      {
        tempopen = Open[i];
        highestdownbarindex = i;

      }
    }

  }

  return(highestdownbarindex);
}

int FindLowestDownBar(int endindex, int size)
{
  int lowestbarindex = -1;

  int startindex = endindex + size;

  double temoclose = 9999;

  for(int i = endindex; i < startindex; i++)
  {
    //is a down trend bar
    if(IsDownBar(i))
    {
      if(Close[i] < temoclose)
      {
        temoclose = Close[i];
        lowestbarindex = i;
      }


    }

  }

  return(lowestbarindex);

}







//1 uptrend, 2 downtrend
int section_trend_start = 0;
int section_trend_end = 0;
int section_trend_type = 0;

int FindAllTrend(int endindex, int inisize)
{

  //Print( "end = ", endindex);

  bool finish = false;

  int pp = 1;
  int p = 1; 

  int trendstartpos = -1;
  int trendendpos = -1;

  int CurrentTrend = 0;

  bool haveuptrend = false;
  bool havedowntrend = false;

  while( !finish ) {

    

    int localsize = p * inisize;
    
    //judge up bar used for up trend 
    int highestupbarindex = FindHighestUpBar(endindex, localsize);
    int lowestupbarindex = FindLowestUpBar(endindex, localsize);
    //down bar used for down trend
    int highestdownbarindex = FindHighestDownBar(endindex, localsize);
    int lowestdownbarindex = FindLowestDownBar(endindex, localsize);

    

    //up trend
    if(lowestupbarindex > highestupbarindex)
    {
      //up 
      haveuptrend = true;
    }

    //down trend
    if(highestdownbarindex > lowestdownbarindex)
    {
      //down
      havedowntrend = true;
    }


    //special situation
    if(havedowntrend && haveuptrend)
    {
      //find have both up and down trend, do not know which noe is the main
      //save range
      pp = p;
      //reset a larger range
      p++;
      //once find this section having both up trend and down trend
      //jump to a larger windowsize
      havedowntrend = false;
      haveuptrend = false;
      //jump to next loop
      continue;

    }
    else if(havedowntrend && (!haveuptrend)) 
    {

      //have a down trend

          if( highestdownbarindex != trendstartpos )
          {
            //a new section
            //save trend start and end and range
            trendstartpos = highestdownbarindex;
            trendendpos = lowestdownbarindex;
            pp = p;
            //expand to a larger range
            p++;
            //reset
            havedowntrend = false;
            haveuptrend = false;

            continue;

          }else{
            //same res, do not need to plug p, back to pp
            //make sure this is a down trend
            CurrentTrend = -1;
            //back to privious trend
            p = pp;
            //end loop
            finish = true;
            //do not do next work
            break;
          }



    }
    else if((!havedowntrend) && haveuptrend)
    {
          
        //find a down trend
          if(lowestupbarindex != trendstartpos)
          {
            //save range
            trendstartpos = lowestupbarindex;
            trendendpos = highestupbarindex;
            pp = p;
            //reset a larger range
            p++;

            haveuptrend = false;
            havedowntrend = false;

            continue;

          }else{
            //make sure this is up trend
            CurrentTrend = 1;


            p = pp;
            finish = true;

            break;
          }

    }



    
  }


  if(CurrentTrend > 0)
  {
    //Print( "display up" );
    DisplayUpTrend(trendstartpos, trendendpos, Close[trendstartpos], Close[trendendpos]);

  }
  if(CurrentTrend < 0)
  {
    //Print( "display down" );
    DisplayDownTrend(trendstartpos, trendendpos, Close[trendstartpos], Close[trendendpos]);

  }

  if(CurrentTrend != 0)
  {

    section_trend_type = CurrentTrend;
    section_trend_start = trendstartpos;
    section_trend_end = trendendpos;

  }
  

  //loop end
  int computedsize = trendstartpos - endindex + 1;
  return(computedsize);



}

int FlushedNumOfBars = 0;
void FlushTrend()
{
  int numofprocessedbars = 0;
    bool allprocessed = false;


    int baseend =  basicend;



    while( !allprocessed ) {



      int psize = FindAllTrend(baseend, windowsize);

      numofprocessedbars = numofprocessedbars + psize;

      baseend = baseend + psize;



      if(numofprocessedbars >= totalbars)
      {
        allprocessed = true;
        FlushedNumOfBars = numofprocessedbars;
      }
      
    }

}






int init()
  {
//---- indicators
   InitIndicatorBuffers();
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

    int    counted_bars=IndicatorCounted();
    CleanVideoDataBuffer();

    //
    //FlushTrend();

    //int cc = GetRes();
    //Print( cc );

    

//----
   return(0);
  }
//+------------------------------------------------------------------+