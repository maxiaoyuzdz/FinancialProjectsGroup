// MT4EA3DLL.cpp : Defines the exported functions for the DLL application.
//



#include "helputiles.h"

//TEST METHODS
#define NUMOFROW 2000
#define NUMOFCLOUM 2


void __stdcall PrintTest()
{
	int len2 = swprintf(
		logbuf, 200, L"mt4 okok");

	OutputDebugString(logbuf);
}
/*double **dataarray;
int **markarray;
int clusterid[NUMOFROW];*/
void __stdcall ArrayTest(double arr[][NUMOFCLOUM], int marr[][NUMOFCLOUM])
{
	/**
	for(int i = 0; i< 10; i++)
	{
		int len2 = swprintf(
		logbuf, 200, L"mt4 %d", arr[i][0]);
		arr[i][0] = 100;

		OutputDebugString(logbuf);
	}
	
	
	double weight[NUMOFCLOUM];
	double error;
	int ifound;


	dataarray = new double *[NUMOFROW];
	markarray = new int *[NUMOFROW];
	for (int i = 0; i < NUMOFROW; i++)
	{
		dataarray[i] = new double[NUMOFCLOUM];
		markarray[i] = new int[NUMOFCLOUM];
	}
	//copy data
	for (int i = 0; i < NUMOFROW; i++)
	{
		for(int j = 0; j<NUMOFCLOUM; j++)
		{
			dataarray[i][j]  = arr[i][j];
			markarray[i][j] = marr[i][j];
		}
	}


	kcluster(8,NUMOFROW,NUMOFCLOUM,dataarray,markarray,weight,0,300,'a','e', 
    clusterid, &error, &ifound);





	
	for(int i = 0; i< NUMOFROW; i++)
	{
		delete [] dataarray[i];
		delete [] markarray[i];

	}

	delete [] dataarray;
	delete [] markarray;
*/

/*
	for(int i = 0; i< 50; i++)
	{
		

		int len2 = swprintf(
		logbuf, 200, L"mt4 %d is reserve = %d, type = %d , x = %f, y = %f  \n", i, marr[i][0], marr[i][1], arr[i][0], arr[i][1]);

		OutputDebugString(logbuf);
	}
*/
	/**
	int len2 = swprintf(
	logbuf, 200, L"mt4 ===========================\n");
	OutputDebugString(logbuf);
	for(int i = 0; i< 100; i++)
	{
		int len2 = swprintf(
		logbuf, 200, L"mt4 %d x = %d \n", i, clusterid[i] );

		OutputDebugString(logbuf);
	}
	*/


}





//
#define SYS_WAITTING_CLOSE 0
#define SYS_WAITTING_SEND 1
int systemstatus = 1;

void AnalyzeForSend(
	double parameters[][10], 
	bool isnewbar, 
	int *output_Commandarr,
	double *output_CommandParametersarr
	)
{
	if( isnewbar )
	{
		//analyze
		
	}
}

void __stdcall AnalyzeFunction( 
	double parameters[][10], 
	bool isnewbar, 
	int *output_Commandarr,
	double *output_CommandParametersarr
	)
{

	switch(systemstatus)
	{
		case SYS_WAITTING_SEND:
		AnalyzeForSend(
			parameters,
			isnewbar,
			output_Commandarr,
			output_CommandParametersarr
			);
		break;

		case SYS_WAITTING_CLOSE:
		break;
	}




}


int __stdcall GetInt()
{
	return 999;
}