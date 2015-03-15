//+------------------------------------------------------------------+
//|                                                 TestTemplete.mq4 |
//|                                                         Maxiaoyu |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
/**
#import "MT4EA3DLL.dll"
void PrintTest();
void ArrayTest(double &arr[][], int &marr[][]);
void AnalyzeFunction( double &parameters[][], 
  bool isnewbar,
  int& cm[],
  double& cmp[]
  );
#import
*/
#define  NL    "\n"

extern string  TradeComment        = "Blessing";

extern double  StopTradePercent    = 10; // percent of account balance lost before trading stops

extern bool    IBFXmicro           = false; // set to true for IBFX micro "penny a pip"

extern bool    UseMM               = true; // Money Management

extern double  LAF                 = 0.5;  // Adjusts MM base lot for large accounts

extern double  lot                 = 0.01; // Starting lots if Money Management is off

extern double  Portion             = 1.0;  // Portion of account you want to trade on this pair

extern double  MaxDDPercent        = 50;   // Percent of portion for max drawdown level.

extern double  Multiplier          = 1.4;  // Multiplier on each level

extern int     MaxTrades           = 15;   // Maximum number of trades to place (stops placing orders when reaches MaxTrades)

extern int     BreakEvenTrade      = 12;   // Close All level , when reaches this level, doesn't wait for TP to be hit

extern bool    MaximizeProfit      = false; // Turns on TP move and Profit Trailing Stop Feature

extern double  ProfitSet           = 90;   // Locks in Profit at this percent of Total Profit Potential

extern int     MoveTP              = 30;   // Moves TP this amount in pips

extern int     TotalMoves          = 2;    // Number of times you want TP to move before stopping movement

extern bool    BollingerStochEntry = false; // if false, uses simple MA for entry

extern bool    CCIEntry            = false; // Confirms MA trend and updates it if necessary

extern int     MAPeriod            = 100;  // Period of MA

extern bool    UsePowerOutSL       = false; // Transmits a SL in case of internet loss   

extern bool    AutoCal             = false; // Auto calculation of TakeProfit and Grid size;

extern double  GAF                 = 1.0;  // Widens/Squishes Grid on increments/decrements of .1

extern int     TimeGrid            = 2400; // Time Grid in seconds , to avoid opening of lots of levels in fast market

extern string  Advancedset         = "Advanced Settings Change sparingly";

extern int     BollPeriod          = 10;   // Period for Bollinger

extern double  BollDistance        = 10;   // Up/Down spread

extern double  BollDeviation       = 2.0;  // Standard deviation multiplier for channel

extern int     BuySellStochZone    = 20;   // Determines Overbought and Oversold Zones

extern int     KPeriod             = 10;    // Stochastic parameters

extern int     DPeriod             = 2;    // Stochastic parameters

extern int     Slowing             = 2;    // Stochastic parameters

extern int     Set1Count           = 4;    // Level 1 max trades at GridSet1
extern int     Set2Count           = 4;    // Level 2 max trades at GridSet2
extern int     GridSet1            = 25;   // Set 1 Grid Size
extern int     TP_Set1             = 50;   // Set 1 Take Profit
extern int     GridSet2            = 50;   // Set 2 Grid Size
extern int     TP_Set2             = 100;  // Set 2 Take Profit
extern int     GridSet3            = 100;  // Beyond Set 2 Grid Size
extern int     TP_Set3             = 200;  // Beyond Set 2 Take Profit
extern int     d                   = 5;    // Used to offset entry to round numbers , for example if you set d=5,
                                           // it will place its sell order on 1.5795 instead of 1.5780

extern int     ForceMarketCond     = 3;    // Market condition 0=uptrend 1=downtrend 2=range 3=off
extern int     bufferPIP           = 5;    // Number of pips to move TPs if Profit Potential is negative
extern double  Level            = 7;    // Largest Assumed Basket size.  Lower number = higher start lots

extern string  DisplayControl      = "Used to Adjust Overlay";

extern bool    displayOverlay      = true; // Turns the display on and off
extern bool    displayLogo         = true; // Turns off copyright and icon
extern int     displayXcord        = 100;  // Moves display left and right
extern int     displayYcord        = 15;   // Moves display up and down
extern int     displayFontSize     = 9;    // Changes size of display characters
extern int     displaySpacing      = 14;   // Changes space between lines
extern color   displayColor        = DeepSkyBlue; // default color of display characters

//+------------------------------------------------------------------+
//| Internal Parameters Set                                          |
//+------------------------------------------------------------------+

bool           ca                  = false;
int            magic               = 0;
double         slip                = 0;       
int            BrokerDecimal       = 1;
int            count;
double         counter;
int            moves;
double         MaxDD;
double         ProfitSL;
int            Accounttype         = 1;
double         pipvalue;
double         spread;
int            correct             = 1;
double         StopTradeBalance;
double         InitialAB;
bool           TESTING             = false;
bool           VISUAL              = false;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|  function                                                   |
//+------------------------------------------------------------------+





//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
// operation here
//---
    


  }


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+

void OnTimer()
  {
//---
        int y;
        int cb=0; // Count buy
        int cs=0; // Count sell
        int cbl=0; // Count buy limit
        int csl=0; // Count sell limit
        int cbs=0; // Count buy limit
        int css=0; // Count sell limit
        double tbl=0; //Count lot size
        double tsl=0; //Count lot size
        double tl=0; //total lots out
        double to=0; //total buy and sell order out
        double buysl=0; //stop losses are set to zero if POSL off
        double sellsl=0; //stop losses are set to zero if POSL off
        double POSL=0; //Initialize POSL
        double ProfitPot=0; //The Potential Profit of a basket of Trades
        double CurrentTP=0; //The current take profit of all orders
        double m,lot2;
        double lp; // last buy price
        double ll; //last lot
        double ltp; //last tp
        double lopt; // last open time
        double g2; 
        double tp2;
        double entry;
        int lticket;
        double ma;
        double stddev;
        double bup, bux;
        double bdn, bdx;
        int zoneBUY  = BuySellStochZone;
        int zoneSELL = 100 - BuySellStochZone;
        double pr=0;
        bool syncOccurred=false;

        //+------------------------------------------------------------------+
        //| Calculate Total Profits, Profit Potential and Total Orders       |
        //+------------------------------------------------------------------+ 
        for (y = 0; y < OrdersTotal(); y++)
        {
                OrderSelect (y, SELECT_BY_POS);
                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {
                  //count
                        cb++;
                        //profit
                        pr=pr+OrderProfit() + OrderSwap() + OrderCommission();
                        //lot
                        tbl=tbl+OrderLots();
                        //profit
                        ProfitPot=ProfitPot + OrderSwap() + OrderCommission() + OrderLots()*pipvalue*(((OrderTakeProfit() - OrderOpenPrice())/Point));
                        CurrentTP=OrderTakeProfit();
                }
                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {
                        cs++;
                        pr=pr+OrderProfit() + OrderSwap() + OrderCommission();
                        tsl=tsl+OrderLots();
                        ProfitPot=ProfitPot + OrderSwap() + OrderCommission() + OrderLots()*pipvalue*(((OrderOpenPrice() - OrderTakeProfit())/Point));
                        CurrentTP=OrderTakeProfit();
                }
                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_BUYLIMIT)) cbl++;
                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_SELLLIMIT)) csl++;
                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_BUYSTOP)) cbs++;
                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_SELLSTOP)) css++;
                tl=tbl+tsl;
                to=cb+cs;
        }

        ProfitPot = NormalizeDouble(ProfitPot,2);
        pr        = NormalizeDouble(pr,2);

        //+------------------------------------------------------------------+
        //| Adjust TP if ProfitPot is < 0                                    |
        //+------------------------------------------------------------------+
        if (bufferPIP > 0.0 && ProfitPot < 0.0) 
        {
             double newTP;
             if (cb > 0 && CurrentTP > 0.0) {
                newTP = CurrentTP + (bufferPIP*Point);   
                
                for (y = 0; y < OrdersTotal(); y++)
                {      // Sync TPs
                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber() != magic) || (OrderType()!=OP_BUY) || (OrderSymbol()!=Symbol())) 
                        { 
                                 continue; 
                        }

                        if (OrderTakeProfit() != newTP) {  // synchronization is needed if OrderTakeProfit() differs from 'newTP'
                               syncOccurred=true;
                               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),newTP,0,Red);
                               Print("j1");
                        }  else {
                               // Do nothing as TP is  equal to ltp (No SYNC is needed)  
                        }
                 } 
                if (syncOccurred == true) {  
                     // if TP sync takes place, need to recalculate ProfitPot & pr value in the next tick.
                     return; 
                } 
                                
             }
             if (cs > 0 && CurrentTP > 0.0) {
                newTP = CurrentTP - (bufferPIP*Point);
                
                syncOccurred=false;
                for (y = 0; y < OrdersTotal(); y++)
                {      // Sync TPs
                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber() != magic) || (OrderType()!=OP_SELL) || (OrderSymbol()!=Symbol())) 
                        { 
                                 continue; 
                        }

                        if (OrderTakeProfit() != newTP) {  // synchronization is needed if OrderTakeProfit() differs from 'ltp'
                               syncOccurred=true;
                               OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),newTP,0,Red);
                               Print("j2");
                        }  else {
                               // Do nothing as TP is  equal to ltp (No SYNC is needed)  
                        }
                 } 
                if (syncOccurred == true) {  
                     // if TP sync takes place, need to recalculate ProfitPot & pr value in the next tick.
                     return; 
                }                         
             }
        }









   
  }


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetMillisecondTimer(5);
   if (Symbol() == "AUDCADm" || Symbol() == "AUDCAD") magic = 101101;
        if (Symbol() == "AUDJPYm" || Symbol() == "AUDJPY") magic = 101102;
        if (Symbol() == "AUDNZDm" || Symbol() == "AUDNZD") magic = 101103;
        if (Symbol() == "AUDUSDm" || Symbol() == "AUDUSD") magic = 101104;
        if (Symbol() == "CHFJPYm" || Symbol() == "CHFJPY") magic = 101105;
        if (Symbol() == "EURAUDm" || Symbol() == "EURAUD") magic = 101106;
        if (Symbol() == "EURCADm" || Symbol() == "EURCAD") magic = 101107;
        if (Symbol() == "EURCHFm" || Symbol() == "EURCHF") magic = 101108;
        if (Symbol() == "EURGBPm" || Symbol() == "EURGBP") magic = 101109;
        if (Symbol() == "EURJPYm" || Symbol() == "EURJPY") magic = 101110;
        if (Symbol() == "EURUSDm" || Symbol() == "EURUSD") magic = 101111;
        if (Symbol() == "GBPCHFm" || Symbol() == "GBPCHF") magic = 101112;
        if (Symbol() == "GBPJPYm" || Symbol() == "GBPJPY") magic = 101113;
        if (Symbol() == "GBPUSDm" || Symbol() == "GBPUSD") magic = 101114;
        if (Symbol() == "NZDJPYm" || Symbol() == "NZDJPY") magic = 101115;
        if (Symbol() == "NZDUSDm" || Symbol() == "NZDUSD") magic = 101116;
        if (Symbol() == "USDCHFm" || Symbol() == "USDCHF") magic = 101117;
        if (Symbol() == "USDJPYm" || Symbol() == "USDJPY") magic = 101118;
        if (Symbol() == "USDCADm" || Symbol() == "USDCAD") magic = 101119;

        if (magic == 0) magic = 701999;

        if(Digits==3 || Digits==5){ 
               BrokerDecimal = 10;
               bufferPIP *= 10;
               MoveTP *= 10;
               d *= 10;}
        if(IBFXmicro) Accounttype = 10;

        pipvalue=MarketInfo(Symbol(),MODE_TICKVALUE);
        spread=MarketInfo(Symbol(),MODE_SPREAD);
        InitialAB=AccountBalance();
        StopTradeBalance=InitialAB - InitialAB*(StopTradePercent/100);

        TESTING=IsTesting();
        VISUAL=IsVisualMode();
         
        LabelCreate();

   

   
   Print("version 1.0");
      
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
   Refresh();
      
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
//| Refresh Object List Function                                     |
//+------------------------------------------------------------------+ 

void LabelCreate(){    
        if ( (displayOverlay && TESTING && VISUAL) ||
             (displayOverlay && !TESTING) ) {
           
            ObjectCreate("ObjLabel1",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel2",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel3",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel4",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel5",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel6",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel7",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel8",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel9",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel10",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel11",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel12",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel13",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel14",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel15",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel16",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel17",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel18",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel19",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel20",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel21",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel22",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel23",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel24",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel25",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel26",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel51",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel52",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel53",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel54",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel55",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel56",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel58",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel59",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel60",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel61",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel62",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel63",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel64",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel65",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel66",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel67",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel68",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel69",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel70",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel71",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel72",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel73",OBJ_LABEL,0,0,0);
            ObjectCreate("ObjLabel74",OBJ_LABEL,0,0,0);
            }
        return;
}

void Refresh(){    
        if (displayOverlay) {
                ObjectDelete("ObjLabel1");
                ObjectDelete("ObjLabel2");
                ObjectDelete("ObjLabel3");
                ObjectDelete("ObjLabel4");
                ObjectDelete("ObjLabel5");
                ObjectDelete("ObjLabel6");
                ObjectDelete("ObjLabel7");
                ObjectDelete("ObjLabel8");
                ObjectDelete("ObjLabel9");
                ObjectDelete("ObjLabel10");
                ObjectDelete("ObjLabel11");
                ObjectDelete("ObjLabel12");
                ObjectDelete("ObjLabel13");
                ObjectDelete("ObjLabel14");
                ObjectDelete("ObjLabel15");
                ObjectDelete("ObjLabel16");
                ObjectDelete("ObjLabel17");
                ObjectDelete("ObjLabel18");
                ObjectDelete("ObjLabel19");
                ObjectDelete("ObjLabel20");
                ObjectDelete("ObjLabel21");
                ObjectDelete("ObjLabel22");
                ObjectDelete("ObjLabel23");                
                ObjectDelete("ObjLabel24");
                ObjectDelete("ObjLabel25");
                ObjectDelete("ObjLabel26");
                ObjectDelete("ObjLabel51");
                ObjectDelete("ObjLabel52");
                ObjectDelete("ObjLabel53");
                ObjectDelete("ObjLabel54");
                ObjectDelete("ObjLabel55");
                ObjectDelete("ObjLabel56");
                ObjectDelete("ObjLabel58");
                ObjectDelete("ObjLabel59");
                ObjectDelete("ObjLabel60");
                ObjectDelete("ObjLabel61");
                ObjectDelete("ObjLabel62");
                ObjectDelete("ObjLabel63");
                ObjectDelete("ObjLabel64");
                ObjectDelete("ObjLabel65");
                ObjectDelete("ObjLabel66");
                ObjectDelete("ObjLabel67");
                ObjectDelete("ObjLabel68");
                ObjectDelete("ObjLabel69");
                ObjectDelete("ObjLabel70");
                ObjectDelete("ObjLabel71");
                ObjectDelete("ObjLabel72");
                ObjectDelete("ObjLabel73");
                ObjectDelete("ObjLabel74");
                } }
//+------------------------------------------------------------------+
//| expert end function                                              |
//+------------------------------------------------------------------+