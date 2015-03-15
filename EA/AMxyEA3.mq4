//+------------------------------------------------------------------+
//|                                                   EATemplete.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property version   "1.00"
#property strict
#property tester_library "MT4EA2DLL.dll"
//MT4EA1DLL
#import "MT4EA2DLL.dll"

int AnalyzeTrend(
	//main h1
	double& main_openarr_H1[],
	double& main_closearr_H1[],
	double& main_higharr_H1[],
	double& main_lowarr_H1[],
	//big view d1
	double& openarr_d1[],
	double& closearr_d1[],
	double& higharr_d1[],
	double& lowarr_d1[],
	//h4
	double& openarr_h4[],
	double& closearr_h4[],
	double& higharr_h4[],
	double& lowarr_h4[],
	//m15
	double& openarr_m15[],
	double& closearr_m15[],
	double& higharr_m15[],
	double& lowarr_m15[],
	//m5
	double& openarr_m5[],
	double& closearr_m5[],
	double& higharr_m5[],
	double& lowarr_m5[],
	//m1
	double& openarr_m1[],
	double& closearr_m1[],
	double& higharr_m1[],
	double& lowarr_m1[],
	//ask bid
	double Ask,
	double Bid,
	//ma
	double& mabuffer_D1_P5[],
	double& mabuffer_H4_P5[],
	double& mabuffer_H1_P5[],
	double& mabuffer_M15_P5[],
	double& mabuffer_M5_P5[],
	double& mabuffer_M1_P5[],

	double& mabuffer_D1_P15[],
	double& mabuffer_H4_P15[],
	double& mabuffer_H1_P15[],
	double& mabuffer_M15_P15[],
	double& mabuffer_M5_P15[],
	double& mabuffer_M1_P15[],
	////new bar or just update
	//int upmark,
	int& barupdatemarklist[],
	//
	
	//
	
	int& biguptrendindexbuffer[],
	int& bigdowntrendindexbuffer[],
	int& backparemeters[],
	double& pp[],
	//double& wpp[],
	//double& cpp[],
	//double& srlines[]
	int& cm[],
	double& cmp[]
	);

void TimeTestStart();
void TimeTestEnd();
void SetMarketInfo_Spread(double sp);

void ReportOrderResult(int ti);

#import



#define DATABUFSIZE 2000
//data buf for c++
//H1
double main_openarr_H1[DATABUFSIZE];
double main_closearr_H1[DATABUFSIZE];
double main_higharr_H1[DATABUFSIZE];
double main_lowarr_H1[DATABUFSIZE];
//D1
double main_openarr_D1[DATABUFSIZE];
double main_closearr_D1[DATABUFSIZE];
double main_higharr_D1[DATABUFSIZE];
double main_lowarr_D1[DATABUFSIZE];
//H4
double main_openarr_H4[DATABUFSIZE];
double main_closearr_H4[DATABUFSIZE];
double main_higharr_H4[DATABUFSIZE];
double main_lowarr_H4[DATABUFSIZE];
//M15
double main_openarr_M15[DATABUFSIZE];
double main_closearr_M15[DATABUFSIZE];
double main_higharr_M15[DATABUFSIZE];
double main_lowarr_M15[DATABUFSIZE];
//M5
double main_openarr_M5[DATABUFSIZE];
double main_closearr_M5[DATABUFSIZE];
double main_higharr_M5[DATABUFSIZE];
double main_lowarr_M5[DATABUFSIZE];
//M1
double main_openarr_M1[DATABUFSIZE];
double main_closearr_M1[DATABUFSIZE];
double main_higharr_M1[DATABUFSIZE];
double main_lowarr_M1[DATABUFSIZE];




//#define ARRAYRANGEFORBUFFER 640
#define NUMOFLINES 20		//20 lines for up and down trend
#define TRENDNUMBUFFER 40  // 20 trend, each has 2 points
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
//////////////////////////////////////////////////////////////
#define NUMOFPP 7
double PivotPoints[NUMOFPP];
string pplinearray[NUMOFPP];

#define NUMOFWOODIEPP 5
double WoodiePivotPoint[NUMOFWOODIEPP];
string woodiepplinearray[NUMOFWOODIEPP];

#define NUMOFCAMARILLAPP 9
double CamarillaPivotPoint[NUMOFCAMARILLAPP];
string camarillapplinearray[NUMOFCAMARILLAPP];

#define NUMOFSRLINES 120 //20 * 6
string srlinearray[NUMOFSRLINES];
double SupportAndResistentValue[NUMOFSRLINES];
//////////////////////////////////////////////////////////////
#define MALENGTH 2000
double mabuffer_D1_P5[MALENGTH];
double mabuffer_H4_P5[MALENGTH];
double mabuffer_H1_P5[MALENGTH];
double mabuffer_M15_P5[MALENGTH];
double mabuffer_M5_P5[MALENGTH];
double mabuffer_M1_P5[MALENGTH];

double mabuffer_D1_P15[MALENGTH];
double mabuffer_H4_P15[MALENGTH];
double mabuffer_H1_P15[MALENGTH];
double mabuffer_M15_P15[MALENGTH];
double mabuffer_M5_P15[MALENGTH];
double mabuffer_M1_P15[MALENGTH];
//////////////////////////////////////////////////////////////
int updatemarkarr[6];
//////////////////////////////////////////////////////////////
//int OrderCommand;
//////////////////////////////////////////////////////////////
//command result
#define COMMANDLENGTH 10
int Command[COMMANDLENGTH];
double CommandParameters[COMMANDLENGTH];
//////////////////////////////////////////////////////////////


//+------------------------------------------------------------------+
//| Flush Data function                                   |
//+------------------------------------------------------------------+

void UpdateData_MA()
{
	for( int i = 0; i < MALENGTH; i++ ){
		mabuffer_D1_P5[i] = iMA( NULL, PERIOD_D1, 5, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_H4_P5[i] = iMA( NULL, PERIOD_H4, 5, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_H1_P5[i] = iMA( NULL, PERIOD_H1, 5, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_M15_P5[i] = iMA( NULL, PERIOD_M15, 5, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_M5_P5[i] = iMA( NULL, PERIOD_M5, 5, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_M1_P5[i] = iMA( NULL, PERIOD_M1, 5, 0, MODE_EMA, PRICE_CLOSE, i );

		mabuffer_D1_P15[i] = iMA( NULL, PERIOD_D1, 15, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_H4_P15[i] = iMA( NULL, PERIOD_H4, 15, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_H1_P15[i] = iMA( NULL, PERIOD_H1, 15, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_M15_P15[i] = iMA( NULL, PERIOD_M15, 15, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_M5_P15[i] = iMA( NULL, PERIOD_M5, 15, 0, MODE_EMA, PRICE_CLOSE, i );
		mabuffer_M1_P15[i] = iMA( NULL, PERIOD_M1, 15, 0, MODE_EMA, PRICE_CLOSE, i );
	}
}




int global_bars_D1 = 0;


void UpdateData_Period_D1()
{
	if(global_bars_D1 != iBars( NULL, PERIOD_D1 ))
	{
		updatemarkarr[5] = 1;

		for( int i = 0; i < DATABUFSIZE; i++ ){
			main_openarr_D1[i] = iOpen( NULL, PERIOD_D1, i );
			main_closearr_D1[i] = iClose( NULL, PERIOD_D1, i );
			main_higharr_D1[i] = iHigh( NULL, PERIOD_D1, i );
			main_lowarr_D1[i] = iLow( NULL, PERIOD_D1, i );
		}

		global_bars_D1 = iBars( NULL, PERIOD_D1 );
	}
	else
	{
		updatemarkarr[5] = 0;

		main_openarr_D1[0] = iOpen( NULL, PERIOD_D1, 0 );
		main_closearr_D1[0] = iClose( NULL, PERIOD_D1, 0 );
		main_higharr_D1[0] = iHigh( NULL, PERIOD_D1, 0 );
		main_lowarr_D1[0] = iLow( NULL, PERIOD_D1, 0 );
	}
}

int global_bars_H4 = 0;

void UpdateData_Period_H4()
{
	if(global_bars_H4 != iBars( NULL, PERIOD_H4 ))
	{
		updatemarkarr[4] = 1;

		for( int i = 0; i < DATABUFSIZE; i++ ){
			main_openarr_H4[i] = iOpen( NULL, PERIOD_H4, i );
			main_closearr_H4[i] = iClose( NULL, PERIOD_H4, i );
			main_higharr_H4[i] = iHigh( NULL, PERIOD_H4, i );
			main_lowarr_H4[i] = iLow( NULL, PERIOD_H4, i );
		}

		global_bars_H4 = iBars( NULL, PERIOD_H4 );
	}
	else
	{
		updatemarkarr[4] = 0;

		main_openarr_H4[0] = iOpen( NULL, PERIOD_H4, 0 );
		main_closearr_H4[0] = iClose( NULL, PERIOD_H4, 0 );
		main_higharr_H4[0] = iHigh( NULL, PERIOD_H4, 0 );
		main_lowarr_H4[0] = iLow( NULL, PERIOD_H4, 0 );
	}
}

int global_bars_H1 = 0;

void UpdateData_Period_H1()
{

	if(global_bars_H1 != Bars)
	{
		updatemarkarr[3] = 1;
		int cs = 
		ArrayCopy( main_openarr_H1, Open, 0, 0, DATABUFSIZE );
		cs = 
		ArrayCopy( main_closearr_H1, Close, 0, 0, DATABUFSIZE );
		cs = 
		ArrayCopy( main_higharr_H1, High, 0, 0, DATABUFSIZE );
		cs = 
		ArrayCopy( main_lowarr_H1, Low, 0, 0, DATABUFSIZE );
		global_bars_H1 = Bars;
	}
	else
	{
		updatemarkarr[3] = 0;
		main_openarr_H1[0] = Open[0];
		main_closearr_H1[0] = Close[0];
		main_higharr_H1[0] = High[0];
		main_lowarr_H1[0] = Low[0];
	}
}


int global_bars_M15 = 0;

void UpdateData_Period_M15()
{
	if(global_bars_M15 != iBars( NULL, PERIOD_M15 ))
	{
		updatemarkarr[2] = 1;

		for( int i = 0; i < DATABUFSIZE; i++ ){
			main_openarr_M15[i] = iOpen( NULL, PERIOD_M15, i );
			main_closearr_M15[i] = iClose( NULL, PERIOD_M15, i );
			main_higharr_M15[i] = iHigh( NULL, PERIOD_M15, i );
			main_lowarr_M15[i] = iLow( NULL, PERIOD_M15, i );
		}

		global_bars_M15 = iBars( NULL, PERIOD_M15 );
	}
	else
	{
		updatemarkarr[2] = 0;
		main_openarr_M15[0] = iOpen( NULL, PERIOD_M15, 0 );
		main_closearr_M15[0] = iClose( NULL, PERIOD_M15, 0 );
		main_higharr_M15[0] = iHigh( NULL, PERIOD_M15, 0 );
		main_lowarr_M15[0] = iLow( NULL, PERIOD_M15, 0 );
	}
}


int global_bars_M5 = 0;

void UpdateData_Period_M5()
{
	if(global_bars_M5 != iBars( NULL, PERIOD_M5 ))
	{
		updatemarkarr[1] = 1;
		for( int i = 0; i < DATABUFSIZE; i++ ){
			main_openarr_M5[i] = iOpen( NULL, PERIOD_M5, i );
			main_closearr_M5[i] = iClose( NULL, PERIOD_M5, i );
			main_higharr_M5[i] = iHigh( NULL, PERIOD_M5, i );
			main_lowarr_M5[i] = iLow( NULL, PERIOD_M5, i );
		}

		global_bars_M5 = iBars( NULL, PERIOD_M5 );
	}
	else
	{
		updatemarkarr[1] = 0;
		main_openarr_M5[0] = iOpen( NULL, PERIOD_M5, 0 );
		main_closearr_M5[0] = iClose( NULL, PERIOD_M5, 0 );
		main_higharr_M5[0] = iHigh( NULL, PERIOD_M5, 0 );
		main_lowarr_M5[0] = iLow( NULL, PERIOD_M5, 0 );
	}
}


int global_bars_M1 = 0;
void UpdateData_Period_M1()
{
	if(global_bars_M1 != iBars( NULL, PERIOD_M1 ))
	{
		updatemarkarr[0] = 1;
		for( int i = 0; i < DATABUFSIZE; i++ ){
			main_openarr_M1[i] = iOpen( NULL, PERIOD_M1, i );
			main_closearr_M1[i] = iClose( NULL, PERIOD_M1, i );
			main_higharr_M1[i] = iHigh( NULL, PERIOD_M1, i );
			main_lowarr_M1[i] = iLow( NULL, PERIOD_M1, i );
		}

		global_bars_M1 = iBars( NULL, PERIOD_M1 );
	}
	else
	{
		updatemarkarr[0] = 0;
		main_openarr_M1[0] = iOpen( NULL, PERIOD_M1, 0 );
		main_closearr_M1[0] = iClose( NULL, PERIOD_M1, 0 );
		main_higharr_M1[0] = iHigh( NULL, PERIOD_M1, 0 );
		main_lowarr_M1[0] = iLow( NULL, PERIOD_M1, 0 );
	}
}



void FlushData()
{

//	TimeTestStart();

	

	
	UpdateData_Period_D1();

	UpdateData_Period_H4();

	UpdateData_Period_H1();

	UpdateData_Period_M15();

	UpdateData_Period_M5();

	UpdateData_Period_M1();


	UpdateData_MA();

//	TimeTestEnd();
	
}
//+------------------------------------------------------------------+
//| Display function                                   |
//+------------------------------------------------------------------+
void InitLineObjectArray()
{
	for( int i = 0; i < NUMOFLINES; i++ )
	{
		string upname = "up"+IntegerToString(i);
		string downname = "down"+IntegerToString(i);
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

	// Povit Points
	pplinearray[0] = "ppr3";
	pplinearray[1] = "ppr2";
	pplinearray[2] = "ppr1";
	pplinearray[3] = "pp";
	pplinearray[4] = "pps1";
	pplinearray[5] = "pps2";
	pplinearray[6] = "pps3";

	for(int j = 0; j < NUMOFPP; j++)
	{
		ObjectCreate(pplinearray[j],OBJ_HLINE,0,0,0);

		ObjectCreate("label"+pplinearray[j],OBJ_TEXT,0,Time[0],0);

		//ObjectSetText(pplinearray[j], pplinearray[j], 10, "Times New Roman", Green);


		//r
		if(j<3)
		{
			ObjectSet( pplinearray[j], OBJPROP_COLOR, Goldenrod );
			ObjectSet( pplinearray[j], OBJPROP_STYLE, STYLE_SOLID );

			ObjectSet( pplinearray[j], OBJPROP_WIDTH, 1 );
			ObjectSet( pplinearray[j], OBJPROP_BACK, false );
			ObjectSet( pplinearray[j], OBJPROP_RAY, false );

		}
		//pp
		if(j == 3)
		{
			ObjectSet( pplinearray[j], OBJPROP_COLOR, CadetBlue );
			ObjectSet( pplinearray[j], OBJPROP_STYLE, STYLE_SOLID );

			ObjectSet( pplinearray[j], OBJPROP_WIDTH, 1 );
			ObjectSet( pplinearray[j], OBJPROP_BACK, false );
			ObjectSet( pplinearray[j], OBJPROP_RAY, false );
		}
		//s
		if(j > 3)
		{
			ObjectSet( pplinearray[j], OBJPROP_COLOR, OrangeRed );
			ObjectSet( pplinearray[j], OBJPROP_STYLE, STYLE_SOLID );

			ObjectSet( pplinearray[j], OBJPROP_WIDTH, 1 );
			ObjectSet( pplinearray[j], OBJPROP_BACK, false );
			ObjectSet( pplinearray[j], OBJPROP_RAY, false );
		}

	}

	// Woodie Povit Point
	woodiepplinearray[0] = "wr2";
	woodiepplinearray[1] = "wr1";
	woodiepplinearray[2] = "wpp";
	woodiepplinearray[3] = "ws1";
	woodiepplinearray[4] = "ws2";

	for(int q = 0; q < NUMOFWOODIEPP; q++)
	{
		ObjectCreate(woodiepplinearray[q],OBJ_HLINE,0,0,0);

		ObjectCreate("label"+woodiepplinearray[q],OBJ_TEXT,0,Time[30],0);
		//wr
		if(q<2)
		{
			ObjectSet( woodiepplinearray[q], OBJPROP_COLOR, DeepSkyBlue );
			ObjectSet( woodiepplinearray[q], OBJPROP_STYLE, STYLE_DOT );

			ObjectSet( woodiepplinearray[q], OBJPROP_WIDTH, 1 );
			ObjectSet( woodiepplinearray[q], OBJPROP_BACK, false );
			ObjectSet( woodiepplinearray[q], OBJPROP_RAY, false );
		}
		//wpp
		if(q==2)
		{
			ObjectSet( woodiepplinearray[q], OBJPROP_COLOR, Gray );
			ObjectSet( woodiepplinearray[q], OBJPROP_STYLE, STYLE_DOT );

			ObjectSet( woodiepplinearray[q], OBJPROP_WIDTH, 1 );
			ObjectSet( woodiepplinearray[q], OBJPROP_BACK, false );
			ObjectSet( woodiepplinearray[q], OBJPROP_RAY, false );
		}
		//ws
		if(q>2)
		{
			ObjectSet( woodiepplinearray[q], OBJPROP_COLOR, BlueViolet );
			ObjectSet( woodiepplinearray[q], OBJPROP_STYLE, STYLE_DOT );

			ObjectSet( woodiepplinearray[q], OBJPROP_WIDTH, 1 );
			ObjectSet( woodiepplinearray[q], OBJPROP_BACK, false );
			ObjectSet( woodiepplinearray[q], OBJPROP_RAY, false );
		}

	}

	camarillapplinearray[0] = "cr4";
	camarillapplinearray[1] = "cr3";
	camarillapplinearray[2] = "cr2";
	camarillapplinearray[3] = "cr1";
	camarillapplinearray[4] = "cpp";
	camarillapplinearray[5] = "cs1";
	camarillapplinearray[6] = "cs2";
	camarillapplinearray[7] = "cs3";
	camarillapplinearray[8] = "cs4";

	//Print("error1: " ,GetLastError() );

	for(int w = 0 ; w< 9; w++)
	{
		//Print( "ini ok0" );
		ObjectCreate(camarillapplinearray[w],OBJ_HLINE,0,0,0);

		//Print("error2: " ,GetLastError() );

		ObjectCreate("label"+camarillapplinearray[w],OBJ_TEXT,0,Time[40],0);
		//rr
		if(w<4)
		{
			//Print( "ini ok1" );
			ObjectSet( camarillapplinearray[w], OBJPROP_COLOR, MediumPurple );
			ObjectSet( camarillapplinearray[w], OBJPROP_STYLE, STYLE_DASHDOT );

			ObjectSet( camarillapplinearray[w], OBJPROP_WIDTH, 1 );
			ObjectSet( camarillapplinearray[w], OBJPROP_BACK, false );
			ObjectSet( camarillapplinearray[w], OBJPROP_RAY, false );
		}
		//pp
		if(w == 4)
		{
			//Print( "ini ok2" );
			ObjectSet( camarillapplinearray[w], OBJPROP_COLOR, CornflowerBlue );
			ObjectSet( camarillapplinearray[w], OBJPROP_STYLE, STYLE_DASHDOT );

			ObjectSet( camarillapplinearray[w], OBJPROP_WIDTH, 1 );
			ObjectSet( camarillapplinearray[w], OBJPROP_BACK, false );
			ObjectSet( camarillapplinearray[w], OBJPROP_RAY, false );

		}
		//ss
		if(w > 4)
		{
			//Print( "ini ok3" );
			ObjectSet( camarillapplinearray[w], OBJPROP_COLOR, MediumSlateBlue );
			ObjectSet( camarillapplinearray[w], OBJPROP_STYLE, STYLE_DASHDOT );

			ObjectSet( camarillapplinearray[w], OBJPROP_WIDTH, 1 );
			ObjectSet( camarillapplinearray[w], OBJPROP_BACK, false );
			ObjectSet( camarillapplinearray[w], OBJPROP_RAY, false );
		}

	}

	//Print( "ini ok" );
	//init sr lines
	for(int e = 0 ;e < NUMOFSRLINES; e++)
	{
		srlinearray[e] = "srline"+ IntegerToString(e);

		ObjectCreate(srlinearray[e],OBJ_HLINE,0,0,0);
		//LightGreen
		ObjectSet( srlinearray[e], OBJPROP_COLOR, LightGreen );
		ObjectSet( srlinearray[e], OBJPROP_STYLE, STYLE_DASHDOTDOT );

		ObjectSet( srlinearray[e], OBJPROP_WIDTH, 1 );
		ObjectSet( srlinearray[e], OBJPROP_BACK, false );
		ObjectSet( srlinearray[e], OBJPROP_RAY, false );


		ObjectCreate("label"+srlinearray[e],OBJ_TEXT,0,Time[60],0);
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

void DisplayPP()
{
	//ObjectCreate("label"+pplinearray[j],OBJ_TEXT,0,pplinearray[j],0);
	//PivotPoints
	for(int i = 0; i < NUMOFPP; i++)
	{
		ObjectSet( pplinearray[i], OBJPROP_PRICE1, PivotPoints[i] );

		ObjectSet( "label"+pplinearray[i], OBJPROP_PRICE1, PivotPoints[i] );

		ObjectSetText("label"+pplinearray[i], pplinearray[i], 10, "Times New Roman", Crimson);

	}
}

void DisplayWoodiePP()
{
	//ObjectCreate("label"+woodiepplinearray[q],OBJ_TEXT,0,Time[5],0);
	for(int i = 0; i < NUMOFWOODIEPP; i++)
	{
		ObjectSet( woodiepplinearray[i], OBJPROP_PRICE1, WoodiePivotPoint[i] );

		ObjectSet( "label"+woodiepplinearray[i], OBJPROP_PRICE1, WoodiePivotPoint[i] );

		ObjectSetText("label"+woodiepplinearray[i], woodiepplinearray[i], 10, "Times New Roman", MediumVioletRed);
	}
}

void DisplayCamarillaPP()
{

	for(int i = 0; i< NUMOFCAMARILLAPP; i++)
	{
		ObjectSet( camarillapplinearray[i], OBJPROP_PRICE1, CamarillaPivotPoint[i] );

		ObjectSet( "label"+camarillapplinearray[i], OBJPROP_PRICE1, CamarillaPivotPoint[i] );

		ObjectSetText("label"+camarillapplinearray[i], camarillapplinearray[i], 10, "Times New Roman", PaleGreen);
	}
}

void DisplaySRLines()
{
	//srlinearray[e]
	for(int i = 0; i< NUMOFSRLINES; i++)
	{
		ObjectSet( srlinearray[i], OBJPROP_PRICE1, SupportAndResistentValue[i] );

		ObjectSet( "label"+srlinearray[i], OBJPROP_PRICE1, SupportAndResistentValue[i] );

		ObjectSetText("label"+srlinearray[i], srlinearray[i], 10, "Times New Roman", LightGreen);
	}
}

void DisplayBigUpTrend()
{
	for(int i = 0; i< numofbiguptrend; i++)
	{
		int linenum = i;
		int startindexpos = linenum * 2 + 1;
		int endindexpos = linenum * 2;

		int startindex = 	biguptrendindexbuffer[startindexpos];
		int endindex = 		biguptrendindexbuffer[endindexpos];


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

		int startindex = 	bigdowntrendindexbuffer[startindexpos];
		int endindex = 		bigdowntrendindexbuffer[endindexpos];
		MoveDownTrendLine(linenum, startindex, endindex);

	}
}

void DisplayAllLines()
{
	DisplayBigUpTrend();
	DisplayBigDownTrend();

	DisplayPP();
	//DisplayWoodiePP();
	//DisplayCamarillaPP();
	//DisplaySRLines();

}
//+------------------------------------------------------------------+
//| run command function                                   |
//+------------------------------------------------------------------+
void RunCommand()
{
	//
	int res_ticket = -2;
	if( Command[0] != 0)
	{
		if( Command[0] == 1 )
		{
			// buy order
			res_ticket = OrderSend( Symbol(), OP_BUY, 0.01, CommandParameters[0], 3, 0.0, 0.0, "buy order", 16384, 0, Green );
			ReportOrderResult( res_ticket );
			Alert( "order send res_ticket = ", res_ticket );
		}

		if( Command[0] == -1 )
		{
			//sell order
			res_ticket = OrderSend( Symbol(), OP_SELL, 0.01, CommandParameters[0], 3, 0.0, 0.0, "buy order", 16384, 0, Green );
			ReportOrderResult( res_ticket );
			Alert( "order send res_ticket = ", res_ticket );
		}

		if( Command[0] == 99 )
		{
			//close order
			bool cr = OrderClose( Command[1], 0.01 , CommandParameters[0], 3, Red );
			Alert( "order close ", Command[1], " res =  ", cr );
			if(cr)
			{
				ReportOrderResult( 99999999 );
			}

		}
	}


}
//+------------------------------------------------------------------+
//| analyze function                                   |
//+------------------------------------------------------------------+
int DLLComputingTrend()
{

	FlushData();

	double a = Ask;
	double b = Bid;
	

	int k = AnalyzeTrend(
		//h1
		main_openarr_H1,
		main_closearr_H1,
		main_higharr_H1,
		main_lowarr_H1,
		//d1
		main_openarr_D1,
		main_closearr_D1,
		main_higharr_D1,
		main_lowarr_D1,
		//h4
		main_openarr_H4,
		main_closearr_H4,
		main_higharr_H4,
		main_lowarr_H4,
		//m15
		main_openarr_M15,
		main_closearr_M15,
		main_higharr_M15,
		main_lowarr_M15,
		//m5
		main_openarr_M5,
		main_closearr_M5,
		main_higharr_M5,
		main_lowarr_M5,
		//m1
		main_openarr_M1,
		main_closearr_M1,
		main_higharr_M1,
		main_lowarr_M1,
		//ask bid
		a,
		b,
		//ma
		mabuffer_D1_P5,
		mabuffer_H4_P5,
		mabuffer_H1_P5,
		mabuffer_M15_P5,
		mabuffer_M5_P5,
		mabuffer_M1_P5,

		mabuffer_D1_P15,
		mabuffer_H4_P15,
		mabuffer_H1_P15,
		mabuffer_M15_P15,
		mabuffer_M5_P15,
		mabuffer_M1_P15,
		//
		updatemarkarr,
		//
		
		//for Displau
		
		biguptrendindexbuffer,
		bigdowntrendindexbuffer,
		backparemeters,
		//3 type of povite points
		PivotPoints,
		//WoodiePivotPoint,
		//CamarillaPivotPoint,
		//
		//SupportAndResistentValue
		Command,
		CommandParameters
		);
    numofbiguptrend = backparemeters[0];
    numofbigdowntrend = backparemeters[1];
    //Print( "su = ",numofbiguptrend," sd = ", numofbigdowntrend);
    return 0;
}

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

  	Print( "version 1.00" );
  	InitLineObjectArray();
//----
	FlushData();

	double sp = MarketInfo( Symbol(), MODE_SPREAD );

	//SetMarketInfo_Spread(sp);
//----
	EventSetMillisecondTimer(5);


   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
 {
  	EventKillTimer();
//----
   DeleteAllObjectInThisWindow();
//----
   //return(0);
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

			DLLComputingTrend();

			RunCommand();

			DisplayAllLines();

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
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
void OnTick()
 {
/**
  	while( !IsStopped() ) 
  	{
  		RefreshRates();


		//TimeTestStart();
  		DLLComputingTrend();
  		//TimeTestEnd();

  		DisplayAllLines();


  		Sleep(5);            
  	}
*/
/***/
		//Print( "tt" );

		/**
		TimeTestStart();
  		DLLComputingTrend();
  		TimeTestEnd();
*/


/**
  		int res_ordersend = 0;


  		Print( "OrderCommand = ",OrderCommand );


  		if(  OrderCommand == -1 )
  		{
  			//send order
  			res_ordersend = OrderSend( Symbol(), OP_SELL, 0.01 , Bid, 3,  Bid + 0.0020 , Bid - 0.0003 );

  			Alert("res = ", res_ordersend);

  		}

  		if( OrderCommand == 1 )
  		{
  			//buy
  			res_ordersend = OrderSend( Symbol(), OP_BUY, 0.01 , Ask, 3,  Ask - 0.0020 , Ask + 0.0003 );

  			Alert("res = ", res_ordersend);
  		}
*/
  		//DisplayAllLines();
  		
		
/**


*/

//----
  // return(0);
 }
//+------------------------------------------------------------------+