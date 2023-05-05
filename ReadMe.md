# Assembler & Ladder Logic made in Forth

This projcet is based on Nicola Cimmino's wonderful [PLC-14500](https://github.com/nicolacimmino/PLC-14500) project.
It uses a MC14500 1-bit-cpu, which is purpose-made for PLC-like applications e.g. systems that run ladder-logic.

## Assembler

You can find the assembler in assi.4th, see also the asm-examples directory for some simple example. For people who want to see source code immediatly, here it is:

```forth
include ./assi.4th

: START IN0 ;
: STOP IN1 ;
: OVERHEAT IN3 ;

: MOTOR OUT0 ;

(start)
ORC RR
IEN RR
OEN RR

LD START
OR SPR0
ANDC TMR
STO SPR0

LD SPR0
ANDC STOP
STOC SPR0

LD SPR0
STO MOTOR

LD OVERHEAT
STO TMR

JMP
(end)

bye
```

`(start)` resets the internal program counter and the program memory.  
`(end)` writes the program to `out.hex`  
To upload the file to the PLC-14500, i just pipe it to the serial port: `cat out.hex > /dev/ttyUSB0`  
You can set the speed of the serial port by using stty: `stty 9600 /dev/ttyUSB0`.

Putting it all together you would run the assembler non-interactively by using it like so:
```bash
gforth <filename.4th> && cat out.hex > /dev/ttyUSB0
```
Hint: this is a Standard Program, feel free to use your favourite Forth system like vfxforth, swiftforth, of whatever floats you bits.

## Ladder

