package com.mxystudio

object test {
  println("Welcome to the Scala worksheet")       //> Welcome to the Scala worksheet
  
  val teststr = "GBPUSD"                          //> teststr  : String = GBPUSD
  
  teststr.substring(0,2)                          //> res0: String = GB
  
  
  
  
  val t = List(1,2,3,4,5,6,7,8,9).toSet[Int].subsets.map(_.toList).toList
                                                  //> t  : List[List[Int]] = List(List(), List(5), List(1), List(6), List(9), List
                                                  //| (2), List(7), List(3), List(8), List(4), List(5, 1), List(5, 6), List(5, 9),
                                                  //|  List(5, 2), List(5, 7), List(5, 3), List(5, 8), List(5, 4), List(1, 6), Lis
                                                  //| t(1, 9), List(1, 2), List(1, 7), List(1, 3), List(1, 8), List(1, 4), List(6,
                                                  //|  9), List(6, 2), List(6, 7), List(6, 3), List(6, 8), List(6, 4), List(9, 2),
                                                  //|  List(9, 7), List(9, 3), List(9, 8), List(9, 4), List(2, 7), List(2, 3), Lis
                                                  //| t(2, 8), List(2, 4), List(7, 3), List(7, 8), List(7, 4), List(3, 8), List(3,
                                                  //|  4), List(8, 4), List(5, 1, 6), List(5, 1, 9), List(5, 1, 2), List(5, 1, 7),
                                                  //|  List(5, 1, 3), List(5, 1, 8), List(5, 1, 4), List(5, 6, 9), List(5, 6, 2), 
                                                  //| List(5, 6, 7), List(5, 6, 3), List(5, 6, 8), List(5, 6, 4), List(5, 9, 2), L
                                                  //| ist(5, 9, 7), List(5, 9, 3), List(5, 9, 8), List(5, 9, 4), List(5, 2, 7), Li
                                                  //| st(5, 2, 3), List(5, 2, 8), List(5, 2, 4), List(5, 7, 3), List(5, 7, 8), Lis
                                                  //| t(5, 7, 4), List(5, 3, 8
                                                  //| Output exceeds cutoff limit.
  
  t.length                                        //> res1: Int = 512
  
  def combine(in: List[Char]): Seq[String] =
    for {
        len <- 1 to in.length
        combinations <- in combinations len
    } yield combinations.mkString                 //> combine: (in: List[Char])Seq[String]
    
    
    val k = combine(List('a','b','c','d','e','f','g','h','i'))
                                                  //> k  : Seq[String] = Vector(a, b, c, d, e, f, g, h, i, ab, ac, ad, ae, af, ag,
                                                  //|  ah, ai, bc, bd, be, bf, bg, bh, bi, cd, ce, cf, cg, ch, ci, de, df, dg, dh,
                                                  //|  di, ef, eg, eh, ei, fg, fh, fi, gh, gi, hi, abc, abd, abe, abf, abg, abh, a
                                                  //| bi, acd, ace, acf, acg, ach, aci, ade, adf, adg, adh, adi, aef, aeg, aeh, ae
                                                  //| i, afg, afh, afi, agh, agi, ahi, bcd, bce, bcf, bcg, bch, bci, bde, bdf, bdg
                                                  //| , bdh, bdi, bef, beg, beh, bei, bfg, bfh, bfi, bgh, bgi, bhi, cde, cdf, cdg,
                                                  //|  cdh, cdi, cef, ceg, ceh, cei, cfg, cfh, cfi, cgh, cgi, chi, def, deg, deh, 
                                                  //| dei, dfg, dfh, dfi, dgh, dgi, dhi, efg, efh, efi, egh, egi, ehi, fgh, fgi, f
                                                  //| hi, ghi, abcd, abce, abcf, abcg, abch, abci, abde, abdf, abdg, abdh, abdi, a
                                                  //| bef, abeg, abeh, abei, abfg, abfh, abfi, abgh, abgi, abhi, acde, acdf, acdg,
                                                  //|  acdh, acdi, acef, aceg, aceh, acei, acfg, acfh, acfi, acgh, acgi, achi, ade
                                                  //| f, adeg, adeh, adei, adfg, adfh, adfi, adgh, adgi, adhi, aefg, aefh, aefi, a
                                                  //| egh, aegi, aehi, afgh, a
                                                  //| Output exceeds cutoff limit.
                                                  
                                                  val kl = k.length
                                                  //> kl  : Int = 511
                                                  
                                                  
                                                  val xs = List( 'a','b','c','d','e','f','g','h','i' )
                                                  //> xs  : List[Char] = List(a, b, c, d, e, f, g, h, i)
val xsc = (1 to xs.length flatMap (x => xs.combinations(x))) map ( x => x.mkString(""))
                                                  //> xsc  : scala.collection.immutable.IndexedSeq[String] = Vector(a, b, c, d, e,
                                                  //|  f, g, h, i, ab, ac, ad, ae, af, ag, ah, ai, bc, bd, be, bf, bg, bh, bi, cd,
                                                  //|  ce, cf, cg, ch, ci, de, df, dg, dh, di, ef, eg, eh, ei, fg, fh, fi, gh, gi,
                                                  //|  hi, abc, abd, abe, abf, abg, abh, abi, acd, ace, acf, acg, ach, aci, ade, a
                                                  //| df, adg, adh, adi, aef, aeg, aeh, aei, afg, afh, afi, agh, agi, ahi, bcd, bc
                                                  //| e, bcf, bcg, bch, bci, bde, bdf, bdg, bdh, bdi, bef, beg, beh, bei, bfg, bfh
                                                  //| , bfi, bgh, bgi, bhi, cde, cdf, cdg, cdh, cdi, cef, ceg, ceh, cei, cfg, cfh,
                                                  //|  cfi, cgh, cgi, chi, def, deg, deh, dei, dfg, dfh, dfi, dgh, dgi, dhi, efg, 
                                                  //| efh, efi, egh, egi, ehi, fgh, fgi, fhi, ghi, abcd, abce, abcf, abcg, abch, a
                                                  //| bci, abde, abdf, abdg, abdh, abdi, abef, abeg, abeh, abei, abfg, abfh, abfi,
                                                  //|  abgh, abgi, abhi, acde, acdf, acdg, acdh, acdi, acef, aceg, aceh, acei, acf
                                                  //| g, acfh, acfi, acgh, acgi, achi, adef, adeg, adeh, adei, adfg, adfh, adfi, a
                                                  //| dgh, adgi, adhi, aefg, a
                                                  //| Output exceeds cutoff limit.
    val xscl = xsc.length                         //> xscl  : Int = 511
    
    val xsc2 = (1 to xs.length flatMap (x => xs.combinations(x))) map ( x => x.mkString("").toList)
                                                  //> xsc2  : scala.collection.immutable.IndexedSeq[List[Char]] = Vector(List(a),
                                                  //|  List(b), List(c), List(d), List(e), List(f), List(g), List(h), List(i), Li
                                                  //| st(a, b), List(a, c), List(a, d), List(a, e), List(a, f), List(a, g), List(
                                                  //| a, h), List(a, i), List(b, c), List(b, d), List(b, e), List(b, f), List(b, 
                                                  //| g), List(b, h), List(b, i), List(c, d), List(c, e), List(c, f), List(c, g),
                                                  //|  List(c, h), List(c, i), List(d, e), List(d, f), List(d, g), List(d, h), Li
                                                  //| st(d, i), List(e, f), List(e, g), List(e, h), List(e, i), List(f, g), List(
                                                  //| f, h), List(f, i), List(g, h), List(g, i), List(h, i), List(a, b, c), List(
                                                  //| a, b, d), List(a, b, e), List(a, b, f), List(a, b, g), List(a, b, h), List(
                                                  //| a, b, i), List(a, c, d), List(a, c, e), List(a, c, f), List(a, c, g), List(
                                                  //| a, c, h), List(a, c, i), List(a, d, e), List(a, d, f), List(a, d, g), List(
                                                  //| a, d, h), List(a, d, i), List(a, e, f), List(a, e, g), List(a, e, h), List(
                                                  //| a, e, i), List(a, f, g)
                                                  //| Output exceeds cutoff limit.
    val xsc2l = xsc2.length                       //> xsc2l  : Int = 511
    
    for( i <- xsc2){
    println(i.length)                             //> 1
                                                  //| 1
                                                  //| 1
                                                  //| 1
                                                  //| 1
                                                  //| 1
                                                  //| 1
                                                  //| 1
                                                  //| 1
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 2
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
                                                  //| 3
    }
    
                                                  
}