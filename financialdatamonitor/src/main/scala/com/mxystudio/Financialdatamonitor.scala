package com.mxystudio
//===================================================
import akka.actor._
import akka.pattern.ask
import akka.util.Timeout
import scala.concurrent.duration._

import akka.actor.{ Actor, ActorRef, Props, ActorSystem, ActorLogging }
//this is important
import scala.concurrent.ExecutionContext.Implicits.global
//===================================================
import com.typesafe.config.ConfigFactory
//===================================================
import com.mxystudio.subsystem.collectsystem.YahooCSVForexDownloaderSys
import com.mxystudio.subsystem.processsystem.YahooCSVForexProcessSys
import com.mxystudio.subsystem.persistentsystem.YahooCSVPersistentSys
//===================================================

//===================================================

object Financialdatamonitor extends App {

  implicit val askTimeout = Timeout(5.seconds)

  //create the root actor system
  val system = ActorSystem("RootFinancialdatamonitorSys")

  //create data persistent system
  val persistentsys = system.actorOf(Props[YahooCSVPersistentSys], "SubPersistentSys")

  //create data process system
  val processsys = system.actorOf(Props(new YahooCSVForexProcessSys(persistentsys)), "SubProcessSys")

  //create yahoo collecter

  val yahoocollectsys = system.actorOf(Props(new YahooCSVForexDownloaderSys(processsys)), "yahooCollectSys")

  //  println(collectsys.path)

  //  system.scheduler.scheduleOnce(10.seconds) {
  //    system.shutdown
  //  }

}
