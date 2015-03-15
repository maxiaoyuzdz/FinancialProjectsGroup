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
void AnalyzeFunction( double &parameters[][], 
  bool isnewbar,
  int& cm[],
  double& cmp[]
  );
#import

#define NUMOFSECTION 20
#define WINDOWSIZE 4


double dllparameters[10][10];

int global_bars_M5 = 0;

bool hasnewbar = false;

void UpdateHasNewData()
{
  if(global_bars_M5 != Bars)
  {
    global_bars_M5 = Bars;

    hasnewbar = true;
  }
  else
  {
    hasnewbar = false;
  }
}


void ComposeDLLParameters()
{
  dllparameters[0][0] = Ask;
  dllparameters[0][1] = Bid;
  dllparameters[0][2] = Open[0];
  dllparameters[0][3] = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_HIGH, 0 );
  dllparameters[0][4] = iMA( NULL, 0, 5, 0, MODE_EMA, PRICE_LOW, 0 );

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
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
double oldask,oldbid;
void OnTimer()
  {
//---
      if( !IsStopped() )
      {
        //do logic
        

        RefreshRates();

        if( oldbid != Bid || oldask != Ask )
        {
          oldbid = Bid;
          oldask = Ask;

          //Print( "new price do calculate" );
          UpdateHasNewData();

          ComposeDLLParameters();

          

          //do the logic operation
          

          

        }
        

      }
    

   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
