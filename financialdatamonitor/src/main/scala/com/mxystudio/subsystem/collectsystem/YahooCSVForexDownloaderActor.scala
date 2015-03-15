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

import dispatch._, Defaults._
//===================================================
object YahooCSVForexDownloaderActor {

}

class YahooCSVForexDownloaderActor(processsys: ActorRef) extends Actor with ActorLogging {
  import YahooCSVForexDownloaderActor._

  def receive = {

    case YahooTicker =>
      val myhttpsource = url("http://download.finance.yahoo.com/d/quotes.csv?s=GBPUSD=X+GBPCHF=X+GBPCAD=X+GBPAUD=X+GBPEUR=X+GBPJPY=X+GBPSGD=X+USDCHF=X+USDCAD=X+USDAUD=X+USDEUR=X+USDJPY=X+USDSGD=X+CHFCAD=X+CHFAUD=X+CHFEUR=X+CHFJPY=X+CHFSGD=X+CADAUD=X+CADEUR=X+CADJPY=X+CADSGD=X+AUDEUR=X+AUDJPY=X+AUDSGD=X+EURJPY=X+EURSGD=X+JPYSGD=X&f=sl1t1a0b0&e=.csv")
      Http(myhttpsource OK as.Bytes) map { (bytes => processsys ! (new String(bytes, "UTF-8"))) }

    case _ =>

  }

}