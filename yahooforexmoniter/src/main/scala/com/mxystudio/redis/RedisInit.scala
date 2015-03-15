package com.mxystudio.redis

import com.redis._

trait RedisInit {

  //  val serverip = "218.245.3.163"
  val serverip = "127.0.0.1"

  val redisclient = new RedisClient(serverip, 6379)

  def isConnected = redisclient.connected

  def SaveToRedis(key: String, value: String) = {
    //    println("set = " + value)

    redisclient.set(key, value)

    //    println("get = " + redisclient.get(key))
  }

}