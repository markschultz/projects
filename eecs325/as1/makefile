CC=g++
CFLAGS=-Wall -g
OBJS=
TARGET=proj1
main: $(OBJS)
	$(CC) $(CFLAGS) $(TARGET).cpp -o $(TARGET)

clean:
	rm -rf $(TARGET)
test: clean main
	./$(TARGET) mac-vendor-id.list addresses-50.dat
