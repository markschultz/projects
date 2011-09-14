
//global imports
#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <sstream>
#include <cstddef>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
//#include <utility>

using namespace std;

typedef unsigned char BYTE;
int unknown = 0;
struct StringPair{
	string mac;
	string name;
};
typedef map<string,StringPair> List;
typedef map<string,int> Count;
//vector<pair<string,int>> clist;
//pair<string,int> cpair;
vector<string> clist;
Count count;
List list;


string doString(int bytes[]);
void printResults();

int main(int argc, char* argv[]) {
	const char *mac_list_arg;
	const char *mac_addr_arg;
	ifstream mac_list;
	ifstream mac_addr;
	mac_list_arg = argv[1];
	mac_addr_arg = argv[2];
	mac_list.open(mac_list_arg);
	if(mac_list.is_open()){
		string line,mac,name;
		while(mac_list.good()){
			getline(mac_list,line);
			istringstream liness(line);
			if(liness.good()){
				getline(liness,mac,' ');
				getline(liness,name,' ');
			}
		/*	istringstream liness2(mac);
			string m1,m2,m3;
			if(liness2.good()){
				getline(liness2,m1,':');
				getline(liness2,m2,':');
				getline(liness2,m3,':');
			}
			stringstream ss;
			int x;
			ss << std::hex << m1 << m2 << m3;
			ss >> x;
		*/
			if(mac != ""){
				//pair<string,int> cpair(mac,0);
				//clist.push_back(cpair);
				list[mac].name=name;
				clist.push_back(mac);
				//cout << mac << endl;
				list[mac].mac=mac;
				count[mac]=0;
			}

		}
		//cout << list.size() << " " << count.size() << endl;
	} else cout << "Cant open file.";
	mac_list.close();
	FILE *mac_address = fopen(mac_addr_arg,"rb");
	int byte;
	int bArray[3];
	int counter = 0;
	string constructed;
	List::const_iterator found;
	while((byte=fgetc(mac_address)) != EOF){
		if(counter < 3){ //only load first 3 bytes
			bArray[counter]=byte;
		}
		if(counter ==2){ //should happen after the 3 bytes are loaded
			constructed = doString(bArray);
			found = list.find(constructed);
			if(found != list.end()){
				//found
				count[constructed]++;
			} else unknown++;
		}
		counter = (counter + 1) % 6;
	}
	mac_addr.close();
	printResults();
	return 0;
}
void printResults(){
	for(vector<string>::iterator it = clist.begin(); it != clist.end(); ++it){
		if(count[*it] !=0) {
			//cout << *it << endl;
			cout << list[*it].mac << " " << count[*it] << " " << list[*it].name << endl;
		}
	}
	cout << "--:--:-- " << unknown << " " << "UNKNOWN" << endl;
}
string doString(int bytes[]){
	string str;
	for(int i = 0; i<3;i++){
		switch(bytes[i]){
		case 0x00:
			str.append("00:");
			break;
		case 0x01:
			str.append("01:");
			break;
		case 0x02:
			str.append("02:");
			break;
		case 0x03:
			str.append("03:");
			break;
		case 0x04:
			str.append("04:");
			break;
		case 0x05:
			str.append("05:");
			break;
		case 0x06:
			str.append("06:");
			break;
		case 0x07:
			str.append("07:");
			break;
		case 0x08:
			str.append("08:");
			break;
		case 0x09:
			str.append("09:");
			break;
		case 0x0A:
			str.append("0A:");
			break;
		case 0x0B:
			str.append("0B:");
			break;
		case 0x0C:
			str.append("0C:");
			break;
		case 0x0D:
			str.append("0D:");
			break;
		case 0x0E:
			str.append("0E:");
			break;
		case 0x0F:
			str.append("0F:");
			break;
		case 0x10:
			str.append("10:");
			break;
		case 0x11:
			str.append("11:");
			break;
		case 0x12:
			str.append("12:");
			break;
		case 0x13:
			str.append("13:");
			break;
		case 0x14:
			str.append("14:");
			break;
		case 0x15:
			str.append("15:");
			break;
		case 0x16:
			str.append("16:");
			break;
		case 0x17:
			str.append("17:");
			break;
		case 0x18:
			str.append("18:");
			break;
		case 0x19:
			str.append("19:");
			break;
		case 0x1A:
			str.append("1A:");
			break;
		case 0x1B:
			str.append("1B:");
			break;
		case 0x1C:
			str.append("1C:");
			break;
		case 0x1D:
			str.append("1D:");
			break;
		case 0x1E:
			str.append("1E:");
			break;
		case 0x1F:
			str.append("1F:");
			break;
		case 0x20:
			str.append("20:");
			break;
		case 0x21:
			str.append("21:");
			break;
		case 0x22:
			str.append("22:");
			break;
		case 0x23:
			str.append("23:");
			break;
		case 0x24:
			str.append("24:");
			break;
		case 0x25:
			str.append("25:");
			break;
		case 0x26:
			str.append("26:");
			break;
		case 0x27:
			str.append("27:");
			break;
		case 0x28:
			str.append("28:");
			break;
		case 0x29:
			str.append("29:");
			break;
		case 0x2A:
			str.append("2A:");
			break;
		case 0x2B:
			str.append("2B:");
			break;
		case 0x2C:
			str.append("2C:");
			break;
		case 0x2D:
			str.append("2D:");
			break;
		case 0x2E:
			str.append("2E:");
			break;
		case 0x2F:
			str.append("2F:");
			break;
		case 0x30:
			str.append("30:");
			break;
		case 0x31:
			str.append("31:");
			break;
		case 0x32:
			str.append("32:");
			break;
		case 0x33:
			str.append("33:");
			break;
		case 0x34:
			str.append("34:");
			break;
		case 0x35:
			str.append("35:");
			break;
		case 0x36:
			str.append("36:");
			break;
		case 0x37:
			str.append("37:");
			break;
		case 0x38:
			str.append("38:");
			break;
		case 0x39:
			str.append("39:");
			break;
		case 0x3A:
			str.append("3A:");
			break;
		case 0x3B:
			str.append("3B:");
			break;
		case 0x3C:
			str.append("3C:");
			break;
		case 0x3D:
			str.append("3D:");
			break;
		case 0x3E:
			str.append("3E:");
			break;
		case 0x3F:
			str.append("3F:");
			break;
		case 0x40:
			str.append("40:");
			break;
		case 0x41:
			str.append("41:");
			break;
		case 0x42:
			str.append("42:");
			break;
		case 0x43:
			str.append("43:");
			break;
		case 0x44:
			str.append("44:");
			break;
		case 0x45:
			str.append("45:");
			break;
		case 0x46:
			str.append("46:");
			break;
		case 0x47:
			str.append("47:");
			break;
		case 0x48:
			str.append("48:");
			break;
		case 0x49:
			str.append("49:");
			break;
		case 0x4A:
			str.append("4A:");
			break;
		case 0x4B:
			str.append("4B:");
			break;
		case 0x4C:
			str.append("4C:");
			break;
		case 0x4D:
			str.append("4D:");
			break;
		case 0x4E:
			str.append("4E:");
			break;
		case 0x4F:
			str.append("4F:");
			break;
		case 0x50:
			str.append("50:");
			break;
		case 0x51:
			str.append("51:");
			break;
		case 0x52:
			str.append("52:");
			break;
		case 0x53:
			str.append("53:");
			break;
		case 0x54:
			str.append("54:");
			break;
		case 0x55:
			str.append("55:");
			break;
		case 0x56:
			str.append("56:");
			break;
		case 0x57:
			str.append("57:");
			break;
		case 0x58:
			str.append("58:");
			break;
		case 0x59:
			str.append("59:");
			break;
		case 0x5A:
			str.append("5A:");
			break;
		case 0x5B:
			str.append("5B:");
			break;
		case 0x5C:
			str.append("5C:");
			break;
		case 0x5D:
			str.append("5D:");
			break;
		case 0x5E:
			str.append("5E:");
			break;
		case 0x5F:
			str.append("5F:");
			break;
		case 0x60:
			str.append("60:");
			break;
		case 0x61:
			str.append("61:");
			break;
		case 0x62:
			str.append("62:");
			break;
		case 0x63:
			str.append("63:");
			break;
		case 0x64:
			str.append("64:");
			break;
		case 0x65:
			str.append("65:");
			break;
		case 0x66:
			str.append("66:");
			break;
		case 0x67:
			str.append("67:");
			break;
		case 0x68:
			str.append("68:");
			break;
		case 0x69:
			str.append("69:");
			break;
		case 0x6A:
			str.append("6A:");
			break;
		case 0x6B:
			str.append("6B:");
			break;
		case 0x6C:
			str.append("6C:");
			break;
		case 0x6D:
			str.append("6D:");
			break;
		case 0x6E:
			str.append("6E:");
			break;
		case 0x6F:
			str.append("6F:");
			break;
		case 0x70:
			str.append("70:");
			break;
		case 0x71:
			str.append("71:");
			break;
		case 0x72:
			str.append("72:");
			break;
		case 0x73:
			str.append("73:");
			break;
		case 0x74:
			str.append("74:");
			break;
		case 0x75:
			str.append("75:");
			break;
		case 0x76:
			str.append("76:");
			break;
		case 0x77:
			str.append("77:");
			break;
		case 0x78:
			str.append("78:");
			break;
		case 0x79:
			str.append("79:");
			break;
		case 0x7A:
			str.append("7A:");
			break;
		case 0x7B:
			str.append("7B:");
			break;
		case 0x7C:
			str.append("7C:");
			break;
		case 0x7D:
			str.append("7D:");
			break;
		case 0x7E:
			str.append("7E:");
			break;
		case 0x7F:
			str.append("7F:");
			break;
		case 0x80:
			str.append("80:");
			break;
		case 0x81:
			str.append("81:");
			break;
		case 0x82:
			str.append("82:");
			break;
		case 0x83:
			str.append("83:");
			break;
		case 0x84:
			str.append("84:");
			break;
		case 0x85:
			str.append("85:");
			break;
		case 0x86:
			str.append("86:");
			break;
		case 0x87:
			str.append("87:");
			break;
		case 0x88:
			str.append("88:");
			break;
		case 0x89:
			str.append("89:");
			break;
		case 0x8A:
			str.append("8A:");
			break;
		case 0x8B:
			str.append("8B:");
			break;
		case 0x8C:
			str.append("8C:");
			break;
		case 0x8D:
			str.append("8D:");
			break;
		case 0x8E:
			str.append("8E:");
			break;
		case 0x8F:
			str.append("8F:");
			break;
		case 0x90:
			str.append("90:");
			break;
		case 0x91:
			str.append("91:");
			break;
		case 0x92:
			str.append("92:");
			break;
		case 0x93:
			str.append("93:");
			break;
		case 0x94:
			str.append("94:");
			break;
		case 0x95:
			str.append("95:");
			break;
		case 0x96:
			str.append("96:");
			break;
		case 0x97:
			str.append("97:");
			break;
		case 0x98:
			str.append("98:");
			break;
		case 0x99:
			str.append("99:");
			break;
		case 0x9A:
			str.append("9A:");
			break;
		case 0x9B:
			str.append("9B:");
			break;
		case 0x9C:
			str.append("9C:");
			break;
		case 0x9D:
			str.append("9D:");
			break;
		case 0x9E:
			str.append("9E:");
			break;
		case 0x9F:
			str.append("9F:");
			break;
		case 0xA0:
			str.append("A0:");
			break;
		case 0xA1:
			str.append("A1:");
			break;
		case 0xA2:
			str.append("A2:");
			break;
		case 0xA3:
			str.append("A3:");
			break;
		case 0xA4:
			str.append("A4:");
			break;
		case 0xA5:
			str.append("A5:");
			break;
		case 0xA6:
			str.append("A6:");
			break;
		case 0xA7:
			str.append("A7:");
			break;
		case 0xA8:
			str.append("A8:");
			break;
		case 0xA9:
			str.append("A9:");
			break;
		case 0xAA:
			str.append("AA:");
			break;
		case 0xAB:
			str.append("AB:");
			break;
		case 0xAC:
			str.append("AC:");
			break;
		case 0xAD:
			str.append("AD:");
			break;
		case 0xAE:
			str.append("AE:");
			break;
		case 0xAF:
			str.append("AF:");
			break;
		case 0xB0:
			str.append("B0:");
			break;
		case 0xB1:
			str.append("B1:");
			break;
		case 0xB2:
			str.append("B2:");
			break;
		case 0xB3:
			str.append("B3:");
			break;
		case 0xB4:
			str.append("B4:");
			break;
		case 0xB5:
			str.append("B5:");
			break;
		case 0xB6:
			str.append("B6:");
			break;
		case 0xB7:
			str.append("B7:");
			break;
		case 0xB8:
			str.append("B8:");
			break;
		case 0xB9:
			str.append("B9:");
			break;
		case 0xBA:
			str.append("BA:");
			break;
		case 0xBB:
			str.append("BB:");
			break;
		case 0xBC:
			str.append("BC:");
			break;
		case 0xBD:
			str.append("BD:");
			break;
		case 0xBE:
			str.append("BE:");
			break;
		case 0xBF:
			str.append("BF:");
			break;
		case 0xC0:
			str.append("C0:");
			break;
		case 0xC1:
			str.append("C1:");
			break;
		case 0xC2:
			str.append("C2:");
			break;
		case 0xC3:
			str.append("C3:");
			break;
		case 0xC4:
			str.append("C4:");
			break;
		case 0xC5:
			str.append("C5:");
			break;
		case 0xC6:
			str.append("C6:");
			break;
		case 0xC7:
			str.append("C7:");
			break;
		case 0xC8:
			str.append("C8:");
			break;
		case 0xC9:
			str.append("C9:");
			break;
		case 0xCA:
			str.append("CA:");
			break;
		case 0xCB:
			str.append("CB:");
			break;
		case 0xCC:
			str.append("CC:");
			break;
		case 0xCD:
			str.append("CD:");
			break;
		case 0xCE:
			str.append("CE:");
			break;
		case 0xCF:
			str.append("CF:");
			break;
		case 0xD0:
			str.append("D0:");
			break;
		case 0xD1:
			str.append("D1:");
			break;
		case 0xD2:
			str.append("D2:");
			break;
		case 0xD3:
			str.append("D3:");
			break;
		case 0xD4:
			str.append("D4:");
			break;
		case 0xD5:
			str.append("D5:");
			break;
		case 0xD6:
			str.append("D6:");
			break;
		case 0xD7:
			str.append("D7:");
			break;
		case 0xD8:
			str.append("D8:");
			break;
		case 0xD9:
			str.append("D9:");
			break;
		case 0xDA:
			str.append("DA:");
			break;
		case 0xDB:
			str.append("DB:");
			break;
		case 0xDC:
			str.append("DC:");
			break;
		case 0xDD:
			str.append("DD:");
			break;
		case 0xDE:
			str.append("DE:");
			break;
		case 0xDF:
			str.append("DF:");
			break;
		case 0xE0:
			str.append("E0:");
			break;
		case 0xE1:
			str.append("E1:");
			break;
		case 0xE2:
			str.append("E2:");
			break;
		case 0xE3:
			str.append("E3:");
			break;
		case 0xE4:
			str.append("E4:");
			break;
		case 0xE5:
			str.append("E5:");
			break;
		case 0xE6:
			str.append("E6:");
			break;
		case 0xE7:
			str.append("E7:");
			break;
		case 0xE8:
			str.append("E8:");
			break;
		case 0xE9:
			str.append("E9:");
			break;
		case 0xEA:
			str.append("EA:");
			break;
		case 0xEB:
			str.append("EB:");
			break;
		case 0xEC:
			str.append("EC:");
			break;
		case 0xED:
			str.append("ED:");
			break;
		case 0xEE:
			str.append("EE:");
			break;
		case 0xEF:
			str.append("EF:");
			break;
		case 0xF0:
			str.append("F0:");
			break;
		case 0xF1:
			str.append("F1:");
			break;
		case 0xF2:
			str.append("F2:");
			break;
		case 0xF3:
			str.append("F3:");
			break;
		case 0xF4:
			str.append("F4:");
			break;
		case 0xF5:
			str.append("F5:");
			break;
		case 0xF6:
			str.append("F6:");
			break;
		case 0xF7:
			str.append("F7:");
			break;
		case 0xF8:
			str.append("F8:");
			break;
		case 0xF9:
			str.append("F9:");
			break;
		case 0xFA:
			str.append("FA:");
			break;
		case 0xFB:
			str.append("FB:");
			break;
		case 0xFC:
			str.append("FC:");
			break;
		case 0xFD:
			str.append("FD:");
			break;
		case 0xFE:
			str.append("FE:");
			break;
		case 0xFF:
			str.append("FF:");
			break;
		}
	}
	return str.substr(0,str.size()-1);
}
