import com.github.retronym.SbtOneJar
import sbt._
import sbt.Keys._

object FinancialdatamonitorBuild extends Build {
  
  def standardSettings = Seq(
    exportJars := true	
  ) ++ Defaults.defaultSettings
  


  lazy val financialdatamonitor = Project(
    id = "financialdatamonitor",
    base = file("."),
    
    
    
    settings = Project.defaultSettings ++ standardSettings ++ SbtOneJar.oneJarSettings ++ Seq(
      name := "financialdatamonitor",
      organization := "com.mxystudio",
      version := "0.1-SNAPSHOT",
      scalaVersion := "2.10.2",
      
      unmanagedClasspath in Runtime <<= (unmanagedClasspath in Runtime, baseDirectory) map { (cp, bd) => cp :+ Attributed.blank(bd / "src/main/resources") },
      
      
      resolvers += "Typesafe Repository" at "http://repo.typesafe.com/typesafe/releases/",
      
      

      libraryDependencies ++= Seq( 
//          "org.scalatest" % "scalatest_2.10" % "1.9.1" % "test",
          "com.typesafe.akka" % "akka-actor_2.10" % "2.1.4",
          "net.databinder.dispatch" %% "dispatch-core" % "0.11.0",
          //log
          "org.clapper" % "grizzled-slf4j_2.10" % "1.0.1",
          "org.slf4j" % "slf4j-log4j12" % "1.7.5",
//          "org.slf4j" % "slf4j-nop" % "1.6.4",
          //=======joda-time scala import======
		"com.github.nscala-time" %% "nscala-time" % "0.4.2",
		//json
		"org.json4s" %% "json4s-native" % "3.2.3",
		"org.json4s" %% "json4s-jackson" % "3.2.3",
		//mysql
		"mysql" % "mysql-connector-java" % "5.1.26"
		//anorm
//		 "play" %% "anorm" % "2.1.1",
		 //slick
//          "com.typesafe.slick" %% "slick" % "1.0.1",
//          "org.orbroker" % "orbroker_2.10" % "3.2.1-1"
         
          )
    )
  )
}
