; Katkestuste näide timer mooduli kaudu RGB ledid

#define IO_SREG     0x3F

#define IO_SPH      0x3E
#define IO_SPL      0x3D

#define IO_MCUCR    0x35

#define IO_PINA     0x00
#define IO_DDRA     0x01
#define IO_PORTA    0x02

#define IO_PINE     0x0C
#define IO_DDRE     0x0D
#define IO_PORTE    0x0E

#define IO_PINF     0x0F
#define IO_DDRF     0x10
#define IO_PORTF    0x11

#define TCCR1A      0x80
#define TCCR1B      0x81
#define TCCR1C      0x82
#define TIMSK1      0x6F
#define IO_TIFR1    0x16

#define OCR1AL      0x88
#define OCR1AH      0x89
#define OCR1BL      0x8A
#define OCR1BH      0x8B
#define OCR1CL      0x8C
#define OCR1CH      0x8D

#define TCNT1H      0x85
#define TCNT1L      0x84

#define USBCON      0xD8
#define OTGIEN      0xDE

#define IO_PORTF    0x11
#define IO_DDRF     0x10

#define TCNT1H      0x85
#define TCNT1L      0x84

.ORG 0x0000
    JMP   Main

.ORG 0x0044
    JMP   ISR_Timer1_COMPA
.ORG 0x0048
    JMP   ISR_Timer1_COMPB
.ORG 0x004C
    JMP   ISR_Timer1_COMPC
.ORG 0x0050
    JMP   ISR_Timer1_OVF

.ORG 0x0100
Main:
    ;disable interupts
    CLI
    
    ;initialise stack
    LDI   R16, 0x10
    OUT   IO_SPH, R16
    LDI   R17, 0xFF
    OUT   IO_SPL, R17

    ;initialise PORTF and PORTE
    SBI   IO_DDRE, 7
    SBI   IO_DDRF, 0
    SBI   IO_DDRF, 1

    ;initialise TIMER1
    LDI   R16, 0x00
    STS   TCCR1A, R16
    LDI   R16, 0x02
    STS   TCCR1B, R16
    LDI   R16, 0x00
    STS   TCCR1C, R16
    LDI   R16, 0x0F
    STS   TIMSK1, R16
    SBI   IO_TIFR1, 0
    SBI   IO_TIFR1, 1
    SBI   IO_TIFR1, 2
    SBI   IO_TIFR1, 3

    LDI   R16, 0x00
    STS   USBCON, R16
    STS   OTGIEN, R16
    
    LDI   R17, 0x00
    LDI   R18, 0xF0
    
    STS   TCNT1H, R18
    STS   TCNT1L, R17

    ;red led
    LDI   R17, 0xFF
    LDI   R18, 0xF8

    STS   OCR1AH, R18
    STS   OCR1AL, R17

    ;green led
    LDI   R17, 0x01
    LDI   R18, 0xF0

    STS   OCR1BH, R18
    STS   OCR1BL, R17
    
    ;blue led
    LDI   R17, 0xFF
    LDI   R18, 0xF8

    STS   OCR1CH, R18
    STS   OCR1CL, R17

    ;enable interrupts
    SEI

Loop:
    NOP
    JMP   Loop

ISR_Timer1_OVF:
    SBI   IO_PORTE, 7
    SBI   IO_PORTF, 0
    SBI   IO_PORTF, 1
    
    LDI   R17, 0x00
    LDI   R18, 0xF0
    
    STS   TCNT1H, R18
    STS   TCNT1L, R17
    
    RETI

ISR_Timer1_COMPA:
    CBI   IO_PORTE, 7
    RETI

ISR_Timer1_COMPB:
    CBI   IO_PORTF, 0
    RETI

ISR_Timer1_COMPC:
    CBI   IO_PORTF, 1
    RETI

