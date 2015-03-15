#include "stdafx.h"
#include <iostream>
#include <windows.h>
#include <ctype.h>
#include <math.h>
#include <omp.h>

using namespace std;
//log buffer
wchar_t logbuf[100];

double PCFreq = 0.0;
__int64 CounterStart = 0;

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
	double start_high;
	double start_low;
	//end bar
	double end_open;
	double end_close;
	double end_high;
	double end_low;

	void reset()
	{
		type = 0;
		start = 0;
		end = 0;

		startvalue = 0;
		endvalue = 0;

		start_open = 0;
		start_close = 0;
		start_high = 0;
		start_low = 0;

		end_open = 0;
		end_close = 0;
		end_high = 0;
		end_low = 0;

	}

};

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




void TimeTestStart();
void TimeTestEnd();

void TimeTestStart()
{
	StartCounter();
}
void TimeTestEnd()
{
	double runtime = GetCounter();
	PCFreq = 0.0;
	CounterStart = 0;
	int len1 = swprintf(logbuf, 100, L"running time = %f \n", runtime );
	OutputDebugString(logbuf);
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




int ProcessOneOLHC(//input
	const double *open,
	const double *close,
	const double *high,
	const double *low,
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
		res_trendobjarray[trendarrindex].start_high = high[uptrendstart];
		res_trendobjarray[trendarrindex].start_low = low[uptrendstart];

		res_trendobjarray[trendarrindex].end_open = open[uptrendend];
		res_trendobjarray[trendarrindex].end_close = close[uptrendend];
		res_trendobjarray[trendarrindex].end_high = high[uptrendend];
		res_trendobjarray[trendarrindex].end_low = low[uptrendend];

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
		res_trendobjarray[trendarrindex].start_high = high[downtrendstart];
		res_trendobjarray[trendarrindex].start_low = low[downtrendstart];

		res_trendobjarray[trendarrindex].end_open = open[downtrendend];
		res_trendobjarray[trendarrindex].end_close = close[downtrendend];
		res_trendobjarray[trendarrindex].end_high = high[downtrendend];
		res_trendobjarray[trendarrindex].end_low = low[downtrendend];

	}


	return(wsize);

}

void ProcessOLHCtoTrend(
	//input
	const double *open,
	const double *close,
	const double *high,
	const double *low,
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

		int psize = ProcessOneOLHC(open,close,high,low,baseend, windowsize, i,res_trendobjarray);

		baseend = baseend + psize;
	}


}

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

void SortAndDeleteRepeatElementInArray(double *array, const int& size)
{
	SortArray(array, size);

	int j = 0;
	for(int i = 0; i < size -1; i++)
	{
		while(array[i] == array[i+1])
		{
			i++;
		}
		array[j++] = array[i];

	}

}

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

void ComposeSixArrayToOne(
	const double* arr1,
	const double* arr2,
	const double* arr3,
	const double* arr4,
	const double* arr5,
	const double* arr6,
	double* totalarr,
	const int& smallsize,
	const int& bigsize
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

	// 	for(int i = 0; i < bigsize; i++)
	// 	{
	// 	 
	// 	 	int len2 = swprintf(logbuf, 100, L"v %d = %f\n", i, totalarr[i]);
	// 	 	OutputDebugString(logbuf);
	// 	 
	// 	}

}

void ProcessTrendResultToGenerateStrategy(
	const TrendSection *trendobjarray_D1,
	const TrendSection *trendobjarray_H4,
	const TrendSection *trendobjarray_H1,
	const TrendSection *trendobjarray_M15,
	const TrendSection *trendobjarray_M5,
	const TrendSection *trendobjarray_m1
	)
{
	//D1 to generate a whole strategy
	int endoftrend_d1 = trendobjarray_D1[0].end;
	int currenttrendtype_d1 = 0;
	if(endoftrend_d1 == 0)
	{
		//current status in the last trend
		currenttrendtype_d1 = trendobjarray_D1[0].type;
	}
	else
	{
		//current status is not in the trend
		int lasttrendtype_d1 = trendobjarray_D1[0].type;
		currenttrendtype_d1 = (lasttrendtype_d1>0? -1:1);

	}


}



