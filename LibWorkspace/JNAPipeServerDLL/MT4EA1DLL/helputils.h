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




/************************************************************************/
/* Function Define                                                                */
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
	int len1 = swprintf(logbuf, 100, L"running time = %f \n", runtime );
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