package com.mxystudio.subsystem.collectsystem

//===================================================
import akka.actor.{
  Actor,
  ActorRef,
  Props,
  ActorSystem,
  ActorLogging,
  ActorInitializationException,
  ActorKilledException,
  OneForOneStrategy
}

import akka.actor.SupervisorStrategy._

import scala.concurrent.duration._

import akka.routing.SmallestMailboxRouter

import com.mxystudio.message.YahooTicker
//===================================================

object YahooCSVForexDownloaderSys {

  case object InnerTick
}

class YahooCSVForexDownloaderSys(processsys: ActorRef) extends Actor with ActorLogging {
  import YahooCSVForexDownloaderSys._

  //===================================================
  implicit val ec = context.dispatcher
  //===================================================
  val yahooticker = context.system.scheduler.schedule(3.second, 1.minute, self, InnerTick)

  val sizeofpool = 5 //context.system.settings.config.getInt("mxy.mxystudio.subsystem.collectsystem.sizeofyahoohttppool")

  val yahoodownloaderrouter = context.actorOf(Props(new YahooCSVForexDownloaderActor(processsys)).withRouter(
    SmallestMailboxRouter(nrOfInstances = sizeofpool, supervisorStrategy = routerStrategy)))

  def receive = {

    case InnerTick =>
      if (CheckIsInTradingTime) {
        yahoodownloaderrouter ! YahooTicker

        processsys ! ("SYSSTATUS", 1)
      } else {
        processsys ! ("SYSSTATUS", 0)

      }

  }

  override def postStop() = {
    yahooticker.cancel
  }

  override val supervisorStrategy = OneForOneStrategy(10, 10.second) {
    case _ => Resume
  }

  val routerStrategy = OneForOneStrategy() {
    case _ => Resume
  }

  def CheckIsInTradingTime() = {
    import com.github.nscala_time.time.Imports._
    import org.joda.time.chrono._
    import org.joda.time.DateTimeConstants._

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

    //    println(MONDAY)
    //
    //    println(greaterthanmon8oclock && lesserthanfri17oclock)

    greaterthanmon8oclock && lesserthanfri17oclock

  }

}