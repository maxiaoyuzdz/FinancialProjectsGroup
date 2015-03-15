// MT4PipeClientDLL.cpp : Defines the exported functions for the DLL application.
//

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


HANDLE pipe1;
HANDLE pipe5;
HANDLE pipe15;
HANDLE pipe30;
HANDLE pipe60;
HANDLE pipe240;
HANDLE pipe1440;




int ClosePipeConnection(const int n)
{
	BOOL close_res;
	switch(n)
	{
	case 1 :close_res = CloseHandle(pipe1);
		break;
	case 5: close_res = CloseHandle(pipe5);
		break;

	case 15: close_res = CloseHandle(pipe15);
		break;

	case 30: close_res = CloseHandle(pipe30);
		break;

	case 60: close_res = CloseHandle(pipe60);
		break;

	case 240: close_res = CloseHandle(pipe240);
		break;

	case 1440: close_res = CloseHandle(pipe1440);
		break;
	}

	
	return close_res;
}


int CreatePipeConnectionForM1()
{
	pipe1 = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipeM1",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe1 == INVALID_HANDLE_VALUE) {
		return 1;
	}

	return 0;
}

int CreatePipeConnectionForM5()
{
	pipe5 = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipeM5",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe5 == INVALID_HANDLE_VALUE) {
		return 1;
	}

	return 0;
}

int CreatePipeConnectionForM15()
{
	pipe15 = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipeM15",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe15 == INVALID_HANDLE_VALUE) {
		return 1;
	}

	return 0;
}

int CreatePipeConnectionForM30()
{
	pipe30 = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipeM30",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe30 == INVALID_HANDLE_VALUE) {
		return 1;
	}

	return 0;
}

int CreatePipeConnectionForH1()
{
	pipe60 = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipeH1",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe60 == INVALID_HANDLE_VALUE) {
		return 1;
	}

	return 0;
}

int CreatePipeConnectionForH4()
{
	pipe240 = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipeH4",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe240 == INVALID_HANDLE_VALUE) {
		return 1;
	}

	return 0;
}

int CreatePipeConnectionForD()
{
	pipe1440 = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipeD",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe1440 == INVALID_HANDLE_VALUE) {
		return 1;
	}

	return 0;
}

/************************************************************************/
/* Help Method                                                                     */
/************************************************************************/
int WriteDoubleToPipeForM1(double *arr,const int arraysize)
{
	
	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe1, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe1);

	return writetoresult;
}

int WriteDoubleToPipeForM5(double *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe5, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe5);

	return writetoresult;
}

int WriteDoubleToPipeForM15(double *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe15, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe15);

	return writetoresult;
}

int WriteDoubleToPipeForM30(double *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe30, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe30);

	return writetoresult;
}

int WriteDoubleToPipeForH1(double *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe60, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe60);

	return writetoresult;
}

int WriteDoubleToPipeForH4(double *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe240, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe240);

	return writetoresult;
}

int WriteDoubleToPipeForD(double *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe1440, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe1440);

	return writetoresult;
}

int WriteIntToPipeForM1(int *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe1, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe1);

	return writetoresult;

}

int WriteIntToPipeForM5(int *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe5, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe5);

	return writetoresult;

}

int WriteIntToPipeForM15(int *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe15, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe15);

	return writetoresult;

}
int WriteIntToPipeForM30(int *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe30, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe30);

	return writetoresult;

}

int WriteIntToPipeForH1(int *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe60, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe60);

	return writetoresult;

}
int WriteIntToPipeForH4(int *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe240, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe240);

	return writetoresult;

}

int WriteIntToPipeForD(int *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe1440, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe1440);

	return writetoresult;

}
/************************************************************************/
/* Help Mehod End                                                                     */
/************************************************************************/



int WriteInitDataToPipeForM1(double *open, double *close,double *high, double *low, int *time, double *quote)
{
	//open
	int or = WriteDoubleToPipeForM1(open, INITBLOCKSIZE);
	//close
	int cr = WriteDoubleToPipeForM1(close, INITBLOCKSIZE);
	//high
	int hr = WriteDoubleToPipeForM1(high, INITBLOCKSIZE);
	//low
	int lr = WriteDoubleToPipeForM1(low, INITBLOCKSIZE);
	//time
	int tr = WriteIntToPipeForM1(time,INITTIMESIZE);
	//quote QUOTEDATASIZE
	int qr = WriteDoubleToPipeForM1(quote, QUOTEDATASIZE);

	return 0;
}

int WriteInitDataToPipeForM5(double *open, double *close,double *high, double *low, int *time, double *quote)
{
	//open
	int or = WriteDoubleToPipeForM5(open, INITBLOCKSIZE);
	//close
	int cr = WriteDoubleToPipeForM5(close, INITBLOCKSIZE);
	//high
	int hr = WriteDoubleToPipeForM5(high, INITBLOCKSIZE);
	//low
	int lr = WriteDoubleToPipeForM5(low, INITBLOCKSIZE);
	//time
	int tr = WriteIntToPipeForM5(time,INITTIMESIZE);
	//quote QUOTEDATASIZE
	int qr = WriteDoubleToPipeForM5(quote, QUOTEDATASIZE);

	return 0;
}

int WriteInitDataToPipeForM15(double *open, double *close,double *high, double *low, int *time, double *quote)
{
	//open
	int or = WriteDoubleToPipeForM15(open, INITBLOCKSIZE);
	//close
	int cr = WriteDoubleToPipeForM15(close, INITBLOCKSIZE);
	//high
	int hr = WriteDoubleToPipeForM15(high, INITBLOCKSIZE);
	//low
	int lr = WriteDoubleToPipeForM15(low, INITBLOCKSIZE);
	//time
	int tr = WriteIntToPipeForM15(time,INITTIMESIZE);
	//quote QUOTEDATASIZE
	int qr = WriteDoubleToPipeForM15(quote, QUOTEDATASIZE);

	return 0;
}

int WriteInitDataToPipeForM30(double *open, double *close,double *high, double *low, int *time, double *quote)
{
	//open
	int or = WriteDoubleToPipeForM30(open, INITBLOCKSIZE);
	//close
	int cr = WriteDoubleToPipeForM30(close, INITBLOCKSIZE);
	//high
	int hr = WriteDoubleToPipeForM30(high, INITBLOCKSIZE);
	//low
	int lr = WriteDoubleToPipeForM30(low, INITBLOCKSIZE);
	//time
	int tr = WriteIntToPipeForM30(time,INITTIMESIZE);
	//quote QUOTEDATASIZE
	int qr = WriteDoubleToPipeForM30(quote, QUOTEDATASIZE);

	return 0;
}

int WriteInitDataToPipeForH1(double *open, double *close,double *high, double *low, int *time, double *quote)
{
	//open
	int or = WriteDoubleToPipeForH1(open, INITBLOCKSIZE);
	//close
	int cr = WriteDoubleToPipeForH1(close, INITBLOCKSIZE);
	//high
	int hr = WriteDoubleToPipeForH1(high, INITBLOCKSIZE);
	//low
	int lr = WriteDoubleToPipeForH1(low, INITBLOCKSIZE);
	//time
	int tr = WriteIntToPipeForH1(time,INITTIMESIZE);
	//quote QUOTEDATASIZE
	int qr = WriteDoubleToPipeForH1(quote, QUOTEDATASIZE);

	return 0;
}

int WriteInitDataToPipeForH4(double *open, double *close,double *high, double *low, int *time, double *quote)
{
	//open
	int or = WriteDoubleToPipeForH4(open, INITBLOCKSIZE);
	//close
	int cr = WriteDoubleToPipeForH4(close, INITBLOCKSIZE);
	//high
	int hr = WriteDoubleToPipeForH4(high, INITBLOCKSIZE);
	//low
	int lr = WriteDoubleToPipeForH4(low, INITBLOCKSIZE);
	//time
	int tr = WriteIntToPipeForH4(time,INITTIMESIZE);
	//quote QUOTEDATASIZE
	int qr = WriteDoubleToPipeForH4(quote, QUOTEDATASIZE);

	return 0;
}
int WriteInitDataToPipeForD(double *open, double *close,double *high, double *low, int *time, double *quote)
{
	//open
	int or = WriteDoubleToPipeForD(open, INITBLOCKSIZE);
	//close
	int cr = WriteDoubleToPipeForD(close, INITBLOCKSIZE);
	//high
	int hr = WriteDoubleToPipeForD(high, INITBLOCKSIZE);
	//low
	int lr = WriteDoubleToPipeForD(low, INITBLOCKSIZE);
	//time
	int tr = WriteIntToPipeForD(time,INITTIMESIZE);
	//quote QUOTEDATASIZE
	int qr = WriteDoubleToPipeForD(quote, QUOTEDATASIZE);

	return 0;
}


int WriteStartDataToPipeForM1(double *arr, int *time)
{
	
	
	int sr = WriteDoubleToPipeForM1(arr,STARTDATASIZE);
	int tr = WriteIntToPipeForM1(time,STARTTIMESIZE);

	return 0;
	
}

int WriteStartDataToPipeForM5(double *arr, int *time)
{


	int sr = WriteDoubleToPipeForM5(arr,STARTDATASIZE);
	int tr = WriteIntToPipeForM5(time,STARTTIMESIZE);

	return 0;

}

int WriteStartDataToPipeForM15(double *arr, int *time)
{


	int sr = WriteDoubleToPipeForM15(arr,STARTDATASIZE);
	int tr = WriteIntToPipeForM15(time,STARTTIMESIZE);

	return 0;

}

int WriteStartDataToPipeForM30(double *arr, int *time)
{


	int sr = WriteDoubleToPipeForM30(arr,STARTDATASIZE);
	int tr = WriteIntToPipeForM30(time,STARTTIMESIZE);

	return 0;

}

int WriteStartDataToPipeForH1(double *arr, int *time)
{


	int sr = WriteDoubleToPipeForH1(arr,STARTDATASIZE);
	int tr = WriteIntToPipeForH1(time,STARTTIMESIZE);

	return 0;

}

int WriteStartDataToPipeForH4(double *arr, int *time)
{


	int sr = WriteDoubleToPipeForH4(arr,STARTDATASIZE);
	int tr = WriteIntToPipeForH4(time,STARTTIMESIZE);

	return 0;

}

int WriteStartDataToPipeForD(double *arr, int *time)
{


	int sr = WriteDoubleToPipeForD(arr,STARTDATASIZE);
	int tr = WriteIntToPipeForD(time,STARTTIMESIZE);

	return 0;

}


/************************************************************************/
/* not used                                                                     */
/************************************************************************/
/**
double DSum(double a,double b)
{
	return a+b;
}
*/
//////////////////////////////////////////////////////////////////////////
/************************************************************************/
/* start to code MT4 client DLL                                                                     */
/************************************************************************/
/**
struct ForexDataStruct{
	double value;
};

double transferdata[2] = {3.14,0.27};//,4.35,3.21,5.6};
*/
/**
int CreatePipeConnection()
{
	pipe = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipe",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe == INVALID_HANDLE_VALUE) {
		return 1;
	}

	return 0;
}
*/

/**
int ReadDataFromPipe(double *arr,const int arraysize)
{
	DWORD numBytesRead = 0;
	BOOL read_result = ReadFile(
		pipe,
		arr, // the data from the pipe will be put here
		arraysize, // number of bytes allocated
		&numBytesRead, // this will store number of bytes actually read
		NULL // not using overlapped IO
		);

	return read_result;

}

int WriteDataToPipe(double *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe);

	return writetoresult;

}

int WriteIntToPipe(int *arr,const int arraysize)
{

	DWORD numBytesWritten = 0;
	BOOL writetoresult = WriteFile(
		pipe, // handle to our outbound pipe
		arr, // data to send
		arraysize, // length of data to send (bytes)
		&numBytesWritten, // will store actual amount of data sent
		NULL // not using overlapped IO
		);

	int fr = FlushFileBuffers(pipe);

	return writetoresult;

}
*/






// int testsizeofdouble()
// {
// 	return sizeof(transferdata);
// 
// }

/************************************************************************/
/* new method                                                                     */
/************************************************************************/