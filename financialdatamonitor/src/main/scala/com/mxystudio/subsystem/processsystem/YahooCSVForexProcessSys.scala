package com.mxystudio.subsystem.processsystem
//===================================================
import akka.actor.{ Actor, ActorRef, Props, ActorSystem, ActorLogging, OneForOneStrategy }
import scala.concurrent.duration._

import akka.routing.SmallestMailboxRouter
import akka.actor.SupervisorStrategy._
//===================================================

object YahooCSVForexProcessSys {

}

class YahooCSVForexProcessSys(persistentsys: ActorRef) extends Actor with ActorLogging {
  import YahooCSVForexProcessSys._

  val sizeofpool = 40 //context.system.settings.config.getInt("mxy.mxystudio.subsystem.collectsystem.sizeofpool")

  val innerrouter = context.actorOf(Props(new YahooCSVForexProcessActor(persistentsys)).withRouter(
    SmallestMailboxRouter(nrOfInstances = sizeofpool, supervisorStrategy = routerStrategy)))

  def receive = {

    case str: String =>

      val itmelist = str.split("\n")

      for (i <- 0 until itmelist.length) {
        val item = itmelist(i)
        innerrouter ! item
      }

    case ("SYSSTATUS", v) =>
      persistentsys ! ("SYSSTATUS", v)

    case _ =>
      log info ("process sys receive unacceptable data ")

  }

  def getRouter = innerrouter

  override val supervisorStrategy = OneForOneStrategy(10, 10.second) {
    case _ => Resume
  }

  val routerStrategy = OneForOneStrategy() {
    case _ => Resume
  }

}