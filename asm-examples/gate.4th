include ../assi.4th

: Up        IN0 ;
: Down      IN1 ;
: End-Up    IN2 ;
: End-Down  IN3 ;
: Obsticle  IN4 ;

: Motor-Up      OUT0 ;
: Motor-Down    OUT1 ;

: Going-Up      SPR0 ;
: Going-Down    SPR1 ;

(start)
ORC RR
IEN RR
OEN RR

\ allow down interrupt ( if no obstruction )
LD      Down
ANDC    Up
ANDC    Going-Up
SKZ
STOC    Going-Up

\ down latching
LD      Down
OR      Going-Down
ANDC    End-Down
STO     Going-Down

\ up latching
LD      Up
OR      Going-Up
ANDC    End-Up
STO     Going-Up

\ obstruction
LD      Obsticle
AND     Going-Down
SKZ
STO     Going-Up

\ Up alays wins
LD      Going-Up
AND     Going-Down
SKZ
STOC    Going-Down

\ Write Outputs
LD      Going-Up
STO     Motor-Up

LD      Going-Down
STO     Motor-Down

JMP
(end)

bye
