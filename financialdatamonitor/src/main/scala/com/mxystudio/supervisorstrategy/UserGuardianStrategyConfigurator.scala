package com.mxystudio.supervisorstrategy

import akka.actor.SupervisorStrategyConfigurator
import akka.actor.SupervisorStrategy._
import akka.actor.SupervisorStrategy
import akka.actor.OneForOneStrategy

class UserGuardianStrategyConfigurator extends SupervisorStrategyConfigurator {

  def create(): SupervisorStrategy = {
    OneForOneStrategy() {
      case _ => Resume

    }
  }

}