include ../ladder.4th
\ Latching motor controller with overhead protection

: START IN0 ;
: STOP IN1 ;
: OVERHEAT IN3 ;

: MOTOR-MERKER SPR0 ;
: MOTOR OUT0 ;

(start)
||
||- -| OVERHEAT |- -( TMR )- -||
||
||- -| START |-        -+
||- -| MOTOR-MERKER |- -+- -|/ STOP |- -|/ TMR |- -( MOTOR-MERKER )- -||
||
||- -| MOTOR-MERKER |- -( MOTOR )- -||
||
(end)

bye
