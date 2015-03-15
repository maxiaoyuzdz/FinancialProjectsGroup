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
#property indicator_color2 Green
#property indicator_color3 White
#property indicator_color4 Yellow
//--- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
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
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
    if(counted_bars < 0) return(-1);
    if(counted_bars > 0) counted_bars --;
    int limit = Bars - counted_bars;
    for(int i=0; i< limit; i++)
    {
      ExtMapBuffer1[i] = Open[i];
    }

   
//----
   return(0);
  }
//+------------------------------------------------------------------+