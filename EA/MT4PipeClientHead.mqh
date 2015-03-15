//+------------------------------------------------------------------+
//|                                            MT4PipeClientHead.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2005

//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);

// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex4"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
#import "MT4PipeClientDLL.dll"
//double DSum(double a, double b);

int ClosePipeConnection(int pt);

int CreatePipeConnectionForM1();
int CreatePipeConnectionForM5();
int CreatePipeConnectionForM15();
int CreatePipeConnectionForM30();
int CreatePipeConnectionForH1();
int CreatePipeConnectionForH4();
int CreatePipeConnectionForD();

int WriteInitDataToPipeForM1(double open[],double close[],double high[],double close[], int ptime[], double quote[]);
int WriteInitDataToPipeForM5(double open[],double close[],double high[],double close[], int ptime[], double quote[]);
int WriteInitDataToPipeForM15(double open[],double close[],double high[],double close[], int ptime[], double quote[]);
int WriteInitDataToPipeForM30(double open[],double close[],double high[],double close[], int ptime[], double quote[]);
int WriteInitDataToPipeForH1(double open[],double close[],double high[],double close[], int ptime[], double quote[]);
int WriteInitDataToPipeForH4(double open[],double close[],double high[],double close[], int ptime[], double quote[]);
int WriteInitDataToPipeForD(double open[],double close[],double high[],double close[], int ptime[], double quote[]);

int WriteStartDataToPipeForM1(double arr[],int ptime[]);
int WriteStartDataToPipeForM5(double arr[],int ptime[]);
int WriteStartDataToPipeForM15(double arr[],int ptime[]);
int WriteStartDataToPipeForM30(double arr[],int ptime[]);
int WriteStartDataToPipeForH1(double arr[],int ptime[]);
int WriteStartDataToPipeForH4(double arr[],int ptime[]);
int WriteStartDataToPipeForD(double arr[],int ptime[]);

//int ReadDataFromPipe( double& arr[],int);//write to arr
//int WriteDataToPipe(double arr[],int);//read from arr
//int DoFlushFileBuffers();

//int testsizeofdouble();
#import




