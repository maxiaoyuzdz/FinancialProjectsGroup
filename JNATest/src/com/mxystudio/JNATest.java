package com.mxystudio;

import com.sun.jna.Library;
import com.sun.jna.Memory;
import com.sun.jna.Native;
import com.sun.jna.Pointer;
import com.sun.jna.platform.win32.Kernel32;
import com.sun.jna.platform.win32.WinNT.HANDLE;
//import com.sun.jna.ptr.PointerByReference;

interface JNAPipeServerDLLInterface extends Library {
	JNAPipeServerDLLInterface INSTANCE = (JNAPipeServerDLLInterface) Native
			.loadLibrary("JNAPipeServerDLL", JNAPipeServerDLLInterface.class);

	HANDLE CreateNamedPipeForName();

	int WaitForClientConnection(HANDLE pipe);

	void setvals(ForexDataStruct.ByReference p);

	int ReadDataFromPipe(HANDLE p, Pointer ptr,int len);

	int WriteDataToPipe(HANDLE p, Pointer ptr, int len);

	int DoFlushFileBuffers(HANDLE p);

}

interface Kernel32DLLInterface extends Kernel32 {
	Kernel32DLLInterface INSTANCE = (Kernel32DLLInterface) Native.loadLibrary(
			"kernel32", Kernel32DLLInterface.class);
}

public class JNATest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		try {

//			ForexDataStruct.ByReference p1 = new ForexDataStruct.ByReference();
//			JNAPipeServerDLLInterface.INSTANCE.setvals(p1);
//			System.out.println("p1 val = " + p1.value);
//
//			ForexDataStruct.ByReference p2 = new ForexDataStruct.ByReference();
			
			
			//test data
			double[] darray = {0,0};//,0,0,0};
			//darray.length * Native.getNativeSize(Double.TYPE)
			//create memory data
			Pointer ptr = new Memory(darray.length * Native.getNativeSize(Double.TYPE));
			int darraylen = darray.length * Native.getNativeSize(Double.TYPE);
			
			for(int i = 0; i< darray.length;i++)
			{
				ptr.setDouble(i * Native.getNativeSize(Double.TYPE), darray[i]);
			}
			
			//create pipe
			HANDLE pipe = JNAPipeServerDLLInterface.INSTANCE
					.CreateNamedPipeForName();
			//wait for connect
			System.out.println("waitting for connect");
			int waitconres = JNAPipeServerDLLInterface.INSTANCE
					.WaitForClientConnection(pipe);
			
			if(waitconres<=0)
			{
				Kernel32DLLInterface.INSTANCE.CloseHandle(pipe);
				System.out.println("Failed to connect a client");
			}
			System.out.println("connection ok");

			//ForexDataStruct finalres = new ForexDataStruct();
//			int count = 0;
			while (true) {
				// read data
				int read_res = JNAPipeServerDLLInterface.INSTANCE
						.ReadDataFromPipe(pipe, ptr, darraylen);

				if (read_res > 0) {


				} else {
					System.out.println("Failed to read data from the pipe.");
				}

				
				// process data

				for(int i = 0; i< darray.length;i++)
				{
					double tempd = ptr.getDouble(i * Native.getNativeSize(Double.TYPE));
					
					ptr.setDouble(i * Native.getNativeSize(Double.TYPE), tempd*100);
					
//					System.out.println("tempd =  "+ tempd);
					
					darray[i] = tempd;
				}
				
				// send data
				int write_res = JNAPipeServerDLLInterface.INSTANCE
						.WriteDataToPipe(pipe, ptr, darraylen);

				if (write_res > 0) {
					// System.out.println("Message: " + p2.value);
				} else {
					System.out.println("Failed to send data.");
				}

				int flush_res = JNAPipeServerDLLInterface.INSTANCE
						.DoFlushFileBuffers(pipe);
				if (flush_res<=0) {
					System.out.println("Failed to FlushFileBuffers.");
					break;
				}

				try {
					Thread.sleep(5);
				} catch (InterruptedException e) {
					System.out.println("got interrupted!");
				}

//				if (count > 100)
//					break;
//				else
//					count++;
			}
			
//			System.out.println("final res = "+ finalres.value);
			

			Kernel32DLLInterface.INSTANCE.CloseHandle(pipe);
			
			for(int i = 0; i< darray.length;i++)
			{
//				darray[i] = ptr.getDouble(i * Native.getNativeSize(Double.TYPE));
				System.out.println("final res "+ i +" = "+ darray[i]);
			}
			


		} catch (UnsatisfiedLinkError e) {
			System.out.println("Exception" + e);
		}

	}

}
