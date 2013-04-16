
AS=avr-as
GCC=avr-gcc
OBJCOPY=avr-objcopy
OBJDUMP=avr-objdump
CPP=avr-cpp
DFUPROG=dfu-programmer
CPU=at90usb647

all: 0001

0001: 0001.S
#	$(CPP) 0001.S -mmcu=atmega8u2 | 
#	$(AS) -o 0001.elf -mmcu=atmega8u2 0001.S
	$(GCC) -o 0001.elf -mmcu=at90usb647 0001.S -nostartfiles
	$(OBJCOPY) -O ihex 0001.elf 0001.hex -j .text
#	$(OBJDUMP) -D -M intel -m avr:6  0001.hex > 0001.asm
	$(OBJDUMP) -s -D -M intel -m avr:6  0001.elf > 0001.asm

clean:
	rm 0001.elf 0001.hex 0001.asm 

program:
	$(DFUPROG) $(CPU) erase
	$(DFUPROG) $(CPU) flash 0001.hex
	$(DFUPROG) $(CPU) start


