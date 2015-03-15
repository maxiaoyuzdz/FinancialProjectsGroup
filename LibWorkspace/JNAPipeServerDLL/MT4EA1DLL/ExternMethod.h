#include "helputils.h"



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

};

struct TrendStatus{
	int trendtype_now;
	int trendtype_pre;
	int trendtype_pre_pre;
	double slope_supportline;
	double slope_resistantline;

	int trendtype_lastsection;
	int end_lastsection;
	double endvalue_lastsection;

	int type_zerobar;
	double open_zerobar;
	double close_zerobar;


	double value_on_supportline_end_lastsection;
	double value_on_resistantline_end_lastsection;

	double value_on_supportline_pos_zero;
	double value_on_resistanctline_pos_zero;

};
/************************************************************************/
/* used for state machine                                                */
/************************************************************************/

#define WAITINGWITHOUTORDER 0
#define WAITINGWITHORDER 1

struct WorkingStatus
{
	int status;

	WorkingStatus()
	{
		status = WAITINGWITHOUTORDER;
	}
};



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
/* compose end                                                                     */
/************************************************************************/


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
	);

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
	);
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




/************************************************************************/
/* process analyze                                                                */
/************************************************************************/
void FindFourValidSections(
	const TrendSection *sectionarray,
	const int& sectionendnum,
	int *orderresultarr
	);
void FindFourValidSections(
	const TrendSection *sectionarray,
	const int& sectionendnum,
	int *orderresultarr
	)
{
	
	int type_end_trend = sectionarray[sectionendnum].type;

	orderresultarr[0] = sectionendnum;

	int positite_type_trend = type_end_trend * -1;
	
	int counter = 1;

	for(int i = (sectionendnum + 1) ; i< 20 ; i++)
	{
		if(sectionarray[i].type == positite_type_trend)
		{
			orderresultarr[counter] = i;

			positite_type_trend = positite_type_trend * -1;

			counter++;
		}
		//res size = 4
		if(counter > 3 ) break; // because size = 4

	}

}


int CalculateSectionTrend(const TrendSection* trend, int *orderlist);
int CalculateSectionTrend(const TrendSection* trend, int *orderlist)
{
	//size = 4

	int i0 = orderlist[0];
	int i2 = orderlist[2];
	
	int i1 = orderlist[1];
	int i3 = orderlist[3];

	int endtype = trend[i0].type;

	//start value
	double s0 = trend[i0].startvalue;
	double s2 = trend[i2].startvalue;
	
	double s1 = trend[i1].startvalue;
	double s3 = trend[i3].startvalue;
	//end value
	double e0 = trend[i0].endvalue;
	double e2 = trend[i2].endvalue;
	
	double e1 = trend[i1].endvalue;
	double e3 = trend[i3].endvalue;

	bool resistantlinevalid = false;
	bool supportlinevalid = false;

	//is down
	if(endtype == -1)
	{

		if(s0 < s2)
		{
			resistantlinevalid = true;
		}

		if(s1 >= s3)
		{
			supportlinevalid = true;
		}

	}


	//is up
	if(endtype == 1)
	{
		if(s0 > s2)
		{
			supportlinevalid = true;
		}

		if(s1 <= s3)
		{
			resistantlinevalid = true;
		}
	}

	//calculate lines
	if(supportlinevalid && !resistantlinevalid)
	{
		// '/'
		//only has support line
		return 1;
	}
	
	if(resistantlinevalid && !supportlinevalid)
	{
		// '\'
		//only has resistant line
		return -1;
	}
	
	if( !supportlinevalid && !resistantlinevalid)
	{
		//   '/'
		//   '\'
		//both support and resistant line are all invalid
		return 10;
	}
	
	if(supportlinevalid && resistantlinevalid)
	{
		//   '\'
		//   '/'
		//both support and resistant line are all valid
		//cross happen or will happen
		return -10;
	}


	return 0;
}







double CalculateInterceptOnSupportLine(
	const TrendSection *sectionarray_w4, 
	const int* orderlist_w4,
	const double& slope
	);
double CalculateInterceptOnSupportLine(
	const TrendSection *sectionarray_w4, 
	const int* orderlist_w4,
	const double& slope
	)
{
	double y1 = 0;
	double x1 = 0;
	double intercept = 0;
	
	int pos_s1 = 0;
	int pos_end = 0;
	int type_end = 0;

	//use w4
	pos_end = orderlist_w4[0];
	type_end = sectionarray_w4[pos_end].type;

	if(type_end == 1)
	{
		//end is a uptrend
		pos_s1 = orderlist_w4[2];		
	}
	else
	{
		//end is a down trend
		pos_s1 = orderlist_w4[3];
	}

	x1 = sectionarray_w4[pos_s1].start * -1;	
	y1 = sectionarray_w4[pos_s1].startvalue;

	intercept = y1 - slope * x1;

	return intercept;
	
}


double CalculateInterceptOnResistantLine(
	const TrendSection *sectionarray_w4, 
	const int* orderlist_w4,
	const double& slope
	);
double CalculateInterceptOnResistantLine(
	const TrendSection *sectionarray_w4, 
	const int* orderlist_w4,
	const double& slope
	)
{
	double y1 = 0;
	double x1 = 0;
	double intercept = 0;
	
	int pos_r1 = 0;
	int pos_end = 0;
	int type_end = 0;
	
	pos_end = orderlist_w4[0];
	type_end = sectionarray_w4[pos_end].type;
	
	if(type_end == 1)
	{
		//end is a up trend
		pos_r1 = orderlist_w4[3];
	}
	else
	{
		//end is a down trend
		pos_r1 = orderlist_w4[2];
	}

	x1 = sectionarray_w4[pos_r1].start * -1;
	y1 = sectionarray_w4[pos_r1].startvalue;
	//y = ax + b   b = y - ax
	intercept = y1 - slope * x1;

	return intercept;
}

double CalculateSlopeOnResistantLine(
	const TrendSection *sectionarray_w4, 
	const int* orderlist_w4
	);
double CalculateSlopeOnResistantLine(
	const TrendSection *sectionarray_w4, 
	const int* orderlist_w4
	)
{

	double y1 = 0;
	double y2 = 0;

	double x1 = 0;
	double x2 = 0;

	int pos_r2 = 0;
	int pos_r1 = 0;

	double slope_resistantline = 0;

	int pos_end = 0;

	int type_end = 0;

	pos_end = orderlist_w4[0];
	type_end = sectionarray_w4[pos_end].type;
	if(type_end == 1)
	{
		//end is a up trend
		pos_r1 = orderlist_w4[3];
		pos_r2 = orderlist_w4[1];
	}
	else
	{
		//end is a down trend
		pos_r1 = orderlist_w4[2];
		pos_r2 = orderlist_w4[0];
	}

	x1 = sectionarray_w4[pos_r1].start * -1;
	x2 = sectionarray_w4[pos_r2].start * -1;

	y1 = sectionarray_w4[pos_r1].startvalue;
	y2 = sectionarray_w4[pos_r2].startvalue;


	slope_resistantline  = (double)((y2 - y1) / (x2 - x1));


	return slope_resistantline;
}

double CalculateSlopeOnSupportLine(
	const TrendSection *sectionarray_w4, 
	const int* orderlist_w4
	);
double CalculateSlopeOnSupportLine(
	const TrendSection *sectionarray_w4, 
	const int* orderlist_w4

	)
{
	double y1 = 0;
	double y2 = 0;

	double x1 = 0;
	double x2 = 0;

	int pos_s2 = 0;
	int pos_s1 = 0;

	double slope_supportline = 0;

	int pos_end = 0;

	int type_end = 0;

	
	//use w4
	pos_end = orderlist_w4[0];
	type_end = sectionarray_w4[pos_end].type;

	if(type_end == 1)
	{
		//end is a uptrend
		pos_s1 = orderlist_w4[2];
		pos_s2 = orderlist_w4[0];
	}
	else
	{
		//end is a down trend
		pos_s1 = orderlist_w4[3];
		pos_s2 = orderlist_w4[1];
	}


	x1 = sectionarray_w4[pos_s1].start * -1;
	x2 = sectionarray_w4[pos_s2].start * -1;

	y1 = sectionarray_w4[pos_s1].startvalue;
	y2 = sectionarray_w4[pos_s2].startvalue;
	


	slope_supportline =(double)( (y2 - y1) / (x2 - x1) );

	return slope_supportline;


}


void CalculatePreAndNowTrend(
	const double& open_zerobar,
	const double& close_zerobar,
	const TrendSection *sectionarray_w4, 
	
	TrendStatus *analyzeres,
	const int& index
	);
void CalculatePreAndNowTrend(
	const double& open_zerobar,
	const double& close_zerobar,
	const TrendSection *sectionarray_w4, 
	
	TrendStatus *analyzeres,
	const int& index
	)
{
	//window size = 4
	int orderlist_w4_now[4];
	int orderlist_w4_pre[4];
	int orderlist_w4_prepre[4];
	int listend_w4_pre = 0;
	int listend_w4_prepre = 0;


	int trendtype_lastsection = 0;
	int end_lastsection = 0;
	double endvalue_lastsection = 0;

	int type_zerobar = 0;
	if(close_zerobar > open_zerobar) type_zerobar = 1;
	else type_zerobar = -1;

	FindFourValidSections(sectionarray_w4, 0, orderlist_w4_now);
	listend_w4_pre = orderlist_w4_now[3] + 1;

	trendtype_lastsection = sectionarray_w4[0].type;
	end_lastsection = sectionarray_w4[0].end;
	endvalue_lastsection = sectionarray_w4[0].endvalue;

	FindFourValidSections(sectionarray_w4, listend_w4_pre, orderlist_w4_pre);

	listend_w4_prepre = orderlist_w4_pre[3] + 1;

	FindFourValidSections(sectionarray_w4, listend_w4_prepre, orderlist_w4_prepre);
	
	
	int trendstatus_now = CalculateSectionTrend(sectionarray_w4,orderlist_w4_now);

	int trendstatus_pre = CalculateSectionTrend(sectionarray_w4, orderlist_w4_pre);

	int trendstatus_prepre = CalculateSectionTrend(sectionarray_w4, orderlist_w4_prepre);



	//calculate now trend line's slope for support and resistant line
	double slope_support = CalculateSlopeOnSupportLine(sectionarray_w4, orderlist_w4_now);

	double slope_resistant = CalculateSlopeOnResistantLine(sectionarray_w4,orderlist_w4_now);

	double intercept_support = CalculateInterceptOnSupportLine(sectionarray_w4, orderlist_w4_now, slope_support);

	double intercepe_resistant = CalculateInterceptOnResistantLine(sectionarray_w4,orderlist_w4_now,slope_resistant);


	//y = ax + b
	double value_on_supportline_end_lastsection = LineFamule(slope_support, end_lastsection, intercept_support);
	double value_on_resistantline_end_lastsection = LineFamule(slope_resistant,end_lastsection, intercepe_resistant);

	double value_on_supportline_pos_zero = LineFamule(slope_support, 0, intercept_support);
	double value_on_resistanctline_pos_zero = LineFamule(slope_resistant, 0, intercepe_resistant);

	

	//
	// finnal quantuate result
	//
	
	analyzeres[index].trendtype_now = trendstatus_now;
	analyzeres[index].trendtype_pre = trendstatus_pre;
	analyzeres[index].trendtype_pre_pre = trendstatus_prepre;
	analyzeres[index].slope_resistantline = slope_resistant;
	analyzeres[index].slope_supportline = slope_support;

	
	analyzeres[index].trendtype_lastsection = trendtype_lastsection;
	analyzeres[index].end_lastsection = end_lastsection;
	analyzeres[index].endvalue_lastsection = endvalue_lastsection;

	analyzeres[index].type_zerobar = type_zerobar;
	analyzeres[index].open_zerobar = open_zerobar;
	analyzeres[index].close_zerobar = close_zerobar;


	analyzeres[index].value_on_supportline_end_lastsection = value_on_supportline_end_lastsection;
	analyzeres[index].value_on_resistantline_end_lastsection = value_on_resistantline_end_lastsection;
	analyzeres[index].value_on_supportline_pos_zero = value_on_supportline_pos_zero;
	analyzeres[index].value_on_resistanctline_pos_zero = value_on_resistanctline_pos_zero;

	
}



void MarketInfoAnalyze(TrendStatus *analyzeres);

void MarketInfoAnalyze(TrendStatus *analyzeres)
{
	//d h4 ouput work direction


	//h1 m15 m5  trace market to output operation command
}







void ProcessTrading();

