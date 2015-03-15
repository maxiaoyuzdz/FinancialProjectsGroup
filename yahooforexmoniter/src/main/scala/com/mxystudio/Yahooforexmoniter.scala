package com.mxystudio

import org.json4s._
import org.json4s.jackson.JsonMethods._
import org.json4s.JsonDSL._

import org.json4s.native.Serialization
import org.json4s.native.Serialization.{ read, write }
//trait import
import com.mxystudio.time.TimerOperator
import com.mxystudio.datebase.DatabaseInit
import com.mxystudio.redis.RedisInit
import com.mxystudio.error.ErrorHandler

import com.mxystudio.model.YahooForexDataSourceObject
import com.mxystudio.model.ForexData
import com.mxystudio.model.ForexDataJson
import com.mxystudio.model.ForexBasicDate

import org.joda.time.DateTime

//import org.squeryl._
import org.squeryl.PrimitiveTypeMode._

object Yahooforexmoniter extends App with DatabaseInit with TimerOperator with RedisInit with ErrorHandler {

  /**
   * setting
   */

  /**
   * init
   */
  //init db
  ConfigureDb()

  val yahoocollector = new YQLPrivateQueryObject()
  //first redis client
  val isconnected = isConnected
  if (isconnected) println("Redis connected") else println("Redis connected Failed")

  //prepare sql str
  val yqlhead = "http://query.yahooapis.com/v1/yql?q="

  val selectstr = "select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22EURUSD%22%2C%22EURAUD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

  val icbcbasicforex = "select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22GBPUSD%22%2C%22USDHKD%22%2C%22USDCHF%22%2C%22USDSGD%22%2C%22USDCAD%22%2C%22AUDUSD%22%2C%22EURGBP%22%2C%22EURUSD%22%2C%22EURJPY%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

  val icbcbasicandxchangeforex = "select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22GBPUSD%22%2C%22USDHKD%22%2C%22USDCHF%22%2C%22USDSGD%22%2C%22USDCAD%22%2C%22AUDUSD%22%2C%22EURGBP%22%2C%22EURUSD%22%2C%22EURJPY%22%2C%22GBPHKD%22%2C%22GBPCHF%22%2C%22GBPSGD%22%2C%22GBPJPY%22%2C%22GBPCAD%22%2C%22GBPAUD%22%2C%22HKDJPY%22%2C%22CHFHKD%22%2C%22CHFSGD%22%2C%22CHFJPY%22%2C%22CHFCAD%22%2C%22SGDHKD%22%2C%22SGDJPY%22%2C%22CADHKD%22%2C%22CADSGD%22%2C%22CADJPY%22%2C%22AUDHKD%22%2C%22AUDCHF%22%2C%22AUDSGD%22%2C%22AUDJPY%22%2C%22AUDCAD%22%2C%22EURHKD%22%2C%22EURCHF%22%2C%22EURSGD%22%2C%22EURCAD%22%2C%22EURAUD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

  val querysql = yqlhead + icbcbasicandxchangeforex

  while (isconnected) {
    //IsWorkingTime
    if (CheckIsInTradingTime) {
      val forexdatastr = yahoocollector.queryCurrencyRate(querysql)

      //      println(forexdatastr)

      val forexdatajson = parse(forexdatastr)
      parseForexData(forexdatajson)

      //mark system status 
      SaveToRedis("working", "Y")

    } else {

      SaveToRedis("working", "N")

    }
    Thread.sleep(20000)
  }

  def parseForexData(forexjasondata: JValue) = {

    implicit val formats = Serialization.formats(NoTypeHints)
    implicit def date2str(date: java.util.Date) = date.toString
    implicit def DateTime2Date(datetime: DateTime) = datetime.toDate()

    val countstr = (forexjasondata \ "query" \ "count")

    try {
      val count = compact(render(countstr)).toInt

      //      println(count + "")

      if (count > 0)
        //=========================================================================================
        for {
          forexindex <- 0 until count
        } {

          try {
            val currentjsondata = (forexjasondata \ "query" \ "results" \ "rate")(forexindex)
            val id = compact(render(currentjsondata \ "id")).replaceAll("\"", "") //String
            val Name = compact(render(currentjsondata \ "Name")).replaceAll("\"", "") //String
            val Rate = (compact(render(currentjsondata \ "Rate")).replaceAll("\"", "")).toFloat // Float
            //=========================================================================================
            val Ask = compact(render(currentjsondata \ "Ask")).replaceAll("\"", "").toFloat //Float
            val Bid = compact(render(currentjsondata \ "Bid")).replaceAll("\"", "").toFloat //Float
            //=========================================================================================
            //get GMT and NY Time 
            val gmttimestr = compact(render(forexjasondata \ "query" \ "created")).replaceAll("\"", "")
            val newyorkpricetimestr = compact(render(currentjsondata \ "Time")).replaceAll("\"", "")
            val newyorkpricedatestr = compact(render(currentjsondata \ "Date")).replaceAll("\"", "")
            val dateprocessresult = ProcessQueryPriceLocalTime(gmttimestr, newyorkpricedatestr, newyorkpricetimestr)
            //======================================================
            //build case class used to convert to json than insert to redis for cache
            //======================================================
            //produce json
            //1 generate case class ForexDataJson, this step could be ignoided 
            val forexdatajson = ForexDataJson(dateprocessresult._1, dateprocessresult._2, dateprocessresult._3, Rate, Ask, Bid)
            val forexjson = write(forexdatajson)
            SaveToRedis(id, forexjson)

            //======================================================
            //build case class used to sql
            //======================================================
            val squerylsession = getNewConnection

            try {

              //inner squeryl error catch   bindToCurrentThread

              //              squerylsession.bindToCurrentThread

              using(squerylsession) {
                val forexdata = new ForexBasicDate(forexdatajson)
                YahooForexDataSourceObject.InsertDateToTable(id, forexdata)
              }

            } catch {

              case e: RuntimeException =>
                println("level 2 squeryl error RuntimeException start")
                PrintError(e)
                println("level 2 squeryl error RuntimeException end")

              case _: Throwable =>
                println("level 2 squeryl error start")
                PrintError(_)
                println("level 2 squeryl error end")
            } finally {

              squerylsession.close

              //              squerylsession.unbindFromCurrentThread

            }

          } catch {

            // inner error catch

            //string 2 number error
            case e: NumberFormatException =>
              println("level 1 inner error NumberFormatException start")
              PrintError(e)
              println("level 1 inner error end")
            //squery connection error
            case e: com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException =>
              println("level 1 inner error MySQLSyntaxErrorException start")
              PrintError(e)
              println("level 1 inner error end")

            case e: RuntimeException =>
              println("level 1 inner error RuntimeException start")
              PrintError(e)
              println("level 1 inner error end")

            //default error
            case _: Throwable =>
              println("level 1 inner default error start")
              PrintError(_)
              println("level 1 inner default error end")
          } finally {

          }

        }

    } catch {
      //outer eeror catch

      //string 2 number error
      case e: NumberFormatException =>
        println("level 0 error NumberFormatException start")
        PrintError(e)
        println("level 0 error end")

      case _: Throwable =>
        println("level 0 default error start")
        PrintError(_)
        println("level 0 default error end")

    }
    //=========================================================================================
  }

}

