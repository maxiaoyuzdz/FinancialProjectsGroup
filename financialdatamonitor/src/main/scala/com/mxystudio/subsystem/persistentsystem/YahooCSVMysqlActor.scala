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

//import com.mxystudio.subsystem.processsystem.ForexDataJson
//===================================================
import java.sql.{ Connection, DriverManager, ResultSet }
//===================================================
import org.json4s._
import org.json4s.native.Serialization
import org.json4s.native.Serialization.{ write }

object YahooCSVMysqlActor {
  case object InnerTickerObj

  //  val dbaddress = "218.245.3.163"

  //  val dbaddress = "192.168.1.100"
  val dbuser = "root"
  val dbpwd = "zdz5973781"

  val dbaddress = "127.0.0.1"
  //  val dbuser = "root"
  //  val dbpwd = "root"

  val dburl = "jdbc:mysql://" + dbaddress + ":3306/forexdb"

  val insertsqltemple = """
INSERT INTO `forexdb`.`[TB]` 
	(`id`, 
	`nypricetime`, 
	`bjquerytime`, 
	`rate`, 
	`ask`, 
	`bid`
	)
	VALUES
	('0', 
	'[NYT] ', 
	'[BJT] ', 
	'[RV]', 
	'[AV]', 
	'[BV]'
	);
"""
}

class YahooCSVMysqlActor extends Actor with ActorLogging {
  import YahooCSVMysqlActor._
  implicit val formats = Serialization.formats(NoTypeHints)

  val ds = new com.mysql.jdbc.jdbc2.optional.MysqlDataSource
  ds.setUrl(dburl)
  ds.setUser(dbuser)
  ds.setPassword(dbpwd)
  val conn = ds.getConnection()

  //===================================================
  implicit val ec = context.dispatcher
  //===================================================
  val yahooticker = context.system.scheduler.schedule(1.second, 30.second, self, InnerTickerObj)

  //  override def preStart() = {
  //
  //  }

  def receive = {
    //check connection
    case InnerTickerObj => {
      if (conn.isClosed())
        println("conn closed")
      else {
        val statement = conn.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY)

        val rs = statement.executeQuery("SELECT 1 AS cc")
        while (rs.next) {
          val rss = rs.getInt("cc")
        }
        statement.close()
      }
    }
    case (name: String, (nyts: String, bjts: String, rate: String, ask: String, bid: String)) => {

      val sql1 = insertsqltemple.replace("[TB]", name.toLowerCase()).replace("[NYT]", nyts).replace("[BJT]", bjts).replace("[RV]", rate).replace("[AV]", ask).replace("[BV]", bid)

      //      println(sql1)

      val prep = conn.prepareStatement(sql1)

      prep.executeUpdate

      //      prep.clearParameters()

      //      conn.commit()

      prep.close()

    }

    case _ =>

  }

  override def postStop() = {
    //stop ticker
    yahooticker.cancel
    //close connection
    conn.close()
    //    sess.close
  }

}