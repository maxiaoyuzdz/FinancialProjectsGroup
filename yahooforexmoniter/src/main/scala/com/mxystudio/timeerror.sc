package com.mxystudio

import org.json4s._
import org.json4s.jackson.JsonMethods._
import org.json4s.JsonDSL._

import java.util.Date

object timeerror {
  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  
  val testtimestr = "9:20am"                      //> testtimestr  : String = 9:20am
  val testtimeformater = new java.text.SimpleDateFormat("hh:mma",java.util.Locale.US)
                                                  //> testtimeformater  : java.text.SimpleDateFormat = java.text.SimpleDateFormat@
                                                  //| b74d9147
  val timevalue = testtimeformater.parse(testtimestr)
                                                  //> timevalue  : java.util.Date = Thu Jan 01 09:20:00 CST 1970
  //java.util.Locale.US
  
  val testcase = ForexData(timevalue,3.14f,3.14f,3.14f)
                                                  //> testcase  : com.mxystudio.ForexData = ForexData(Thu Jan 01 09:20:00 CST 1970
                                                  //| ,3.14,3.14,3.14)
  /**
  val json =
  ("ForexData" ->
  	("time" -> ForexData.time)
  	
  )
  */
  
  /**
  case class Winner(time: Date, id: Long, numbers: List[Int])
  case class Lotto(time:Date, id: Long, winningNumbers: List[Int], winners: List[Winner], drawDate: Option[java.util.Date])

  val winners = List(Winner(timevalue,23, List(2, 45, 34, 23, 3, 5)), Winner(timevalue,54, List(52, 3, 12, 11, 18, 22)))
  val lotto = Lotto(timevalue, 5, List(2, 45, 34, 23, 7, 5, 3), winners, None)

  val json =
    ("lotto" ->
    	("lotto-time" -> lotto.time) ~
      ("lotto-id" -> lotto.id) ~
      ("winning-numbers" -> lotto.winningNumbers) ~
      ("draw-date" -> lotto.drawDate.map(_.toString)) ~
      ("winners" ->
        lotto.winners.map { w =>
          (("winner-id" -> w.id) ~
           ("numbers" -> w.numbers))}))

  println(compact(render(json)))
  */
  

  
  
}