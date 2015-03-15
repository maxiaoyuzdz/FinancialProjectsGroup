package com.mxystudio.datebase

import com.mchange.v2.c3p0.ComboPooledDataSource
import org.squeryl.adapters.MySQLAdapter
import org.squeryl.Session
import org.squeryl.SessionFactory
import org.slf4j.LoggerFactory

trait DatabaseInit {
  val logger = LoggerFactory.getLogger(getClass)

  val dbaddress = "127.0.0.1"
  //  val dbaddress = "218.245.3.163"

  //  val databaseUsername = "root"
  //  val databasePassword = "root"
  val databaseConnection = "jdbc:mysql://" + dbaddress + ":3306/forexdb"

  val databaseUsername = "root"
  val databasePassword = "zdz5973781"
  //  val databaseConnection = "jdbc:mysql://" + dbaddress + ":3306/forexdb"

  var cpds = new ComboPooledDataSource

  def ConfigureDb() {
    cpds.setDriverClass("com.mysql.jdbc.Driver")
    cpds.setJdbcUrl(databaseConnection)
    cpds.setUser(databaseUsername)
    cpds.setPassword(databasePassword)

    cpds.setMinPoolSize(10)
    cpds.setAcquireIncrement(10)
    cpds.setMaxPoolSize(500)

    cpds.setIdleConnectionTestPeriod(60)

    cpds.setMaxIdleTime(2500)

    SessionFactory.concreteFactory = Some(() => getNewConnection)

    /**
     * create test session
     */
    logger.info("Creating connection with c3po connection pool")
    Session.create(cpds.getConnection, new MySQLAdapter)
    println("DB connect start ok")

  }

  def getNewConnection = {
    logger.info("Creating connection with c3po connection pool")
    Session.create(cpds.getConnection, new MySQLAdapter)
  }

  def closeDbConnection() {
    logger.info("Closing c3po connection pool")
    cpds.close()
  }

}