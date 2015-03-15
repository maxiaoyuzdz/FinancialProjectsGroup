package com.mxystudio.subsystem.persistentsystem

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

import com.redis._

object YahooCSVRedisActor {

  case object InnerTickerObj

}

class YahooCSVRedisActor extends Actor with ActorLogging {

  import YahooCSVRedisActor._

  //===================================================
  implicit val ec = context.dispatcher
  //===================================================
  val yahooticker = context.system.scheduler.schedule(1.second, 10.second, self, InnerTickerObj)

  //  val serverip = "218.245.3.163"
  //  val serverip = "192.168.1.100"
  val serverip = "127.0.0.1"
  val redisclient = new RedisClient(serverip, 6379)

  def receive = {

    case ("SYSSTATUS", v) =>
      redisclient.set("SYSSTATUS", v)

    case InnerTickerObj =>

      val res = redisclient.get("SYSSTATUS")

      if (!redisclient.connected) {
        //if connection closed, then restart this actor
        throw new Exception
      }

    case (key, value) =>
      redisclient.set(key, value)

    case _ =>

  }

  override def postStop() = {
    yahooticker.cancel
  }

}