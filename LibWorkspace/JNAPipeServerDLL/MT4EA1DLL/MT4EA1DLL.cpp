#include "ExternMethod.h"

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
TrendSection trendarray_D1_W4[NUMOFSECTION];
TrendSection trendarray_H4_W4[NUMOFSECTION];
TrendSection trendarray_H1_W4[NUMOFSECTION];
TrendSection trendarray_M15_W4[NUMOFSECTION];
TrendSection trendarray_M5_W4[NUMOFSECTION];
TrendSection trendarray_M1_W4[NUMOFSECTION];
//for special situation, standard condition not work
/**
TrendSection trendarray_D1_W8[NUMOFSECTION];
TrendSection trendarray_H4_W8[NUMOFSECTION];
TrendSection trendarray_H1_W8[NUMOFSECTION];
TrendSection trendarray_M15_W8[NUMOFSECTION];
TrendSection trendarray_M5_W8[NUMOFSECTION];
TrendSection trendarray_M1_W8[NUMOFSECTION];
*/
//////////////////////////////////////////////////////////////
//pivot points
double StandardPivotPoints[7];
double WoodiePivotPoints[5];
double CamarillaPivotPoints[9];
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
double SupportAndResistentLevel_D1[NUMOFSECTION];
double SupportAndResistentLevel_H4[NUMOFSECTION];
double SupportAndResistentLevel_H1[NUMOFSECTION];
double SupportAndResistentLevel_M15[NUMOFSECTION];
double SupportAndResistentLevel_M5[NUMOFSECTION];
double SupportAndResistentLevel_M1[NUMOFSECTION];

double SupportAndResistentLevelTotal[NUMOFSECTION * 6];
//////////////////////////////////////////////////////////////
#define PRICECAPITICAL_D1 0.002
#define PRICECAPITICAL_H4 0.002
#define PRICECAPITICAL_H1 0.0004

double marketinfo_spread = 0;
double PRICECAPITICAL_M = 0;
//////////////////////////////////////////////////////////////
WorkingStatus systemstatus;
/*TrendStatus trendstatus;*/
//////////////////////////////////////////////////////////////
#define NUMOFJUDGEELEMENT 7
int statussource_D1[NUMOFJUDGEELEMENT];
int statussource_H4[NUMOFJUDGEELEMENT];
int statussource_H1[NUMOFJUDGEELEMENT];
int statussource_M15[NUMOFJUDGEELEMENT];
int statussource_M5[NUMOFJUDGEELEMENT];
int statussource_M1[NUMOFJUDGEELEMENT];
//////////////////////////////////////////////////////////////
TrendStatus res_quantization_trend[6];
//////////////////////////////////////////////////////////////
void SetMarketInfo_Spread(const double sp)
{
	marketinfo_spread = sp;
	PRICECAPITICAL_M = 0.00001 * marketinfo_spread;
// 	int len2 = swprintf(logbuf, 100, L"spread = %f\n", marketinfo_spread);
// 	OutputDebugString(logbuf);
}



int AnalyzeTrend(
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
	//bid
	const double Bid,
	//output result
	//for display trend line
	int *output_uptrendindexbuffer,
	int *output_downtrendindexbuffer,
	//for other
	int *output_backparemeters,
	//for pp
	double *ppres,
	double *wppres,
	double *cppres,
	//for all support and resistent lines
	double *srres
	)

{
	//clear buffer
	ClearOutputDisplayBuffer(
		output_uptrendindexbuffer,
		output_downtrendindexbuffer,
		NUMOFTRENDINBUFFER
		);

	/************************************************************************/
	/* computing all sections                                                                     */
	/************************************************************************/
	//D1
	ProcessOLHCtoTrend(openarr_d1,closearr_d1,higharr_d1,lowarr_d1, NUMOFSECTION, WINDOWSIZE, trendarray_D1_W4);
	//H4
	ProcessOLHCtoTrend(openarr_h4,closearr_h4,higharr_h4,lowarr_h4, NUMOFSECTION, WINDOWSIZE, trendarray_H4_W4);
	//main work area H1
	ProcessOLHCtoTrend(openarr_h1,closearr_h1,higharr_h1,lowarr_h1, NUMOFSECTION, WINDOWSIZE, trendarray_H1_W4);
	//M15
	ProcessOLHCtoTrend(openarr_m15,closearr_m15,higharr_m15,lowarr_m15, NUMOFSECTION, WINDOWSIZE, trendarray_M15_W4);
	//M5
	ProcessOLHCtoTrend(openarr_m5,closearr_m5,higharr_m5,lowarr_m5, NUMOFSECTION, WINDOWSIZE, trendarray_M5_W4);
	//M1
	ProcessOLHCtoTrend(openarr_m1,closearr_m1,higharr_m1,lowarr_m1, NUMOFSECTION, WINDOWSIZE, trendarray_M1_W4);
/**
	//D1
	ProcessOLHCtoTrend(openarr_d1,closearr_d1,higharr_d1,lowarr_d1, NUMOFSECTION, LARGEWINDOWSIZE, trendarray_D1_W8);
	//H4
	ProcessOLHCtoTrend(openarr_h4,closearr_h4,higharr_h4,lowarr_h4, NUMOFSECTION, LARGEWINDOWSIZE, trendarray_H4_W8);
	//main work area H1
	ProcessOLHCtoTrend(openarr_h1,closearr_h1,higharr_h1,lowarr_h1, NUMOFSECTION, LARGEWINDOWSIZE, trendarray_H1_W8);
	//M15
	ProcessOLHCtoTrend(openarr_m15,closearr_m15,higharr_m15,lowarr_m15, NUMOFSECTION, LARGEWINDOWSIZE, trendarray_M15_W8);
	//M5
	ProcessOLHCtoTrend(openarr_m5,closearr_m5,higharr_m5,lowarr_m5, NUMOFSECTION, LARGEWINDOWSIZE, trendarray_M5_W8);
	//M1
	ProcessOLHCtoTrend(openarr_m1,closearr_m1,higharr_m1,lowarr_m1, NUMOFSECTION, LARGEWINDOWSIZE, trendarray_M1_W8);
*/
	/************************************************************************/
	/* computing pivotpoints                                                */
	/************************************************************************/
	CalculateStandardPivotPoints(openarr_d1[1],closearr_d1[1],higharr_d1[1], lowarr_d1[1], StandardPivotPoints,ppres);

	//CalculateWoodiePivotpoint(openarr_d1[1],closearr_d1[1],higharr_d1[1], lowarr_d1[1], WoodiePivotPoints,wppres);

	//CalculateCamarillaPivotpoint(openarr_d1[1],closearr_d1[1],higharr_d1[1], lowarr_d1[1], CamarillaPivotPoints,cppres);
	/************************************************************************/
	/*  computing pivotpoints end                                           */
	/************************************************************************/
	/************************************************************************/
	/* start to analyze                                                     */
	/************************************************************************/
	//////////////////////////////////////////////////////////////////////////
	//d1
	CalculatePreAndNowTrend(openarr_d1[0], closearr_d1[0], trendarray_D1_W4, res_quantization_trend, 5);
	//h4
	CalculatePreAndNowTrend(openarr_h4[0], closearr_h4[0], trendarray_H4_W4, res_quantization_trend, 4);
	//h1
	CalculatePreAndNowTrend(openarr_h1[0], closearr_h1[0], trendarray_H1_W4, res_quantization_trend, 3);
	//m15
	CalculatePreAndNowTrend(openarr_m15[0], closearr_m15[0], trendarray_M15_W4, res_quantization_trend, 2);
	//m5
	CalculatePreAndNowTrend(openarr_m5[0], closearr_m5[0], trendarray_M5_W4, res_quantization_trend, 1);
	
	int len2 = swprintf(logbuf, 100, L"ppt = %d pt = %d, nt = %d, ss = %f, sr = %f\n", res_quantization_trend[5].trendtype_pre_pre, res_quantization_trend[5].trendtype_pre, res_quantization_trend[5].trendtype_now, res_quantization_trend[5].slope_supportline, res_quantization_trend[5].slope_resistantline);
	OutputDebugString(logbuf);


// 	int res = MxyProcessD1(trendarray_D1_W4);
// 	int len2 = swprintf(logbuf, 100, L"t = %d \n", res);
// 	OutputDebugString(logbuf);
	//////////////////////////////////////////////////////////////////////////
	/************************************************************************/
	/* analyze end                                                                     */
	/************************************************************************/




	/************************************************************************/
	/* For Display trendlines in H1                                                                    */
	/************************************************************************/
	GenerateTrendLineOutput(output_uptrendindexbuffer,output_downtrendindexbuffer,output_backparemeters,trendarray_H1_W4,NUMOFSECTION);
	memcpy(srres, SupportAndResistentLevelTotal, NUMOFSECTION * 6 * sizeof(double));


	return 0;
}



void AnalyzeConditionsOfSendingOrder()
{

}

void AnalyzeConditionOfClosingOrder()
{

}
void ProcessTrading()
{
	switch(systemstatus.status)
	{
	case WAITINGWITHOUTORDER: AnalyzeConditionsOfSendingOrder();
		break;
	case WAITINGWITHORDER: AnalyzeConditionOfClosingOrder();
		break;
	}

}

