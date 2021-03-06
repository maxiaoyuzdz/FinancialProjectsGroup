package com.mxystudio;
//import com.sun.jna.Pointer;
import com.sun.jna.Structure;

import java.util.Arrays;
import java.util.List;
/**
 * <i>native declaration : line 2</i><br>
 * This file was autogenerated by <a href="http://jnaerator.googlecode.com/">JNAerator</a>,<br>
 * a tool written by <a href="http://ochafik.com/">Olivier Chafik</a> that <a href="http://code.google.com/p/jnaerator/wiki/CreditsAndLicense">uses a few opensource projects.</a>.<br>
 * For help, please visit <a href="http://nativelibs4java.googlecode.com/">NativeLibs4Java</a> , <a href="http://rococoa.dev.java.net/">Rococoa</a>, or <a href="http://jna.dev.java.net/">JNA</a>.
 */
public class ForexDataStruct extends Structure {
	public double value;
	public ForexDataStruct() {
		super();
	}
	protected List<? > getFieldOrder() {
		return Arrays.asList("value");
	}
	public ForexDataStruct(double value) {
		super();
		this.value = value;
	}
	
//	public ForexDataStruct(Pointer p) {
//        super(p);
//        read();
//    }
//	
	
	public static class ByReference extends ForexDataStruct implements Structure.ByReference {
		
	};
	public static class ByValue extends ForexDataStruct implements Structure.ByValue {
		
	};
}
