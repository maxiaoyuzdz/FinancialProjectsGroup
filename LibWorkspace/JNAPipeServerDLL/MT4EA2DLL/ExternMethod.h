#include "helputils.h"






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


int CalculateSectionTrend(const TrendSection* trend, const int *orderlist);
int CalculateSectionTrend(const TrendSection* trend, const int *orderlist)
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
		// '//'
		//only has support line
		//support line is valid
		return 1;
	}

	if(resistantlinevalid && !supportlinevalid)
	{
		// '\\'
		//only has resistant line
		//resistant line is valid
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
	const TrendSection *sectionarray_w4, 
	const int *orderlist,
	const int& index,
	TrendStatus *analyzeres
	);
void CalculatePreAndNowTrend(
	const TrendSection *sectionarray_w4, 
	const int *orderlist,
	const int& index,
	TrendStatus *analyzeres
	)
{





	//calculate now trend line's slope for support and resistant line
	double slope_support = CalculateSlopeOnSupportLine(sectionarray_w4, orderlist);

	double slope_resistant = CalculateSlopeOnResistantLine(sectionarray_w4,orderlist);

	double intercept_support = CalculateInterceptOnSupportLine(sectionarray_w4, orderlist, slope_support);

	double intercepe_resistant = CalculateInterceptOnResistantLine(sectionarray_w4,orderlist,slope_resistant);

	int end_lastsection = sectionarray_w4[0].end;
	//y = ax + b
	double value_on_supportline_end_lastsection = LineFamule(slope_support, end_lastsection, intercept_support);
	double value_on_resistantline_end_lastsection = LineFamule(slope_resistant,end_lastsection, intercepe_resistant);

	double value_on_supportline_pos_zero = LineFamule(slope_support, 0, intercept_support);
	double value_on_resistanctline_pos_zero = LineFamule(slope_resistant, 0, intercepe_resistant);


	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// finnal quantuate result
	//
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	//trend type  1 -1 10 -10
	analyzeres[index].trendtype_now = CalculateSectionTrend(sectionarray_w4,orderlist);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	//support and resistanct 
	//slope value
	analyzeres[index].slope_resistantline = slope_resistant;
	analyzeres[index].slope_supportline = slope_support;
	//intercept
	analyzeres[index].intercept_resistantline = intercepe_resistant;
	analyzeres[index].intercept_supportline = intercept_support;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	//+1 -1
	analyzeres[index].trendtype_lastsection = sectionarray_w4[0].type;
	//end position
	analyzeres[index].end_lastsection = end_lastsection;	//is 0, judge is the zero bar
	//start position
	analyzeres[index].start_lastsection = sectionarray_w4[0].start;


	analyzeres[index].value_on_supportline_end_lastsection = value_on_supportline_end_lastsection;
	analyzeres[index].value_on_resistantline_end_lastsection = value_on_resistantline_end_lastsection;
	analyzeres[index].value_on_supportline_pos_zero = value_on_supportline_pos_zero;
	analyzeres[index].value_on_resistanctline_pos_zero = value_on_resistanctline_pos_zero;



	bool ismainpower_lastsection_source = CheckSectionSourceisMainPower(
		analyzeres[index].trendtype_lastsection, // 1 -1
		analyzeres[index].trendtype_now, // 1 -1 10 -10
		slope_support,
		slope_resistant
		);

	if(ismainpower_lastsection_source)
	{
		//last section is in main trend
		analyzeres[index].main_power = analyzeres[index].trendtype_lastsection;

		analyzeres[index].drive_by_main_lastsection = true;
	}
	else
	{
		//last section is in callback
		analyzeres[index].main_power = analyzeres[index].trendtype_lastsection * -1;

		analyzeres[index].drive_by_main_lastsection = false;
	}

}










void AnalyzeMA(
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
	MAAnalyzeResult *res_analyze
	);
void AnalyzeMA(
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
	MAAnalyzeResult *res_analyze
	)
{
	bool check_d = false;
	bool check_h4 = false;
	bool check_h1 = false;
	bool check_m15 = false;
	bool check_m5 = false;
	bool check_m1 = false;

	res_analyze[5].count_acroess_in_5 = 0;
	res_analyze[4].count_acroess_in_5 = 0;
	res_analyze[3].count_acroess_in_5 = 0;
	res_analyze[2].count_acroess_in_5 = 0;
	res_analyze[1].count_acroess_in_5 = 0;
	res_analyze[0].count_acroess_in_5 = 0;

	for (int i = 0; i < MAARRAYLENGTH-1; ++i)
	{
		/* code */
		int j = i + 1;
		//D1
		if( check_d == false && mabuffer_D1_P5[i] <= mabuffer_D1_P15[i] &&  mabuffer_D1_P5[j] > mabuffer_D1_P15[j] )
		{
			check_d = true;
			res_analyze[5].type_lastacroess = -1;

		}

		if( check_d == false && mabuffer_D1_P5[i] >= mabuffer_D1_P15[i] &&  mabuffer_D1_P5[j] < mabuffer_D1_P15[j] )
		{
			check_d = true;
			res_analyze[5].type_lastacroess = 1;
		}
		//h4
		if( check_h4 == false && mabuffer_H4_P5[i] <= mabuffer_H4_P15[i] &&  mabuffer_H4_P5[j] > mabuffer_H4_P15[j] )
		{
			check_h4 = true;
			res_analyze[4].type_lastacroess = -1;
		}

		if( check_h4 == false && mabuffer_H4_P5[i] >= mabuffer_H4_P15[i] &&  mabuffer_H4_P5[j] < mabuffer_H4_P15[j] )
		{
			check_h4 = true;
			res_analyze[4].type_lastacroess = 1;
		}
		//h1
		if( check_h1 == false && mabuffer_H1_P5[i] <= mabuffer_H1_P15[i] &&  mabuffer_H1_P5[j] > mabuffer_H1_P15[j] )
		{
			check_h1 = true;
			res_analyze[3].type_lastacroess = -1;
		}

		if( check_h1 == false && mabuffer_H1_P5[i] >= mabuffer_H1_P15[i] &&  mabuffer_H1_P5[j] < mabuffer_H1_P15[j] )
		{
			check_h1 = true;
			res_analyze[3].type_lastacroess = 1;
		}

		//m15
		if( check_m15 == false && mabuffer_M15_P5[i] <= mabuffer_M15_P15[i] &&  mabuffer_M15_P5[j] > mabuffer_M15_P15[j] )
		{
			check_m15 = true;
			res_analyze[2].type_lastacroess = -1;
		}

		if( check_m15 == false && mabuffer_M15_P5[i] >= mabuffer_M15_P15[i] &&  mabuffer_M15_P5[j] < mabuffer_M15_P15[j] )
		{
			check_m15 = true;
			res_analyze[2].type_lastacroess = 1;
		}
		//m5
		if( check_m5 == false && mabuffer_M5_P5[i] <= mabuffer_M5_P15[i] &&  mabuffer_M5_P5[j] > mabuffer_M5_P15[j] )
		{
			check_m5 = true;
			res_analyze[1].type_lastacroess = -1;
		}

		if( check_m5 == false && mabuffer_M5_P5[i] >= mabuffer_M5_P15[i] &&  mabuffer_M5_P5[j] < mabuffer_M5_P15[j] )
		{
			check_m5 = true;
			res_analyze[1].type_lastacroess = 1;
		}
		//m1
		if( check_m1 == false && mabuffer_M1_P5[i] <= mabuffer_M1_P15[i] &&  mabuffer_M1_P5[j] > mabuffer_M1_P15[j] )
		{
			check_m1 = true;
			res_analyze[0].type_lastacroess = -1;
		}

		if( check_m1 == false && mabuffer_M1_P5[i] >= mabuffer_M1_P15[i] &&  mabuffer_M1_P5[j] < mabuffer_M1_P15[j] )
		{
			check_m1 = true;
			res_analyze[0].type_lastacroess = 1;
		}

		if(check_d && check_h4 && check_h1 && check_m15 && check_m5 && check_m1)
		{
			break;
		}



	}

	



	for(int i = 0; i < 10; ++i)
	{
		int j = i + 1;
		//d
		if( (mabuffer_D1_P5[i] <= mabuffer_D1_P15[i] &&  mabuffer_D1_P5[j] > mabuffer_D1_P15[j]) 
			||
			( mabuffer_D1_P5[i] >= mabuffer_D1_P15[i] &&  mabuffer_D1_P5[j] < mabuffer_D1_P15[j] )
			)
		{
			
			res_analyze[5].count_acroess_in_5++;
		}

		//h4
		if( ( mabuffer_H4_P5[i] <= mabuffer_H4_P15[i] &&  mabuffer_H4_P5[j] > mabuffer_H4_P15[j])
			||

			( mabuffer_H4_P5[i] >= mabuffer_H4_P15[i] &&  mabuffer_H4_P5[j] < mabuffer_H4_P15[j])
		 )
		{
			
			res_analyze[4].count_acroess_in_5++;
		}

		//h1
		if( 
			(mabuffer_H1_P5[i] <= mabuffer_H1_P15[i] &&  mabuffer_H1_P5[j] > mabuffer_H1_P15[j] )
			||
			( mabuffer_H1_P5[i] >= mabuffer_H1_P15[i] &&  mabuffer_H1_P5[j] < mabuffer_H1_P15[j] )
			)
		{
			res_analyze[3].count_acroess_in_5++;
		}

		

		//m15
		if( 
			(mabuffer_M15_P5[i] <= mabuffer_M15_P15[i] &&  mabuffer_M15_P5[j] > mabuffer_M15_P15[j] )
			||
			( mabuffer_M15_P5[i] >= mabuffer_M15_P15[i] &&  mabuffer_M15_P5[j] < mabuffer_M15_P15[j] )
			)
		{
			res_analyze[2].count_acroess_in_5++;
		}

		
		//m5
		if( 
			( mabuffer_M5_P5[i] <= mabuffer_M5_P15[i] &&  mabuffer_M5_P5[j] > mabuffer_M5_P15[j] )
			||
			(  mabuffer_M5_P5[i] >= mabuffer_M5_P15[i] &&  mabuffer_M5_P5[j] < mabuffer_M5_P15[j] )
			)
		{
			
			res_analyze[1].count_acroess_in_5++;
		}

		//m1
		if( 
			(mabuffer_M1_P5[i] <= mabuffer_M1_P15[i] &&  mabuffer_M1_P5[j] > mabuffer_M1_P15[j] )
			||

			( mabuffer_M1_P5[i] >= mabuffer_M1_P15[i] &&  mabuffer_M1_P5[j] < mabuffer_M1_P15[j] )

			)
		{
			
			res_analyze[0].count_acroess_in_5++;
		}

		

	}

}




/////////////////////////////////////////////////////////////////////////////////////
#define PI 3.14159265
#define FIBNOCCI_V 68.76 //0.236
int JudgeKTypeByMXYMethod(
	const double& op,
	const double& hi,
	const double& lo,
	const double& cl
	);
int JudgeKTypeByMXYMethod(
	const double& op,
	const double& hi,
	const double& lo,
	const double& cl
	)
{
	double open = op * 100;
	double high = hi * 100;
	double low = lo * 100;
	double close = cl * 100;


	double pos_a, a, b, c, rate_x, rate_y;

	bool issun = ( close >= open )?true:false;

	if( issun )
	{
		pos_a = close - abs(( close - open ) / 2 );
	}
	else
	{
		pos_a = open - abs(( close - open ) / 2);
	}

	a = abs( ( close - open ) / 2 );

    if( a < 0.00000001 || a == 0 ) a = 0.00000001;

    b = abs( high - pos_a );
    c = abs( low - pos_a );

    rate_x = atan( b / a ) * 180 / PI;
    rate_y = atan( c / a ) * 180 / PI;

    int bodyvalue = ( issun )?30:60;

    if(rate_x < 0.00000001 || rate_x == 0) rate_x = 0.00000001;
    if(rate_y < 0.00000001 || rate_y == 0) rate_y = 0.00000001;


    int res_ana = 0;

    if( rate_x > FIBNOCCI_V || rate_y > FIBNOCCI_V )
    {
      res_ana = 5;
      //long high
      if( rate_x > FIBNOCCI_V &&  rate_y < FIBNOCCI_V )
      {
        
        res_ana = bodyvalue + 5;

      }
      //long low
      if( rate_x < FIBNOCCI_V &&  rate_y > FIBNOCCI_V )
      {
        
        res_ana = bodyvalue - 5;
      }

      //check is blance doji
      if( abs(rate_x - rate_y) < 0.00000001 )
      {
        res_ana = 20;
      }

      if( abs(rate_x - rate_y) < 1 && rate_x > FIBNOCCI_V && rate_y > FIBNOCCI_V )
      {
        res_ana = 10;
      }



    }

    
    if( res_ana == 5 || res_ana == 10)
    {

	  double headv, legv, bodyv, rate_head, rate_leg;

      headv = abs( high - close );
      legv = abs( low - open );
      bodyv = abs(close - open);

      if(bodyv < 0.00000001 || bodyv == 0) bodyv = 0.00000001;


      rate_head = (double)headv/bodyv;
      rate_leg = (double)legv/bodyv;


      res_ana = 10;

      if( rate_head * 10 > rate_leg * 10 )
      {
        res_ana = res_ana + 5;
      }
      if( rate_head * 10 < rate_leg * 10 )
      {
        res_ana = res_ana - 5;
      }
    }



    if( res_ana == 0 )
    {
    	res_ana = bodyvalue;

    	if( abs( rate_x - FIBNOCCI_V ) < 0.00000001  && abs( rate_y - FIBNOCCI_V ) > 0.00000001 )
    	{
    		res_ana = res_ana - 2;
    	}

    	if( abs( rate_y - FIBNOCCI_V ) < 0.00000001  && abs( rate_x - FIBNOCCI_V ) > 0.00000001 )
    	{
    		res_ana = res_ana + 2;
    	}

    	if( rate_x <  rate_y)
	      {
	        res_ana = res_ana - 2;
	      }

	      if( rate_x >  rate_y)
	      {
	        res_ana = res_ana + 2;
	      }

	      if( rate_x ==  rate_y)
	      {
	        res_ana = res_ana * 10;
	      }

    	//
    }


    return res_ana;

}



void ProcessMAAndTrend(
	const double* ma_p5_arr, 
	const double* ma_p15_arr, 
	const TrendSection* trendsectionarr,
	MAAcroessAndTrendResult* res
	);
void ProcessMAAndTrend(
	const double* ma_p5_arr, 
	const double* ma_p15_arr, 
	const TrendSection* trendsectionarr,
	MAAcroessAndTrendResult* res
	)
{
	for( int i = 0; i< 20; i++ )
	{
		int start_section = trendsectionarr[i].start;
		int end_section = trendsectionarr[i].end;

		res[i].type_trend = trendsectionarr[i].type;

		bool findac = false;

		for( int j = end_section; j <= start_section; j++ )
		{
			int k = j + 1;

			if( ma_p5_arr[j] <= ma_p15_arr[j] &&  ma_p5_arr[k] > ma_p15_arr[k] )
			{
				//find a acroess, pos = j
				res[i].hasmaacroess = true;
				res[i].type_maacroess = -1;
				res[i].pos_maacroess = j;
				findac = true;

				break;
			}


			if( ma_p5_arr[j] >= ma_p15_arr[j] &&  ma_p5_arr[k] < ma_p15_arr[k] )
			{
				res[i].hasmaacroess = true;
				res[i].type_maacroess = 1;
				res[i].pos_maacroess = j;
				findac = true;

				break;
			}


		}

		if( findac )
		{
			//find the acroess
			res[i].type_matrend = res[i].type_maacroess;

			//calculate the posinfront
			int pos_middle_pos = (start_section + end_section) / 2;
			if( res[i].pos_maacroess > pos_middle_pos )
			{
				res[i].posinfront = true;
			}
			else
			{
				res[i].posinfront = false;;
			}

		}
		else
		{
			//no ma acroess
			int pos_middle_pos = (start_section + end_section) / 2;
			if( ma_p5_arr[pos_middle_pos] > ma_p15_arr[pos_middle_pos] )
			{
				res[i].type_matrend = 1;

			}
			else
			{
				res[i].type_matrend = -1;
			}
		}

	}
}



