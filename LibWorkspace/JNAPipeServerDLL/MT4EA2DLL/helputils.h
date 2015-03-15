#include "stdafx.h"
#include <iostream>
#include <windows.h>
#include <ctype.h>
#include <math.h>
#include <omp.h>


using namespace std;

#define PP_RESISTANT_3 0
#define PP_RESISTANT_2 1
#define PP_RESISTANT_1 2
#define PP_STANDARD 3
#define PP_SUPPORT_1 4
#define PP_SUPPORT_2 5
#define PP_SUPPORT_3 6


#define DOJIRANGE_D1 0.0005
#define DOJIRANGE_H1 0.00005

#define MALENGTH 2000

//log buffer
wchar_t logbuf[200];

double PCFreq = 0.0;
__int64 CounterStart = 0;


/************************************************************************/
/* struct Define                                                      */
/************************************************************************/
struct TrendSection{
	int type;
	//position
	int start;
	int end;
	double startvalue;
	double endvalue;
	//start bar
	double start_open;
	double start_close;
	//double start_high;
	//double start_low;
	//end bar
	double end_open;
	double end_close;
	//double end_high;
	//double end_low;

};

struct TrendStatus{
	//trend type -1 1 10 -10
	int trendtype_now;
//	int trendtype_pre;
//	int trendtype_pre_pre;
	//support and resistant line parameters
	double slope_supportline;
	double slope_resistantline;
	double intercept_supportline;
	double intercept_resistantline;
	//last section
	int trendtype_lastsection;

	int end_lastsection;

	int start_lastsection;

	int main_power;
	bool drive_by_main_lastsection;

	
	//edge value for last section
	double value_on_supportline_end_lastsection;
	double value_on_resistantline_end_lastsection;
	//edge value for zero bar
	double value_on_supportline_pos_zero;
	double value_on_resistanctline_pos_zero;

	



};

struct TrendStatusFilterResult
{
	/* data */

	int current_main_trend;
	bool lastsection_in_main;
	int value_price_zone;

	bool trend_is_reduce;
	int direction_break_out;

	int trendtype_now;
	double slope_supportline,slope_resistantline, dis_priceandsupport, dis_priceandresistant;

	bool end_is_zero;

	//last section
	int trendtype_lastsection;


	TrendStatusFilterResult()
	{
		end_is_zero = false;
	}


};

#define MAARRAYLENGTH 2000

struct MAAnalyzeResult
{
	/* data */
	int type_lastacroess;

	int count_acroess_in_5;
};


struct TrendLogicParamaters
{
	/* data */
	//up or down
	int type_current_trend;

	//last trend in main development or in callback or unkonen
	int status_lastsection;

};


struct MAAcroessAndTrendResult
{
	/* data */
	int type_trend;
	bool hasmaacroess;
	int type_maacroess;
	int pos_maacroess;
	bool posinfront;

	int type_matrend;
};

/************************************************************************/
/* used for state machine                                                */
/************************************************************************/
#define CHECKINFCONDITIONOFSENDORDER 0
#define CHECKINGCONDITIONOFCLOSEORDER 1


struct SysStutas
{
	/* data */
	int status;

	int ordertype;

	double price;

	int ticket;

	SysStutas()
	{
		status = CHECKINFCONDITIONOFSENDORDER;
	}
};


/************************************************************************/
/* struct Define                                                      */
/************************************************************************/

/************************************************************************/
/* Function Define                                                      */
/************************************************************************/
void StartCounter();
double GetCounter();

int FindLowest(const double *dataarr, const int& end, const int& size);
int FindHighest(const double *dataarr, const int& end, const int& size);
void SortArray(double *array, const int& size);

void TimeTestStart();
void TimeTestEnd();

void ClearOutputDisplayBuffer(
	int *uptrendindexbuffer,
	int *downtrendindexbuffer,
	const int& size
	);


void CalculateWoodiePivotpoint(
	const double& open,
	const double& close,
	const double& high,
	const double& low,
	double *res,
	double *copyres
	);

void CalculateStandardPivotPoints(
	const double& open,
	const double& close,
	const double& high,
	const double& low,
	double *res,
	double *copyres
	);
void CalculateCamarillaPivotpoint(
	const double& open,
	const double& close,
	const double& high,
	const double& low,
	double *res,
	double *copyres
	);
double LineFamule(const double&slope, const int&x, const double& intercept);

/************************************************************************/
/* Function Define   end                                                             */
/************************************************************************/


/************************************************************************/
/* Function Declear                                                               */
/************************************************************************/
/************************************************************************/
/* Performance Test Functions                                                               */
/************************************************************************/
void StartCounter()
{
	LARGE_INTEGER li;
	if(!QueryPerformanceFrequency(&li))
		cout << "QueryPerformanceFrequency failed!\n";

	PCFreq = double(li.QuadPart)/1000.0;

	QueryPerformanceCounter(&li);
	CounterStart = li.QuadPart;
}
double GetCounter()
{
	LARGE_INTEGER li;
	QueryPerformanceCounter(&li);
	return double(li.QuadPart-CounterStart)/PCFreq;
}

void TimeTestStart()
{
	StartCounter();
}
void TimeTestEnd()
{
	double runtime = GetCounter();
	PCFreq = 0.0;
	CounterStart = 0;
	int len1 = swprintf(logbuf, 100, L"mt4 running time = %f \n", runtime );
	OutputDebugString(logbuf);
}


int FindLowest(const double *dataarr, const int& end, const int& size)
{
	int p;
	double t = 9999;
	for(int i = 0; i < size; i++)
	{
		int index = end + i;
		if(dataarr[index] < t)
		{
			p = index;
			t = dataarr[index];
		}
	}
	return p;
}



int FindHighest(const double *dataarr, const int& end, const int& size)
{
	int p;
	double t = 0;
	for(int i = 0; i< size; i++)
	{
		int index = end + i;
		if(dataarr[index] > t)
		{
			p = index;
			t = dataarr[index];
		}
	}
	return p;
}


void SortArray(double *array, const int& size)
{
	for (int i = 0; i < size - 1 ; i++)
	{
		int min = i;

		for(int j = i + 1; j < size; j++)
		{
			if(array[min] > array[j])
			{
				min = j;
			}
		}

		if(min != i)
		{
			swap(array[i], array[min]);
		}

	}
}







void ClearOutputDisplayBuffer(
	int *uptrendindexbuffer,
	int *downtrendindexbuffer,
	const int& size
	)
{
	memset(uptrendindexbuffer,0,size*sizeof(int));
	memset(downtrendindexbuffer,0,size*sizeof(int));
}

void ComposeSixArrayToOne(
	const double* arr1,
	const double* arr2,
	const double* arr3,
	const double* arr4,
	const double* arr5,
	const double* arr6,
	double* totalarr,
	const int& smallsize,
	const int& bigsize,
	const double& sp
	);
void ComposeSixArrayToOne(
	const double* arr1,
	const double* arr2,
	const double* arr3,
	const double* arr4,
	const double* arr5,
	const double* arr6,
	double* totalarr,
	const int& smallsize,
	const int& bigsize,
	const double& sp
	)
{
	for(int i = 0; i< smallsize; i++)
	{
		totalarr[i] = arr1[i];
		totalarr[i + smallsize] = arr2[i];
		totalarr[i + 2 * smallsize] = arr3[i];
		totalarr[i + 3 * smallsize] = arr4[i];
		totalarr[i + 4 * smallsize] = arr5[i];
		totalarr[i + 5 * smallsize] = arr6[i];
	}

	SortArray(totalarr, bigsize);

	for(int i = 0; i< bigsize; i++)
	{

		for(int j = i+1; j <  bigsize-1; j++)
		{
			if(abs(totalarr[j]-totalarr[i])<= sp * 2)
			{
				totalarr[j] = 999;

			}
			else
			{
				i = j;
			}
		}
	}

	SortArray(totalarr, bigsize);

}

/************************************************************************/
/* Calculate Pivot Points                                                */
/************************************************************************/

void CalculateStandardPivotPoints(
	const double& open,
	const double& close,
	const double& high,
	const double& low,
	double *res,
	double *copyres
	)
{
	double pp = (high + low + close)/3.0;
	double r1 = ( 2 * pp ) - low;
	double s1 = ( 2 * pp ) - high;

	double r2 = pp + (high - low);
	double s2 = pp - (high - low);

	double r3 = high + 2*(pp - low);
	double s3 = low - 2*(high - pp);

	res[0] = r3;
	res[1] = r2;
	res[2] = r1;
	res[3] = pp;
	res[4] = s1;
	res[5] = s2;
	res[6] = s3;

	memcpy(copyres, res, 7 * sizeof(double));
}

void CalculateWoodiePivotpoint(
	const double& open,
	const double& close,
	const double& high,
	const double& low,
	double *res,
	double *copyres
	)
{
	double pp = (high + low + 2 * close) / 4.0;

	double r2 = pp + high - low;

	double r1 = ( 2 * pp ) - low;

	double s1 = ( 2 * pp ) - high;

	double s2 = pp - high + low;


	res[0] = r2;
	res[1] = r1;
	res[2] = pp;
	res[3] = s1;
	res[4] = s2;

	memcpy(copyres, res, 5 * sizeof(double));
}


void CalculateCamarillaPivotpoint(
	const double& open,
	const double& close,
	const double& high,
	const double& low,
	double *res,
	double *copyres
	)
{
	double pp = (high + low + close)/3.0;

	double r4 = close + ((high - low) * 1.5000);
	double r3 = close + ((high - low) * 1.2500);
	double r2 = close + ((high - low) * 1.1666);
	double r1 = close + ((high - low) * 1.0833);

	double s1 = close - ((high - low) * 1.0833);
	double s2 = close - ((high - low) * 1.1666);
	double s3 = close - ((high - low) * 1.2500);
	double s4 = close - ((high - low) * 1.5000);

	res[0] = r4;
	res[1] = r3;
	res[2] = r2;
	res[3] = r1;
	res[4] = pp;
	res[5] = s1;
	res[6] = s2;
	res[7] = s3;
	res[8] = s4;

	memcpy(copyres, res, 9 * sizeof(double));

}


double LineFamule(const double&slope, const int&x, const double& intercept)
{
	return (double)( x * slope + intercept);
}

/************************************************************************/
/* calculate end                                                         */
/************************************************************************/

/************************************************************************/
/* Function Declear  end                                                             */
/************************************************************************/


/************************************************************************/
/* computing section array                                                    */
/************************************************************************/
int ProcessOneOLHC(//input
	const double *open,
	const double *close,
	//const double *high,
	//const double *low,
	const int& end,
	const int& windowsize,
	const int& trendarrindex,
	//res
	TrendSection *res_trendobjarray
	);

int ProcessOneOLHC(//input
	const double *open,
	const double *close,
	//const double *high,
	//const double *low,
	const int& end,
	const int& windowsize,
	const int& trendarrindex,
	//res
	TrendSection *res_trendobjarray
	)
{
	int uptrendstart = 0;
	int downtrendstart = 0;

	int uptrendend = 0;
	int downtrendend = 0;

	int n = 1;

	bool findupstart = false;
	bool finddownstart = false;

	int wsize = 0;



	while(true)
	{
		int localsize1 = n * windowsize;

		int localsize2 = (n + 1) * windowsize;


		int uptrendstartindex = FindLowest( open, end, localsize1);

		int downtrendstartindex = FindHighest( open, end, localsize1 );

		int uptrendstartindex2 = FindLowest( open, end, localsize2);

		int downtrendstartindex2 = FindHighest( open, end, localsize2 );

		if(uptrendstartindex2 ==  uptrendstartindex)
		{
			uptrendstart = uptrendstartindex;

			wsize = uptrendstart - end + 1;

			uptrendend = FindHighest( close, end, wsize );

			if(uptrendend < uptrendstart) 
			{

				findupstart = true;
				break;
			}

		}

		if(downtrendstartindex2 == downtrendstartindex)
		{
			downtrendstart = downtrendstartindex;

			wsize = downtrendstart - end + 1;

			downtrendend = FindLowest( close, end, wsize );

			if(downtrendend < downtrendstart) 
			{

				finddownstart = true;
				break;
			}

		}

		n++;

	}

	if(findupstart)
	{
		res_trendobjarray[trendarrindex].type = 1;

		res_trendobjarray[trendarrindex].start = uptrendstart;
		res_trendobjarray[trendarrindex].end = uptrendend;
		res_trendobjarray[trendarrindex].startvalue = open[uptrendstart];
		res_trendobjarray[trendarrindex].endvalue = close[uptrendend];

		res_trendobjarray[trendarrindex].start_open = open[uptrendstart];
		res_trendobjarray[trendarrindex].start_close = close[uptrendstart];
		//res_trendobjarray[trendarrindex].start_high = high[uptrendstart];
		//res_trendobjarray[trendarrindex].start_low = low[uptrendstart];

		res_trendobjarray[trendarrindex].end_open = open[uptrendend];
		res_trendobjarray[trendarrindex].end_close = close[uptrendend];
		//res_trendobjarray[trendarrindex].end_high = high[uptrendend];
		//res_trendobjarray[trendarrindex].end_low = low[uptrendend];

	}
	if(finddownstart)
	{

		//store in to the arr
		res_trendobjarray[trendarrindex].type = -1;
		res_trendobjarray[trendarrindex].start = downtrendstart;
		res_trendobjarray[trendarrindex].end = downtrendend;
		res_trendobjarray[trendarrindex].startvalue = open[downtrendstart];
		res_trendobjarray[trendarrindex].endvalue = close[downtrendend];

		res_trendobjarray[trendarrindex].start_open = open[downtrendstart];
		res_trendobjarray[trendarrindex].start_close = close[downtrendstart];
		//res_trendobjarray[trendarrindex].start_high = high[downtrendstart];
		//res_trendobjarray[trendarrindex].start_low = low[downtrendstart];

		res_trendobjarray[trendarrindex].end_open = open[downtrendend];
		res_trendobjarray[trendarrindex].end_close = close[downtrendend];
		//res_trendobjarray[trendarrindex].end_high = high[downtrendend];
		//res_trendobjarray[trendarrindex].end_low = low[downtrendend];

	}


	return(wsize);

}

void ProcessOLHCtoTrend(
	//input
	const double *open,
	const double *close,
	//const double *high,
	//const double *low,
	const int& numofsection,
	const int& windowsize,
	//res
	TrendSection *res_trendobjarray
	);
void ProcessOLHCtoTrend(
	//input
	const double *open,
	const double *close,
	//const double *high,
	//const double *low,
	const int& numofsection,
	const int& windowsize,
	//res
	TrendSection *res_trendobjarray
	)
{
	//initialize paramaters

	int baseend = 0;

	for (int i = 0; i< numofsection; i++)
	{

		int psize = ProcessOneOLHC(open,close,baseend, windowsize, i,res_trendobjarray);

		baseend = baseend + psize;
	}

}






/************************************************************************/
/* compose the trend line result to output                               */
/************************************************************************/
void GenerateTrendLineOutput(
	int *output_uptrendindexbuffer,
	int *output_downtrendindexbuffer,
	//for other
	int *output_backparemeters,
	const TrendSection *res_trendobjarray,
	const int& size
	);
void GenerateTrendLineOutput(
	int *output_uptrendindexbuffer,
	int *output_downtrendindexbuffer,
	//for other
	int *output_backparemeters,
	const TrendSection *res_trendobjarray,
	const int& size
	)
{
	int numofuptrend = 0;
	int numofdowntrend = 0;
	int uptrendindex = 0;
	int downtrendindex = 0;
	for (int i = 0; i< size; i++)
	{
		if(res_trendobjarray[i].type == 1)
		{
			numofuptrend++;

			output_uptrendindexbuffer[uptrendindex] = res_trendobjarray[i].end;
			uptrendindex++;
			output_uptrendindexbuffer[uptrendindex] = res_trendobjarray[i].start;
			uptrendindex++;
		}
		if(res_trendobjarray[i].type == -1)
		{
			numofdowntrend++;

			output_downtrendindexbuffer[downtrendindex] = res_trendobjarray[i].end;
			downtrendindex++;
			output_downtrendindexbuffer[downtrendindex] = res_trendobjarray[i].start;
			downtrendindex++;
		}
	}

	output_backparemeters[0] = numofuptrend;
	output_backparemeters[1] = numofdowntrend;
}
/************************************************************************/
/* compose end                                                          */
/************************************************************************/



/************************************************************************/
/* computing section array end                                                          */
/************************************************************************/


void FilterTrendToGenerateSRLevelForOnePeriod(const TrendSection *res_trendobjarray, const int& objnum, const double& cap, double *srarray);
void FilterTrendToGenerateSRLevelForOnePeriod(const TrendSection *res_trendobjarray, const int& objnum, const double& cap, double *srarray)
{

	double currentup_startvalue = 0;
	double priviousup_startvalue = 0;
	int priviousup_startposition = 0;

	double currentdown_startvalue = 0;
	double priviousdown_startvalue = 0;
	int priviousdown_startposition = 0;

	for (int i = 0; i< objnum; i++)
	{

		//uptrend
		if(res_trendobjarray[i].type>0)
		{
			currentup_startvalue = res_trendobjarray[i].startvalue;

			if(priviousup_startvalue != 0)
			{
				double up_dis = abs(currentup_startvalue - priviousup_startvalue);

				if(up_dis <= cap)
				{
					//may to merge
					if(currentup_startvalue <= priviousup_startvalue)
					{
						//change
						srarray[priviousup_startposition] = 999;//currentup_startvalue;
					}
					else
					{
						currentup_startvalue = priviousup_startvalue;
						srarray[priviousup_startposition] = 999;
					}
				}

			}

			priviousup_startvalue = currentup_startvalue;
			priviousup_startposition = i;
			srarray[i] = currentup_startvalue;

		}
		//down trend
		if(res_trendobjarray[i].type<0)
		{
			currentdown_startvalue = res_trendobjarray[i].startvalue;

			if(priviousdown_startvalue != 0)
			{
				double down_dis = abs(currentdown_startvalue - priviousdown_startvalue);
				if(down_dis <= cap)
				{
					if(currentdown_startvalue >= priviousdown_startvalue)
					{
						srarray[priviousdown_startposition] = 999;//currentdown_startvalue;
					}
					else
					{

						currentdown_startvalue = priviousdown_startvalue;
						srarray[priviousdown_startposition] = 999;
					}
				}
			}

			priviousdown_startvalue = currentdown_startvalue;
			priviousdown_startposition = i;
			srarray[i] = currentdown_startvalue;

		}

	}

}



//new function
int CalculateSlopeAbs(const double& abs_slope_supportlinem, const double& abs_slope_resistantline);
int CalculateSlopeAbs(const double& abs_slope_supportlinem, const double& abs_slope_resistantline)
{
	if(abs(abs_slope_supportlinem) > abs(abs_slope_resistantline))
		return -1;
	else
		return 1;
}

int CalculatePowerOfLongAndShort(const int& trendtype_now, const double& slope_supportline, const double& slope_resistantline);
int CalculatePowerOfLongAndShort(
	const int& trendtype_now, 
	const double& slope_supportline, 
	const double& slope_resistantline
	)
{
	int res = 0;

	switch(trendtype_now)
	{
		case 1: res = 1;
		break;

		case -1: res = -1;
		break;

		case -10: res = CalculateSlopeAbs(slope_supportline, slope_resistantline);
		break;

		case 10: res = CalculateSlopeAbs(slope_supportline, slope_resistantline);
		break;
	}

	return res;
}

int JudgeAcroess(const double& slope_supportline, const double& slope_resistantline);
int JudgeAcroess(const double& slope_supportline, const double& slope_resistantline)
{
	
	if(slope_supportline > 0  && slope_resistantline > 0 && slope_supportline < slope_resistantline)
	{
		return 0;
	}

	if(slope_supportline > 0  && slope_resistantline > 0 && slope_supportline > slope_resistantline)
	{
		return 1;
	}

	if(slope_supportline > 0  && slope_resistantline > 0 && slope_supportline == slope_resistantline)
	{
		return 10;
	}


	if(slope_supportline > 0  && slope_resistantline < 0)
	{
		return 1;
	}

	if(slope_supportline < 0  && slope_resistantline < 0 && slope_supportline > slope_resistantline)
	{
		return 1;
	}

	if(slope_supportline < 0  && slope_resistantline < 0 && slope_supportline < slope_resistantline)
	{
		return 0;
	}


	if(slope_supportline < 0  && slope_resistantline < 0 && slope_supportline == slope_resistantline)
	{
		return -10;
	}

}

int CalculateDirectionOfBreakout(const int& biggerpower, const int& acroess);
int CalculateDirectionOfBreakout(const int& biggerpower, const int& acroess)
{
	int res = 0;

	if(acroess == 1)
	{




	}




	return res;


}


bool CheckPriceInRange(const double& price, const double& value_resistantline, const double& value_supportline);
bool CheckPriceInRange(const double& price, const double& value_resistantline, const double& value_supportline)
{

}

bool CheckSectionSourceisMainPower(
	const int& trendtype_lastsection,
	const int& trendtype_now,
	const double& slope_supportline,
	const double& slope_resistantline
	);

bool CheckSectionSourceisMainPower(
	const int& trendtype_lastsection,
	const int& trendtype_now,
	const double& slope_supportline,
	const double& slope_resistantline
	)
{
	bool res = false;

	if( trendtype_lastsection == -1 && trendtype_now == -1)
		return true;

	if( trendtype_lastsection == 1 && trendtype_now == 1 )
		return true;

	if( trendtype_now == 10 )
	{
		if( trendtype_lastsection == 1 && abs(slope_supportline) < abs(slope_resistantline) )
			return true;

		if( trendtype_lastsection == -1 && abs(slope_supportline) > abs(slope_resistantline) )
			return true;
	}


	if(  trendtype_now == -10 )
	{
		if( trendtype_lastsection == 1 && abs(slope_supportline) < abs(slope_resistantline) )
			return true;

		if( trendtype_lastsection == -1 && abs(slope_supportline) > abs(slope_resistantline) )
			return true;
	}


	return res;
}



//////////////////////////////////////////////////////////////
#define PRICECAPITICAL_D1 0.002
#define PRICECAPITICAL_H4 0.002
#define PRICECAPITICAL_H1 0.0004

double marketinfo_spread = 0;
double PRICECAPITICAL_M = 0;
double minidistance = 0;
//////////////////////////////////////////////////////////////
