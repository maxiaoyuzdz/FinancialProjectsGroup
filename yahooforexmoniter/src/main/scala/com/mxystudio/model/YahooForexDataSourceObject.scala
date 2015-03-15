package com.mxystudio.model
import org.squeryl.PrimitiveTypeMode._
import org.squeryl.Schema
import org.squeryl.annotations.Column
import org.squeryl.dsl.ast.LogicalBoolean

import java.util.Date
import java.sql.Timestamp
import org.squeryl.KeyedEntity

case class ForexData(yearmonthday: Date, time: Date, rate: Float, ask: Float, bid: Float)

case class ForexDataJson(gmtquerytime: Date, nypricetime: Date, bjquerytime: Date, rate: Float, ask: Float, bid: Float)

case class ForexBasicDate(val id: Int, val gmtquerytime: Timestamp, val nypricetime: Timestamp, val bjquerytime: Timestamp, val rate: Float, val ask: Float, val bid: Float) extends KeyedEntity[Int] {
  def this() = this(0, new Timestamp((new Date).getTime()), new Timestamp((new Date).getTime()), new Timestamp((new Date).getTime()), 0.0f, 0.0f, 0.0f)

  def this(obj: ForexDataJson) = this(0,
    new Timestamp(obj.gmtquerytime.getTime()),
    new Timestamp(obj.nypricetime.getTime()),
    new Timestamp(obj.bjquerytime.getTime()),
    obj.rate,
    obj.ask,
    obj.bid)

}

object YahooForexDataSourceObject extends Schema {

  //EURUSD
  val eurusd_table = table[ForexBasicDate]("eurusd")

  on(eurusd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURUSD(valobj: ForexBasicDate) = eurusd_table.insert(valobj)

  //EURAUD

  val euraud_table = table[ForexBasicDate]("euraud")

  on(euraud_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURAUD(valobj: ForexBasicDate) = euraud_table.insert(valobj)

  //EURCAD
  val eurcad_table = table[ForexBasicDate]("eurcad")

  on(eurcad_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURCAD(valobj: ForexBasicDate) = eurcad_table.insert(valobj)

  //EURCHF
  val eurchf_table = table[ForexBasicDate]("eurchf")

  on(eurchf_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURCHF(valobj: ForexBasicDate) = eurchf_table.insert(valobj)

  //EURCNY
  val eurcny_table = table[ForexBasicDate]("eurcny")

  on(eurcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURCNY(valobj: ForexBasicDate) = eurcny_table.insert(valobj)

  //EURGBP
  val eurgbp_table = table[ForexBasicDate]("eurgbp")

  on(eurgbp_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURGBP(valobj: ForexBasicDate) = eurgbp_table.insert(valobj)

  //EURHKD
  val eurhkd_table = table[ForexBasicDate]("eurhkd")

  on(eurhkd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURHKD(valobj: ForexBasicDate) = eurhkd_table.insert(valobj)

  //EURJPY
  val eurjpy_table = table[ForexBasicDate]("eurjpy")

  on(eurjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURJPY(valobj: ForexBasicDate) = eurjpy_table.insert(valobj)

  //EURNZD
  val eurnzd_table = table[ForexBasicDate]("eurnzd")

  on(eurnzd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURNZD(valobj: ForexBasicDate) = eurnzd_table.insert(valobj)

  //======================================================================
  //GBPUSD
  val gbpusd_table = table[ForexBasicDate]("gbpusd")

  on(gbpusd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPUSD(valobj: ForexBasicDate) = gbpusd_table.insert(valobj)

  //GBPAUD
  val gbpaud_table = table[ForexBasicDate]("gbpaud")

  on(gbpaud_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPAUD(valobj: ForexBasicDate) = gbpaud_table.insert(valobj)

  //GBPCAD
  val gbpcad_table = table[ForexBasicDate]("gbpcad")

  on(gbpcad_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPCAD(valobj: ForexBasicDate) = gbpcad_table.insert(valobj)

  //GBPCHF
  val gbpchf_table = table[ForexBasicDate]("gbpchf")

  on(gbpchf_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPCHF(valobj: ForexBasicDate) = gbpchf_table.insert(valobj)

  //GBPCNY
  val gbpcny_table = table[ForexBasicDate]("gbpcny")

  on(gbpcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPCNY(valobj: ForexBasicDate) = gbpcny_table.insert(valobj)

  //GBPEUR
  val gbpeur_table = table[ForexBasicDate]("gbpeur")

  on(gbpeur_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPEUR(valobj: ForexBasicDate) = gbpeur_table.insert(valobj)

  //GBPHKD
  val gbphkd_table = table[ForexBasicDate]("gbphkd")

  on(gbphkd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPHKD(valobj: ForexBasicDate) = gbphkd_table.insert(valobj)

  //GBPJPY
  val gbpjpy_table = table[ForexBasicDate]("gbpjpy")

  on(gbpjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPJPY(valobj: ForexBasicDate) = gbpjpy_table.insert(valobj)

  //GBPNZD
  val gbpnzd_table = table[ForexBasicDate]("gbpnzd")

  on(gbpnzd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPNZD(valobj: ForexBasicDate) = gbpnzd_table.insert(valobj)

  //====================================================================

  //AUDUSD
  val audusd_table = table[ForexBasicDate]("audusd")

  on(audusd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDUSD(valobj: ForexBasicDate) = audusd_table.insert(valobj)

  //AUDCHF
  val audchf_table = table[ForexBasicDate]("audchf")

  on(audchf_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDCHF(valobj: ForexBasicDate) = audchf_table.insert(valobj)

  //AUDCNY
  val audcny_table = table[ForexBasicDate]("audcny")

  on(audcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDCNY(valobj: ForexBasicDate) = audcny_table.insert(valobj)

  //AUDEUR
  val audeur_table = table[ForexBasicDate]("audeur")

  on(audeur_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDEUR(valobj: ForexBasicDate) = audeur_table.insert(valobj)

  //AUDGBP
  val audgbp_table = table[ForexBasicDate]("audgbp")

  on(audgbp_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDGBP(valobj: ForexBasicDate) = audgbp_table.insert(valobj)

  //AUDHKD
  val audhkd_table = table[ForexBasicDate]("audhkd")

  on(audhkd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDHKD(valobj: ForexBasicDate) = audhkd_table.insert(valobj)

  //AUDJPY
  val audjpy_table = table[ForexBasicDate]("audjpy")

  on(audjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDJPY(valobj: ForexBasicDate) = audjpy_table.insert(valobj)

  //AUDNZD
  val audnzd_table = table[ForexBasicDate]("audnzd")

  on(audnzd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDNZD(valobj: ForexBasicDate) = audnzd_table.insert(valobj)

  //====================================================================================

  //NZDUSD
  val nzdusd_table = table[ForexBasicDate]("nzdusd")

  on(nzdusd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertNZDUSD(valobj: ForexBasicDate) = nzdusd_table.insert(valobj)

  //NZDCNY
  val nzdcny_table = table[ForexBasicDate]("nzdcny")

  on(nzdcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertNZDCNY(valobj: ForexBasicDate) = nzdcny_table.insert(valobj)

  //====================================================================================

  //USDCNY
  val usdcny_table = table[ForexBasicDate]("usdcny")

  on(usdcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDCNY(valobj: ForexBasicDate) = usdcny_table.insert(valobj)

  //USDTWD
  val usdtwd_table = table[ForexBasicDate]("usdtwd")

  on(usdtwd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDTWD(valobj: ForexBasicDate) = usdtwd_table.insert(valobj)

  //USDHKD
  val usdhkd_table = table[ForexBasicDate]("usdhkd")

  on(usdtwd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDHKD(valobj: ForexBasicDate) = usdhkd_table.insert(valobj)

  //USDSGD
  val usdsgd_table = table[ForexBasicDate]("usdsgd")

  on(usdsgd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDSGD(valobj: ForexBasicDate) = usdsgd_table.insert(valobj)

  //USDCAD
  val usdcad_table = table[ForexBasicDate]("usdcad")

  on(usdcad_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDCAD(valobj: ForexBasicDate) = usdcad_table.insert(valobj)

  //USDCHF
  val usdchf_table = table[ForexBasicDate]("usdchf")

  on(usdchf_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDCHF(valobj: ForexBasicDate) = usdchf_table.insert(valobj)

  //USDJPY
  val usdjpy_table = table[ForexBasicDate]("usdjpy")

  on(usdjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDJPY(valobj: ForexBasicDate) = usdjpy_table.insert(valobj)

  //USDMOP
  val usdmop_table = table[ForexBasicDate]("usdmop")

  on(usdmop_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDMOP(valobj: ForexBasicDate) = usdmop_table.insert(valobj)

  //USDMYR
  val usdmyr_table = table[ForexBasicDate]("usdmyr")

  on(usdmyr_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertUSDMYR(valobj: ForexBasicDate) = usdmyr_table.insert(valobj)

  //====================================================================================

  //CADAUD
  val cadaud_table = table[ForexBasicDate]("cadaud")

  on(cadaud_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADAUD(valobj: ForexBasicDate) = cadaud_table.insert(valobj)

  //CADCHF
  val cadchf_table = table[ForexBasicDate]("cadchf")

  on(cadchf_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADCHF(valobj: ForexBasicDate) = cadchf_table.insert(valobj)

  //CADCNY
  val cadcny_table = table[ForexBasicDate]("cadcny")

  on(cadcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADCNY(valobj: ForexBasicDate) = cadcny_table.insert(valobj)

  //CADEUR
  val cadeur_table = table[ForexBasicDate]("cadeur")

  on(cadeur_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADEUR(valobj: ForexBasicDate) = cadeur_table.insert(valobj)

  //CADGBP
  val cadgbp_table = table[ForexBasicDate]("cadgbp")

  on(cadgbp_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADGBP(valobj: ForexBasicDate) = cadgbp_table.insert(valobj)

  //CADHKD
  val cadhkd_table = table[ForexBasicDate]("cadhkd")

  on(cadhkd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADHKD(valobj: ForexBasicDate) = cadhkd_table.insert(valobj)

  //CADJPY
  val cadjpy_table = table[ForexBasicDate]("cadjpy")

  on(cadjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADJPY(valobj: ForexBasicDate) = cadjpy_table.insert(valobj)

  //CADNZD
  val cadnzd_table = table[ForexBasicDate]("cadnzd")

  on(cadnzd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADNZD(valobj: ForexBasicDate) = cadnzd_table.insert(valobj)

  //====================================================================================

  //CHFAUD
  val chfaud_table = table[ForexBasicDate]("chfaud")

  on(chfaud_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCHFAUD(valobj: ForexBasicDate) = chfaud_table.insert(valobj)

  //CHFCAD
  val chfcad_table = table[ForexBasicDate]("chfcad")

  on(chfcad_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCHFCAD(valobj: ForexBasicDate) = chfcad_table.insert(valobj)

  //CHFCNY
  val chfcny_table = table[ForexBasicDate]("chfcny")

  on(chfcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCHFCNY(valobj: ForexBasicDate) = chfcny_table.insert(valobj)

  //CHFEUR
  val chfeur_table = table[ForexBasicDate]("chfeur")

  on(chfeur_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCHFEUR(valobj: ForexBasicDate) = chfeur_table.insert(valobj)

  //CHFGBP
  val chfgbp_table = table[ForexBasicDate]("chfgbp")

  on(chfgbp_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCHFGBP(valobj: ForexBasicDate) = chfgbp_table.insert(valobj)

  //CHFHKD
  val chfhkd_table = table[ForexBasicDate]("chfhkd")

  on(chfhkd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCHFHKD(valobj: ForexBasicDate) = chfhkd_table.insert(valobj)

  //CHFJPY
  val chfjpy_table = table[ForexBasicDate]("chfjpy")

  on(chfjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCHFJPY(valobj: ForexBasicDate) = chfjpy_table.insert(valobj)

  //====================================================================================
  //CNYJPY
  val cnyjpy_table = table[ForexBasicDate]("cnyjpy")

  on(cnyjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCNYJPY(valobj: ForexBasicDate) = cnyjpy_table.insert(valobj)

  //====================================================================================
  //HKDAUD
  val hkdaud_table = table[ForexBasicDate]("hkdaud")

  on(hkdaud_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertHKDAUD(valobj: ForexBasicDate) = hkdaud_table.insert(valobj)

  //HKDCAD
  val hkdcad_table = table[ForexBasicDate]("hkdcad")

  on(hkdcad_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertHKDCAD(valobj: ForexBasicDate) = hkdcad_table.insert(valobj)

  //HKDCHF
  val hkdchf_table = table[ForexBasicDate]("hkdchf")

  on(hkdchf_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertHKDCHF(valobj: ForexBasicDate) = hkdchf_table.insert(valobj)

  //HKDCNY
  val hkdcny_table = table[ForexBasicDate]("hkdcny")

  on(hkdcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertHKDCNY(valobj: ForexBasicDate) = hkdcny_table.insert(valobj)

  //HKDEUR
  val hkdeur_table = table[ForexBasicDate]("hkdeur")

  on(hkdeur_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertHKDEUR(valobj: ForexBasicDate) = hkdeur_table.insert(valobj)

  //HKDGBP
  val hkdgbp_table = table[ForexBasicDate]("hkdgbp")

  on(hkdgbp_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertHKDGBP(valobj: ForexBasicDate) = hkdgbp_table.insert(valobj)

  //HKDJPY
  val hkdjpy_table = table[ForexBasicDate]("hkdjpy")

  on(hkdjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertHKDJPY(valobj: ForexBasicDate) = hkdjpy_table.insert(valobj)

  //====================================================================================

  //JPYAUD
  val jpyaud_table = table[ForexBasicDate]("jpyaud")

  on(jpyaud_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertJPYAUD(valobj: ForexBasicDate) = jpyaud_table.insert(valobj)

  //JPYCAD
  val jpycad_table = table[ForexBasicDate]("jpycad")

  on(jpycad_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertJPYCAD(valobj: ForexBasicDate) = jpycad_table.insert(valobj)

  //JPYCHF
  val jpychf_table = table[ForexBasicDate]("jpychf")

  on(jpychf_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertJPYCHF(valobj: ForexBasicDate) = jpychf_table.insert(valobj)

  //JPYEUR
  val jpyeur_table = table[ForexBasicDate]("jpyeur")

  on(jpyeur_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertJPYEUR(valobj: ForexBasicDate) = jpyeur_table.insert(valobj)

  //JPYGBP
  val jpygbp_table = table[ForexBasicDate]("jpygbp")

  on(jpygbp_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertJPYGBP(valobj: ForexBasicDate) = jpygbp_table.insert(valobj)

  //JPYHKD
  val jpyhkd_table = table[ForexBasicDate]("jpyhkd")

  on(jpyhkd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertJPYHKD(valobj: ForexBasicDate) = jpyhkd_table.insert(valobj)
  //====================================================================================
  //SGDCNY
  val sgdcny_table = table[ForexBasicDate]("sgdcny")

  on(sgdcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertSGDCNY(valobj: ForexBasicDate) = sgdcny_table.insert(valobj)

  //====================================================================================
  //TWDCNY
  val twdcny_table = table[ForexBasicDate]("twdcny")

  on(twdcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertTWDCNY(valobj: ForexBasicDate) = twdcny_table.insert(valobj)

  //====================================================================================
  //SEKCNY
  val sekcny_table = table[ForexBasicDate]("sekcny")

  on(sekcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertSEKCNY(valobj: ForexBasicDate) = sekcny_table.insert(valobj)

  //DKKCNY
  val dkkcny_table = table[ForexBasicDate]("dkkcny")

  on(dkkcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertDKKCNY(valobj: ForexBasicDate) = dkkcny_table.insert(valobj)

  //NOKCNY
  val nokcny_table = table[ForexBasicDate]("nokcny")

  on(nokcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertNOKCNY(valobj: ForexBasicDate) = nokcny_table.insert(valobj)

  //JPYCNY
  val jpycny_table = table[ForexBasicDate]("jpycny")

  on(jpycny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertJPYCNY(valobj: ForexBasicDate) = jpycny_table.insert(valobj)

  //MYRCNY
  val myrcny_table = table[ForexBasicDate]("myrcny")

  on(myrcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertMYRCNY(valobj: ForexBasicDate) = myrcny_table.insert(valobj)

  //MOPCNY
  val mopcny_table = table[ForexBasicDate]("mopcny")

  on(mopcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertMOPCNY(valobj: ForexBasicDate) = mopcny_table.insert(valobj)

  //PHPCNY
  val phpcny_table = table[ForexBasicDate]("phpcny")

  on(phpcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertPHPCNY(valobj: ForexBasicDate) = phpcny_table.insert(valobj)

  //THBCNY
  val thbcny_table = table[ForexBasicDate]("thbcny")

  on(thbcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertTHBCNY(valobj: ForexBasicDate) = thbcny_table.insert(valobj)

  //KRWCNY
  val krwcny_table = table[ForexBasicDate]("krwcny")

  on(krwcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertKRWCNY(valobj: ForexBasicDate) = krwcny_table.insert(valobj)

  //RUBCNY
  val rubcny_table = table[ForexBasicDate]("rubcny")

  on(rubcny_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertRUBCNY(valobj: ForexBasicDate) = rubcny_table.insert(valobj)

  //====================================================================================
  //GBPSGD
  val gbpsgd_table = table[ForexBasicDate]("gbpsgd")

  on(gbpsgd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertGBPSGD(valobj: ForexBasicDate) = gbpsgd_table.insert(valobj)

  //CHFSGD chfsgd
  val chfsgd_table = table[ForexBasicDate]("chfsgd")

  on(chfsgd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCHFSGD(valobj: ForexBasicDate) = chfsgd_table.insert(valobj)

  //SGDHKD
  val sgdhkd_table = table[ForexBasicDate]("sgdhkd")

  on(sgdhkd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertSGDHKD(valobj: ForexBasicDate) = sgdhkd_table.insert(valobj)

  //SGDJPY
  val sgdjpy_table = table[ForexBasicDate]("sgdjpy")

  on(sgdjpy_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertSGDJPY(valobj: ForexBasicDate) = sgdjpy_table.insert(valobj)

  //CADSGD
  val cadsgd_table = table[ForexBasicDate]("cadsgd")

  on(cadsgd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertCADSGD(valobj: ForexBasicDate) = cadsgd_table.insert(valobj)

  //AUDSGD audsgd
  val audsgd_table = table[ForexBasicDate]("audsgd")

  on(audsgd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDSGD(valobj: ForexBasicDate) = audsgd_table.insert(valobj)

  //AUDCAD
  val audcad_table = table[ForexBasicDate]("audcad")

  on(audcad_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertAUDCAD(valobj: ForexBasicDate) = audcad_table.insert(valobj)

  //EURSGD
  val eursgd_table = table[ForexBasicDate]("eursgd")

  on(eursgd_table)(item => declare(
    item.id is (primaryKey, autoIncremented)))

  def insertEURSGD(valobj: ForexBasicDate) = eursgd_table.insert(valobj)

  //====================================================================================

  def InsertDateToTable(tablename: String, valobj: ForexBasicDate) = {

    tablename match {
      case "EURUSD" => insertEURUSD(valobj)
      case "EURAUD" => insertEURAUD(valobj)
      case "EURCAD" => insertEURCAD(valobj)
      case "EURCHF" => insertEURCHF(valobj)
      //      case "EURCNY" => insertEURCNY(valobj)
      case "EURGBP" => insertEURGBP(valobj)
      case "EURHKD" => insertEURHKD(valobj)
      case "EURJPY" => insertEURJPY(valobj)
      //      case "EURNZD" => insertEURNZD(valobj)
      //
      case "GBPUSD" => insertGBPUSD(valobj)
      case "GBPAUD" => insertGBPAUD(valobj)
      case "GBPCAD" => insertGBPCAD(valobj)
      case "GBPCHF" => insertGBPCHF(valobj)
      //      case "GBPCNY" => insertGBPCNY(valobj)
      //      case "GBPEUR" => insertGBPEUR(valobj)
      case "GBPHKD" => insertGBPHKD(valobj)
      case "GBPJPY" => insertGBPJPY(valobj)
      //      case "GBPNZD" => insertGBPNZD(valobj)
      //
      case "AUDUSD" => insertAUDUSD(valobj)
      case "AUDCHF" => insertAUDCHF(valobj)
      //      case "AUDCNY" => insertAUDCNY(valobj)
      //      case "AUDEUR" => insertAUDEUR(valobj)
      //      case "AUDGBP" => insertAUDGBP(valobj)
      case "AUDHKD" => insertAUDHKD(valobj)
      case "AUDJPY" => insertAUDJPY(valobj)
      //      case "AUDNZD" => insertAUDNZD(valobj)
      //
      //      case "NZDUSD" => insertNZDUSD(valobj)
      //      case "NZDCNY" => insertNZDCNY(valobj)
      //
      //      case "USDCNY" => insertUSDCNY(valobj)
      //      case "USDTWD" => insertUSDTWD(valobj)
      case "USDHKD" => insertUSDHKD(valobj)
      //
      case "USDSGD" => insertUSDSGD(valobj)
      case "USDCAD" => insertUSDCAD(valobj)
      case "USDCHF" => insertUSDCHF(valobj)
      //      case "USDJPY" => insertUSDJPY(valobj)
      //      case "USDMOP" => insertUSDMOP(valobj)
      //      case "USDMYR" => insertUSDMYR(valobj)
      //
      //      case "CADAUD" => insertCADAUD(valobj)
      //      case "CADCHF" => insertCADCHF(valobj)
      //      case "CADCNY" => insertCADCNY(valobj)
      //      case "CADEUR" => insertCADEUR(valobj)
      //      case "CADGBP" => insertCADGBP(valobj)
      case "CADHKD" => insertCADHKD(valobj)
      case "CADJPY" => insertCADJPY(valobj)
      //      case "CADNZD" => insertCADNZD(valobj)
      //
      //      case "CHFAUD" => insertCHFAUD(valobj)
      case "CHFCAD" => insertCHFCAD(valobj)
      //      case "CHFCNY" => insertCHFCNY(valobj)
      //      case "CHFEUR" => insertCHFEUR(valobj)
      //      case "CHFGBP" => insertCHFGBP(valobj)
      case "CHFHKD" => insertCHFHKD(valobj)
      case "CHFJPY" => insertCHFJPY(valobj)
      //
      //      case "CNYJPY" => insertCNYJPY(valobj)
      //
      //      case "HKDAUD" => insertHKDAUD(valobj)
      //      case "HKDCAD" => insertHKDCAD(valobj)
      //      case "HKDCHF" => insertHKDCHF(valobj)
      //      case "HKDCNY" => insertHKDCNY(valobj)
      //      case "HKDEUR" => insertHKDEUR(valobj)
      //      case "HKDGBP" => insertHKDGBP(valobj)
      case "HKDJPY" => insertHKDJPY(valobj)
      //
      //      case "JPYAUD" => insertJPYAUD(valobj)
      //      case "JPYCAD" => insertJPYCAD(valobj)
      //      case "JPYCHF" => insertJPYCHF(valobj)
      //      case "JPYEUR" => insertJPYEUR(valobj)
      //      case "JPYGBP" => insertJPYGBP(valobj)
      //      case "JPYHKD" => insertJPYHKD(valobj)
      //
      //      case "SGDCNY" => insertSGDCNY(valobj)
      //
      //      case "TWDCNY" => insertTWDCNY(valobj)
      //
      //      case "SEKCNY" => insertSEKCNY(valobj)
      //      case "DKKCNY" => insertDKKCNY(valobj)
      //      case "NOKCNY" => insertNOKCNY(valobj)
      //      case "JPYCNY" => insertJPYCNY(valobj)
      //      case "MYRCNY" => insertMYRCNY(valobj)
      //      case "MOPCNY" => insertMOPCNY(valobj)
      //      case "PHPCNY" => insertPHPCNY(valobj)
      //      case "THBCNY" => insertTHBCNY(valobj)
      //      case "KRWCNY" => insertKRWCNY(valobj)
      //      case "RUBCNY" => insertRUBCNY(valobj)
      case "GBPSGD" => insertGBPSGD(valobj)
      case "CHFSGD" => insertCHFSGD(valobj)
      case "SGDHKD" => insertSGDHKD(valobj)
      case "SGDJPY" => insertSGDJPY(valobj)
      case "CADSGD" => insertCADSGD(valobj)
      case "AUDSGD" => insertAUDSGD(valobj)
      case "AUDCAD" => insertAUDCAD(valobj)
      case "EURSGD" => insertEURSGD(valobj)

      case _ => println("no match error")

    }

  }

}