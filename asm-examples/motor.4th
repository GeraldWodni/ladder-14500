include ../assi.4th

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
