\ Forth Assembler for MC14500
\ (c) copyright 2023 by Gerald Wodni

256 constant /prog
/prog buffer: prog
variable pc

: (start) ( -- )
    \ *G reset assembler
    prog /prog $00 fill
    0 pc ! ;

: (end) ( -- )
    \ *G write progbuffer
    cr pc @ . ." bytes" cr
    prog pc @ dump

    s" out.hex" w/o create-file throw >r
    prog /prog r@ write-file throw
    r> close-file throw
    ;

\ IO Map
: iomap ( address <parse-name> -- )
    create ,
    does> @ prog pc @ + c! ;

$00 iomap spr0  \ scratch pad ram
$10 iomap spr1
$20 iomap spr2
$30 iomap spr3
$40 iomap spr4
$50 iomap spr5
$60 iomap spr6
$70 iomap rr    \ result register (routed back into D)
$80 iomap OUT0  \ output leds
$90 iomap OUT1
$A0 iomap OUT2
$B0 iomap OUT3
$C0 iomap OUT4
$D0 iomap OUT5
$E0 iomap OUT6
$F0 iomap TMR
: IN0 OUT0 ;    \ input switches/buttons
: IN1 OUT1 ;
: IN2 OUT2 ;
: IN3 OUT3 ;
: IN4 OUT4 ;
: IN5 OUT5 ;
: IN6 OUT6 ;

\ Opcodes
: opcode ( opcode <parse-name> -- )
    create ,
    does> 
        @ prog pc @ + >r
        r@ c@ or dup hex. r> c!
        1 pc +!  ;

$0 opcode NOPO, \ No change in registers. R ~ R. FlGO +-S1..
$1 opcode LD,   \ Load Result Reg. Data -+ RR
$2 opcode LDC,  \ Load Complement Data -+- RR
$3 opcode AND,  \ logical AND. RR • 0 ..... RR
$4 opcode ANDC, \ logical AND Compl.RR· 0 ..... RR
$5 opcode OR,   \ logical OR. RR + 0'" RR
$6 opcode ORC,  \ logical OR Compl. RR +0'" RR
$7 opcode XNOR, \ Exclusive NOR. If RR = 0, RR +-1
$8 opcode STO,  \ Store. RR -+ Data Pin, Write +-1
$9 opcode STOC, \ Store Compl. RR -+ Data Pin, Write +-1
$A opcode IEN,  \ Input Enable. 0 -+IEN Reg.
$B opcode OEN,  \ Output Enable. 0'" OEN Reg.
$C opcode JMP,  \ Jump. JMP Flag <- .n..
$D opcode RTN,  \ Return. RTN Flag +-Jl.. Skip next Inst.
$E opcode SKZ,  \ Skip next instruction if RR = 0
$F opcode NOPF, \ No change in Registers RR -+RR, FLGF

