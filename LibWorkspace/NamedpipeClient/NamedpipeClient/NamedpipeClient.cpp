#include <iostream>
#include <windows.h>
using namespace std;

// struct DD{
// 	int name;
// 	double value;
// };


struct ForexDataStruct{
	double value;
};

double transferdata[5] = {3.14,0.27,4.35,3.21,5.6};

int main(int argc, const char **argv)
{
	wcout << "Connecting to pipe..." << endl;

	// Open the named pipe
	// Most of these parameters aren't very relevant for pipes.
	HANDLE pipe = CreateFile(
		L"\\\\.\\pipe\\forextradingmasterpipe",
		GENERIC_READ | GENERIC_WRITE, // only need read access
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		);

	if (pipe == INVALID_HANDLE_VALUE) {
		//wcout << "Failed to connect to pipe." << endl;
		// look up error code here using GetLastError()
		system("pause");
		return 1;
	}

	wcout << "connect ok" << endl;

	

	

	ForexDataStruct testdata;
	
	testdata.value = 1.001;

	ForexDataStruct rec_result;

	int count = 0;

	while (1)
	{
		//send data
		DWORD numBytesWritten = 0;
		BOOL write_result = WriteFile(
			pipe, // handle to our outbound pipe

			&transferdata, // data to send
			sizeof(transferdata), // length of data to send (bytes)

			&numBytesWritten, // will store actual amount of data sent
			NULL // not using overlapped IO
			);

		if (write_result) {
			//wcout << "Number of bytes sent: " << numBytesWritten << endl;
		} else {
			//wcout << "Failed to send data." << endl;
			// look up error code here using GetLastError()
			break;
		}
		//testdata.value = testdata.value + 1.1;
		//////////////////////////////////////////////////////////////////////////

		
		/** */
		DWORD numBytesRead = 0;
		BOOL read_result = ReadFile(
			pipe,
			//buffer, // the data from the pipe will be put here
			&transferdata, // the data from the pipe will be put here
			sizeof(transferdata), // number of bytes allocated

			&numBytesRead, // this will store number of bytes actually read
			NULL // not using overlapped IO
			);

		if (read_result) {
			//		buffer[numBytesRead / sizeof(wchar_t)] = '\0'; // null terminate the string
			//wcout << "Number of bytes read: " << numBytesRead << endl;
			//wcout << "Message: " << buffer << endl;
			//wcout << "Message: " << rec_result.value << endl;
		} else {
			//wcout << "Failed to read data from the pipe." << endl;
		}

		//
		//testdata.value = rec_result.value;
		
		Sleep(10);

		if(count>1000)
			break;
		else
			count++;
	}




	//printf("final res =  %lf", testdata.value);


	// Close our pipe handle
	CloseHandle(pipe);

	for(int i=0;i<5;i++)
	{
		printf("final res =  %lf", transferdata[i]);
	}


	wcout << "Done." << endl;

	system("pause");
	return 0;
}