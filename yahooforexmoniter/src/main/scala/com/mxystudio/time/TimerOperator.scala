package com.mxystudio.time

import java.util.Date
import java.util.Calendar
import java.util.TimeZone
import java.util.Locale
import java.text.SimpleDateFormat
import java.text.DateFormat

//joda time
import com.github.nscala_time.time.Imports._
import org.joda.time.chrono._
import org.joda.time.DateTimeConstants._

trait TimerOperator {
  /**
   * local define
   */

  //==========================================================
  //new time method based on joda-time
  //==========================================================

  def CheckIsInTradingTime() = {
    val localdt = new DateTime

    val aucklanddt = localdt.withZone(DateTimeZone.forID("Pacific/Auckland"))
    //    println("auc dt = " + aucklanddt.toString())

    val chicagodt = localdt.withZone(DateTimeZone.forID("America/Chicago"))
    //    println("chi dt = " + chicagodt.toString())

    val weekdayforauc = aucklanddt.getDayOfWeek()

    val weekdayforchi = chicagodt.getDayOfWeek()

    val hourforauc = aucklanddt.getHourOfDay()

    val hourforchi = chicagodt.getHourOfDay()

    val minforchi = chicagodt.getMinuteOfHour()

    def greaterthanmon8oclock = (weekdayforauc > MONDAY) || (weekdayforauc == MONDAY && hourforauc >= 8)

    def lesserthanfri17oclock = (weekdayforchi < FRIDAY) ||
      (weekdayforchi == FRIDAY && hourforchi < 17) ||
      (weekdayforchi == FRIDAY && hourforchi == 17 && minforchi < 1) ||
      (weekdayforchi > FRIDAY && weekdayforauc == MONDAY) //resolve when mon in auc but sun in chi

    greaterthanmon8oclock && lesserthanfri17oclock

  }

  def ProcessQueryPriceLocalTime(querygmtstr: String, nydatestr: String, nytimestr: String) = {
    //===============================================================================
    val querygmtdt = new DateTime(querygmtstr, DateTimeZone.forID("Etc/GMT"))
    //===============================================================================
    //    println(querygmtdt.toDate().toString())

    val nydatearray = nydatestr.split("/").map(a => a.toInt)

    val isam = nytimestr.contains("am")

    val nytimearray = nytimestr.replace("am", "").replace("pm", "").split(":").map(a => a.toInt)

    //    println("")

    val offset = DateTimeZone.forID("America/New_York").getOffset(new DateTime());
    val offsethour = offset / (60 * 60 * 1000)

    val offserhourabs = Math.abs(offsethour)

    //    println("offsethour = " + offsethour)

    //    val nythour = if (isam) nytimearray(0) else nytimearray(0) + 12

    val nythour = if (isam) {
      if (nytimearray(0) == 12) 0
      else nytimearray(0)

    } else {
      if (nytimearray(0) == 12) nytimearray(0)
      else nytimearray(0) + 12

    }

    //2013-08-19T14:08:01Z
    val nypricetstr = nydatearray(2) + "-" + nydatearray(0) + "-" + nydatearray(1) + "T" + nythour + ":" + nytimearray(1) + ":00" + "-0" + offserhourabs + ":00" //offsethour

    //===============================================================================
    val pricenydt = new DateTime(nypricetstr, DateTimeZone.forID("America/New_York"))
    //===============================================================================
    //    println(pricenydt.toDate().toString()) //local
    //
    //    println("")

    (querygmtdt, pricenydt, new DateTime)

  }

}