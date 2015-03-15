import com.github.retronym.SbtOneJar
import sbt._
import sbt.Keys._





object YahooforexmoniterBuild extends Build {
  def standardSettings = Seq(
    exportJars := true
	
  ) ++ Defaults.defaultSettings



  lazy val yahooforexmoniter = Project(
    id = "yahooforexmoniter",
    base = file("."),
	
    settings = Project.defaultSettings ++ SbtOneJar.oneJarSettings ++ Seq(
	
	
	
      name := "YahooForexMoniter",
      organization := "com.mxystudio",
      version := "0.1-SNAPSHOT",
      scalaVersion := "2.10.2",
      // add other settings here
	  resolvers += "rediscala" at "https://github.com/etaty/rediscala-mvn/raw/master/snapshots/",
	  resolvers += "Typesafe repository" at "http://repo.typesafe.com/typesafe/releases/",
	  libraryDependencies ++= Seq(
		"commons-codec" % "commons-codec" % "1.6",
		//log
		"org.clapper" % "grizzled-slf4j_2.10" % "1.0.1",
		"org.slf4j" % "slf4j-log4j12" % "1.7.5",
		//akka redis client
		"com.etaty.rediscala" %% "rediscala" % "0.6-SNAPSHOT",
		//json
		"org.json4s" %% "json4s-native" % "3.2.3",
		"org.json4s" %% "json4s-jackson" % "3.2.3",
		//end
		//===============sql=====================================
		"org.squeryl" %% "squeryl" % "0.9.5-6", 
		"mysql" % "mysql-connector-java" % "5.1.10",      // for MySQL, or use  5.1.10  5.1.22
		"c3p0" % "c3p0" % "0.9.1.2",
		//=======joda-time scala import======
		"com.github.nscala-time" %% "nscala-time" % "0.4.2"
		
		
		
	  )
    )
  )
}
