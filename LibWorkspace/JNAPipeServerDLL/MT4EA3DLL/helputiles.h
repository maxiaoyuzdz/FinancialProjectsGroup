
#include "stdafx.h"
#include <iostream>
#include <windows.h>
#include <ctype.h>
#include <math.h>

using namespace std;
//log buffer
wchar_t logbuf[200];

double PCFreq = 0.0;
__int64 CounterStart = 0;

/************************************************************************/
/* Function Define                                                      */
/************************************************************************/
void StartCounter();
double GetCounter();

void TimeTestStart();
void TimeTestEnd();

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
