package com.mxystudio

import com.redis._

object Forexinterestrulegenerator extends App {

  println("ok")
  //  val serverip = "218.245.3.163"
  val serverip = "192.168.1.100"
  val redisclient = new RedisClient(serverip, 6379)

  /**
   * coda data
   */
  //=========================================

  //GBPGBP
  val GBPGBP = 1.0f
  val GBPGBP_ASK = 1.0f
  val GBPGBP_BID = 1.0f

  //GBPUSD
  val GBPUSDOPT = redisclient.get("GBPUSD_rate")

  val GBPUSD = GBPUSDOPT.get.toFloat

  val GBPUSDOPTA = redisclient.get("GBPUSD_ask")
  val GBPUSDOPTB = redisclient.get("GBPUSD_bid")
  val GBPUSD_ASK = GBPUSDOPTA.get.toFloat
  val GBPUSD_BID = GBPUSDOPTB.get.toFloat
  //GBPCHF
  val GBPCHFOPT = redisclient.get("GBPCHF_rate")
  val GBPCHF = GBPCHFOPT.get.toFloat

  val GBPCHF_A = redisclient.get("GBPCHF_ask")
  val GBPCHF_B = redisclient.get("GBPCHF_bid")
  val GBPCHF_ASK = GBPCHF_A.get.toFloat
  val GBPCHF_BID = GBPCHF_B.get.toFloat

  //GBPCAD
  val GBPCADOPT = redisclient.get("GBPCAD_rate")
  val GBPCAD = GBPCADOPT.get.toFloat

  val GBPCAD_A = redisclient.get("GBPCAD_ask")
  val GBPCAD_B = redisclient.get("GBPCAD_bid")
  val GBPCAD_ASK = GBPCAD_A.get.toFloat
  val GBPCAD_BID = GBPCAD_B.get.toFloat

  //GBPAUD

  val GBPAUDOPT = redisclient.get("GBPAUD_rate")
  val GBPAUD = GBPAUDOPT.get.toFloat

  val GBPAUD_A = redisclient.get("GBPAUD_ask")
  val GBPAUD_B = redisclient.get("GBPAUD_bid")
  val GBPAUD_ASK = GBPAUD_A.get.toFloat
  val GBPAUD_BID = GBPAUD_B.get.toFloat

  //GBPEUR
  val GBPEUROPT = redisclient.get("GBPEUR_rate")
  val GBPEUR = GBPEUROPT.get.toFloat

  val GBPEUR_A = redisclient.get("GBPEUR_ask")
  val GBPEUR_B = redisclient.get("GBPEUR_bid")
  val GBPEUR_ASK = GBPEUR_A.get.toFloat
  val GBPEUR_BID = GBPEUR_B.get.toFloat

  //GBPJPY
  val GBPJPYOPT = redisclient.get("GBPJPY_rate")
  val GBPJPY = GBPJPYOPT.get.toFloat

  val GBPJPY_A = redisclient.get("GBPJPY_ask")
  val GBPJPY_B = redisclient.get("GBPJPY_bid")
  val GBPJPY_ASK = GBPJPY_A.get.toFloat
  val GBPJPY_BID = GBPJPY_B.get.toFloat

  //GBPSGD
  val GBPSGDOPT = redisclient.get("GBPSGD_rate")
  val GBPSGD = GBPSGDOPT.get.toFloat

  val GBPSGD_A = redisclient.get("GBPSGD_ask")
  val GBPSGD_B = redisclient.get("GBPSGD_bid")
  val GBPSGD_ASK = GBPSGD_A.get.toFloat
  val GBPSGD_BID = GBPSGD_B.get.toFloat

  //=========================================

  //USDGBP
  val USDGBP = 1.0f / GBPUSD

  val USDGBP_ASK = 1.0f / GBPUSD_BID
  val USDGBP_BID = 1.0f / GBPUSD_ASK

  //USDUSD
  val USDUSD = 1.0f

  val USDUSD_ASK = 1.0f
  val USDUSD_BID = 1.0f

  //USDCHF
  val USDCHFOPT = redisclient.get("USDCHF_rate")
  val USDCHF = USDCHFOPT.get.toFloat

  val USDCHF_A = redisclient.get("USDCHF_ask")
  val USDCHF_B = redisclient.get("USDCHF_bid")
  val USDCHF_ASK = USDCHF_A.get.toFloat
  val USDCHF_BID = USDCHF_B.get.toFloat

  //USDCAD
  val USDCADOPT = redisclient.get("USDCAD_rate")
  val USDCAD = USDCADOPT.get.toFloat

  val USDCAD_A = redisclient.get("USDCAD_ask")
  val USDCAD_B = redisclient.get("USDCAD_bid")
  val USDCAD_ASK = USDCAD_A.get.toFloat
  val USDCAD_BID = USDCAD_B.get.toFloat

  //USDAUD
  val USDAUDOPT = redisclient.get("USDAUD_rate")
  val USDAUD = USDAUDOPT.get.toFloat

  val USDAUD_A = redisclient.get("USDAUD_ask")
  val USDAUD_B = redisclient.get("USDAUD_bid")
  val USDAUD_ASK = USDAUD_A.get.toFloat
  val USDAUD_BID = USDAUD_B.get.toFloat

  //USDEUR
  val USDEUROPT = redisclient.get("USDEUR_rate")
  val USDEUR = USDEUROPT.get.toFloat

  val USDEUR_A = redisclient.get("USDEUR_ask")
  val USDEUR_B = redisclient.get("USDEUR_bid")
  val USDEUR_ASK = USDEUR_A.get.toFloat
  val USDEUR_BID = USDEUR_B.get.toFloat

  //USDJPY
  val USDJPYOPT = redisclient.get("USDJPY_rate")
  val USDJPY = USDJPYOPT.get.toFloat

  val USDJPY_A = redisclient.get("USDJPY_ask")
  val USDJPY_B = redisclient.get("USDJPY_bid")
  val USDJPY_ASK = USDJPY_A.get.toFloat
  val USDJPY_BID = USDJPY_B.get.toFloat

  //USDSGD
  val USDSGDOPT = redisclient.get("USDSGD_rate")
  val USDSGD = USDSGDOPT.get.toFloat

  val USDSGD_A = redisclient.get("USDSGD_ask")
  val USDSGD_B = redisclient.get("USDSGD_bid")
  val USDSGD_ASK = USDSGD_A.get.toFloat
  val USDSGD_BID = USDSGD_B.get.toFloat

  //=========================================

  //CHFGBP
  val CHFGBP = 1.0f / GBPCHF

  val CHFGBP_ASK = 1.0f / GBPCHF_BID
  val CHFGBP_BID = 1.0f / GBPCHF_ASK

  //CHFUSD
  val CHFUSD = 1.0f / USDCHF

  val CHFUSD_ASK = 1.0f / USDCHF_BID
  val CHFUSD_BID = 1.0f / USDCHF_ASK

  //CHFCHF
  val CHFCHF = 1.0f

  val CHFCHF_ASK = 1.0f
  val CHFCHF_BID = 1.0f

  //CHFCAD
  val CHFCADOPT = redisclient.get("CHFCAD_rate")
  val CHFCAD = CHFCADOPT.get.toFloat

  val CHFCAD_A = redisclient.get("CHFCAD_ask")
  val CHFCAD_B = redisclient.get("CHFCAD_bid")
  val CHFCAD_ASK = CHFCAD_A.get.toFloat
  val CHFCAD_BID = CHFCAD_B.get.toFloat

  //CHFAUD
  val CHFAUDOPT = redisclient.get("CHFAUD_rate")
  val CHFAUD = CHFAUDOPT.get.toFloat

  val CHFAUD_A = redisclient.get("CHFAUD_ask")
  val CHFAUD_B = redisclient.get("CHFAUD_bid")
  val CHFAUD_ASK = CHFAUD_A.get.toFloat
  val CHFAUD_BID = CHFAUD_B.get.toFloat

  //CHFEUR
  val CHFEUROPT = redisclient.get("CHFEUR_rate")
  val CHFEUR = CHFEUROPT.get.toFloat

  val CHFEUR_A = redisclient.get("CHFEUR_ask")
  val CHFEUR_B = redisclient.get("CHFEUR_bid")
  val CHFEUR_ASK = CHFEUR_A.get.toFloat
  val CHFEUR_BID = CHFEUR_B.get.toFloat

  //CHFJPY
  val CHFJPYOPT = redisclient.get("CHFJPY_rate")
  val CHFJPY = CHFJPYOPT.get.toFloat

  val CHFJPY_A = redisclient.get("CHFJPY_ask")
  val CHFJPY_B = redisclient.get("CHFJPY_bid")
  val CHFJPY_ASK = CHFJPY_A.get.toFloat
  val CHFJPY_BID = CHFJPY_B.get.toFloat

  //CHFSGD
  val CHFSGDOPT = redisclient.get("CHFSGD_rate")
  val CHFSGD = CHFSGDOPT.get.toFloat

  val CHFSGD_A = redisclient.get("CHFSGD_ask")
  val CHFSGD_B = redisclient.get("CHFSGD_bid")
  val CHFSGD_ASK = CHFSGD_A.get.toFloat
  val CHFSGD_BID = CHFSGD_B.get.toFloat

  //=========================================

  //CADGBP
  val CADGBP = 1.0f / GBPCAD

  val CADGBP_ASK = 1.0f / GBPCAD_BID
  val CADGBP_BID = 1.0f / GBPCAD_ASK

  //CADUSD
  val CADUSD = 1.0f / USDCAD

  val CADUSD_ASK = 1.0f / USDCAD_BID
  val CADUSD_BID = 1.0f / USDCAD_ASK

  //CADCHF
  val CADCHF = 1.0f / CHFCAD

  val CADCHF_ASK = 1.0f / CHFCAD_BID
  val CADCHF_BID = 1.0f / CHFCAD_ASK

  //CADCAD
  val CADCAD = 1.0f

  val CADCAD_ASK = 1.0f
  val CADCAD_BID = 1.0f

  //CADAUD
  val CADAUDOPT = redisclient.get("CADAUD_rate")
  val CADAUD = CADAUDOPT.get.toFloat

  val CADAUD_A = redisclient.get("CADAUD_ask")
  val CADAUD_B = redisclient.get("CADAUD_bid")
  val CADAUD_ASK = CADAUD_A.get.toFloat
  val CADAUD_BID = CADAUD_B.get.toFloat

  //CADEUR
  val CADEUROPT = redisclient.get("CADEUR_rate")
  val CADEUR = CADEUROPT.get.toFloat

  val CADEUR_A = redisclient.get("CADEUR_ask")
  val CADEUR_B = redisclient.get("CADEUR_bid")
  val CADEUR_ASK = CADEUR_A.get.toFloat
  val CADEUR_BID = CADEUR_B.get.toFloat

  //CADJPY
  val CADJPYOPT = redisclient.get("CADJPY_rate")
  val CADJPY = CADJPYOPT.get.toFloat

  val CADJPY_A = redisclient.get("CADJPY_ask")
  val CADJPY_B = redisclient.get("CADJPY_bid")
  val CADJPY_ASK = CADJPY_A.get.toFloat
  val CADJPY_BID = CADJPY_B.get.toFloat

  //CADSGD
  val CADSGDOPT = redisclient.get("CADSGD_rate")
  val CADSGD = CADSGDOPT.get.toFloat

  val CADSGD_A = redisclient.get("CADSGD_ask")
  val CADSGD_B = redisclient.get("CADSGD_bid")
  val CADSGD_ASK = CADSGD_A.get.toFloat
  val CADSGD_BID = CADSGD_B.get.toFloat

  //=========================================

  //AUDGBP
  val AUDGBP = 1.0f / GBPAUD

  val AUDGBP_ASK = 1.0f / GBPAUD_BID
  val AUDGBP_BID = 1.0f / GBPAUD_ASK

  //AUDUSD
  val AUDUSD = 1.0f / USDAUD

  val AUDUSD_ASK = 1.0f / USDAUD_BID
  val AUDUSD_BID = 1.0f / USDAUD_ASK

  //AUDCHF
  val AUDCHF = 1.0f / CHFAUD

  val AUDCHF_ASK = 1.0f / CHFAUD_BID
  val AUDCHF_BID = 1.0f / CHFAUD_ASK

  //ADUCAD
  val AUDCAD = 1.0f / CADAUD

  val AUDCAD_ASK = 1.0f / CADAUD_BID
  val AUDCAD_BID = 1.0f / CADAUD_ASK

  //AUDAUD
  val AUDAUD = 1.0f

  val AUDAUD_ASK = 1.0f
  val AUDAUD_BID = 1.0f

  //AUDEUR
  val AUDEUROPT = redisclient.get("AUDEUR_rate")
  val AUDEUR = AUDEUROPT.get.toFloat

  val AUDEUR_A = redisclient.get("AUDJPY_ask")
  val AUDEUR_B = redisclient.get("AUDEUR_bid")
  val AUDEUR_ASK = AUDEUR_A.get.toFloat
  val AUDEUR_BID = AUDEUR_B.get.toFloat

  //AUDJPY
  val AUDJPYOPT = redisclient.get("AUDJPY_rate")
  val AUDJPY = AUDJPYOPT.get.toFloat

  val AUDJPY_A = redisclient.get("AUDJPY_ask")
  val AUDJPY_B = redisclient.get("AUDJPY_bid")
  val AUDJPY_ASK = AUDJPY_A.get.toFloat
  val AUDJPY_BID = AUDJPY_B.get.toFloat

  //AUDSGD
  val AUDSGDOPT = redisclient.get("AUDSGD_rate")
  val AUDSGD = AUDSGDOPT.get.toFloat

  val AUDSGD_A = redisclient.get("AUDSGD_ask")
  val AUDSGD_B = redisclient.get("AUDSGD_bid")
  val AUDSGD_ASK = AUDSGD_A.get.toFloat
  val AUDSGD_BID = AUDSGD_B.get.toFloat

  //=========================================

  //EURGBP
  val EURGBP = 1.0f / GBPEUR

  val EURGBP_ASK = 1.0f / GBPEUR_BID
  val EURGBP_BID = 1.0f / GBPEUR_ASK

  //EURUSD
  val EURUSD = 1.0f / USDEUR

  val EURUSD_ASK = 1.0f / USDEUR_BID
  val EURUSD_BID = 1.0f / USDEUR_ASK

  //EURCHF
  val EURCHF = 1.0f / CHFEUR

  val EURCHF_ASK = 1.0f / CHFEUR_BID
  val EURCHF_BID = 1.0f / CHFEUR_ASK

  //EURCAD
  val EURCAD = 1.0f / CADEUR

  val EURCAD_ASK = 1.0f / CADEUR_BID
  val EURCAD_BID = 1.0f / CADEUR_ASK

  //EURAUD
  val EURAUD = 1.0f / AUDEUR

  val EURAUD_ASK = 1.0f / AUDEUR_BID
  val EURAUD_BID = 1.0f / AUDEUR_ASK

  //EUREUR
  val EUREUR = 1.0f

  val EUREUR_ASK = 1.0f
  val EUREUR_BID = 1.0f

  //EURJPY
  val EURJPYOPT = redisclient.get("EURJPY_rate")
  val EURJPY = EURJPYOPT.get.toFloat

  val EURJPY_A = redisclient.get("EURJPY_ask")
  val EURJPY_B = redisclient.get("EURJPY_bid")
  val EURJPY_ASK = EURJPY_A.get.toFloat
  val EURJPY_BID = EURJPY_B.get.toFloat

  //EURSGD
  val EURSGDOPT = redisclient.get("EURSGD_rate")
  val EURSGD = EURSGDOPT.get.toFloat

  val EURSGD_A = redisclient.get("EURSGD_ask")
  val EURSGD_B = redisclient.get("EURSGD_bid")
  val EURSGD_ASK = EURSGD_A.get.toFloat
  val EURSGD_BID = EURSGD_B.get.toFloat
  //=========================================

  //JPYGBP
  val JPYGBP = 1.0f / GBPJPY

  val JPYGBP_ASK = 1.0f / GBPJPY_BID
  val JPYGBP_BID = 1.0f / GBPJPY_ASK

  //JPYUSD
  val JPYUSD = 1.0f / USDJPY

  val JPYUSD_ASK = 1.0f / USDJPY_BID
  val JPYUSD_BID = 1.0f / USDJPY_ASK

  //JPYCHF
  val JPYCHF = 1.0f / CHFJPY

  val JPYCHF_ASK = 1.0f / CHFJPY_BID
  val JPYCHF_BID = 1.0f / CHFJPY_ASK

  //JPYCAD
  val JPYCAD = 1.0f / CADJPY

  val JPYCAD_ASK = 1.0f / CADJPY_BID
  val JPYCAD_BID = 1.0f / CADJPY_ASK

  //JPYAUD
  val JPYAUD = 1.0f / AUDJPY

  val JPYAUD_ASK = 1.0f / AUDJPY_BID
  val JPYAUD_BID = 1.0f / AUDJPY_ASK

  //JPYEUR
  val JPYEUR = 1.0f / EURJPY

  val JPYEUR_ASK = 1.0f / EURJPY_BID
  val JPYEUR_BID = 1.0f / EURJPY_ASK

  //JPYJPY
  val JPYJPY = 1.0f

  val JPYJPY_ASK = 1.0f
  val JPYJPY_BID = 1.0f
  //JPYSGD
  val JPYSGDOPT = redisclient.get("JPYSGD_rate")
  val JPYSGD = JPYSGDOPT.get.toFloat

  val JPYSGD_A = redisclient.get("JPYSGD_ask")
  val JPYSGD_B = redisclient.get("JPYSGD_bid")
  val JPYSGD_ASK = JPYSGD_A.get.toFloat
  val JPYSGD_BID = JPYSGD_B.get.toFloat
  //=========================================
  //SGDGBP
  val SGDGBP = 1.0f / GBPSGD

  val SGDGBP_ASK = 1.0f / GBPSGD_BID
  val SGDGBP_BID = 1.0f / GBPSGD_ASK

  //SGDUSD
  val SGDUSD = 1.0f / USDSGD

  val SGDUSD_ASK = 1.0f / USDSGD_BID
  val SGDUSD_BID = 1.0f / USDSGD_ASK
  //SGDCHF
  val SGDCHF = 1.0f / CHFSGD

  val SGDCHF_ASK = 1.0f / CHFSGD_BID
  val SGDCHF_BID = 1.0f / CHFSGD_ASK
  //SGDCAD
  val SGDCAD = 1.0f / CADSGD

  val SGDCAD_ASK = 1.0f / CADSGD_BID
  val SGDCAD_BID = 1.0f / CADSGD_ASK
  //SGDAUD
  val SGDAUD = 1.0f / AUDSGD

  val SGDAUD_ASK = 1.0f / AUDSGD_BID
  val SGDAUD_BID = 1.0f / AUDSGD_ASK
  //SGDEUR
  val SGDEUR = 1.0f / EURSGD

  val SGDEUR_ASK = 1.0f / EURSGD_BID
  val SGDEUR_BID = 1.0f / EURSGD_ASK
  //SGDJPY
  val SGDJPY = 1.0f / JPYSGD

  val SGDJPY_ASK = 1.0f / JPYSGD_BID
  val SGDJPY_BID = 1.0f / JPYSGD_ASK
  //SGDSGD
  val SGDSGD = 1.0f

  val SGDSGD_ASK = 1.0f
  val SGDSGD_BID = 1.0f
  //=========================================

  val ratelist = List(
    GBPGBP, GBPUSD, GBPCHF, GBPCAD, GBPAUD, GBPEUR, GBPJPY, GBPSGD,
    USDGBP, USDUSD, USDCHF, USDCAD, USDAUD, USDEUR, USDJPY, USDSGD,
    CHFGBP, CHFUSD, CHFCHF, CHFCAD, CHFAUD, CHFEUR, CHFJPY, CHFSGD,
    CADGBP, CADUSD, CADCHF, CADCAD, CADAUD, CADEUR, CADJPY, CADSGD,
    AUDGBP, AUDUSD, AUDCHF, AUDCAD, AUDAUD, AUDEUR, AUDJPY, AUDSGD,
    EURGBP, EURUSD, EURCHF, EURCAD, EURAUD, EUREUR, EURJPY, EURSGD,
    JPYGBP, JPYUSD, JPYCHF, JPYCAD, JPYAUD, JPYEUR, JPYJPY, JPYSGD,
    SGDGBP, SGDUSD, SGDCHF, SGDCAD, SGDAUD, SGDEUR, SGDJPY, SGDSGD)

  val asklist = List(
    GBPGBP_ASK, GBPUSD_ASK, GBPCHF_ASK, GBPCAD_ASK, GBPAUD_ASK, GBPEUR_ASK, GBPJPY_ASK, GBPSGD_ASK,
    USDGBP_ASK, USDUSD_ASK, USDCHF_ASK, USDCAD_ASK, USDAUD_ASK, USDEUR_ASK, USDJPY_ASK, USDSGD_ASK,
    CHFGBP_ASK, CHFUSD_ASK, CHFCHF_ASK, CHFCAD_ASK, CHFAUD_ASK, CHFEUR_ASK, CHFJPY_ASK, CHFSGD_ASK,
    CADGBP_ASK, CADUSD_ASK, CADCHF_ASK, CADCAD_ASK, CADAUD_ASK, CADEUR_ASK, CADJPY_ASK, CADSGD_ASK,
    AUDGBP_ASK, AUDUSD_ASK, AUDCHF_ASK, AUDCAD_ASK, AUDAUD_ASK, AUDEUR_ASK, AUDJPY_ASK, AUDSGD_ASK,
    EURGBP_ASK, EURUSD_ASK, EURCHF_ASK, EURCAD_ASK, EURAUD_ASK, EUREUR_ASK, EURJPY_ASK, EURSGD_ASK,
    JPYGBP_ASK, JPYUSD_ASK, JPYCHF_ASK, JPYCAD_ASK, JPYAUD_ASK, JPYEUR_ASK, JPYJPY_ASK, JPYSGD_ASK,
    SGDGBP_ASK, SGDUSD_ASK, SGDCHF_ASK, SGDCAD_ASK, SGDAUD_ASK, SGDEUR_ASK, SGDJPY_ASK, SGDSGD_ASK)

  val bidlist = List(
    GBPGBP_BID, GBPUSD_BID, GBPCHF_BID, GBPCAD_BID, GBPAUD_BID, GBPEUR_BID, GBPJPY_BID, GBPSGD_BID,
    USDGBP_BID, USDUSD_BID, USDCHF_BID, USDCAD_BID, USDAUD_BID, USDEUR_BID, USDJPY_BID, USDSGD_BID,
    CHFGBP_BID, CHFUSD_BID, CHFCHF_BID, CHFCAD_BID, CHFAUD_BID, CHFEUR_BID, CHFJPY_BID, CHFSGD_BID,
    CADGBP_BID, CADUSD_BID, CADCHF_BID, CADCAD_BID, CADAUD_BID, CADEUR_BID, CADJPY_BID, CADSGD_BID,
    AUDGBP_BID, AUDUSD_BID, AUDCHF_BID, AUDCAD_BID, AUDAUD_BID, AUDEUR_BID, AUDJPY_BID, AUDSGD_BID,
    EURGBP_BID, EURUSD_BID, EURCHF_BID, EURCAD_BID, EURAUD_BID, EUREUR_BID, EURJPY_BID, EURSGD_BID,
    JPYGBP_BID, JPYUSD_BID, JPYCHF_BID, JPYCAD_BID, JPYAUD_BID, JPYEUR_BID, JPYJPY_BID, JPYSGD_BID,
    SGDGBP_BID, SGDUSD_BID, SGDCHF_BID, SGDCAD_BID, SGDAUD_BID, SGDEUR_BID, SGDJPY_BID, SGDSGD_BID)

  //  println(ratelist.toString)

  val t = compute(0)

  println(t.toString)

  def compute(door: Int): (Float, String, List[Int]) = {

    var finalres = 100.0f

    var finalpathstr = ""

    var finalpathlist = List(99)

    val pp = List(0, 1, 2, 3, 4, 5, 6, 7).filter(a => a != door)
    //zuhe filter(a => a != door)
    val patheumnlist = pp.toSet[Int].subsets.map(_.toList).toList

    for (pathemu <- patheumnlist) {

      //quan pai lie
      val pathlist = pathemu.permutations

      //each pailie
      for (path <- pathlist) {
        //[1 2 3  4 1]
        val pathforonecompute = List(door) ::: path ::: List(door) ::: Nil

        val pathlength = pathforonecompute.length

        /**
         * compute
         */

        var cres = 100.0f
        for (i <- 0 until (pathlength - 1)) {
          val xs = pathforonecompute(i)
          val ys = pathforonecompute(i + 1)

          val rateval = getRateByPos(xs, ys)
          val askval = getAskByPos(xs, ys)
          val bidval = getBidByPos(xs, ys)

          //          cres = cres * askval - cres * (askval - bidval)

          cres = cres * bidval

        }
        //after compute once
        if (cres > finalres) {
          finalres = cres
          //do other save operations
          finalpathstr = pathforonecompute.toString

          finalpathlist = pathforonecompute

        }

      }

    }

    (finalres, finalpathstr, finalpathlist)

  }

  def getRateByPos(x: Int, y: Int): Float = {
    ratelist(x * 8 + y)
  }

  def getAskByPos(x: Int, y: Int): Float = {
    asklist(x * 8 + y)
  }

  def getBidByPos(x: Int, y: Int): Float = {
    bidlist(x * 8 + y)
  }

}
