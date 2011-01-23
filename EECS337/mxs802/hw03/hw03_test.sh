#
#	run the test script
#
make clean
make
./universe +debug +yydebug < input1.txt
./universe +debug +yydebug < input1234.txt
