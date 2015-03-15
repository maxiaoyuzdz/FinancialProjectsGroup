#property copyright "JavaDev"
#property link      "mailto:javadev@rambler.ru"

#include <http51.mqh>

int start()
  {
  
   string params [0,2];
   //params[?,0] = Key
   //params[?,1] = Value

   ArrayResize( params, 0); // Flush old data
   int status[1];           // HTTP Status code
  
   // Setup parameters addParam(Key,Value,paramArray)
   addParam("Bid",Bid,params);
   addParam("Ask",Ask,params);
   // TODO .... any other parameters

   //create URLEncoded string from parameters array
   string req = ArrayEncode(params);

   //Send Request 
   //string res = httpGET("http://127.0.0.1/test?"+ req, status);
   string res = httpGET("http://127.0.0.1:8080/test1", status);
   //string res = httpPOST("http://127.0.0.1:8080/", req, status);
   
   Print("HTTP:",status[0]," ", res);
   Comment(res);
    
   return(0);
  }
//+------------------------------------------------------------------+