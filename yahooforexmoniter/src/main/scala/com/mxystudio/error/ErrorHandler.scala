package com.mxystudio.error
import java.lang.Throwable
import org.joda.time.DateTime

trait ErrorHandler {

  def PrintError(exception: Throwable) = {
    println("Error Occured at " + new DateTime().toString())
    println("Message : " + exception.getMessage())
    println("Message : " + exception.getMessage())
    println("StackTrace Info :")
    exception.printStackTrace()

  }

}