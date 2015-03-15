package com.mxystudio

import org.json4s._
import org.json4s.jackson.JsonMethods._

import java.util.Date
import java.util.Calendar




case class Answer(query:QueryItem2)
case class QueryItem2(count:Int,created:String,lang:String, results:ResultsItem )
case class ResultsItem(rate:List[ForexItem])
case class ForexItem( id:String, Name:String, Rate:String, Date:String, Time:String, Ask:Float, Bid:Float)


case class TT(id:String,Name:String,Rate:String){
//implicit def str2float(str:String) = str.toFloat
}

object test {
  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  
  //implicit def JString2Float(valuestr:JString) = compact(render(valuestr)).toFloat
  
  
  implicit lazy val formats = DefaultFormats      //> formats: => org.json4s.DefaultFormats.type
  val json =
  """
  {"query":{"count":68,"created":"2013-08-12T03:07:55Z","lang":"en-US","results":{"rate":[{"id":"EURUSD","Name":"EUR to USD","Rate":"1.3325","Date":"8/12/2013","Time":"11:01pm","Ask":"1.3327","Bid":"1.3323"},{"id":"EURAUD","Name":"EUR to AUD","Rate":"1.4464","Date":"8/12/2013","Time":"11:01pm","Ask":"1.4468","Bid":"1.446"},{"id":"EURCAD","Name":"EUR to CAD","Rate":"1.3703","Date":"8/12/2013","Time":"11:02pm","Ask":"1.3707","Bid":"1.37"},{"id":"EURCHF","Name":"EUR to CHF","Rate":"1.2312","Date":"8/12/2013","Time":"11:01pm","Ask":"1.2314","Bid":"1.231"},{"id":"EURCNY","Name":"EUR to CNY","Rate":"8.16","Date":"8/12/2013","Time":"11:01pm","Ask":"8.1679","Bid":"8.1521"},{"id":"EURGBP","Name":"EUR to GBP","Rate":"0.86","Date":"8/12/2013","Time":"11:01pm","Ask":"0.8601","Bid":"0.8598"},{"id":"EURHKD","Name":"EUR to HKD","Rate":"10.3334","Date":"8/12/2013","Time":"11:01pm","Ask":"10.3351","Bid":"10.3317"},{"id":"EURJPY","Name":"EUR to JPY","Rate":"128.6595","Date":"8/12/2013","Time":"11:02pm","Ask":"128.7122","Bid":"128.6069"},{"id":"EURNZD","Name":"EUR to NZD","Rate":"1.6546","Date":"8/12/2013","Time":"11:01pm","Ask":"1.6551","Bid":"1.6541"},{"id":"GBPUSD","Name":"GBP to USD","Rate":"1.5495","Date":"8/12/2013","Time":"11:01pm","Ask":"1.5495","Bid":"1.5494"},{"id":"GBPAUD","Name":"GBP to AUD","Rate":"1.6819","Date":"8/12/2013","Time":"11:01pm","Ask":"1.6822","Bid":"1.6816"},{"id":"GBPCAD","Name":"GBP to CAD","Rate":"1.5935","Date":"8/12/2013","Time":"11:02pm","Ask":"1.5936","Bid":"1.5933"},{"id":"GBPCHF","Name":"GBP to CHF","Rate":"1.4317","Date":"8/12/2013","Time":"11:01pm","Ask":"1.4318","Bid":"1.4316"},{"id":"GBPCNY","Name":"GBP to CNY","Rate":"9.4885","Date":"8/12/2013","Time":"11:01pm","Ask":"9.4966","Bid":"9.4805"},{"id":"GBPEUR","Name":"GBP to EUR","Rate":"1.1628","Date":"8/12/2013","Time":"11:01pm","Ask":"1.163","Bid":"1.1626"},{"id":"GBPHKD","Name":"GBP to HKD","Rate":"12.0159","Date":"8/12/2013","Time":"11:01pm","Ask":"12.0164","Bid":"12.0153"},{"id":"GBPJPY","Name":"GBP to JPY","Rate":"149.6071","Date":"8/12/2013","Time":"11:02pm","Ask":"149.6507","Bid":"149.5636"},{"id":"GBPNZD","Name":"GBP to NZD","Rate":"1.924","Date":"8/12/2013","Time":"11:01pm","Ask":"1.9243","Bid":"1.9237"},{"id":"AUDUSD","Name":"AUD to USD","Rate":"0.9213","Date":"8/12/2013","Time":"11:01pm","Ask":"0.9214","Bid":"0.9211"},{"id":"AUDCHF","Name":"AUD to CHF","Rate":"0.8513","Date":"8/12/2013","Time":"11:02pm","Ask":"0.8514","Bid":"0.8511"},{"id":"AUDCNY","Name":"AUD to CNY","Rate":"5.6416","Date":"8/12/2013","Time":"11:01pm","Ask":"5.647","Bid":"5.6363"},{"id":"AUDEUR","Name":"AUD to EUR","Rate":"0.6914","Date":"8/12/2013","Time":"11:01pm","Ask":"0.6916","Bid":"0.6912"},{"id":"AUDGBP","Name":"AUD to GBP","Rate":"0.5946","Date":"8/12/2013","Time":"11:01pm","Ask":"0.5947","Bid":"0.5945"},{"id":"AUDHKD","Name":"AUD to HKD","Rate":"7.1443","Date":"8/12/2013","Time":"11:01pm","Ask":"7.1453","Bid":"7.1433"},{"id":"AUDJPY","Name":"AUD to JPY","Rate":"88.9523","Date":"8/12/2013","Time":"11:02pm","Ask":"88.9869","Bid":"88.9176"},{"id":"AUDNZD","Name":"AUD to NZD","Rate":"1.144","Date":"8/12/2013","Time":"11:01pm","Ask":"1.1443","Bid":"1.1437"},{"id":"NZDUSD","Name":"NZD to USD","Rate":"0.8053","Date":"8/12/2013","Time":"11:01pm","Ask":"0.8054","Bid":"0.8052"},{"id":"NZDCNY","Name":"NZD to CNY","Rate":"4.9316","Date":"8/12/2013","Time":"11:01pm","Ask":"4.9363","Bid":"4.927"},{"id":"USDCNY","Name":"USD to CNY","Rate":"6.1238","Date":"8/12/2013","Time":"11:01pm","Ask":"6.1288","Bid":"6.1188"},{"id":"USDTWD","Name":"USD to TWD","Rate":"29.951","Date":"8/12/2013","Time":"11:01pm","Ask":"29.956","Bid":"29.946"},{"id":"USDHKD","Name":"USD to HKD","Rate":"7.7549","Date":"8/12/2013","Time":"11:01pm","Ask":"7.755","Bid":"7.7548"},{"id":"USDSGD","Name":"USD to SGD","Rate":"1.2605","Date":"8/12/2013","Time":"11:02pm","Ask":"1.2606","Bid":"1.2604"},{"id":"USDCAD","Name":"USD to CAD","Rate":"1.0284","Date":"8/12/2013","Time":"11:02pm","Ask":"1.0285","Bid":"1.0283"},{"id":"USDCHF","Name":"USD to CHF","Rate":"0.924","Date":"8/12/2013","Time":"11:02pm","Ask":"0.9241","Bid":"0.924"},{"id":"USDJPY","Name":"USD to JPY","Rate":"96.555","Date":"8/12/2013","Time":"11:02pm","Ask":"96.58","Bid":"96.53"},{"id":"USDMOP","Name":"USD to MOP","Rate":"7.9878","Date":"8/12/2013","Time":"11:01pm","Ask":"7.9881","Bid":"7.9875"},{"id":"USDMYR","Name":"USD to MYR","Rate":"3.234","Date":"8/12/2013","Time":"11:01pm","Ask":"3.2355","Bid":"3.2325"},{"id":"CADAUD","Name":"CAD to AUD","Rate":"1.0555","Date":"8/12/2013","Time":"11:02pm","Ask":"1.0557","Bid":"1.0553"},{"id":"CADCHF","Name":"CAD to CHF","Rate":"0.8985","Date":"8/12/2013","Time":"11:02pm","Ask":"0.8986","Bid":"0.8984"},{"id":"CADCNY","Name":"CAD to CNY","Rate":"5.9547","Date":"8/12/2013","Time":"11:02pm","Ask":"5.96","Bid":"5.9494"},{"id":"CADEUR","Name":"CAD to EUR","Rate":"0.7297","Date":"8/12/2013","Time":"11:02pm","Ask":"0.7299","Bid":"0.7296"},{"id":"CADGBP","Name":"CAD to GBP","Rate":"0.6276","Date":"8/12/2013","Time":"11:02pm","Ask":"0.6276","Bid":"0.6275"},{"id":"CADHKD","Name":"CAD to HKD","Rate":"7.5407","Date":"8/12/2013","Time":"11:02pm","Ask":"7.5414","Bid":"7.5401"},{"id":"CADJPY","Name":"CAD to JPY","Rate":"93.8881","Date":"8/12/2013","Time":"11:02pm","Ask":"93.9193","Bid":"93.8569"},{"id":"CADNZD","Name":"CAD to NZD","Rate":"1.2074","Date":"8/12/2013","Time":"11:02pm","Ask":"1.2077","Bid":"1.2072"},{"id":"CHFAUD","Name":"CHF to AUD","Rate":"1.1747","Date":"8/12/2013","Time":"11:02pm","Ask":"1.1749","Bid":"1.1745"},{"id":"CHFCAD","Name":"CHF to CAD","Rate":"1.1129","Date":"8/12/2013","Time":"11:02pm","Ask":"1.1131","Bid":"1.1128"},{"id":"CHFCNY","Name":"CHF to CNY","Rate":"6.6272","Date":"8/12/2013","Time":"11:02pm","Ask":"6.6328","Bid":"6.6216"},{"id":"CHFEUR","Name":"CHF to EUR","Rate":"0.8122","Date":"8/12/2013","Time":"11:02pm","Ask":"0.8123","Bid":"0.812"},{"id":"CHFGBP","Name":"CHF to GBP","Rate":"0.6984","Date":"8/12/2013","Time":"11:02pm","Ask":"0.6985","Bid":"0.6984"},{"id":"CHFHKD","Name":"CHF to HKD","Rate":"8.3924","Date":"8/12/2013","Time":"11:02pm","Ask":"8.3928","Bid":"8.392"},{"id":"CHFJPY","Name":"CHF to JPY","Rate":"104.4922","Date":"8/12/2013","Time":"11:02pm","Ask":"104.5227","Bid":"104.4618"},{"id":"CNYJPY","Name":"CNY to JPY","Rate":"15.7672","Date":"8/12/2013","Time":"11:02pm","Ask":"15.7841","Bid":"15.7502"},{"id":"HKDAUD","Name":"HKD to AUD","Rate":"0.14","Date":"8/12/2013","Time":"11:01pm","Ask":"0.14","Bid":"0.14"},{"id":"HKDCAD","Name":"HKD to CAD","Rate":"0.1326","Date":"8/12/2013","Time":"11:02pm","Ask":"0.1326","Bid":"0.1326"},{"id":"HKDCHF","Name":"HKD to CHF","Rate":"0.1192","Date":"8/12/2013","Time":"11:02pm","Ask":"0.1192","Bid":"0.1191"},{"id":"HKDCNY","Name":"HKD to CNY","Rate":"0.7897","Date":"8/12/2013","Time":"11:01pm","Ask":"0.7903","Bid":"0.789"},{"id":"HKDEUR","Name":"HKD to EUR","Rate":"0.0968","Date":"8/12/2013","Time":"11:01pm","Ask":"0.0968","Bid":"0.0968"},{"id":"HKDGBP","Name":"HKD to GBP","Rate":"0.0832","Date":"8/12/2013","Time":"11:01pm","Ask":"0.0832","Bid":"0.0832"},{"id":"HKDJPY","Name":"HKD to JPY","Rate":"12.4508","Date":"8/12/2013","Time":"11:02pm","Ask":"12.4542","Bid":"12.4474"},{"id":"JPYAUD","Name":"JPY to AUD","Rate":"0.0112","Date":"8/12/2013","Time":"11:02pm","Ask":"0.0112","Bid":"0.0112"},{"id":"JPYCAD","Name":"JPY to CAD","Rate":"0.0107","Date":"8/12/2013","Time":"11:02pm","Ask":"0.0107","Bid":"0.0106"},{"id":"JPYCHF","Name":"JPY to CHF","Rate":"0.0096","Date":"8/12/2013","Time":"11:02pm","Ask":"0.0096","Bid":"0.0096"},{"id":"JPYEUR","Name":"JPY to EUR","Rate":"0.0078","Date":"8/12/2013","Time":"11:02pm","Ask":"0.0078","Bid":"0.0078"},{"id":"JPYGBP","Name":"JPY to GBP","Rate":"0.0067","Date":"8/12/2013","Time":"11:02pm","Ask":"0.0067","Bid":"0.0067"},{"id":"JPYHKD","Name":"JPY to HKD","Rate":"0.0803","Date":"8/12/2013","Time":"11:02pm","Ask":"0.0803","Bid":"0.0803"},{"id":"SGDCNY","Name":"SGD to CNY","Rate":"4.8583","Date":"8/12/2013","Time":"11:02pm","Ask":"4.8627","Bid":"4.8539"},{"id":"TWDCNY","Name":"TWD to CNY","Rate":"0.2045","Date":"8/12/2013","Time":"11:01pm","Ask":"0.2047","Bid":"0.2043"}]}}}
  """                                             //> json  : String = "
                                                  //|   {"query":{"count":68,"created":"2013-08-12T03:07:55Z","lang":"en-US","res
                                                  //| ults":{"rate":[{"id":"EURUSD","Name":"EUR to USD","Rate":"1.3325","Date":"8
                                                  //| /12/2013","Time":"11:01pm","Ask":"1.3327","Bid":"1.3323"},{"id":"EURAUD","N
                                                  //| ame":"EUR to AUD","Rate":"1.4464","Date":"8/12/2013","Time":"11:01pm","Ask"
                                                  //| :"1.4468","Bid":"1.446"},{"id":"EURCAD","Name":"EUR to CAD","Rate":"1.3703"
                                                  //| ,"Date":"8/12/2013","Time":"11:02pm","Ask":"1.3707","Bid":"1.37"},{"id":"EU
                                                  //| RCHF","Name":"EUR to CHF","Rate":"1.2312","Date":"8/12/2013","Time":"11:01p
                                                  //| m","Ask":"1.2314","Bid":"1.231"},{"id":"EURCNY","Name":"EUR to CNY","Rate":
                                                  //| "8.16","Date":"8/12/2013","Time":"11:01pm","Ask":"8.1679","Bid":"8.1521"},{
                                                  //| "id":"EURGBP","Name":"EUR to GBP","Rate":"0.86","Date":"8/12/2013","Time":"
                                                  //| 11:01pm","Ask":"0.8601","Bid":"0.8598"},{"id":"EURHKD","Name":"EUR to HKD",
                                                  //| "Rate":"10.3334","Date":"8/12/2013","Time":"11:01pm","Ask":"10.3351","Bid":
   
  
  val parsedBody = parse(json)                    //> parsedBody  : org.json4s.JValue = JObject(List((query,JObject(List((count,J
                                                  //| Int(68)), (created,JString(2013-08-12T03:07:55Z)), (lang,JString(en-US)), (
                                                  //| results,JObject(List((rate,JArray(List(JObject(List((id,JString(EURUSD)), (
                                                  //| Name,JString(EUR to USD)), (Rate,JString(1.3325)), (Date,JString(8/12/2013)
                                                  //| ), (Time,JString(11:01pm)), (Ask,JString(1.3327)), (Bid,JString(1.3323)))),
                                                  //|  JObject(List((id,JString(EURAUD)), (Name,JString(EUR to AUD)), (Rate,JStri
                                                  //| ng(1.4464)), (Date,JString(8/12/2013)), (Time,JString(11:01pm)), (Ask,JStri
                                                  //| ng(1.4468)), (Bid,JString(1.446)))), JObject(List((id,JString(EURCAD)), (Na
                                                  //| me,JString(EUR to CAD)), (Rate,JString(1.3703)), (Date,JString(8/12/2013)),
                                                  //|  (Time,JString(11:02pm)), (Ask,JString(1.3707)), (Bid,JString(1.37)))), JOb
                                                  //| ject(List((id,JString(EURCHF)), (Name,JString(EUR to CHF)), (Rate,JString(1
                                                  //| .2312)), (Date,JString(8/12/2013)), (Time,JString(11:01pm)), (Ask,JString(1
                                                  //| .2314)), (Bid,JString(1
                                                  //| Output exceeds cutoff limit.
  
  parsedBody \\ "lang"                            //> res0: org.json4s.JValue = JString(en-US)
  parsedBody \ "lang"                             //> res1: org.json4s.JValue = JNothing
  
      
  
 
  
  val n = parsedBody \\ "count"                   //> n  : org.json4s.JValue = JInt(68)
  
  val vn = compact(render(n))                     //> vn  : String = 68
   

  
   val parsedBody2 = parse(json)                  //> parsedBody2  : org.json4s.JValue = JObject(List((query,JObject(List((count,
                                                  //| JInt(68)), (created,JString(2013-08-12T03:07:55Z)), (lang,JString(en-US)), 
                                                  //| (results,JObject(List((rate,JArray(List(JObject(List((id,JString(EURUSD)), 
                                                  //| (Name,JString(EUR to USD)), (Rate,JString(1.3325)), (Date,JString(8/12/2013
                                                  //| )), (Time,JString(11:01pm)), (Ask,JString(1.3327)), (Bid,JString(1.3323))))
                                                  //| , JObject(List((id,JString(EURAUD)), (Name,JString(EUR to AUD)), (Rate,JStr
                                                  //| ing(1.4464)), (Date,JString(8/12/2013)), (Time,JString(11:01pm)), (Ask,JStr
                                                  //| ing(1.4468)), (Bid,JString(1.446)))), JObject(List((id,JString(EURCAD)), (N
                                                  //| ame,JString(EUR to CAD)), (Rate,JString(1.3703)), (Date,JString(8/12/2013))
                                                  //| , (Time,JString(11:02pm)), (Ask,JString(1.3707)), (Bid,JString(1.37)))), JO
                                                  //| bject(List((id,JString(EURCHF)), (Name,JString(EUR to CHF)), (Rate,JString(
                                                  //| 1.2312)), (Date,JString(8/12/2013)), (Time,JString(11:01pm)), (Ask,JString(
                                                  //| 1.2314)), (Bid,JString(
                                                  //| Output exceeds cutoff limit.
   
  val c = (parsedBody2 \ "query" \ "count")       //> c  : org.json4s.JValue = JInt(68)
  compact(render(c)).toInt                        //> res2: Int = 68
  (parsedBody \\ "results" \ "rate")(67) \ "id"   //> res3: org.json4s.JValue = JString(TWDCNY)
  val pres = (parsedBody \\ "results" \ "rate")(67)
                                                  //> pres  : org.json4s.JsonAST.JValue = JObject(List((id,JString(TWDCNY)), (Nam
                                                  //| e,JString(TWD to CNY)), (Rate,JString(0.2045)), (Date,JString(8/12/2013)), 
                                                  //| (Time,JString(11:01pm)), (Ask,JString(0.2047)), (Bid,JString(0.2043))))
  
  pres transformField{
  case ("Rate",x) => ("Rate1", x)
  }                                               //> res4: org.json4s.JValue = JObject(List((id,JString(TWDCNY)), (Name,JString(
                                                  //| TWD to CNY)), (Rate1,JString(0.2045)), (Date,JString(8/12/2013)), (Time,JSt
                                                  //| ring(11:01pm)), (Ask,JString(0.2047)), (Bid,JString(0.2043))))
  
  val pp = pres \ "id"                            //> pp  : org.json4s.JValue = JString(TWDCNY)
  val obj = (parsedBody \\ "results" \ "rate")(67).extract[TT]
                                                  //> obj  : com.mxystudio.TT = TT(TWDCNY,TWD to CNY,0.2045)
  
  // ( (parsedBody \\ "results" \ "rate")(0) \ "id" ).extract[String]
  
 // val ans = parsedBody2.extract[Answer]
 
   val k =  (parsedBody \\ "results" \ "rate")(0) //\ "id"
                                                  //> k  : org.json4s.JsonAST.JValue = JObject(List((id,JString(EURUSD)), (Name,J
                                                  //| String(EUR to USD)), (Rate,JString(1.3325)), (Date,JString(8/12/2013)), (Ti
                                                  //| me,JString(11:01pm)), (Ask,JString(1.3327)), (Bid,JString(1.3323))))
  
  val Dates = compact(render(k \ "Date")) //Date ?//> Dates  : String = "8/12/2013"
  println("sss")                                  //> sss
  println(Dates)                                  //> "8/12/2013"
  val datess = Dates.replaceAll("\"","")          //> datess  : String = 8/12/2013
      val format = new java.text.SimpleDateFormat("dd/MM/yyyy")
                                                  //> format  : java.text.SimpleDateFormat = java.text.SimpleDateFormat@d936eac0
                                                  //| 
      val DataValue = format.parse(datess)        //> DataValue  : java.util.Date = Sun Dec 08 00:00:00 CST 2013
      
      val dayinmonth = DataValue.getDate          //> dayinmonth  : Int = 8
      val monthinyear = DataValue.getMonth        //> monthinyear  : Int = 11
      val year = DataValue.getYear                //> year  : Int = 113
      val tCalendar = Calendar.getInstance();     //> tCalendar  : java.util.Calendar = java.util.GregorianCalendar[time=1376586
                                                  //| 037502,areFieldsSet=true,areAllFieldsSet=true,lenient=true,zone=sun.util.c
                                                  //| alendar.ZoneInfo[id="Asia/Shanghai",offset=28800000,dstSavings=0,useDaylig
                                                  //| ht=false,transitions=19,lastRule=null],firstDayOfWeek=1,minimalDaysInFirst
                                                  //| Week=1,ERA=1,YEAR=2013,MONTH=7,WEEK_OF_YEAR=33,WEEK_OF_MONTH=3,DAY_OF_MONT
                                                  //| H=16,DAY_OF_YEAR=228,DAY_OF_WEEK=6,DAY_OF_WEEK_IN_MONTH=3,AM_PM=0,HOUR=1,H
                                                  //| OUR_OF_DAY=1,MINUTE=0,SECOND=37,MILLISECOND=502,ZONE_OFFSET=28800000,DST_O
                                                  //| FFSET=0]
tCalendar.setTime(DataValue);
val tdayinmonth = tCalendar.get(Calendar.DAY_OF_MONTH)
                                                  //> tdayinmonth  : Int = 8
val tmonthinyear = tCalendar.get(Calendar.MONTH)  //> tmonthinyear  : Int = 11
val tyear = tCalendar.get(Calendar.YEAR)          //> tyear  : Int = 2013
  
  
  val timestempstr = compact(render(k \ "Time")).replaceAll("\"","")
                                                  //> timestempstr  : String = 11:01pm
  val testtime = compact(render(k \ "Time")).replaceAll("\"","")
                                                  //> testtime  : String = 11:01pm
  val timeformat = new java.text.SimpleDateFormat("HH:mm")
                                                  //> timeformat  : java.text.SimpleDateFormat = java.text.SimpleDateFormat@4183
                                                  //| e5a
  
  val hasp = testtime.contains("pm")              //> hasp  : Boolean = true
  val processts = if(hasp) testtime.replaceAll("pm","") else testtime.replaceAll("am","")
                                                  //> processts  : String = 11:01
  val valofts = processts.split(":")              //> valofts  : Array[String] = Array(11, 01)
  val hourval = if(hasp) valofts(0).toInt + 12 else  valofts(0).toInt
                                                  //> hourval  : Int = 23
  val minval = valofts(1).toInt                   //> minval  : Int = 1
  val finatimeval = hourval+":"+minval            //> finatimeval  : String = 23:1
  timeformat.parse(finatimeval)                   //> res5: java.util.Date = Thu Jan 01 23:01:00 CST 1970
  
  
  val testtimestr = "11:20"                       //> testtimestr  : String = 11:20
  val testtimeformater = new java.text.SimpleDateFormat("HH:mm")
                                                  //> testtimeformater  : java.text.SimpleDateFormat = java.text.SimpleDateForma
                                                  //| t@4183e5a
  val timevalue = testtimeformater.parse(testtimestr)
                                                  //> timevalue  : java.util.Date = Thu Jan 01 11:20:00 CST 1970
  
  val currenttimevalue = new Date                 //> currenttimevalue  : java.util.Date = Fri Aug 16 01:00:37 CST 2013
  
  
  
  
  
 
 
 
 
}