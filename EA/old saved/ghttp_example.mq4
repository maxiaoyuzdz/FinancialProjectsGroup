//+------------------------------------------------------------------+
//|                                                ghttp_example.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
   #include <ghttp.mqh>

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
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
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----


string params[2][2];

params[0][0] = "key1"; 

params[0][1] = "value1";

params[1][0] = "key2"; 
params[1][1] = "value2";

// for multiple file upload
string filenames[2][2];

filenames[0][0] = "uploaded1"; // name of form field for file upload 
filenames[0][1] = "test1.txt"; // file name in experts/files/ subfolder

filenames[1][0] = "uploaded2"; 
filenames[1][1] = "test2.txt"; 

string response; 

//HttpPOST("127.0.0.1", "/upload.php", params, filenames, response); 
HttpGET("http://127.0.0.1:8080/test2", response);
Comment(response);
//----
   return(0);
  }
//+------------------------------------------------------------------+