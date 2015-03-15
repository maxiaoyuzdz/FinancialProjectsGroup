//+------------------------------------------------------------------+
//|                                                MT4PipeClient.mq4 |
//|                                                         Maxiaoyu |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Maxiaoyu"
#property link      "http://www.metaquotes.net"
#import "MT4PipeClientDLL.dll"


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


#import
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+

double temp_open[60];
double temp_close[60];
double temp_high[60];
double temp_low[60];
int    temp_time[60];
double temp_quote[2];
//===============================================



//===============================================
//used for start
double start_data_to_server[18];
int    start_timedata_to_server[6];
int numofbars = 0;
//===============================================


//===============================================
int period_type;
int cr = 0;
//===============================================

int init()
  {
//----
   numofbars = Bars;
   int pv = Period();
   period_type = Period();
   int crpv = 0;
   switch(pv)
   {
      case 1: crpv = CreatePipeConnectionForM1();
      break;
      case 5: crpv = CreatePipeConnectionForM5();
      break;
      case 15: crpv = CreatePipeConnectionForM15();
      break;
      case 30: crpv = CreatePipeConnectionForM30();
      break;
      case 60: crpv = CreatePipeConnectionForH1();
      break;
      case 240: crpv = CreatePipeConnectionForH4();
      break;
      case 1440: crpv = CreatePipeConnectionForD();
      break;
   }
//----


cr = ArrayCopy(temp_open,Open,0,0,60);
cr = ArrayCopy(temp_close,Close,0,0,60);
cr = ArrayCopy(temp_high,High,0,0,60);
cr = ArrayCopy(temp_low,Low,0,0,60);
cr = ArrayCopy(temp_time,Time,0,0,60);

temp_quote[0] = Ask;
temp_quote[1] = Bid;

switch(period_type){
      case 1: crpv = WriteInitDataToPipeForM1(temp_open,temp_close,temp_high,temp_low, temp_time, temp_quote);
      break;
      case 5: crpv = WriteInitDataToPipeForM5(temp_open,temp_close,temp_high,temp_low, temp_time, temp_quote);
      break;
      case 15: crpv = WriteInitDataToPipeForM15(temp_open,temp_close,temp_high,temp_low, temp_time, temp_quote);
      break;
      case 30: crpv = WriteInitDataToPipeForM30(temp_open,temp_close,temp_high,temp_low, temp_time, temp_quote);
      break;
      case 60: crpv = WriteInitDataToPipeForH1(temp_open,temp_close,temp_high,temp_low, temp_time, temp_quote);
      break;
      case 240: crpv = WriteInitDataToPipeForH4(temp_open,temp_close,temp_high,temp_low, temp_time, temp_quote);
      break;
      case 1440: crpv = WriteInitDataToPipeForD(temp_open,temp_close,temp_high,temp_low, temp_time, temp_quote);
      break;
}



   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   int closepiperes = ClosePipeConnection(period_type);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+

int start()
  {
//----
//start_data_to_server
//store bar 0
start_data_to_server[0] = Open[0];
start_data_to_server[1] = Close[0];
start_data_to_server[2] = High[0];
start_data_to_server[3] = Low[0];
//store bar 1
start_data_to_server[4] = Open[1];
start_data_to_server[5] = Close[1];
start_data_to_server[6] = High[1];
start_data_to_server[7] = Low[1];
//store bar 2
start_data_to_server[8] = Open[2];
start_data_to_server[9] = Close[2];
start_data_to_server[10] = High[2];
start_data_to_server[11] = Low[2];
//store bar 3
start_data_to_server[12] = Open[3];
start_data_to_server[13] = Close[3];
start_data_to_server[14] = High[3];
start_data_to_server[15] = Low[3];

//store current ask Bid
start_data_to_server[16] = Ask;
start_data_to_server[17] = Bid;

//copy 4 time data
//cr = ArrayCopy(start_timedata_to_server,Time,0,0,4);


int diffnumofbars = Bars - numofbars;

numofbars = Bars;

start_timedata_to_server[4] = diffnumofbars;
start_timedata_to_server[0] = Time[0];
start_timedata_to_server[1] = Time[1];
start_timedata_to_server[2] = Time[2];
start_timedata_to_server[3] = Time[3];
//send data to server
int crpv = 0;
switch(period_type)
   {
      case 1: crpv = WriteStartDataToPipeForM1(start_data_to_server,start_timedata_to_server);
      break;
      case 5: crpv = WriteStartDataToPipeForM5(start_data_to_server,start_timedata_to_server);
      break;
      case 15: crpv = WriteStartDataToPipeForM15(start_data_to_server,start_timedata_to_server);
      break;
      case 30: crpv = WriteStartDataToPipeForM30(start_data_to_server,start_timedata_to_server);
      break;
      case 60: crpv = WriteStartDataToPipeForH1(start_data_to_server,start_timedata_to_server);
      break;
      case 240: crpv = WriteStartDataToPipeForH4(start_data_to_server,start_timedata_to_server);
      break;
      case 1440: crpv = WriteStartDataToPipeForD(start_data_to_server,start_timedata_to_server);
      break;
   }

//int send_res = WriteStartDataToPipe(start_data_to_server,start_timedata_to_server);





if(period_type == 1)
{
   //only M1 could do command operation
}
   
   
   
//----
   return(0);
}
//+------------------------------------------------------------------+