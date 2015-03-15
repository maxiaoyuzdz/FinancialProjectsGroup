#include "ExternMethod.h"

//////////////////////////////////////////////////////////////
#define NUMOFSECTION 20
#define WINDOWSIZE 8
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
#define DATABUFSIZE 2000
#define NUMOFTRENDINBUFFER NUMOFSECTION * 2  //1 trend has 2 points, 20 * 2 = 40
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
TrendSection trendarray[NUMOFSECTION];
//////////////////////////////////////////////////////////////
//pivot points
double StandardPivotPoints[7];

double WoodiePivotPoints[5];

double CamarillaPivotPoints[9];
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
double SupportAndResistentLevel[NUMOFSECTION];
//////////////////////////////////////////////////////////////
#define PRICECAPITICAL_D1 0.002
#define PRICECAPITICAL_H4 0.002
#define PRICECAPITICAL_H1 0.0004

double marketinfo_spread = 0;
double PRICECAPITICAL_M = 0;

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
	const double *openarr,
	const double *closearr,
	const double *higharr,
	const double *lowarr,
	const double *lastdaydata,
	const int period,
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

	//main work area H1
	ProcessOLHCtoTrend(openarr,closearr,higharr,lowarr, NUMOFSECTION, WINDOWSIZE, trendarray);


	/************************************************************************/
	/* computing pivotpoints                                                 */
	/************************************************************************/
	CalculateStandardPivotPoints(lastdaydata[0],lastdaydata[1],lastdaydata[2], lastdaydata[3], StandardPivotPoints,ppres);

	CalculateWoodiePivotpoint(lastdaydata[0],lastdaydata[1],lastdaydata[2], lastdaydata[3], WoodiePivotPoints,wppres);

	CalculateCamarillaPivotpoint(lastdaydata[0],lastdaydata[1],lastdaydata[2], lastdaydata[3], CamarillaPivotPoints,cppres);
	/************************************************************************/
	/*  computing pivotpoints end                                                                    */
	/************************************************************************/
	/************************************************************************/
	/* For Display                                                                     */
	/************************************************************************/
	GenerateTrendLineOutput(output_uptrendindexbuffer,output_downtrendindexbuffer,output_backparemeters,trendarray,NUMOFSECTION);


	// 	int len0 = swprintf(logbuf, 100, L"check start\n");
	// 	OutputDebugString(logbuf);
	// 	for (int i = 0; i < NUMOFSECTION; i++)
	// 	{
	// 		int len1 = swprintf(logbuf, 100, L"type %d = %d\n", i, trendarray_M1[i].type);
	// 		OutputDebugString(logbuf);
	// 	}
	// 
	// 	int len2 = swprintf(logbuf, 100, L"check end\n");
	// 	OutputDebugString(logbuf);

	/************************************************************************/
	/* search all result, to get line list                                                                     */
	/************************************************************************/
	/************************************************************************/
	/* 1 filter trend res                                                                     */
	/************************************************************************/
	/************************************************************************/
	/* filter D                                                                     */
	/************************************************************************/
	double pricecaptical = 0;
	switch(period){
	case 1: pricecaptical = 0.00001 * marketinfo_spread;
		break;
	case 5: pricecaptical = 0.00001 * marketinfo_spread;
		break;
	case 15: pricecaptical = 0.00001 * marketinfo_spread;
		break;
	case 60: pricecaptical = 0.0004;
		break;
	case 240: pricecaptical = 0.002;
		break;
	case 1440: pricecaptical = 0.002;
		break;
	}
	//filter H1 main area
	FilterTrendToGenerateSRLevelForOnePeriod(trendarray,NUMOFSECTION,pricecaptical, SupportAndResistentLevel);

	//compose
	/************************************************************************/
	/* For Display                                                                     */
	/************************************************************************/
	SortArray(SupportAndResistentLevel,NUMOFSECTION);
	

	memcpy(srres, SupportAndResistentLevel, NUMOFSECTION * sizeof(double));

	//process each section


	return 0;
}