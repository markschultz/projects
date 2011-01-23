TARGET=msp430x20x3_1
CPU=msp430x2013

CC=msp430-gcc
WARN=-W -Wall -Wshadow -Wconversion
CFLAGS=-Os -g -mmcu=$(CPU) $(WARN)


OBJS=$(TARGET).o 

all: $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET).elf $(OBJS)
	ls -lh *$(TARGET)*

program: $(TARGET)
	mspdebug rf2500 "prog $(TARGET).elf"

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -rf $(TARGET).elf $(OBJS) 

