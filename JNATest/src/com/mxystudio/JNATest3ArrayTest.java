package com.mxystudio;

import com.sun.jna.Library;
import com.sun.jna.Native;
//import com.sun.jna.platform.win32.Kernel32;
//import com.sun.jna.platform.win32.WinNT.HANDLE;
import com.sun.jna.Pointer;
//import com.sun.jna.ptr.PointerByReference;
import com.sun.jna.Memory;

interface ArrayTestDllLib extends Library {
	ArrayTestDllLib INSTANCE = (ArrayTestDllLib) Native
			.loadLibrary("JNAPipeServerDLL", ArrayTestDllLib.class);

	double sendDoubleArray(Pointer p, int numVals);
	
	Pointer changeDoubleArray(Pointer p, int numVals);

}

public class JNATest3ArrayTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		double[] darray = {3.14,5.67,3.23};
		
		Pointer ptr = new Memory(darray.length * Native.getNativeSize(Double.TYPE));
		
		for(int i = 0; i< darray.length;i++)
		{
			ptr.setDouble(i * Native.getNativeSize(Double.TYPE), darray[i]);
		}
		
		double res = ArrayTestDllLib.INSTANCE.sendDoubleArray(ptr, darray.length);
		
		System.out.println("send res = " + res);
		
		Pointer p1 = ArrayTestDllLib.INSTANCE.changeDoubleArray(ptr, darray.length);
		
		for(int i = 0; i< darray.length;i++)
		{
			double dp = p1.getDouble(i * Native.getNativeSize(Double.TYPE));
			
			System.out.println("change1 res = " + dp);
		}
		
		for(int i = 0; i< darray.length;i++)
		{
			double dp = ptr.getDouble(i * Native.getNativeSize(Double.TYPE));
			
			System.out.println("change2 res = " + dp);
		}
		
		

	}

}
