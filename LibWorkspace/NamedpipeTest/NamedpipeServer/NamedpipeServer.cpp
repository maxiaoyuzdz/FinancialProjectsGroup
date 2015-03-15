// NamedpipeServer.cpp : Defines the entry point for the console application.
//

#include <iostream>
#include <windows.h>
using namespace std;

struct DD{
	int name;
	double value;
};
double transferdata[5] = {0,0,0,0,0};

int main(int argc, const char **argv)
{
	HANDLE pipe = CreateNamedPipe( 
		L"\\\\.\\pipe\\forextradingmasterpipe",             // pipe name 
		PIPE_ACCESS_DUPLEX,       // read/write access 
		PIPE_TYPE_BYTE,
		1, // max. instances  
		0,                  // output buffer size 
		0,                  // input buffer size 
		0,                        // client time-out 
		NULL);                    // default security attribute 
	
	if (pipe == NULL || pipe == INVALID_HANDLE_VALUE) {
		wcout << "Failed to create outbound pipe instance.";
		// look up error code here using GetLastError()
		system("pause");
		return 1;
	}

	wcout << "Waiting for a client to connect to the pipe..." << endl;
	// This call blocks until a client process connects to the pipe
	BOOL write_result = ConnectNamedPipe(pipe, NULL);
	if (!write_result) {
		wcout << "Failed to make connection on named pipe." << endl;
		// look up error code here using GetLastError()
		CloseHandle(pipe); // close the pipe
		system("pause");
		return 1;
	}

	wcout << "Sending data to pipe..." << endl;

	// This call blocks until a client process reads all the data
	const wchar_t *data = L"*** Hello Pipe World ***";

	DD testdata;
	testdata.name = 100;
	testdata.value = 1.001;

	DD rec_result;
	rec_result.name = 100;
	rec_result.value = 1.001;

	int count = 0;
	while(1)
	{
		//read data
		//read
		
		DWORD numBytesRead = 0;
		BOOL read_result = ReadFile(
			pipe,
			//buffer, // the data from the pipe will be put here
			//127 * sizeof(wchar_t), // number of bytes allocated
			&transferdata, // the data from the pipe will be put here
			sizeof(transferdata), // number of bytes allocated


			&numBytesRead, // this will store number of bytes actually read
			NULL // not using overlapped IO
			);
		if (read_result) {

			//wcout << "Number of bytes read: " << numBytesRead << endl;
			//wcout << "Message: " << buffer << endl;

			//wcout << "Message: " << rec_result.value << endl;
		} else {
			wcout << "Failed to read data from the pipe." << endl;
		}
		//process data
		//rec_result.value = rec_result.value + 1000;

		//testdata.value = rec_result.value;

		for(int i=0;i<5;i++)
		{
			transferdata[i] = transferdata[i]+ 1.5;
		}


		//send data
		DWORD numBytesWritten = 0;
		write_result = WriteFile(
			pipe, // handle to our outbound pipe
			
			&transferdata, // data to send
			sizeof(transferdata), // length of data to send (bytes)

			&numBytesWritten, // will store actual amount of data sent
			NULL // not using overlapped IO
			);

		if (write_result) {
			wcout << "Number of bytes sent: " << numBytesWritten << endl;
		} else {
			wcout << "Failed to send data." << endl;
			// look up error code here using GetLastError()
		}

		bool fres = FlushFileBuffers(pipe);
		if(!fres)
			break;

		
		Sleep(5);

		if(count > 100)
			break;
		else
			count++;

	}

	for(int i=0;i<5;i++)
	{
		printf("final res =  %lf", transferdata[i]);
	}
	
	


	// Close the pipe (automatically disconnects client too)
	CloseHandle(pipe);

	wcout << "Done." << endl;

	

	system("pause");






	return 0;
}

