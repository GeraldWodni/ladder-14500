include ../assi.4th

: OLDSTEP SPR6 ;
: STEP SPR5 ;

(start)
ORC RR
IEN RR
OEN RR

LDC OLDSTEP
AND TMR



JMP
(end)

bye
