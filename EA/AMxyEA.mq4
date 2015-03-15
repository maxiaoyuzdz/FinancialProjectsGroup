//+------------------------------------------------------------------+
//|                                                   EATemplete.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//MT4EA1DLL
//#import "MT4EA1DLL.dll"

//#import

//--- input parameters
extern int       windowsize = 8;
//extern int       totalbars=480;
extern int       recnumoflargetrend = 5;



//#define ARRAYRANGEFORBUFFER 640
#define TRENDNUMBUFFER 512  //256 trend
#define NUMOFLINES 128		//but only 128 lins to use
//used for lines
string uptrendlinenamearray[NUMOFLINES];
string downtrendlinenamearray[NUMOFLINES];

int totaluptrendsbuffer[TRENDNUMBUFFER];
int totaldowntrendsbuffer[TRENDNUMBUFFER];
int totalnumofuptrendlines = 0;
int totalnumofdowntrendlines = 0;

//for big trend
int biguptrendindexbuffer[TRENDNUMBUFFER];
int bigdowntrendindexbuffer[TRENDNUMBUFFER];

int biguptrendindex = 0;
int bigdowntrendindex = 0;

int numofbiguptrend = 0;
int numofbigdowntrend = 0;

//for small trend
int smalluptrendindexbuffer[TRENDNUMBUFFER];
int smalldowntrendindexbuffer[TRENDNUMBUFFER];

int smalluptrendindex = 0;
int smalldowntrendindex = 0;

int numofsmalluptrend = 0;
int numofsmalldowntrend = 0;


//+------------------------------------------------------------------+
//| custom function                                   |
//+------------------------------------------------------------------+
void InitLinesArray()
{
	for( int i = 0; i < NUMOFLINES; i++ ){
		string upname = "up"+i;
		string downname = "down"+i;
		uptrendlinenamearray[i] = upname;
		downtrendlinenamearray[i] = downname;
		//upline

		int upst = Time[0];
		double upsp = 0;
	    ObjectCreate( upname, OBJ_TREND, 0, upst, upsp);//
	    ObjectSet( upname, OBJPROP_COLOR, Red );
		ObjectSet( upname, OBJPROP_STYLE, STYLE_SOLID );

		ObjectSet( upname, OBJPROP_WIDTH, 1 );
		ObjectSet( upname, OBJPROP_BACK, false );
		ObjectSet( upname, OBJPROP_RAY, false );

		//downline
	    ObjectCreate( downname, OBJ_TREND, 0, upst, upsp);//
	    ObjectSet( downname, OBJPROP_COLOR, Yellow );
		ObjectSet( downname, OBJPROP_STYLE, STYLE_SOLID );

		ObjectSet( downname, OBJPROP_WIDTH, 1 );
		ObjectSet( downname, OBJPROP_BACK, false );
		ObjectSet( downname, OBJPROP_RAY, false );

	}
}
void DeleteAllObjectInThisWindow()
{

	ObjectsDeleteAll();
	/**
	for( int i = 0; i < NUMOFLINES; i++ )
	{
		string upname = uptrendlinenamearray[i];
		string downname = downtrendlinenamearray[i];

		ObjectDelete( upname );
		ObjectDelete( downname );
	}
	*/
}
string GetUpTrendLineName(int index)
{
	return(uptrendlinenamearray[index]);
}
string GetDownTrendLineName(int index)
{
	return(downtrendlinenamearray[index]);
}
void MoveUpTrendLine(int linenum, int si, int ei)
{
	

	int st = Time[si];
	double sp = Close[si];
	int et = Time[ei];
	double ep = Close[ei];
	string linename = GetUpTrendLineName(linenum);

	ObjectSet( linename, OBJPROP_TIME1, st );
	ObjectSet( linename, OBJPROP_PRICE1, sp );
	ObjectSet( linename, OBJPROP_TIME2, et );
	ObjectSet( linename, OBJPROP_PRICE2, ep );

}

void MoveDownTrendLine(int linenum, int si, int ei)
{
	
	int st = Time[si];
	double sp = Close[si];
	int et = Time[ei];
	double ep = Close[ei];
	string linename = GetDownTrendLineName(linenum);

	ObjectSet( linename, OBJPROP_TIME1, st );
	ObjectSet( linename, OBJPROP_PRICE1, sp );
	ObjectSet( linename, OBJPROP_TIME2, et );
	ObjectSet( linename, OBJPROP_PRICE2, ep );

}


//+------------------------------------------------------------------+
//| analyze function                                   |
//+------------------------------------------------------------------+
void ClearComputingBuffer()
{


	ArrayInitialize( biguptrendindexbuffer, 0 );
	ArrayInitialize( bigdowntrendindexbuffer, 0 );

	biguptrendindex = 0;
	bigdowntrendindex = 0;

	numofbiguptrend = 0;
	numofbigdowntrend = 0;


	ArrayInitialize( smalluptrendindexbuffer, 0 );
	ArrayInitialize( smalldowntrendindexbuffer, 0 );

	smalluptrendindex = 0;
	smalldowntrendindex = 0;

	numofsmalluptrend = 0;
	numofsmalldowntrend = 0;



	ArrayInitialize( totaluptrendsbuffer, 0 );
	ArrayInitialize( totaldowntrendsbuffer, 0 );
	totalnumofuptrendlines = 0;
	totalnumofdowntrendlines = 0;

}
//+------------------------------------------------------------------+
//| analyze function                                   |
//+------------------------------------------------------------------+
bool IsUpBar( int pos)
{
	return (Close[pos] > Open[pos]);
}
bool IsDownBar(int pos)
{
	return (Close[pos] < Open[pos]);
}
//+------------------------------------------------------------------+
//| analyze function                                   |
//+------------------------------------------------------------------+

int FindHighestUpBar(int end, int size)
{
	int highupbarindex = -1;
	int startp = end + size;
	double tempclose = 0;

	for(int i = end; i < startp; i++)
	{
		if(IsUpBar(i))
		{
			if(Close[i] > tempclose)
			{
				tempclose = Close[i];

				highupbarindex = i;

			}
		}
	}


	return(highupbarindex);

}
int FindLowestUpBar(int end, int size)
{
	int lowestupbarindex = -1;
	int startp = end + size;

	double tempopen = 999;

	for (int i = end; i< startp; i++)
	{
		if(IsUpBar(i))
		{
			if(Open[i] < tempopen)
			{
				tempopen = Open[i];
				lowestupbarindex = i;
			}

		}
	}

	return(lowestupbarindex);
}

int FindHighestDownBar(int end, int size)
{
	int highestdownbarindex = -1;

	int startp = end + size;

	double tempopen = 0;

	for (int i = end; i< startp; i++)
	{
		if(IsDownBar(i))
		{
			if(Open[i] > tempopen)
			{
				tempopen = Open[i];
				highestdownbarindex = i;

			}
		}
	}

	return(highestdownbarindex);

}
int FindLowestDownBar(int end, int size)
{
	int lowestbarindex = -1;

	int startp = end + size;

	double temoclose = 9999;

	for (int i = end; i< startp; i++)
	{
		if(IsDownBar(i))
		{
			if(Close[i] < temoclose)
			{
				temoclose = Close[i];
				lowestbarindex = i;

			}
		}

	}

	return (lowestbarindex);

}
//+------------------------------------------------------------------+
//| analyze function                                   |
//+------------------------------------------------------------------+
int FindAllBigTrend(int end, int wsize)
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

	int localsize = 0;

	int co = 0;
	

	while(!finish)
	{
		co++;
		//get data range for this computing
		localsize = p * wsize;

		//Print("p= ", localsize );



		int highestupbarindex = FindHighestUpBar(end, localsize);
		int lowestupbarindex = FindLowestUpBar(end, localsize);
		//down bar used for down trend
		int highestdownbarindex = FindHighestDownBar(end, localsize);
		int lowestdownbarindex = FindLowestDownBar(end, localsize);

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
			//Print("p= ", localsize );
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

		if( haveuptrend && (!havedowntrend))
		{
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
			}
			else
			{
				//make sure this is up trend
				CurrentTrend = 1;
				p = pp;
				finish = true;
				break;
			}
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



	}
	//end while loop
	if(CurrentTrend > 0)
	{
		//Print( "display up" );
		//DisplayUpTrend(trendstartpos, trendendpos, close[trendstartpos], close[trendendpos], resuptrendarr);
		biguptrendindexbuffer[biguptrendindex] = trendendpos;
		biguptrendindex++;
		biguptrendindexbuffer[biguptrendindex] = trendstartpos;
		biguptrendindex++;

		numofbiguptrend++;

	}
	if(CurrentTrend < 0)
	{
		//Print( "display down" );
		//DisplayDownTrend(trendstartpos, trendendpos, close[trendstartpos], close[trendendpos],resdowntrendarr);
		bigdowntrendindexbuffer[bigdowntrendindex] = trendendpos;
		bigdowntrendindex++;
		bigdowntrendindexbuffer[bigdowntrendindex] = trendstartpos;
		bigdowntrendindex++;

		numofbigdowntrend++;
	}

	Print( "co= ",co );

	//loop end
	int computedsize = trendstartpos - end + 1;
	return(computedsize);


	return(0);
}

int FindAllSmallTrend(int end, int wsize)
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

	int localsize = 0;

	while(!finish)
	{
		//get data range for this computing
		localsize = p * wsize;

//		Print( localsize );

		int highestupbarindex = FindHighestUpBar(end, localsize);
		int lowestupbarindex = FindLowestUpBar(end, localsize);
		//down bar used for down trend
		int highestdownbarindex = FindHighestDownBar(end, localsize);
		int lowestdownbarindex = FindLowestDownBar(end, localsize);

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

		if( haveuptrend && (!havedowntrend))
		{
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
			}
			else
			{
				//make sure this is up trend
				CurrentTrend = 1;
				p = pp;
				finish = true;
				break;
			}
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



	}
	//end while loop
	if(CurrentTrend > 0)
	{
		//Print( "display up" );
		//DisplayUpTrend(trendstartpos, trendendpos, close[trendstartpos], close[trendendpos], resuptrendarr);
		smalluptrendindexbuffer[smalluptrendindex] = trendendpos;
		smalluptrendindex++;
		smalluptrendindexbuffer[smalluptrendindex] = trendstartpos;
		smalluptrendindex++;

		numofsmalluptrend++;

	}
	if(CurrentTrend < 0)
	{
		//Print( "display down" );
		//DisplayDownTrend(trendstartpos, trendendpos, close[trendstartpos], close[trendendpos],resdowntrendarr);
		smalldowntrendindexbuffer[smalldowntrendindex] = trendendpos;
		smalldowntrendindex++;
		smalldowntrendindexbuffer[smalldowntrendindex] = trendstartpos;
		smalldowntrendindex++;

		numofsmalldowntrend++;
	}

	

	//loop end
	int computedsize = trendstartpos - end + 1;
	return(computedsize);


	return(0);
}

int ComputingTrend()
{
	ClearComputingBuffer();

	int bigbaseend = 0; 
	//find 20 trends  max = 256

	for(int i = 0; i < recnumoflargetrend; i++)
	{
		int psize = FindAllBigTrend(bigbaseend, windowsize);
		bigbaseend = bigbaseend + psize;
	}

/**
	int smallbaseend = 0;
	for(int j = 0; j < recnumoflargetrend; j++)
	{
		int smallsize = FindAllSmallTrend(smallbaseend, windowsize/2);
		smallbaseend = smallbaseend + smallsize;

	}
*/
	//merge operation




	return(0);
}

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int DisplayTrendLines(int type)
{
	if(type > 0)
	{
		for(int i = 0; i< numofbiguptrend; i++)
		{
			int uplinebum = i;
			int upsi = uplinebum * 2 + 1;
			int upei = uplinebum * 2;

			int upsp = biguptrendindexbuffer[upsi];
			int upep = biguptrendindexbuffer[upei];
			MoveUpTrendLine(uplinebum, upsp, upep);

		}
		//MoveDownTrendLine
		for(int j = 0; j< numofbigdowntrend; j++)
		{
			int downlinebum = j;
			int downsi = downlinebum * 2 + 1;
			int downei = downlinebum * 2;

			int downsp = bigdowntrendindexbuffer[downsi];
			int downep = bigdowntrendindexbuffer[downei];
			MoveDownTrendLine(downlinebum, downsp, downep);

		}
	}
	else
	{
		for(int si = 0; si< numofsmalluptrend; si++)
		{
			int suplinebum = si;
			int supsi = suplinebum * 2 + 1;
			int supei = suplinebum * 2;

			int supsp = smalluptrendindexbuffer[supsi];
			int supep = smalluptrendindexbuffer[supei];
			MoveUpTrendLine(suplinebum, supsp, supep);

		}
		//MoveDownTrendLine
		for(int sj = 0; sj< numofsmalldowntrend; sj++)
		{
			int ssdownlinebum = sj;
			int ssdownsi = ssdownlinebum * 2 + 1;
			int ssdownei = ssdownlinebum * 2;

			int ssdownsp = smalldowntrendindexbuffer[ssdownsi];
			int ssdownep = smalldowntrendindexbuffer[ssdownei];
			MoveDownTrendLine(ssdownlinebum, ssdownsp, ssdownep);

		}

	}
	

	return(0);
}

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
  	InitLinesArray();
//----

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   DeleteAllObjectInThisWindow();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
  	Print( "s = ",TimeLocal() );
  	if(IsTradeAllowed()) Print( "aaaa" );
  	else  Print( "bbbb" );
//----

	int cs = ComputingTrend();
	cs = DisplayTrendLines(1);


//----
   return(0);
  }
//+------------------------------------------------------------------+