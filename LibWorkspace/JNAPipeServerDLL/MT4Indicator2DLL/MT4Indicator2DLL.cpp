// MT4Indicator2DLL.cpp : Defines the exported functions for the DLL application.
//



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


double iMA(const double& preemavalue, const double& currentclosevalue, const int& period)
{
	double pr = 2.0 / (period + 1.0);

	double currentimavalue = currentclosevalue * pr + preemavalue * ( 1.0 - pr );

	return currentimavalue;

}



//////////////////////////////////////////////////////////////
#define EMABUFFERSIZE 8
// double ema_h4_8_buffer[EMABUFFERSIZE];
// double ema_h4_30_buffer[EMABUFFERSIZE];

//////////////////////////////////////////////////////////////


#define DATABUFSIZE 2000
#define NUMOFTRENDINBUFFER 128  //256 trend
#define NUMOFLINES 128		//but only 128 lins to use

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////


int biguptrendindex = 0;
int bigdowntrendindex = 0;

int numofbiguptrend = 0;
int numofbigdowntrend = 0;



int smalluptrendindex = 0;
int smalldowntrendindex = 0;

int numofsmalluptrend = 0;
int numofsmalldowntrend = 0;
//////////////////////////////////////////////////////////////


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

//////////////////////////////////////////////////////////////



int FindOneTrendByBigSize(
	const double *open, 
	const double *close,
	const int& end, 
	const int& windowsize,
	int *biguptrendindexbuffer,
	int *bigdowntrendindexbuffer
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


		biguptrendindexbuffer[biguptrendindex] = uptrendend;
		biguptrendindex++;
		biguptrendindexbuffer[biguptrendindex] = uptrendstart;
		biguptrendindex++;

		numofbiguptrend++;

	}

	if(finddownstart)
	{


		bigdowntrendindexbuffer[bigdowntrendindex] = downtrendend;
		bigdowntrendindex++;
		bigdowntrendindexbuffer[bigdowntrendindex] = downtrendstart;
		bigdowntrendindex++;

		numofbigdowntrend++;

	}



	return(wsize);


}


void ClearComputingBuffer(
	int *biguptrendindexbuffer,
	int *bigdowntrendindexbuffer
	)
{
	memset(biguptrendindexbuffer,0,NUMOFTRENDINBUFFER*sizeof(int));
	memset(bigdowntrendindexbuffer,0,NUMOFTRENDINBUFFER*sizeof(int));

	biguptrendindex = 0;
	bigdowntrendindex = 0;

	numofbiguptrend = 0;
	numofbigdowntrend = 0;

}

int AnalyzeTrend(
	//trend parameters
	const int recnumoflargetrend,
	const int windowsize,
	const double *openarr,
	const double *closearr,
	const double *higharr,
	const double *lowarr,
	//trend result
	int *biguptrendindexbuffer,
	int *bigdowntrendindexbuffer,
	int *backparemeters
	)

{
	//clear buffer
	ClearComputingBuffer(
		biguptrendindexbuffer,
		bigdowntrendindexbuffer
		);



	int bigbaseend = 0; 
	for (int i = 0; i< recnumoflargetrend; i++)
	{
		int psize = FindOneTrendByBigSize(openarr, closearr, bigbaseend, windowsize, biguptrendindexbuffer, bigdowntrendindexbuffer);

		bigbaseend = bigbaseend + psize;
	}




	backparemeters[0] = numofbiguptrend;
	backparemeters[1] = numofbigdowntrend;




	return 0;
}