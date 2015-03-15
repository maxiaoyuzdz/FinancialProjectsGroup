package com.mxystudio.subsystem.persistentsystem

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
import akka.routing.RoundRobinRouter
//===================================================
//import com.mxystudio.subsystem.processsystem.ForexDataJson

object YahooCSVPersistentSys {

}

class YahooCSVPersistentSys extends Actor with ActorLogging {
  import YahooCSVPersistentSys._

  val sizeofpool = 40 //context.system.settings.config.getInt("mxy.mxystudio.subsystem.collectsystem.sizeofpool")
  //redis
  val redisrouter = context.actorOf(Props(new YahooCSVRedisActor()).withRouter(
    SmallestMailboxRouter(nrOfInstances = sizeofpool, supervisorStrategy = redisRouterStrategy)))
  //mysql
  val mysqlrouter = context.actorOf(Props(new YahooCSVMysqlActor()).withRouter(
    RoundRobinRouter(nrOfInstances = 40, supervisorStrategy = redisRouterStrategy)))

  def receive = {
    //redis
    case (key, value) =>
      redisrouter ! (key, value)

    //mysql
    case ("MYSQL", name, processres) =>
      mysqlrouter ! (name, processres)

    case _ =>
      log info ("receive unacceptable data ")

  }

  override val supervisorStrategy = OneForOneStrategy(10, 10.second) {

    case _ => Resume
  }

  val redisRouterStrategy = OneForOneStrategy() {

    case _: Exception =>
      log info ("connect error restart")
      Restart

    case _ => Resume
  }

}