// JNAPipeServerDLL.cpp : Defines the exported functions for the DLL application.
// x64 could be run under JNA

#include "stdafx.h"
#include <iostream>
#include <windows.h>
using namespace std;

#define BUFFERSIZE 512
#define INITBLOCKSIZE 60*sizeof(double)
#define INITTIMESIZE 60*sizeof(int)

#define STARTDATASIZE 18*sizeof(double)
#define STARTTIMESIZE 5*sizeof(int)
#define QUOTEDATASIZE 2*sizeof(double)


//wait for connect
int WaitForClientConnection(HANDLE p)
{
	BOOL result = ConnectNamedPipe(p, NULL);
	return result;
}


HANDLE CreateNamedPipeForM1()
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipeM1",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		BUFFERSIZE,                  // output buffer size 
		BUFFERSIZE,                  // input buffer size 
		0,                        // client time-out 
		NULL);

	return pipe;
}

HANDLE CreateNamedPipeForM5()
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipeM5",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		BUFFERSIZE,                  // output buffer size 
		BUFFERSIZE,                  // input buffer size 
		0,                        // client time-out 
		NULL);

	return pipe;
}

HANDLE CreateNamedPipeForM15()
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipeM15",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		BUFFERSIZE,                  // output buffer size 
		BUFFERSIZE,                  // input buffer size 
		0,                        // client time-out 
		NULL);

	return pipe;
}

HANDLE CreateNamedPipeForM30()
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipeM30",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		BUFFERSIZE,                  // output buffer size 
		BUFFERSIZE,                  // input buffer size 
		0,                        // client time-out 
		NULL);

	return pipe;
}

HANDLE CreateNamedPipeForH1()
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipeH1",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		BUFFERSIZE,                  // output buffer size 
		BUFFERSIZE,                  // input buffer size 
		0,                        // client time-out 
		NULL);

	return pipe;
}

HANDLE CreateNamedPipeForH4()
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipeH4",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		BUFFERSIZE,                  // output buffer size 
		BUFFERSIZE,                  // input buffer size 
		0,                        // client time-out 
		NULL);

	return pipe;
}

HANDLE CreateNamedPipeForD()
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipeD",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		BUFFERSIZE,                  // output buffer size 
		BUFFERSIZE,                  // input buffer size 
		0,                        // client time-out 
		NULL);

	return pipe;
}
/************************************************************************/
/* Help Method                                                                     */
/************************************************************************/
int ReadDoubleFromPipe(HANDLE p,double* ptr,int len)
{
	DWORD numBytesRead = 0;
	BOOL read_result = ReadFile(
		p,
		ptr, // the data from the pipe will be put here
		len, // number of bytes allocated
		&numBytesRead, // this will store number of bytes actually read
		NULL // not using overlapped IO
		);

	return read_result;
}

int ReadIntFromPipe(HANDLE p,int* ptr,int len)
{
	DWORD numBytesRead = 0;
	BOOL read_result = ReadFile(
		p,
		ptr, // the data from the pipe will be put here
		len, // number of bytes allocated
		&numBytesRead, // this will store number of bytes actually read
		NULL // not using overlapped IO
		);

	return read_result;
}

/************************************************************************/
/* Help Method End                                                                     */
/************************************************************************/
int ReadInitDataFromPipe(HANDLE p, double *open, double *close,double *high, double *low, int *time, double *quote )
{
	//open
	int or = ReadDoubleFromPipe(p,open, INITBLOCKSIZE);
	//close
	int cr = ReadDoubleFromPipe(p,close, INITBLOCKSIZE);
	//high
	int hr = ReadDoubleFromPipe(p,high, INITBLOCKSIZE);
	//low
	int lr = ReadDoubleFromPipe(p,low, INITBLOCKSIZE);
	//time
	int tr = ReadIntFromPipe(p,time,INITTIMESIZE);
	//quote
	int qr = ReadDoubleFromPipe(p,quote, QUOTEDATASIZE);

	return 0;
}

int ReadStartDataFromPipe(HANDLE p, double* ptr,int *time)
{
	int rs = ReadDoubleFromPipe(p,ptr,STARTDATASIZE);
	int tr = ReadIntFromPipe(p,time,STARTTIMESIZE);

	return 0;
}



/************************************************************************/
/* not used code                                                                     */
/************************************************************************/

/**
struct DD{
	int name;
	double value;
};
*/
/************************************************************************/
/* new method                                                                     */
/************************************************************************/
/**
struct ForexDataStruct{
	double value;
};
*/
//create pipe
/**
HANDLE CreateNamedPipeForName()
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipe",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		BUFFERSIZE,                  // output buffer size 
		BUFFERSIZE,                  // input buffer size 
		0,                        // client time-out 
		NULL);

	return pipe;
}
*/

//for reference test
/**
void setvals(ForexDataStruct* ptr)
{
	ptr->value = 999.99;
}
*/

//read data
/**
int ReadDataFromPipe(HANDLE p,double* ptr,int len)
{
	DWORD numBytesRead = 0;
	BOOL read_result = ReadFile(
		p,
		ptr, // the data from the pipe will be put here
		len, // number of bytes allocated
		&numBytesRead, // this will store number of bytes actually read
		NULL // not using overlapped IO
		);
	
	return read_result;
}

int WriteDataToPipe(HANDLE p,double* ptr,int len)
{
	
	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		p, // handle to our outbound pipe
		ptr, // data to send
		len, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);
	int fr = FlushFileBuffers(p);
	return writetoresult;
}
*/
/**
int DoFlushFileBuffers(HANDLE p)
{
	return FlushFileBuffers(p);
}
*/
/**
*/
/************************************************************************/
/* new method end                                                                     */
/************************************************************************/


/************************************************************************/
/* test                                                                      */
/************************************************************************/
/**
double sendDoubleArray(const double* vals, const int numVals)
{

	double total = 0;
	for (int loop=0; loop<numVals; loop++)
	{
		total += vals[loop];
	}
	return total;
}

double* changeDoubleArray(double* vals, int numVals)
{

	
	for (int loop=0; loop<numVals; loop++)
	{
		vals[loop] = vals[loop] * 1.05;
	}
	return vals;
}
*/

/**
int ReadIntFromPipe(HANDLE p,int* ptr,int len)
{
DWORD numBytesRead = 0;
BOOL read_result = ReadFile(
p,
ptr, // the data from the pipe will be put here
len, // number of bytes allocated
&numBytesRead, // this will store number of bytes actually read
NULL // not using overlapped IO
);

return read_result;
}
*/





/************************************************************************/
/* new                                                                      */
/************************************************************************/