// SimpleClient.cpp : Defines the entry point for the console application.
//

#include <iostream>
#include <windows.h>
using namespace std;


double testdata[] = {3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9,
	3.14,0.27,4.35,3.21,5.6,7.9
};

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


	wcout << "Done." << endl;

	system("pause");

	CloseHandle(pipe);

	wcout << "close ok." << endl;

	return 0;
}

