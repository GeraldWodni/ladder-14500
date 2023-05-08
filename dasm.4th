\ Forth Disassembler for MC14500
\ (c) copyright 2023 by Gerald Wodni

variable read-buffer

\ Opcodes
: opcode ( opcode x <parse-name> -- R: x -- x )
    create , lastxt name>string 2,
    does>
        >r r@ @ over = if
            r@ cell+ 2@ 1- type
        then r> drop ;

$0 opcode NOPO? \ No change in registers. R ~ R. FlGO +-S1..
$1 opcode LD?   \ Load Result Reg. Data -+ RR
$2 opcode LDC?  \ Load Complement Data -+- RR
$3 opcode AND?  \ logical AND. RR • 0 ..... RR
$4 opcode ANDC? \ logical AND Compl.RR· 0 ..... RR
$5 opcode OR?   \ logical OR. RR + 0'" RR
$6 opcode ORC?  \ logical OR Compl. RR +0'" RR
$7 opcode XNOR? \ Exclusive NOR. If RR = 0, RR +-1
$8 opcode STO?  \ Store. RR -+ Data Pin, Write +-1
$9 opcode STOC? \ Store Compl. RR -+ Data Pin, Write +-1
$A opcode IEN?  \ Input Enable. 0 -+IEN Reg.
$B opcode OEN?  \ Output Enable. 0'" OEN Reg.
$C opcode JMP?  \ Jump. JMP Flag <- .n..
$D opcode RTN?  \ Return. RTN Flag +-Jl.. Skip next Inst.
$E opcode SKZ?  \ Skip next instruction if RR = 0
$F opcode NOPF? \ No change in Registers RR -+RR, FLGF

$00 opcode SPR0? \ scratch pad ram
$10 opcode SPR1?
$20 opcode SPR2?
$30 opcode SPR3?
$40 opcode SPR4?
$50 opcode SPR5?
$60 opcode SPR6?
$70 opcode RR?  \ result register (routed back into D)
$80 opcode IO0? \ output leds
$90 opcode IO1?
$A0 opcode IO2?
$B0 opcode IO3?
$C0 opcode IO4?
$D0 opcode IO5?
$E0 opcode IO6?
$F0 opcode TMR?

: hex.2 ( x -- )
    \ *G display hex with optional leading zero
    base @ >r
    0 hex <# # # #> type space
    r> base ! ;

: dasm-byte ( x -- )
    \ *G Display disassembled byte
    ?dup if
        cr dup hex.2
        dup $0F and
        NOPO?   LD?     LDC?    AND?
        ANDC?   OR?     ORC?    XNOR?
        STO?    STOC?   IEN?    OEN?
        JMP?    RTN?    SKZ?    NOPF?   drop
        space
        $F0 and
        SPR0?   SPR1?   SPR2?   SPR3?
        SPR4?   SPR5?   SPR6?   RR?
        IO0?    IO1?    IO2?    IO3?
        IO4?    IO5?    IO6?    TMR?    drop
    then ;

: dasm-file ( c-addr n -- )
    \ *G Display disassembled file
    r/o bin open-file throw >r
    begin
        read-buffer 1 r@ read-file throw
    while
        read-buffer c@ dasm-byte
    repeat r> close-file throw ;

\ s" out.hex" dasm-file
