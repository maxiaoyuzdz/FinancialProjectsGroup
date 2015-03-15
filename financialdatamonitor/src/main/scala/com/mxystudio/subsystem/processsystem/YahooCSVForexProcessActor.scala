package com.mxystudio.subsystem.processsystem

//===================================================
import akka.actor.{ Actor, ActorRef, Props, ActorSystem, ActorLogging }
import scala.concurrent.duration._
//===================================================
import java.util.Date
import com.github.nscala_time.time.Imports._
import org.joda.time.chrono._
import org.joda.time.DateTimeConstants._

import org.json4s._
import org.json4s.native.Serialization
import org.json4s.native.Serialization.{ read, write }

case class ForexDataJson(name: String, nylasttradedt: Date, bjquerytime: Date, rate: Float, ask: Float, bid: Float)

object YahooCSVForexProcessActor {

}

class YahooCSVForexProcessActor(persistentsys: ActorRef) extends Actor with ActorLogging {

  implicit val formats = Serialization.formats(NoTypeHints)
  implicit def date2str(date: java.util.Date) = date.toString
  implicit def DateTime2Date(datetime: DateTime) = datetime.toDate()

  def receive = {
    case item: String =>

      val objarray = item.replace("=X", "").replaceAll("\"", "").split(",")
      //0 name e
      val name = objarray(0)

      //1 rate
      val rate = objarray(1).toFloat
      //2 date
      //      val datestr = objarray(2)

      //2 time
      val timestr = objarray(2)

      //3 ask
      val ask = objarray(3).toFloat

      //4 bid
      val bid = objarray(4).toFloat

      val isam = timestr.contains("am")

      val nytimearray = timestr.replace("am", "").replace("pm", "").split(":").map(a => a.toInt)

      //      val offset = DateTimeZone.forID("America/New_York").getOffset(new DateTime());
      //      val offsethour = offset / (60 * 60 * 1000)
      //      val offserhourabs = Math.abs(offsethour)
      //
      //      val testofset = (DateTimeZone.forID("America/New_York").getOffset(new DateTime())) / (60 * 60 * 1000)

      val offserhourabs = Math.abs((DateTimeZone.forID("America/New_York").getOffset(new DateTime())) / (60 * 60 * 1000))

      val nythour = if (isam) {
        if (nytimearray(0) == 12) 0
        else nytimearray(0)

      } else {
        if (nytimearray(0) == 12) nytimearray(0)
        else nytimearray(0) + 12

      }
      //===============================================================================
      val localdt = new DateTime
      //===============================================================================
      val nylasttradetimestr = nythour + ":" + nytimearray(1) + ":00"
      val NYLocaldt = localdt.withZone(DateTimeZone.forID("America/New_York"))
      val nylastradedatetimestr = NYLocaldt.toString("yyyy-MM-dd") + "T" + nylasttradetimestr + "-0" + offserhourabs + ":00" //offsethour

      val nylasttradeDT = new DateTime(nylastradedatetimestr, DateTimeZone.forID("America/New_York"))

      val processres = ForexDataJson(name, nylasttradeDT, new DateTime, rate, ask, bid) // to mysql

      val forexjson = write(processres) // to redis
      //===============================================================================
      val NYLocalTimeString = NYLocaldt.toString("yyyy-MM-dd") + " " + nylasttradetimestr
      val BJLocalTimeString = (new DateTime).toString("yyyy-MM-dd HH:mm:ss")
      //===============================================================================

      persistentsys ! (name + "_json", forexjson)
      persistentsys ! (name + "_rate", rate)
      persistentsys ! (name + "_ask", ask)
      persistentsys ! (name + "_bid", bid)

      persistentsys ! ("MYSQL", name, (NYLocalTimeString, BJLocalTimeString, rate + "", ask + "", bid + ""))

      //calculate the return rates and ask and bid
      val reposiname = name.substring(3, 6) + name.substring(0, 3)
      persistentsys ! (reposiname + "_rate", 1.0f / rate)
      persistentsys ! (reposiname + "_ask", 1.0f / bid)
      persistentsys ! (reposiname + "_bid", 1.0f / ask)

  }

}