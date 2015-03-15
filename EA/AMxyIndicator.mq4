//+------------------------------------------------------------------+
//|                                                           t1.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Yellow
#property indicator_color3 White
#property indicator_color4 Yellow
//--- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];

//+------------------------------------------------------------------+
//| Custom Extern Parameters                         |
//+------------------------------------------------------------------+
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
//| Global Functions                              |
//+------------------------------------------------------------------+  
void CleanVideoDataBuffer()
{
  for(int clean_i = 0; clean_i<500; clean_i++)
    {
      ExtMapBuffer1[clean_i] = 0;
      ExtMapBuffer2[clean_i] = 0;

      ExtMapBuffer3[clean_i] = 0;
      ExtMapBuffer4[clean_i] = 0;
    }

}

double MathUpTrendInterpolation( int startindex, int endindex ,double startnum, double endnum, int index)
{
  int length = MathAbs( startindex - endindex );
  double valdistance = MathAbs( endnum - startnum );
  double averagedistance = valdistance / length;

  if(index == startindex) return(startnum);

  if(index == endindex) return(endnum);

  double res = endnum - (index - endindex)* averagedistance;

  return(res);

}

double MathDownTrendInterpolation( int startindex, int endindex ,double startnum, double endnum, int index)
{
  int length = MathAbs( startindex - endindex );
  double valdistance = MathAbs( startnum - endnum );
  double averagedistance = valdistance / length;

  if(index == startindex) return(startnum);

  if(index == endindex) return(endnum);

  double res = endnum + (index - endindex)* averagedistance;

  return(res);

}

void DisplayUpTrend(int start, int end, double startprice, double endprice)
{
  //direction is from right to left
  //from 0 to N
  for(int i = end; i <= start; i++)
  {
    ExtMapBuffer1[i] = MathUpTrendInterpolation(start,end, startprice, endprice, i); //MathAverageInterpolation(startprice, endprice, start, end, i);
  }

}
void DisplayDownTrend(int start, int end, double startprice, double endprice)
{
  for(int i = end; i <= start; i++)
  {
    ExtMapBuffer2[i] = MathDownTrendInterpolation(start,end, startprice, endprice, i); //MathAverageInterpolation(startprice, endprice, start, end, i);
  }
}
//+------------------------------------------------------------------+
//| Custom processed function                              |
//+------------------------------------------------------------------+
int FindUpTrend(int end, int size)
{
  //size <= 0
  if(size <= 0) return(0);

  // size  =  1
  if(size == 1)
  {
    double openprice = Open[end];
    double closeprice = Close[end];

    if(openprice > closeprice)
    {
      //do process on one bar
      //show the bar
      DisplayUpTrend(end, end, openprice, closeprice);
      //
    }

    return(1);

  }

  // size > 1

  int start = end + size - 1;

  int lowestopenprice_index = ArrayMinimum( Open, size, end );

  //Print( "low = ", lowestopenprice_index );


  int highestcloseprice_index = ArrayMaximum( Close, size, end );

  //Print( "high = ", highestcloseprice_index );

  if(  lowestopenprice_index > highestcloseprice_index )
  {
    //have obvoious trend
    //Print( "has Up ");
    //then display them

    DisplayUpTrend(lowestopenprice_index, highestcloseprice_index, Open[lowestopenprice_index], Close[highestcloseprice_index]);


    int processedsize = lowestopenprice_index - end + 1;

    return(processedsize);

  }
  else
  {
    return(size);
  }


}

int FindAllTrend(int end, int size)
{
  
  //find up trend
  //size <= 0
  if(size <= 0) return(0);

  // size  =  1
  if(size == 1)
  {
    double openprice = Open[end];
    double closeprice = Close[end];

    if(openprice < closeprice)
    {
      //do process on one bar
      //show the bar
      DisplayUpTrend(end, end, openprice, closeprice);
      //
    }
    else
    {
      DisplayDownTrend(end, end, openprice, closeprice);
    }

    return(1);

  }

  // size > 1
  int start = end + size - 1;

  //check has up trend condition
  int lowestopenprice_index = ArrayMinimum( Open, size, end );
  int highestcloseprice_index = ArrayMaximum( Close, size, end );

  //check down trend condition
  int highestopenprice_index = ArrayMaximum( Open, size, end );
  int lowestcloseprice_index = ArrayMinimum( Close, size, end );

  if(  lowestopenprice_index > highestcloseprice_index )
  {
    

    //process up trend
    DisplayUpTrend(lowestopenprice_index, highestcloseprice_index, Open[lowestopenprice_index], Close[highestcloseprice_index]);

    //check the dis between right edge and end

    int udis = highestcloseprice_index - end;

    //int ru = FindAllTrend(end,udis);


    int uprocessedsize = lowestopenprice_index - end + 1;

    return(uprocessedsize);

  }
  else if(highestopenprice_index > lowestcloseprice_index)
  {
    //process down trend
    DisplayDownTrend(highestopenprice_index, lowestcloseprice_index, Open[highestopenprice_index], Close[lowestcloseprice_index]);

    int ddis = highestcloseprice_index - end;

    //int rd = FindAllTrend(end,ddis);

    int dprocessedsize = highestopenprice_index - end + 1;


    return(dprocessedsize);



  }
  else
  {
    return(size);
  }



  
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
    int    counted_bars=IndicatorCounted();
   CleanVideoDataBuffer();
//----

    int numofprocessedbars = 0;
    bool allprocessed = false;


    int baseend = 0;



    while( !allprocessed ) {



      int psize = FindAllTrend(baseend, windowsize);

      numofprocessedbars = numofprocessedbars + psize;

      baseend = baseend + psize;



      if(numofprocessedbars >= totalbars)
      {
        allprocessed = true;
      }
      
    }
    

   
//----
   return(0);
  }
//+------------------------------------------------------------------+