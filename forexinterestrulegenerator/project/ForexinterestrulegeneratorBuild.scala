import sbt._
import sbt.Keys._

object ForexinterestrulegeneratorBuild extends Build {

  lazy val forexinterestrulegenerator = Project(
    id = "forexinterestrulegenerator",
    base = file("."),
    settings = Project.defaultSettings ++ Seq(
      name := "ForexInterestRuleGenerator",
      organization := "com.mxystudio",
      version := "0.1-SNAPSHOT",
      scalaVersion := "2.10.2",
      // add other settings here
            libraryDependencies ++= Seq( 

          //log
          "org.clapper" % "grizzled-slf4j_2.10" % "1.0.1",
          "org.slf4j" % "slf4j-log4j12" % "1.7.5"
         
          )
      
    )
  )
}
