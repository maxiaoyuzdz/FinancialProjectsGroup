//+------------------------------------------------------------------+
//|                                                           t1.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"
//DLL Import
#import "MT4IndicatorDLL.dll"
int ComputingTrend(double openarr[], double closearr[], double emafastarr[], double emaslowarr[], int arrsize, int windowsize, double& resuptrendarr[], double& resdowntrendarr[], double& unknowntrendarr[], int& specialparametersarr[]);
#import

#define ARRAYRANGE 640
#define EMAFAST 8
#define EMASLOW 30
#define ARRAYBLANKSIZE 128


#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Red
#property indicator_color2 Yellow
#property indicator_color3 White
#property indicator_color4 Blue

#property indicator_color5 LawnGreen
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
//extern int       basicend=0;
extern int       windowsize=8;
extern int       totalbars=480;
//extern int       arrayrange = 600;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
double openarray[ARRAYRANGE];
double closearray[ARRAYRANGE];
double computingresultforuptrend[ARRAYRANGE];
double computingresultfordowntrend[ARRAYRANGE];
double computingresultforunknown[ARRAYRANGE];

int specialparameters[8];

double emafastarray[ARRAYRANGE];
double emaslowarray[ARRAYRANGE];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void InitIndicatorBuffers()
{
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);

   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);

   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,217);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexEmptyValue(2,0.0);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,218);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexEmptyValue(4,0.0);

   
}




//+------------------------------------------------------------------+
//| Custom functions                              |
//+------------------------------------------------------------------+
void CleanVideoDataBuffer()
{
  for(int clean_i = 0; clean_i<ARRAYRANGE; clean_i++)
    {
      //clear display cache
      ExtMapBuffer1[clean_i] = 0;
      ExtMapBuffer2[clean_i] = 0;
      ExtMapBuffer3[clean_i] = 0;

      ExtMapBuffer4[clean_i] = 0;
      ExtMapBuffer5[clean_i] = 0;

      computingresultforuptrend[clean_i] = 0;
      computingresultfordowntrend[clean_i] = 0;
      computingresultforunknown[clean_i] = 0;
    }

    for( int i = 0; i < 8; i++ ){
      specialparameters[i] = 0;
      
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

    //int    counted_bars=IndicatorCounted();
    CleanVideoDataBuffer();

    //prepare data
    int copyres;
    copyres = ArrayCopy(openarray,Open,0,0,ARRAYRANGE);
    copyres = ArrayCopy(closearray,Close,0,0,ARRAYRANGE);
    //ema

    for(int i = 0; i < ARRAYRANGE; i++)
    {
      emafastarray[i] = iMA(NULL, 0, EMAFAST, 0, MODE_EMA, PRICE_CLOSE, i);
      emaslowarray[i] = iMA(NULL, 0, EMASLOW, 0, MODE_EMA, PRICE_CLOSE, i);

      
    }



    //process data
    copyres = ComputingTrend(openarray, closearray, emafastarray, emaslowarray, totalbars, windowsize, computingresultforuptrend, computingresultfordowntrend, computingresultforunknown, specialparameters );
    //Print( copyres );


    //display result
    copyres = ArrayCopy(ExtMapBuffer1,computingresultforuptrend,0,0,ARRAYRANGE);
    copyres = ArrayCopy(ExtMapBuffer2,computingresultfordowntrend,0,0,ARRAYRANGE);
    copyres = ArrayCopy(ExtMapBuffer3,computingresultforunknown,0,0,ARRAYRANGE);
    //Print( "blank size = ", specialparameters[0] );

    

//----
   return(0);
  }
//+------------------------------------------------------------------+