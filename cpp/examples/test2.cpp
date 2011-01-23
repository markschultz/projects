// get_input.cpp
// use cin and such

#include <iostream>
using namespace std;

int main() {
	int input_var = 0;
	do {
		cout << "enter a number (-1=q):";
		if (!(cin >> input_var)) {
			cout << "you entered a non numeric!" << endl;
			cin.clear();
			cin.ignore(10000, '\n');
		}
		if (input_var != -1){
			cout << "you entered: " << input_var << endl;
		}
	} while (input_var != -1);
	cout << "goodbye..." << endl;
	return 0;
}

