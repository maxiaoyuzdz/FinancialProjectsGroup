#include "ExternMethod.h"
/**
extern "C" {
	#include "cluster.h"
}
*/
//////////////////////////////////////////////////////////////
#define NUMOFSECTION 20
#define WINDOWSIZE 4
#define LARGEWINDOWSIZE 8
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
#define DATABUFSIZE 2000
#define NUMOFTRENDINBUFFER NUMOFSECTION * 2  //1 trend has 2 points, 20 * 2 = 40
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//for standard used
//start end startvalue, endvalue
TrendSection trendarray_D1_W4[NUMOFSECTION];
TrendSection trendarray_H4_W4[NUMOFSECTION];
TrendSection trendarray_H1_W4[NUMOFSECTION];
TrendSection trendarray_M15_W4[NUMOFSECTION];
TrendSection trendarray_M5_W4[NUMOFSECTION];
TrendSection trendarray_M1_W4[NUMOFSECTION];
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
int orderlist_D1[4];
int orderlist_H4[4];
int orderlist_H1[4];
int orderlist_M15[4];
int orderlist_M5[4];
int orderlist_M1[4];
//////////////////////////////////////////////////////////////
//from TrendSection
TrendStatus res_quantization_trend[6];
//////////////////////////////////////////////////////////////
//TrendStatusFilterResult res_analyze_trend[6];
//////////////////////////////////////////////////////////////
MAAnalyzeResult res_analyze_ma[6];
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//pivot points
double StandardPivotPoints[7];
//double WoodiePivotPoints[5];
//double CamarillaPivotPoints[9];
//////////////////////////////////////////////////////////////
/* for system status switch */
SysStutas systemstatus;
//////////////////////////////////////////////////////////////
//TrendLogicParamaters trendlogicparameters[6];
////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
/* for store command */
int Command[10];
double CommandParameters[10];
///////////////////////////////////////////////////////////
// int ktypearray[6][10];
///////////////////////////////////////////////////////////
int ma_acroess_pos_m5[4];
int ma_acroess_type_m5[4];
///////////////////////////////////////////////////////////
// int testres[2][2000];
///////////////////////////////////////////////////////////
MAAcroessAndTrendResult res_ma_trend_D1[20];
MAAcroessAndTrendResult res_ma_trend_H4[20];
MAAcroessAndTrendResult res_ma_trend_H1[20];
MAAcroessAndTrendResult res_ma_trend_M15[20];
MAAcroessAndTrendResult res_ma_trend_M5[20];
MAAcroessAndTrendResult res_ma_trend_M1[20];
///////////////////////////////////////////////////////////
double globel_ask;
double global_bid;

// const double* pt1;
int oldendsection[6];
bool hasnewsection[6];
///////////////////////////////////////////////////////////
int maacroessstatus[6];
int global_parameter1 = 0;






void ResetCommandArr()
{
	memset(Command, 0, 10*sizeof(int));
	memset(CommandParameters,0, 10*sizeof(double));
}


void SetMarketInfo_Spread(const double sp)
{
	marketinfo_spread = sp;
	PRICECAPITICAL_M = 0.00001 * marketinfo_spread;
	minidistance = PRICECAPITICAL_M;
// 	int len2 = swprintf(logbuf, 100, L"spread = %f\n", marketinfo_spread);
// 	OutputDebugString(logbuf);
}
////////////////////////////////////////////////////////////////////////////////////





void AnalyzeConditionsForClosingOrder(const double& ask, const double& bid);
void AnalyzeConditionsForClosingOrder(const double& ask, const double& bid)
{
	if( systemstatus.ordertype == 1 )
	{
		if( (bid - systemstatus.price) >= 0.0003 )
		{
			//close
			Command[0] = 99;
			Command[1] = systemstatus.ticket;
			CommandParameters[0] = bid;
		}

	}

	if( systemstatus.ordertype == -1 )
	{
		if( ( systemstatus.price - ask ) >= 0.0003 )
		{
			//close
			Command[0] = 99;
			Command[1] = systemstatus.ticket;
			CommandParameters[0] = ask;
		}
	}

}


void OrderSendAnalyze(
	const double *openarr_h1,
	const double *closearr_h1,
	const double *higharr_h1,
	const double *lowarr_h1,
	//big view d1
	const double *openarr_d1,
	const double *closearr_d1,
	const double *higharr_d1,
	const double *lowarr_d1,
	//h4
	const double *openarr_h4,
	const double *closearr_h4,
	const double *higharr_h4,
	const double *lowarr_h4,
	//m15
	const double *openarr_m15,
	const double *closearr_m15,
	const double *higharr_m15,
	const double *lowarr_m15,
	//m5
	const double *openarr_m5,
	const double *closearr_m5,
	const double *higharr_m5,
	const double *lowarr_m5,
	//m1
	const double *openarr_m1,
	const double *closearr_m1,
	const double *higharr_m1,
	const double *lowarr_m1,
	//
	const double& ask,
	const double& bid, //current standard price
	//
	const int* updatelist,
	const double *mabuffer_D1_P5,
	const double *mabuffer_H4_P5,
	const double *mabuffer_H1_P5,
	const double *mabuffer_M15_P5,
	const double *mabuffer_M5_P5,
	const double *mabuffer_M1_P5,

	const double *mabuffer_D1_P15,
	const double *mabuffer_H4_P15,
	const double *mabuffer_H1_P15,
	const double *mabuffer_M15_P15,
	const double *mabuffer_M5_P15,
	const double *mabuffer_M1_P15
	);
void OrderSendAnalyze(
	const double *openarr_h1,
	const double *closearr_h1,
	const double *higharr_h1,
	const double *lowarr_h1,
	//big view d1
	const double *openarr_d1,
	const double *closearr_d1,
	const double *higharr_d1,
	const double *lowarr_d1,
	//h4
	const double *openarr_h4,
	const double *closearr_h4,
	const double *higharr_h4,
	const double *lowarr_h4,
	//m15
	const double *openarr_m15,
	const double *closearr_m15,
	const double *higharr_m15,
	const double *lowarr_m15,
	//m5
	const double *openarr_m5,
	const double *closearr_m5,
	const double *higharr_m5,
	const double *lowarr_m5,
	//m1
	const double *openarr_m1,
	const double *closearr_m1,
	const double *higharr_m1,
	const double *lowarr_m1,
	//
	const double& ask,
	const double& bid, //current standard price
	//
	const int* updatelist,
	const double *mabuffer_D1_P5,
	const double *mabuffer_H4_P5,
	const double *mabuffer_H1_P5,
	const double *mabuffer_M15_P5,
	const double *mabuffer_M5_P5,
	const double *mabuffer_M1_P5,

	const double *mabuffer_D1_P15,
	const double *mabuffer_H4_P15,
	const double *mabuffer_H1_P15,
	const double *mabuffer_M15_P15,
	const double *mabuffer_M5_P15,
	const double *mabuffer_M1_P15
	)
{
	ResetCommandArr();
	
	



}


////////////////////////////////////////////////////////////////////////////////////

void __stdcall ReportOrderResult(const int ordericket)
{
	if( ordericket != -1 && ordericket != 99999999)
	{
		systemstatus.ticket = ordericket;

		if( systemstatus.status ==  CHECKINFCONDITIONOFSENDORDER)
		{
			systemstatus.status = CHECKINGCONDITIONOFCLOSEORDER;

			int len2 = swprintf(logbuf, 200, L"mt4 order send \n");
			OutputDebugString(logbuf);

		}

		
	}
	if( ordericket == 99999999 )
	{
		if( systemstatus.status == CHECKINGCONDITIONOFCLOSEORDER )
		{
			systemstatus.status =  CHECKINFCONDITIONOFSENDORDER;
		}

	}
}



int __stdcall AnalyzeTrend(
	//trend parameters
	//main h1
	const double *openarr_h1,
	const double *closearr_h1,
	const double *higharr_h1,
	const double *lowarr_h1,
	//big view d1
	const double *openarr_d1,
	const double *closearr_d1,
	const double *higharr_d1,
	const double *lowarr_d1,
	//h4
	const double *openarr_h4,
	const double *closearr_h4,
	const double *higharr_h4,
	const double *lowarr_h4,
	//m15
	const double *openarr_m15,
	const double *closearr_m15,
	const double *higharr_m15,
	const double *lowarr_m15,
	//m5
	const double *openarr_m5,
	const double *closearr_m5,
	const double *higharr_m5,
	const double *lowarr_m5,
	//m1
	const double *openarr_m1,
	const double *closearr_m1,
	const double *higharr_m1,
	const double *lowarr_m1,
	//ask
	const double Ask,
	const double Bid,
	//ma array 12
	const double *mabuffer_D1_P5,
	const double *mabuffer_H4_P5,
	const double *mabuffer_H1_P5,
	const double *mabuffer_M15_P5,
	const double *mabuffer_M5_P5,
	const double *mabuffer_M1_P5,

	const double *mabuffer_D1_P15,
	const double *mabuffer_H4_P15,
	const double *mabuffer_H1_P15,
	const double *mabuffer_M15_P15,
	const double *mabuffer_M5_P15,
	const double *mabuffer_M1_P15,

	//new bar or just update
	const int *barupdatemarklist,
	//
	

	//output result
	//for display trend line
	int *output_uptrendindexbuffer,
	int *output_downtrendindexbuffer,
	//for other
	int *output_backparemeters,
	
	//for pp
	double *output_ppres,
	//double *wppres,
	//double *cppres,
	
	//for all support and resistent lines
	//double *srres
	int *output_Commandarr,
	double *output_CommandParametersarr

	)

{
	//worktype = wt;
	globel_ask = Ask;
	global_bid = Bid;

	// pt1 = mabuffer_M1_P15;

	//clear buffer
	ClearOutputDisplayBuffer(
		output_uptrendindexbuffer,
		output_downtrendindexbuffer,
		NUMOFTRENDINBUFFER
		);

	/************************************************************************/
	/* computing pivotpoints                                                */
	/************************************************************************/
	//CalculateStandardPivotPoints(openarr_d1[1],closearr_d1[1],higharr_d1[1], lowarr_d1[1], StandardPivotPoints,output_ppres);

	/************************************************************************/
	/* computing all sections                                                                     */
	/************************************************************************/
	//D1
	ProcessOLHCtoTrend(openarr_d1,closearr_d1, NUMOFSECTION, WINDOWSIZE, trendarray_D1_W4);
	//H4
	ProcessOLHCtoTrend(openarr_h4,closearr_h4, NUMOFSECTION, WINDOWSIZE, trendarray_H4_W4);
	//main work area H1
	ProcessOLHCtoTrend(openarr_h1,closearr_h1, NUMOFSECTION, WINDOWSIZE, trendarray_H1_W4);
	//M15
	ProcessOLHCtoTrend(openarr_m15,closearr_m15, NUMOFSECTION, WINDOWSIZE, trendarray_M15_W4);
	//M5
	ProcessOLHCtoTrend(openarr_m5,closearr_m5, NUMOFSECTION, WINDOWSIZE, trendarray_M5_W4);
	//M1
	ProcessOLHCtoTrend(openarr_m1,closearr_m1, NUMOFSECTION, WINDOWSIZE, trendarray_M1_W4);

	/* initialize new section update arr */
	if( oldendsection[5] == 0 )
	{
		hasnewsection[5] = false;
		oldendsection[5] = trendarray_D1_W4[0].type;
	}
	if( oldendsection[4] == 0 )
	{
		hasnewsection[4] = false;
		oldendsection[4] = trendarray_H4_W4[0].type;
	}
	if( oldendsection[3] == 0 )
	{
		hasnewsection[3] = false;
		oldendsection[3] = trendarray_H1_W4[0].type;
	}
	if( oldendsection[2] == 0 )
	{
		hasnewsection[2] = false;
		oldendsection[2] = trendarray_M15_W4[0].type;
	}
	if( oldendsection[1] == 0 )
	{
		hasnewsection[1] = false;
		oldendsection[1] = trendarray_M5_W4[0].type;
	}
	if( oldendsection[0] == 0 )
	{
		hasnewsection[0] = false;
		oldendsection[0] = trendarray_M1_W4[0].type;
	}
	
	/* initialize end */
	
	/************************************************************************/
	/*  computing pivotpoints end                                           */
	/************************************************************************/
	/************************************************************************/
	/* start to analyze                                                     */
	/************************************************************************/
	//////////////////////////////////////////////////////////////////////////
	//calculate orderlist
	//D1
	FindFourValidSections(trendarray_D1_W4, 0, orderlist_D1);
	//H4
	FindFourValidSections(trendarray_H4_W4, 0, orderlist_H4);
	//H1
	FindFourValidSections(trendarray_H1_W4, 0, orderlist_H1);
	//M15
	FindFourValidSections(trendarray_M15_W4, 0, orderlist_M15);
	//M5
	FindFourValidSections(trendarray_M5_W4, 0, orderlist_M5);
	//M1
	FindFourValidSections(trendarray_M1_W4, 0, orderlist_M1);


/***/
	//d1
	CalculatePreAndNowTrend(trendarray_D1_W4, orderlist_D1, 5, res_quantization_trend);
	//h4
	CalculatePreAndNowTrend(trendarray_H4_W4, orderlist_H4, 4, res_quantization_trend);
	//h1
	CalculatePreAndNowTrend(trendarray_H1_W4, orderlist_H1, 3, res_quantization_trend);
	//m15
	CalculatePreAndNowTrend( trendarray_M15_W4, orderlist_M15, 2, res_quantization_trend);
	//m5
	CalculatePreAndNowTrend(trendarray_M5_W4, orderlist_M5, 1, res_quantization_trend);
	//m1
	CalculatePreAndNowTrend( trendarray_M1_W4, orderlist_M1, 0, res_quantization_trend);




	AnalyzeMA(
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
		res_analyze_ma

		);

	/* analyze maacroess */
	ProcessMAAndTrend(mabuffer_D1_P5,mabuffer_D1_P15,trendarray_D1_W4,res_ma_trend_D1);
	ProcessMAAndTrend(mabuffer_H4_P5,mabuffer_H4_P15,trendarray_H4_W4,res_ma_trend_H4);
	ProcessMAAndTrend(mabuffer_H1_P5,mabuffer_H1_P15,trendarray_H1_W4,res_ma_trend_H1);
	ProcessMAAndTrend(mabuffer_M15_P5,mabuffer_M15_P15,trendarray_M15_W4,res_ma_trend_M15);
	ProcessMAAndTrend(mabuffer_M5_P5,mabuffer_M5_P15,trendarray_M5_W4,res_ma_trend_M5);
	ProcessMAAndTrend(mabuffer_M1_P5,mabuffer_M1_P15,trendarray_M1_W4,res_ma_trend_M1);




	// memcpy( updatemarkarr, barupdatemarklist, 6 * sizeof(int) );

		
	
/*	for (int i = 5; i >= 0; i--)
	{
		
		
		int len2 = swprintf(
		logbuf, 200, L"mt4 i = %d,inup = %d, endpos = %d, startpos = %d, typelast = %d, max = %d, num= %d, main = %d, bymain = %d\n", 
		
		i,
		barupdatemarklist[i],

		res_quantization_trend[i].end_lastsection, 
		res_quantization_trend[i].start_lastsection, 
		res_quantization_trend[i].trendtype_lastsection,

		res_analyze_ma[i].type_lastacroess,
		res_analyze_ma[i].count_acroess_in_5,

		res_quantization_trend[i].main_power,
		res_quantization_trend[i].drive_by_main_lastsection

		);
		OutputDebugString(logbuf);
	}*/
	


	//start analyze logic

	switch(systemstatus.status)
	{
		case CHECKINFCONDITIONOFSENDORDER: 
		OrderSendAnalyze(
			openarr_h1,
			closearr_h1,
			higharr_h1,
			lowarr_h1,
			//big view d1
			openarr_d1,
			closearr_d1,
			higharr_d1,
			lowarr_d1,
			//h4
			openarr_h4,
			closearr_h4,
			higharr_h4,
			lowarr_h4,
			//m15
			openarr_m15,
			closearr_m15,
			higharr_m15,
			lowarr_m15,
			//m5
			openarr_m5,
			closearr_m5,
			higharr_m5,
			lowarr_m5,
			//m1
			openarr_m1,
			closearr_m1,
			higharr_m1,
			lowarr_m1,
			//
			Ask,
			Bid,
			barupdatemarklist,
			//ma
			//ma array 12
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
			mabuffer_M1_P15
			);

		break;

		case CHECKINGCONDITIONOFCLOSEORDER: AnalyzeConditionsForClosingOrder(Ask,Bid);
		break;
	}


	//Command[0] = 1;
	//CommandParameters[0] = Ask;


	memcpy( output_Commandarr, Command, 10 * sizeof(int) );
	memcpy(output_CommandParametersarr, CommandParameters, 10 * sizeof(double));


	
	




// 	int res = MxyProcessD1(trendarray_D1_W4);
// 	int len2 = swprintf(logbuf, 100, L"t = %d \n", res);
// 	OutputDebugString(logbuf);
	//////////////////////////////////////////////////////////////////////////
	/************************************************************************/
	/* analyze end                                                                     */
	/************************************************************************/
	//copy command and parameters

	/************************************************************************/
	/* For Display trendlines in H1                                                                    */
	/************************************************************************/
	GenerateTrendLineOutput(output_uptrendindexbuffer,output_downtrendindexbuffer,output_backparemeters,trendarray_H1_W4,NUMOFSECTION);
	//memcpy(srres, SupportAndResistentLevelTotal, NUMOFSECTION * 6 * sizeof(double));


	return 0;
}


