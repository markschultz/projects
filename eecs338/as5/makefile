CC=gcc
CFLAGS=-Wall -g
OBJS=
TARGET=main
main: $(OBJS)
	$(CC) $(CFLAGS) $(TARGET).c -o $(TARGET)

clean:
	rm -rf $(TARGET)
test: clean main
	./$(TARGET)
