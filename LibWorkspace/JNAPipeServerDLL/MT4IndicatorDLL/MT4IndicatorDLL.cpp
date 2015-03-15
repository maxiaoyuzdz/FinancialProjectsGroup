// MT4IndicatorDLL.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include <iostream>
#include <windows.h>
#include <ctype.h>
#include <math.h>
using namespace std;
wchar_t logbuf[100];

bool IsUpBar( const double *open, const double *close, const int& pos)
{
	return (close[pos] > open[pos]);
}

bool IsDownBar(const double *open, const double *close, const int& pos)
{
	return (close[pos] < open[pos]);
}


int FindHighestUpBar(const double *open, const double *close,const int& end, const int& size)
{
	int highupbarindex = -1;
	int startp = end + size;
	double tempclose = 0;

	for(int i = end; i < startp; i++)
	{
		if(IsUpBar(open,close, i))
		{
			if(close[i] > tempclose)
			{
				tempclose = close[i];

				highupbarindex = i;

			}
		}
	}


	return highupbarindex;
}

int FindLowestUpBar(const double *open, const double *close,const int& end, const int& size)
{
	int lowestupbarindex = -1;
	int startp = end + size;

	double tempopen = 999;

	for (int i = end; i< startp; i++)
	{
		if(IsUpBar(open,close,i))
		{
			if(open[i] < tempopen)
			{
				tempopen = open[i];
				lowestupbarindex = i;
			}

		}
	}

	return lowestupbarindex;
}

int FindHighestDownBar(const double *open, const double *close,const int& end, const int& size)
{
	int highestdownbarindex = -1;

	int startp = end + size;

	double tempopen = 0;

	for (int i = end; i< startp; i++)
	{
		if(IsDownBar(open,close,i))
		{
			if(open[i] > tempopen)
			{
				tempopen = open[i];
				highestdownbarindex = i;

			}
		}
	}

	return highestdownbarindex;

}

int FindLowestDownBar(const double *open, const double *close,const int& end, const int& size)
{
	int lowestbarindex = -1;

	int startp = end + size;

	double temoclose = 9999;

	for (int i = end; i< startp; i++)
	{
		if(IsDownBar(open,close,i))
		{
			if(close[i] < temoclose)
			{
				temoclose = close[i];
				lowestbarindex = i;

			}
		}

	}

	return lowestbarindex;

}

double MathTrendInterpolation(const int& startindex, const int& endindex , const double& startnum, const double& endnum, const int& index, const int& trendtype)
{
	int length = abs( startindex - endindex );
	double valdistance = abs( endnum - startnum );
	double averagedistance = valdistance / length;

	if(index == startindex) return(startnum);

	if(index == endindex) return(endnum);

	double res = 0;

	if(trendtype > 0)
	{
		//up trend
		res = endnum - (index - endindex)* averagedistance;
	}
	else
	{

		res = endnum + (index - endindex)* averagedistance;

	}

	return(res);

}

void DisplayUpTrend(const int& start, const int& end, const double& startprice, const double& endprice, double *resuptrendarr)
{
	for(int i = end; i <= start; i++)
	{
		resuptrendarr[i] = MathTrendInterpolation(start,end, startprice, endprice, i, 1); 
	}

}

void DisplayDownTrend(const int& start, const int& end, const double& startprice, const double& endprice, double *resdowntrendarr)
{
	for(int i = end; i <= start; i++)
	{
		resdowntrendarr[i] = MathTrendInterpolation(start,end, startprice, endprice, i, -1);
	}
}

//////////////////////////////////////////////////////////////////////////
///				analyze one section start in a fixed size			//////
//////////////////////////////////////////////////////////////////////////
int FindTrend(const double *open, const double *close,const int& endindex, const int& windowsize, const int& blanksize, double *resuptrendarr, double *resdowntrendarr)
{
	//return 0;
	//judge for one section is analyze finished
	bool finish = false;

	//save previous section end position
	int pp = 1;
	//save this section end position
	int p = 1;

	//save trend start and end position in this section
	int trendstartpos = -1;
	int trendendpos = -1;

	//mark trend type for this section
	int CurrentTrend = 0;

	bool haveuptrend = false;
	bool havedowntrend = false;

	int np = blanksize / windowsize;

	while(!finish)
	{
		//get data range for this computing
		int localsize = 0;

		if(p >= np)
		{
			localsize = blanksize;

			finish = true;
		}
		else
		{
			localsize = p * windowsize;

		}

// 		if(localsize > blanksize)
// 		{
// 			break;
// 		}

		//judge up bar used for up trend 
		int highestupbarindex = FindHighestUpBar(open, close, endindex, localsize);
		int lowestupbarindex = FindLowestUpBar(open, close, endindex, localsize);
		//down bar used for down trend
		int highestdownbarindex = FindHighestDownBar(open, close, endindex, localsize);
		int lowestdownbarindex = FindLowestDownBar(open, close, endindex, localsize);

		//up trend
		if(lowestupbarindex > highestupbarindex)
		{
			//up 
			haveuptrend = true;
		}

		//down trend
		if(highestdownbarindex > lowestdownbarindex)
		{
			//down
			havedowntrend = true;
		}

		//special situation
		if(havedowntrend && haveuptrend)
		{
			//find have both up and down trend, do not know which one is the main trend
			//save range
			pp = p;
			//reset a larger range
			p++;
			//once find this section having both up trend and down trend
			//jump to a larger windowsize
			havedowntrend = false;
			haveuptrend = false;
			//jump to next loop
			continue;

		}

		if(havedowntrend && (!haveuptrend)) 
		{

			//have a down trend  start = highestdownbarindex end = lowestdownbarindex

			if( highestdownbarindex > trendstartpos )
			{
				//a new section
				//save trend start and end and range
				trendstartpos = highestdownbarindex;
				trendendpos = lowestdownbarindex;
				pp = p;
				//expand to a larger range
				p++;
				//reset
				havedowntrend = false;
				haveuptrend = false;

				continue;

			}else{
				//same res, do not need to plug p, back to pp
				//make sure this is a down trend
				CurrentTrend = -1;
				//back to previous trend
				p = pp;
				//end loop
				finish = true;
				//do not do next work
				break;
			}



		}

		if( haveuptrend && (!havedowntrend))
		{

			//find a up trend  start = lowestupbarindex end = highestupbarindex
			if(lowestupbarindex > trendstartpos)
			{
				//find a new start
				//save range
				trendstartpos = lowestupbarindex;
				trendendpos = highestupbarindex;
				pp = p;
				//reset a larger range
				p++;

				haveuptrend = false;
				havedowntrend = false;

				continue;

			}else{
				//make sure this is up trend
				CurrentTrend = 1;


				p = pp;
				finish = true;

				break;
			}

		}






	}
	//end while loop
	if(CurrentTrend > 0)
	{
		//Print( "display up" );
		DisplayUpTrend(trendstartpos, trendendpos, close[trendstartpos], close[trendendpos], resuptrendarr);

	}
	if(CurrentTrend < 0)
	{
		//Print( "display down" );
		DisplayDownTrend(trendstartpos, trendendpos, close[trendstartpos], close[trendendpos],resdowntrendarr);

	}
	//no found
	if(CurrentTrend == 0)
		return blanksize;
	//found a trend
	int computedsize = trendstartpos - endindex + 1;
	return(computedsize);
}

int FindTrendsInFiexRange(const double *open, const double *close,const int& start, const int& end, const int& blanksize, const int& windowsize, double *resuptrendarr, double *resdowntrendarr)
{

	//blanksize must > windowsize
	
	//int len = swprintf(logbuf, 100, L"fixedsize = %d\n inisize = %d\n", fixedsize, inisize);
	//OutputDebugString(logbuf);

	int numofprocessedbars = 0;
	bool allprocessed = false;
	int baseend = end;

	int leftblanksize = blanksize;//total blank in this section

	while(!allprocessed)
	{
		//psize = the section from end to end+psize-1 including a obvious trend
		int psize = FindTrend(open, close, end, windowsize, leftblanksize, resuptrendarr, resdowntrendarr);

		numofprocessedbars = numofprocessedbars + psize;

		leftblanksize = blanksize - psize;//psize is not more than blanksize

		baseend = baseend + psize;

		if(leftblanksize <=0 || leftblanksize < windowsize || baseend>= start)
		{
			allprocessed = true;
			break;
		}

	}
	//int len = swprintf(logbuf, 100, L"process = %d\n ", numofprocessedbars);
	//OutputDebugString(logbuf);
	return numofprocessedbars;
}


//////////////////////////////////////////////////////////////////////////
///				analyze one section end in a fixed size				//////
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
///				analyze one section start							//////
//////////////////////////////////////////////////////////////////////////

//find one trend in one time
int FindAllTrend(const double *open, const double *close,const int& endindex, const int& inisize, double *resuptrendarr, double *resdowntrendarr)
{


	//judge for one section is analyze finished
	bool finish = false;

	//save previous section end position
	int pp = 1;
	//save this section end position
	int p = 1;

	//save trend start and end position in this section
	int trendstartpos = -1;
	int trendendpos = -1;

	//mark trend type for this section
	int CurrentTrend = 0;


	bool haveuptrend = false;
	bool havedowntrend = false;


	while(!finish)
	{
		//get data range for this computing
		int localsize = p * inisize;

		//judge up bar used for up trend 
		int highestupbarindex = FindHighestUpBar(open, close, endindex, localsize);
		int lowestupbarindex = FindLowestUpBar(open, close, endindex, localsize);
		//down bar used for down trend
		int highestdownbarindex = FindHighestDownBar(open, close, endindex, localsize);
		int lowestdownbarindex = FindLowestDownBar(open, close, endindex, localsize);


		//up trend
		if(lowestupbarindex > highestupbarindex)
		{
			//up 
			haveuptrend = true;
		}

		//down trend
		if(highestdownbarindex > lowestdownbarindex)
		{
			//down
			havedowntrend = true;
		}

		//special situation
		if(havedowntrend && haveuptrend)
		{
			//find have both up and down trend, do not know which one is the main trend
			//save range
			pp = p;
			//reset a larger range
			p++;
			//once find this section having both up trend and down trend
			//jump to a larger windowsize
			havedowntrend = false;
			haveuptrend = false;
			//jump to next loop
			continue;

		}
		if(havedowntrend && (!haveuptrend)) 
		{

			//have a down trend  start = highestdownbarindex end = lowestdownbarindex

			if( highestdownbarindex > trendstartpos )
			{
				//a new section
				//save trend start and end and range
				trendstartpos = highestdownbarindex;
				trendendpos = lowestdownbarindex;
				pp = p;
				//expand to a larger range
				p++;
				//reset
				havedowntrend = false;
				haveuptrend = false;

				continue;

			}else{
				//same res, do not need to plug p, back to pp
				//make sure this is a down trend
				CurrentTrend = -1;
				//back to previous trend
				p = pp;
				//end loop
				finish = true;
				//do not do next work
				break;
			}



		}

		if( haveuptrend && (!havedowntrend))
		{

			//find a up trend  start = lowestupbarindex end = highestupbarindex
			if(lowestupbarindex > trendstartpos)
			{
				//find a new start
				//save range
				trendstartpos = lowestupbarindex;
				trendendpos = highestupbarindex;
				pp = p;
				//reset a larger range
				p++;

				haveuptrend = false;
				havedowntrend = false;

				continue;

			}else{
				//make sure this is up trend
				CurrentTrend = 1;


				p = pp;
				finish = true;

				break;
			}

		}




	}
	//end while loop

	if(CurrentTrend > 0)
	{
		//Print( "display up" );
		DisplayUpTrend(trendstartpos, trendendpos, close[trendstartpos], close[trendendpos], resuptrendarr);

	}
	if(CurrentTrend < 0)
	{
		//Print( "display down" );
		DisplayDownTrend(trendstartpos, trendendpos, close[trendstartpos], close[trendendpos],resdowntrendarr);

	}

	//loop end
	int computedsize = trendstartpos - endindex + 1;
	return(computedsize);

}
//////////////////////////////////////////////////////////////////////////
///				analyze one section end								//////
//////////////////////////////////////////////////////////////////////////


int ComputingTrend(const double *openarr, const double *closearr, const double *emafastarr, const double *emaslowarr, const int totalbars, const int windowsize, double *resuptrendarr, double *resdowntrendarr, double *unknowntrendarr, int *specialparametersarr)
{
	
	int numofprocessedbars = 0;
	bool allprocessed = false;
	//calculation from bar 0 
	int baseend = 0;
	//////////////////////////////////////////////////////////////////////////
	///				main process start										//////
	//////////////////////////////////////////////////////////////////////////
	while(!allprocessed)
	{
		
		int psize = FindAllTrend(openarr, closearr, baseend, windowsize, resuptrendarr, resdowntrendarr);

		numofprocessedbars = numofprocessedbars + psize;
		
		baseend = baseend + psize;

		if(numofprocessedbars >= totalbars)
		{
			allprocessed = true;
			break;
		}

	}
	//////////////////////////////////////////////////////////////////////////
	///				main process  end									//////
	//////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////
	///				blank process start							//////
	//////////////////////////////////////////////////////////////////////////

	/**

	int smallwindowsize  = windowsize/2;
	//scan twice
	int scantimes = 4;
	for (int i = 0; i<scantimes;i++)
	{
		int blankend = 0;
		int blandstart = 0;
		bool hasblankend = false;
		bool hasblankstart = false;

		int numofloop = i;


		for (int i = 0; i< numofprocessedbars; i++)
		{
			if( resuptrendarr[i] == 0 && resdowntrendarr[i]== 0)
			{
				if(!hasblankend)
				{
					blankend = i;
					hasblankend = true;
					continue;
				}

				if(!hasblankstart)
				{
					blandstart = i;
					continue;
				}

			}


			if(resuptrendarr[i]>0 || resdowntrendarr[i]>0)
			{
				hasblankstart = true;
				//do some computing
				//prepare blank
				if(hasblankstart && hasblankend && blandstart > blankend)
				{
					//find a blank size
					int blanksize = blandstart - blankend + 1;

					//int len = swprintf(logbuf, 100, L"loop = %d ,start = %d end = %d size = %d\n",numofloop, blandstart, blankend,blanksize);
					//OutputDebugString(logbuf);

					if(blanksize >= smallwindowsize)
					{
						int fixedres = FindTrendsInFiexRange(openarr,closearr,blandstart, blankend, blanksize, smallwindowsize, resuptrendarr, resdowntrendarr);
					}


				}
					//computing end
					//reset parameters
				hasblankend = false;
				hasblankstart = false;
				blankend = i;
				blandstart = i;

			}

		}

	}

	*/

	//////////////////////////////////////////////////////////////////////////
	///				blank process end									//////
	//////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////
	///				order process start									//////
	//////////////////////////////////////////////////////////////////////////


	//////////////////////////////////////////////////////////////////////////
	///				first step : make sure a trading solution			//////
	//////////////////////////////////////////////////////////////////////////

	/************************************************************************/
	/* recognize trend                                                                     */
	/************************************************************************/
	/**
	//1 find the most closest trend from bar0
	int mostclosesttrendtype = 0;

	for (int i = 0; i < numofprocessedbars; i++)
	{
		unknowntrendarr[i] = closearr[i]+ 0.0100;
	}

	int len = swprintf(logbuf, 100, L"price = %f\n", unknowntrendarr[5]);
	OutputDebugString(logbuf);
	*/
	/************************************************************************/
	/* wait a back position                                                                     */
	/************************************************************************/


	/************************************************************************/
	/* wait a back model                                                                     */
	/************************************************************************/
	//////////////////////////////////////////////////////////////////////////
	///				second step : process the trading					//////
	//////////////////////////////////////////////////////////////////////////


	//////////////////////////////////////////////////////////////////////////
	///				order process end									//////
	//////////////////////////////////////////////////////////////////////////
	
	

	

	return numofprocessedbars;
}





