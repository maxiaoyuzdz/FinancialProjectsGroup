package com.mxystudio.message

case object YahooTicker
case object YahooTicker2

case class CommandDownload(requesttype: String, url: String, parmars: String) {

}