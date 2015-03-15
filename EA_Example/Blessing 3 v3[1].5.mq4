//+------------------------------------------------------------------+
//|                                                  Blessing 3 v3.5 |
//|                                                February 19, 2010 |
//|                              Copyright © 2007-2010, MQLCoder.com |
//|         Improved Strategy and Safety by LRon / jta@jtatoday.com  |
//|         Main Strategy by FiFtHeLeMeNt / fifthelement80@gmail.com |
//|         Bollenger Band and Stochastic Indicator addition by Jepm |
//| Min Lot check condition/Improved MM math/CCI addition by Beckham |
//|           Sync TP and Postive ProfitPotential Fix by Robotofdawn |
//|                   Debugging and speed up recommendations by d4v3 |
//|  In no event will authors be liable for any damages whatsoever.  |
//|                      Use at your own risk.                       |
//+------------------------------------------------------------------+

// Blessing 3 updates since inception:
// Website created dedicated to Blessing at http://www.jtatoday.com
// Added grid settings to menu for user adjustment
// Changed Blessing EA naming convention back to version number
// Moved menu around to create advanced settings section
// Cleaned out median price code from Blessing 2 fixing divide by zero error
// Updated Break Even Close Trade Function
// Updated Exit Trade Function to eliminate delete order error
// Reduces multiple calls to iMA and iStoc by storing the value
//        in a variable and referencing it during conditional checks,
// Doesn't perform the ObjectCreate / Refresh() calls in testing mode
// Re-indented the entire source code with a formatter to make the code
//        blocks more obvious during debugging
// Force Market Condition Variable added for manual enteries
// Fixed CCI bug errors
// Internalized Stop Trade Balance and recoded as a percent of Account Balance
// Fixed Sync TP Function to update all TPs each tic
// Function added to check that TP set ensures basket profit using a Buffer Pip (user selectable)
// Forward testing functionality added to Blessing website
// Chart Overlay changed for user selectability
// Bug fixed in the Profit Maximizer Funtion to set solid Trailing Stop
// Set Files added to Results page on website for Forward Test
// Money Management math function updated to allow a level variable - advanced use, default is 6
// POSL Function sped up with MathMin function
// Variables added to init section for speed up
// Minimum lot condition check added for brokers allowing .1 lots or greater

#property copyright "Copyright © 2007-2010, J Talon LLC/FiFtHeLeMeNt"
#property link      "http://www.jtatoday.com"
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
extern double  Level   	   		  = 7;    // Largest Assumed Basket size.  Lower number = higher start lots

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

int init()
{
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

        return(0);
}

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+

int deinit()
{
        
Refresh();
        
return(0);
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

int start()
{
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
                OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {
                        cb++;
                        pr=pr+OrderProfit() + OrderSwap() + OrderCommission();
                        tbl=tbl+OrderLots();
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
                to=cb+cs;}

        ProfitPot = NormalizeDouble(ProfitPot,2);
        pr        = NormalizeDouble(pr,2);

        //+------------------------------------------------------------------+
        //| Adjust TP if ProfitPot is < 0                                    |
        //+------------------------------------------------------------------+
                
        if (bufferPIP > 0.0 && ProfitPot < 0.0) {
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
		  
        //+------------------------------------------------------------------+
        //| Maximize Profit with Moving TP and setting Trailing Profit Stop  |
        //+------------------------------------------------------------------+

        if(MaximizeProfit) { 
                if(ProfitSL > 0 && pr <= ProfitSL)
                ExitAllTrades(Green,"Profit Trailing Stop Reached");
                if(to == 0){ 
                        counter  = 0;
                        moves    = 0;
                        ProfitSL = 0;}
                if((pr && ProfitPot) > 0){
                        if(pr/ProfitPot >= ProfitSet/100) ProfitSL = ProfitPot - (ProfitPot * (1-(ProfitSet/100)));}
                if(ProfitSL > 0 && ProfitSL > counter && MoveTP > 0 && TotalMoves > moves) {
                        for (y = 0; y < OrdersTotal(); y++) {
                                OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {
                                        OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),(CurrentTP+(MoveTP*Point)),0,Blue); }
                                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {
                                        OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),(CurrentTP-(MoveTP*Point)),0,Red); } 
                        }
                        moves++;   
                        counter = ProfitSL;}
        } 
        
        //+------------------------------------------------------------------+
        //| Account Protection                                               |
        //+------------------------------------------------------------------+ 

        double PortionBalance = NormalizeDouble(AccountBalance()/Portion,2);
        double PortionEquity  = NormalizeDouble(PortionBalance + pr,2);
        if ( PortionBalance - PortionEquity >= (PortionBalance * MaxDDPercent/100) )  
        ExitAllTrades(Red,"Equity Stop Loss Reached");

        //+------------------------------------------------------------------+
        //| Trading with EA Criteria                                         |
        //+------------------------------------------------------------------+
        
        double StepAB = InitialAB + InitialAB*(StopTradePercent/100);
        double StepSTB = AccountBalance() - AccountBalance()*(StopTradePercent/100);
        double NextISTB = StepAB - StepAB*(StopTradePercent/100);
        
        if(StepSTB > NextISTB){
             InitialAB = StepAB;
             StopTradeBalance = StepSTB;}
        
        double InitialAccountMultiPortion = StopTradeBalance/Portion;
        if (PortionBalance < InitialAccountMultiPortion){ 
                PlaySound("alert.wav");
                Print("Account Balance dropped below stop trade percent"); 
                MessageBox( "Reset Blessing, account balance dropped below stop trade percent on " + Symbol()+ Period(), "Blessing 3: Warning", 48 );
                return(0);}

        //+------------------------------------------------------------------+
        //| Power Out Stop Loss Protection                                   |
        //+------------------------------------------------------------------+ 

        if(UsePowerOutSL) {
                
                if(Accounttype == 1 && pipvalue < 5) correct = 10;
                if(tl > 0) POSL =  MathMin(NormalizeDouble((PortionBalance * (MaxDDPercent + 1)/100)/(pipvalue * tl * correct),0),600);
                else POSL = 600;
                
                buysl = Ask - (POSL * BrokerDecimal) * Point;
                sellsl= Bid + (POSL * BrokerDecimal) * Point;

                if(to == 0) count = 0;
                if(to > 0 && to > count){

                        // sync up order stop losses
                        for (int q = 0; q < OrdersTotal(); q++) {
                                OrderSelect (q, SELECT_BY_POS, MODE_TRADES);
                                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_BUY)) {
                                        OrderModify(OrderTicket(), OrderOpenPrice(), buysl, OrderTakeProfit(), 0, Purple);}
                                if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_SELL)) {
                                        OrderModify(OrderTicket(), OrderOpenPrice(), sellsl, OrderTakeProfit(), 0, Purple);} } } 
                count = to;}

        //+------------------------------------------------------------------+
        //| Money Management and Lot size coding                             |
        //+------------------------------------------------------------------+

        if(UseMM){

                double Contracts, Factor, Lotsize;

                Contracts = (AccountBalance()/10000)/Portion;
                
                Factor = (MathPow(Multiplier,Level)-Multiplier) / (Multiplier - 1);

                Lotsize = LAF*Accounttype*(Contracts/(1.0 + Factor));

                //Determine Lot size boundries from minimum to maximum

                lot=NormalizeDouble(Lotsize,2);

                if(Lotsize<0.01) lot=0.01;
                if(Lotsize<MarketInfo(Symbol(),MODE_MINLOT)) lot=MarketInfo(Symbol(),MODE_MINLOT);
                if(Lotsize>100/MathPow(Multiplier,6) && Accounttype == 1) lot=NormalizeDouble(100/MathPow(Multiplier,6),2);
                if(Lotsize>50/MathPow(Multiplier,6)  && Accounttype == 10) lot=NormalizeDouble(50/MathPow(Multiplier,6),2);}

        //+------------------------------------------------------------------+
        //| ATR to autocalculate the Grid                                    | 
        //+------------------------------------------------------------------+     

        double GridStart,value1;
        double atrvalue = iATR(NULL,PERIOD_D1,21,0);  
        if(AutoCal){
                if(Digits == 2 || Digits == 3) value1 = atrvalue*100;
                if(Digits == 4 || Digits == 5) value1 = atrvalue*10000;
                GridStart = value1*2/10;
                GridSet1  = GridStart;
                TP_Set1   = GridStart + GridSet1;
                GridSet2  = TP_Set1;
                TP_Set2   = (GridStart + GridSet1) * 2;
                GridSet3  = TP_Set2;
                TP_Set3   = (GridStart + GridSet1) * 4;}       

        //+------------------------------------------------------------------+
        //| Moving Average Indicator for Calculation of Trend Direction      |
        //+------------------------------------------------------------------+      
        
        int MC = 2;
        double ima_0 = iMA(Symbol(),0,MAPeriod,0,MODE_EMA,PRICE_CLOSE,0);
        if (Bid<ima_0) MC=1;
        else if (Bid>ima_0) MC=0;
        
        double MC_final;
        if ( ForceMarketCond == 0 || ForceMarketCond == 1 || ForceMarketCond == 2) MC_final = ForceMarketCond;
        else MC_final = MC;
        
        double DD = PortionBalance - PortionEquity;

        if (DD > MaxDD) MaxDD = DD;

        double MaxDDPer = (MaxDD / PortionBalance) * 100;

        //+------------------------------------------------------------------+
        //|Uses CCI of 5M,15M,30M,1H to determine Market Condition (MC_final)|
        //+------------------------------------------------------------------+      

        if (CCIEntry && ForceMarketCond == 3) {
                  double cci_01 = iCCI(Symbol(),PERIOD_M5,14,PRICE_CLOSE,0);
                  double cci_02 = iCCI(Symbol(),PERIOD_M15,14,PRICE_CLOSE,0);
                  double cci_03 = iCCI(Symbol(),PERIOD_M30,14,PRICE_CLOSE,0);
                  double cci_04 = iCCI(Symbol(),PERIOD_H1,14,PRICE_CLOSE,0);
                  double cci_11 = iCCI(Symbol(),PERIOD_M5,14,PRICE_CLOSE,1);
                  double cci_12 = iCCI(Symbol(),PERIOD_M15,14,PRICE_CLOSE,1);
                  double cci_13 = iCCI(Symbol(),PERIOD_M30,14,PRICE_CLOSE,1);
                  double cci_14 = iCCI(Symbol(),PERIOD_H1,14,PRICE_CLOSE,1);
                  if ( cci_11 > 0 && cci_12 > 0 && cci_13 > 0 && cci_14 > 0 
                    && cci_01 > 0 && cci_02 > 0 && cci_03 > 0 && cci_04 > 0) {
                        MC_final=0;     
                  }
                  else if ( cci_11 < 0 && cci_12 < 0 && cci_13 < 0 && cci_14 < 0 
                    && cci_01 < 0 && cci_02 < 0 && cci_03 < 0 && cci_04 < 0 ) {
                        MC_final=1;                        
                  }        
        }

        //+------------------------------------------------------------------+
        //| Bollinger Band trade Long/Short                                  |
        //+------------------------------------------------------------------+ 

        if(BollingerStochEntry){
                
                ma = iMA(Symbol(),0,BollPeriod,0,MODE_SMA,PRICE_OPEN,0);
                stddev = iStdDev(Symbol(),0,BollPeriod,0,MODE_SMA,PRICE_OPEN,0);   
                bup = ma+(BollDeviation*stddev);
                bdn = ma-(BollDeviation*stddev);

                bux=(bup+(BollDistance*Point));
                bdx=(bdn-(BollDistance*Point));}  

        //+------------------------------------------------------------------+
        //| Blessing Code                                                    |
        //+------------------------------------------------------------------+   

        if (cs==0 && cb==0 && cbs==0 && cbl==0 && css==0 && csl==0) ca=false;

        slip = NormalizeDouble((999 * BrokerDecimal),0);

        if (((cb>=BreakEvenTrade || cs>=BreakEvenTrade) && pr>0) || ca) {
                ca=true;
                ExitAllTrades(Lime,"Break Even Function Triggered");
                return;}

        g2=GridSet1;
        tp2=TP_Set1;

        if (cb>=Set1Count || cs>=Set1Count) {
                g2=GridSet2;
                tp2=TP_Set2;}

        if (cb>=Set2Count+Set1Count || cs>=Set2Count+Set1Count) {
                g2=GridSet3;
                tp2=TP_Set3;}

        //+------------------------------------------------------------------+
        //| Broker Decimal Selection                                         |
        //+------------------------------------------------------------------+ 

        if (BrokerDecimal == 10){
                g2 *= 10;
                tp2 *= 10;}

        //+------------------------------------------------------------------+
        //| Adjust Grid and Normalize Values                                 |
        //+------------------------------------------------------------------+

        g2  = NormalizeDouble(g2*GAF,0);
        tp2 = NormalizeDouble(tp2*GAF,0);

        //+------------------------------------------------------------------+
        //| Set TP on Open Order created by BBStoch                          |
        //+------------------------------------------------------------------+ 

        if(cb==1 || cs==1){
                for (int t = 0; t < OrdersTotal(); t++) {
                        OrderSelect (t, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_BUY) && (OrderTakeProfit()==0)) {
                                OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() , (OrderOpenPrice() + tp2*Point), 0, Blue);}
                        if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()==OP_SELL) && (OrderTakeProfit()==0)) {
                                OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss() , (OrderOpenPrice() - tp2*Point), 0, Red);} } }

        //+------------------------------------------------------------------+
        //| Trade Selection Logic                                            |
        //+------------------------------------------------------------------+ 

        if ((cb==0) && (cs==0)) {
                for (y = 0; y < OrdersTotal(); y++){
                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderLots()>lot)) 
                        OrderDelete(OrderTicket());}

                if (BollingerStochEntry==false){
                        if (MC_final==0) {
                                if (cbs==0 && css==0) {
                                        m=MathMod(Ask/Point,g2);
                                        if ((g2-m+d)>MarketInfo(Symbol(),MODE_STOPLEVEL)) {
                                                OrderSend(Symbol(),OP_BUYSTOP,lot,Ask*2-Bid+(g2-m+d)*Point,0,buysl,Ask*2-Bid+(g2-m+d+tp2)*Point,TradeComment,magic,0,CLR_NONE);
                                                Print("s2");
                                                return;} }
                                if (cbl==0 && csl==0) {
                                        m=MathMod(Ask/Point,g2);
                                        if ((m+d)>MarketInfo(Symbol(),MODE_STOPLEVEL)) {
                                                OrderSend(Symbol(),OP_BUYLIMIT,lot,Ask*2-Bid-(m+d)*Point,0,buysl,Ask*2-Bid-(m+d-tp2)*Point,TradeComment,magic,0,CLR_NONE);
                                                Print("s1");
                                                return;} } }

                        if (MC_final==1) {
                                if (csl==0 && cbl==0) {
                                        m=MathMod(Bid/Point,g2);
                                        if ((g2-m-d)>MarketInfo(Symbol(),MODE_STOPLEVEL)) {
                                                OrderSend(Symbol(),OP_SELLLIMIT,lot,Bid+(g2-m-d)*Point,0,sellsl,Bid+(g2-m-d-tp2)*Point,TradeComment,magic,0,CLR_NONE);
                                                Print("s2");
                                                return;} }
                                if (css==0 && cbs==0) {
                                        m=MathMod(Bid/Point,g2);
                                        if ((m+d)>MarketInfo(Symbol(),MODE_STOPLEVEL)) {
                                                OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-(m+d)*Point,0,sellsl,Bid-(m+d+tp2)*Point,TradeComment,magic,0,CLR_NONE);
                                                Print("s1");
                                                return; } } }

                        if (MC_final==2) {
                                if (css==0) {
                                        m=MathMod(Bid/Point,g2);
                                        if ((m+d)>MarketInfo(Symbol(),MODE_STOPLEVEL)) {
                                                OrderSend(Symbol(),OP_SELLSTOP,lot,Bid-(m+d)*Point,0,sellsl,Bid-(m+d+tp2)*Point,TradeComment,magic,0,CLR_NONE);
                                                Print("s1");
                                                return; } }
                                if (cbs==0) {
                                        m=MathMod(Ask/Point,g2);
                                        if ((g2-m+d)>MarketInfo(Symbol(),MODE_STOPLEVEL)) {
                                                OrderSend(Symbol(),OP_BUYSTOP,lot,Ask*2-Bid+(g2-m+d)*Point,0,buysl,Ask*2-Bid+(g2-m+d+tp2)*Point,TradeComment,magic,0,CLR_NONE);
                                                Print("s2");
                                                return;} } } }
                else if (BollingerStochEntry == True){ 
                        //if (MC_final==0) {
                        double stoc_0 = iStochastic(NULL,0,KPeriod,DPeriod,Slowing,MODE_LWMA,1,0,1);
                        double stoc_1 = iStochastic(NULL,0,KPeriod,DPeriod,Slowing,MODE_LWMA,1,1,1);
                        if (Close[0] < bdx && stoc_0 < zoneBUY && stoc_1 < zoneBUY){
                                if (cbs==0) {
                                        if (tp2 >= 10) OrderSend(Symbol(),OP_BUY,lot,Ask,slip,0,0,TradeComment,magic,0,Blue);
                                        return;
                                }
                        }

                        //if (MC_final==1) {
                        if (Close[0] > bux && stoc_0 > zoneSELL && stoc_1 > zoneSELL){
                                if (css==0) {
                                        if (tp2 >= 10) OrderSend(Symbol(),OP_SELL,lot,Bid,slip,0,0,TradeComment,magic,0,Red);
                                        return;
                                }
                        }
                }
        }       

        if (cb>0 || cs>0) {
                for (y = 0; y < OrdersTotal(); y++){
                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber()==magic) && (OrderSymbol()==Symbol()) && (OrderType()!=OP_SELL) && (OrderType()!=OP_BUY) && OrderLots()==lot) OrderDelete(OrderTicket());} }

        if (cb>0) {
                for (y = 0; y < OrdersTotal(); y++){
                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber() != magic) || (OrderType()!=OP_BUY) || (OrderSymbol()!=Symbol())) { continue; }
                        lp=OrderOpenPrice();
                        ll=OrderLots();
                        ltp=OrderTakeProfit();
                        lopt=OrderOpenTime();
                        lticket=OrderTicket();
                }

                if ((TimeCurrent()-TimeGrid>lopt) && (cb<MaxTrades)) {
                
                        if (lp>Ask) entry=NormalizeDouble(lp-(MathRound((lp-Ask)/Point/g2)+1)*g2*Point,Digits); else entry=NormalizeDouble(lp-g2*Point,Digits);
                        if (ll <= 0.01) lot2=NormalizeDouble(ll*2,2); else lot2=NormalizeDouble(ll*Multiplier,2);

                        if (cbl==0) {
                                Print("Ticket="+OrderTicket()+" ProfitPot="+ProfitPot+" #BUY="+cb+" #SELL="+cs);

                                OrderSend(Symbol(),OP_BUYLIMIT,lot2,entry,0,buysl,entry+tp2*Point,TradeComment,magic);
                                Print("s3");
                                return;}

                        if (cbl==1) {
                                for (y = 0; y < OrdersTotal(); y++){
                                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                                        if (OrderType()==OP_BUYLIMIT && OrderMagicNumber()==magic && (OrderSymbol()==Symbol()) && entry-OrderOpenPrice()>g2/2*Point) {
                                                OrderModify(OrderTicket(),entry,buysl,entry+tp2*Point,0);
                                                Print("mo1");} } } } 

                syncOccurred=false;
                for (y = 0; y < OrdersTotal(); y++)
                {      // Sync TPs
                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber() != magic) || (OrderType()!=OP_BUY) || (OrderSymbol()!=Symbol())) 
                        { 
                                 continue; 
                        }

                        if (OrderTakeProfit() != ltp) {  // synchronization is needed if OrderTakeProfit() differs from 'ltp'
                               syncOccurred=true;
                               OrderModify(OrderTicket(),OrderOpenPrice(),buysl,ltp,0,Red);
                               Print("m2");
                        }  else {
                               // Do nothing as TP is  equal to ltp (No SYNC is needed)  
                        }
                 } 
                 
                if (syncOccurred == true) {  
                     // if TP sync takes place, need to recalculate ProfitPot & pr value in the next tick.
                     return; 
                } 
                                
        }

        if (cs>0) {
                for (y = 0; y < OrdersTotal(); y++){
                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber() != magic) || (OrderType()!=OP_SELL) || (OrderSymbol()!=Symbol())) { continue; }
                        lp=OrderOpenPrice();
                        ll=OrderLots();
                        ltp=OrderTakeProfit();
                        lopt=OrderOpenTime();
                        lticket=OrderTicket();
                }


                if ((TimeCurrent()-TimeGrid>lopt) && (cs<MaxTrades)) {
                
                        if (Bid>lp) entry=NormalizeDouble(lp+(MathRound((-lp+Bid)/Point/g2)+1)*g2*Point,Digits); else entry=NormalizeDouble(lp+g2*Point,Digits);
                        if (ll <= 0.01) lot2=NormalizeDouble(ll*2,2); else lot2=NormalizeDouble(ll*Multiplier,2);
                        
                        if (csl==0) {
                                Print("Ticket="+OrderTicket()+" ProfitPot="+ProfitPot+" #BUY="+cb+" #SELL="+cs);
                        
                                OrderSend(Symbol(),OP_SELLLIMIT,lot2,entry,0,sellsl,entry-tp2*Point,TradeComment,magic);
                                Print("s4");
                                return;}

                        if (csl==1) {
                                for (y = 0; y < OrdersTotal(); y++)           {
                                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                                        if (OrderType()==OP_SELLLIMIT && OrderMagicNumber()==magic && (OrderSymbol()==Symbol()) && OrderOpenPrice()-entry>g2/2*Point) {
                                                OrderModify(OrderTicket(),entry,sellsl,entry-tp2*Point,0);
                                                Print("mo2");} } } }

                syncOccurred=false;
                for (y = 0; y < OrdersTotal(); y++)
                {      // Sync TPs
                        OrderSelect (y, SELECT_BY_POS, MODE_TRADES);
                        if ((OrderMagicNumber() != magic) || (OrderType()!=OP_SELL) || (OrderSymbol()!=Symbol())) 
                        { 
                                 continue; 
                        }

                        if (OrderTakeProfit() != ltp) {  // synchronization is needed if OrderTakeProfit() differs from 'ltp'
                               syncOccurred=true;
                               OrderModify(OrderTicket(),OrderOpenPrice(),sellsl,ltp,0,Red);
                               Print("m2");
                        }  else {
                               // Do nothing as TP is  equal to ltp (No SYNC is needed)  
                        }
                 } 
                if (syncOccurred == true) {  
                     // if TP sync takes place, need to recalculate ProfitPot & pr value in the next tick.
                     return; 
                } 
               // Do nothing, the code should fall to writing overlay
         }

        
        //+------------------------------------------------------------------+
        //| External Script Code                                             |
        //+------------------------------------------------------------------+
        
          if ( (displayOverlay && TESTING && VISUAL) ||
             (displayOverlay && !TESTING) ) {

                if(displayLogo){
                        ObjectSetText("ObjLabel1","Q",36,"Wingdings",Crimson);
                        ObjectSet("ObjLabel1",OBJPROP_CORNER,3);
                        ObjectSet("ObjLabel1",OBJPROP_XDISTANCE,10);
                        ObjectSet("ObjLabel1",OBJPROP_YDISTANCE,10);}
                        
                if(!displayLogo)ObjectDelete("ObjLabel1");        

                if(UseMM){
                        ObjectSetText("ObjLabel2","Money Management is On",displayFontSize,"Arial Bold",Green);
                        ObjectSet("ObjLabel2",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel2",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel2",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*7)));}
                
                if(!UseMM){
                        ObjectSetText("ObjLabel2","Money Management is Off",displayFontSize,"Arial Bold",Red);
                        ObjectSet("ObjLabel2",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel2",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel2",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*7)));}
                        
                ObjectSetText("ObjLabel3","Current Time is:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel3",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel3",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel3",OBJPROP_YDISTANCE,(displayYcord));
                
                ObjectSetText("ObjLabel52",TimeToStr(TimeCurrent(), TIME_SECONDS),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel52",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel52",OBJPROP_XDISTANCE,(displayXcord+125));
                ObjectSet("ObjLabel52",OBJPROP_YDISTANCE,(displayYcord));
                
                ObjectSetText("ObjLabel4","Equity Protection % Set:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel4",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel4",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel4",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*2)));
                
                ObjectSetText("ObjLabel53",DoubleToStr(MaxDDPercent, 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel53",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel53",OBJPROP_XDISTANCE,(displayXcord+200));
                ObjectSet("ObjLabel53",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*2)));
                
                if(UsePowerOutSL){        
                        ObjectSetText("ObjLabel5","Power Off Stop Loss is On",displayFontSize,"Arial Bold",Green);
                        ObjectSet("ObjLabel5",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel5",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel5",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*8)));}
                        
                if(!UsePowerOutSL){
                        ObjectSetText("ObjLabel5","Power Off Stop Loss is Off",displayFontSize,"Arial Bold",Red);
                        ObjectSet("ObjLabel5",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel5",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel5",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*8)));}
                
                if(displayLogo){
                        ObjectSetText("ObjLabel6","© 2010, J Talon LLC/FiFtHeLeMeNt",10,"Arial",Silver);
                        ObjectSet("ObjLabel6",OBJPROP_CORNER,3);
                        ObjectSet("ObjLabel6",OBJPROP_XDISTANCE,5);
                        ObjectSet("ObjLabel6",OBJPROP_YDISTANCE,3);}
                        
                if(!displayLogo)ObjectDelete("ObjLabel6");                
                
                ObjectSetText("ObjLabel7","Starting Lot Size:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel7",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel7",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel7",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*10)));
                
                ObjectSetText("ObjLabel54",DoubleToStr(lot, 2),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel54",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel54",OBJPROP_XDISTANCE,(displayXcord+140));
                ObjectSet("ObjLabel54",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*10)));
                
                ObjectSetText("ObjLabel73","Total Lots:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel73",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel73",OBJPROP_XDISTANCE,(displayXcord+190));
                ObjectSet("ObjLabel73",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*10)));
                
                ObjectSetText("ObjLabel74",DoubleToStr(tl, 2),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel74",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel74",OBJPROP_XDISTANCE,(displayXcord+275));
                ObjectSet("ObjLabel74",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*10)));
                               
                ObjectSetText("ObjLabel8","Profit Potential:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel8",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel8",OBJPROP_XDISTANCE,(displayXcord+30));
                ObjectSet("ObjLabel8",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*12)));
                
                ObjectSetText("ObjLabel55",DoubleToStr(ProfitPot, 2),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel55",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel55",OBJPROP_XDISTANCE,(displayXcord+190));
                ObjectSet("ObjLabel55",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*12)));
                
                ObjectSetText("ObjLabel9","Profit Trailing Stop:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel9",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel9",OBJPROP_XDISTANCE,(displayXcord+30));
                ObjectSet("ObjLabel9",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*13)));
                
                ObjectSetText("ObjLabel56",DoubleToStr(ProfitSL, 2),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel56",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel56",OBJPROP_XDISTANCE,(displayXcord+190));
                ObjectSet("ObjLabel56",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*13)));
                
                if(MC == 0){   
                        ObjectSetText("ObjLabel10","Trend is UP",displayFontSize+10,"Arial Bold",Green);
                        ObjectSet("ObjLabel10",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel10",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel10",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*20)));}
                if(MC == 1){   
                        ObjectSetText("ObjLabel10","Trend is DOWN",displayFontSize+10,"Arial Bold",Red);
                        ObjectSet("ObjLabel10",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel10",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel10",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*20)));}
                if(MC == 2){   
                        ObjectSetText("ObjLabel10","Trend is Ranging",displayFontSize+10,"Arial Bold",Orange);
                        ObjectSet("ObjLabel10",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel10",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel10",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*20)));}

                ObjectSetText("ObjLabel11","Buy Count:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel11",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel11",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel11",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*17)));
                
                ObjectSetText("ObjLabel58",DoubleToStr(cb, 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel58",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel58",OBJPROP_XDISTANCE,(displayXcord+100));
                ObjectSet("ObjLabel58",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*17)));
                
                ObjectSetText("ObjLabel12","Sell Count:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel12",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel12",OBJPROP_XDISTANCE,(displayXcord+150));
                ObjectSet("ObjLabel12",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*17)));
                
                ObjectSetText("ObjLabel59",DoubleToStr(cs, 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel59",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel59",OBJPROP_XDISTANCE,(displayXcord+240));
                ObjectSet("ObjLabel59",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*17)));
                
                ObjectSetText("ObjLabel13","Current TP:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel13",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel13",OBJPROP_XDISTANCE,(displayXcord+30));
                ObjectSet("ObjLabel13",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*15)));
                
                ObjectSetText("ObjLabel60",DoubleToStr(CurrentTP, 5),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel60",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel60",OBJPROP_XDISTANCE,(displayXcord+170));
                ObjectSet("ObjLabel60",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*15)));
                
                ObjectSetText("ObjLabel14","Move TP by:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel14",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel14",OBJPROP_XDISTANCE,(displayXcord+30));
                ObjectSet("ObjLabel14",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*16)));
                
                ObjectSetText("ObjLabel61",DoubleToStr((MoveTP/BrokerDecimal), 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel61",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel61",OBJPROP_XDISTANCE,(displayXcord+140));
                ObjectSet("ObjLabel61",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*16)));
                
                ObjectSetText("ObjLabel15","# Moves:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel15",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel15",OBJPROP_XDISTANCE,(displayXcord+190));
                ObjectSet("ObjLabel15",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*16)));
                
                ObjectSetText("ObjLabel62",DoubleToStr(moves, 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel62",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel62",OBJPROP_XDISTANCE,(displayXcord+270));
                ObjectSet("ObjLabel62",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*16)));
                
                ObjectSetText("ObjLabel71","/",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel71",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel71",OBJPROP_XDISTANCE,(displayXcord+283));
                ObjectSet("ObjLabel71",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*16)));
                
                ObjectSetText("ObjLabel72",DoubleToStr(TotalMoves, 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel72",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel72",OBJPROP_XDISTANCE,(displayXcord+290));
                ObjectSet("ObjLabel72",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*16)));
                
                ObjectSetText("ObjLabel16","Account Portion:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel16",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel16",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel16",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*5)));
                
                ObjectSetText("ObjLabel63",DoubleToStr(Portion, 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel63",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel63",OBJPROP_XDISTANCE,(displayXcord+150));
                ObjectSet("ObjLabel63",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*5)));
                
                ObjectSetText("ObjLabel17","Account % Risked:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel17",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel17",OBJPROP_XDISTANCE,(displayXcord+210));
                ObjectSet("ObjLabel17",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*6)));
                
                ObjectSetText("ObjLabel64",DoubleToStr(MaxDDPercent/Portion, 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel64",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel64",OBJPROP_XDISTANCE,(displayXcord+350));
                ObjectSet("ObjLabel64",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*6)));
                
                ObjectSetText("ObjLabel18","Portion Balance:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel18",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel18",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel18",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*6)));
                
                ObjectSetText("ObjLabel65",DoubleToStr(PortionBalance, 2),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel65",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel65",OBJPROP_XDISTANCE,(displayXcord+150));
                ObjectSet("ObjLabel65",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*6)));
                
                ObjectSetText("ObjLabel19","Stop Trade Ammount:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel19",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel19",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel19",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*4)));
                
                ObjectSetText("ObjLabel66",DoubleToStr(InitialAccountMultiPortion, 0),displayFontSize,"Arial Bold",Red);
                ObjectSet("ObjLabel66",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel66",OBJPROP_XDISTANCE,(displayXcord+200));
                ObjectSet("ObjLabel66",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*4)));
                
                ObjectSetText("ObjLabel20","Max DD:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel20",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel20",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel20",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*18)));
                
                ObjectSetText("ObjLabel67",DoubleToStr(MaxDD,2),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel67",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel67",OBJPROP_XDISTANCE,(displayXcord+100));
                ObjectSet("ObjLabel67",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*18)));   
                
                ObjectSetText("ObjLabel21","Portion P/L:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel21",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel21",OBJPROP_XDISTANCE,(displayXcord+30));
                ObjectSet("ObjLabel21",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*14)));
                
                if(MC == 0){   
                        ObjectSetText("ObjLabel22","é",displayFontSize+9,"Wingdings",Green);
                        ObjectSet("ObjLabel22",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel22",OBJPROP_XDISTANCE,(displayXcord+160));
                        ObjectSet("ObjLabel22",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*20)));}
                if(MC == 1){   
                        ObjectSetText("ObjLabel22","ê",displayFontSize+9,"Wingdings",Red);
                        ObjectSet("ObjLabel22",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel22",OBJPROP_XDISTANCE,(displayXcord+210));
                        ObjectSet("ObjLabel22",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*20)));}
                        
                ObjectSetText("ObjLabel23","Max DD %:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel23",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel23",OBJPROP_XDISTANCE,(displayXcord+150));
                ObjectSet("ObjLabel23",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*18)));
                
                ObjectSetText("ObjLabel68",DoubleToStr(MaxDDPer,2),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel68",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel68",OBJPROP_XDISTANCE,(displayXcord+240));
                ObjectSet("ObjLabel68",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*18)));        
                        
                if(pr >= 0){   
                        ObjectSetText("ObjLabel24",DoubleToStr(pr, 2),displayFontSize,"Arial Bold",Green);
                        ObjectSet("ObjLabel24",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel24",OBJPROP_XDISTANCE,(displayXcord+190));
                        ObjectSet("ObjLabel24",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*14)));}
                if(pr < 0){   
                        ObjectSetText("ObjLabel24",DoubleToStr(pr, 2),displayFontSize,"Arial Bold",Red);
                        ObjectSet("ObjLabel24",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel24",OBJPROP_XDISTANCE,(displayXcord+190));
                        ObjectSet("ObjLabel24",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*14)));}
                        
                ObjectSetText("ObjLabel25","Stop Trade % Set:",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel25",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel25",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel25",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*3)));
                
                ObjectSetText("ObjLabel51",DoubleToStr(StopTradePercent, 0),displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel51",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel51",OBJPROP_XDISTANCE,(displayXcord+200));
                ObjectSet("ObjLabel51",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*3)));
                
                ObjectSetText("ObjLabel26","======================",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel26",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel26",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel26",OBJPROP_YDISTANCE,(displayYcord+displaySpacing));
                
                ObjectSetText("ObjLabel69","======================",displayFontSize,"Arial Bold",displayColor);
                ObjectSet("ObjLabel69",OBJPROP_CORNER,0);
                ObjectSet("ObjLabel69",OBJPROP_XDISTANCE,(displayXcord));
                ObjectSet("ObjLabel69",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*9)));
                
                if(MaximizeProfit){
                        ObjectSetText("ObjLabel70","Profit Maximizer is On",displayFontSize,"Arial Bold",Green);
                        ObjectSet("ObjLabel70",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel70",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel70",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*11)));}
                
                if(!MaximizeProfit){
                        ObjectSetText("ObjLabel70","Profit Maximizer is Off",displayFontSize,"Arial Bold",Red);
                        ObjectSet("ObjLabel70",OBJPROP_CORNER,0);
                        ObjectSet("ObjLabel70",OBJPROP_XDISTANCE,(displayXcord));
                        ObjectSet("ObjLabel70",OBJPROP_YDISTANCE,(displayYcord+(displaySpacing*11)));}        

        }  
        return(0);
}

//+------------------------------------------------------------------+
//| Exit Trade Function                                              |
//+------------------------------------------------------------------+ 

void ExitAllTrades(color Color, string reason){
        slip = NormalizeDouble((999 * BrokerDecimal),0);
        bool success;
        for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt --){
                OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
                if (OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
                        if(OrderType()>OP_SELL) OrderDelete(OrderTicket(),Color);
                        else success=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(), slip, Color); 
                        if(success==true){
                                Print("Closed all positions because ",reason);} } } }

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