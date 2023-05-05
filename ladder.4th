\ parse for ladder logic
\ (c)copyright 2022, 2023 by Gerald Wodni <gerald.wodni@gmail.com>

\ include PLC-14500 assembler
include ./assi.4th

variable line-open
variable post-invert
variable first-or

warnings off
: (start)
\ *G perform assembler-(start), out- & input-enable
    first-or on
    (start)
    RR ORC,
    RR IEN,
    RR OEN, ;

: (end)
\ *G JMP to start and perform assembler-(end)
    JMP, (end) ;
warnings on

: || ( -- )
\ *G treat the rest of the line as comment
    13 parse 2drop ;

: ||- ( -- t )
\ *G start ladder line
    line-open @ if
        abort" Line already open, possible missplaced '||-'"
    else
        RR ORC, \ put true into RR
        line-open on
    then ;

: -|| ( x -- )
\ *G end ladder line
    line-open @ if
        line-open off
    else
        abort" Line already closed, possible missplaced '-||' or '-+'"
    then ;

: -| ( f -- f )
\ *G Start input expression, must be closed with '|-' or '/|-'.
\ ** The expression can assume one flag on the stack.
\ ** The expression itself must put an extra flag on the stack.
\ *E Example: -| I1 |-
    post-invert off ;

: -|/ ( f -- f)
\ *G Like '-|', but instructs closing counterpart to invert.
\ *P Must be closed by '|-'.
    post-invert on ;

\ *S And-parsing
\ *P Logical ands always reside on the same line,
\ ** therfor parsing them is trivial

: |- ( f1 f2 -- f3 )
\ *G graphical end of input expression synonym for \see{and}
    post-invert @ if 
        ANDC,
    else
        AND,
    then ;

: /|- ( f1 f2 -- f3 )
\ *G graphical end of inverted input expression synonym for \see{andc}
    post-invert @ if
        abort" Cannot use '/|-' when starting with '-|/': too much inverting"
    else
        ANDC,
    then ;

: -( ; ( f -- f f )
\ *G graphical start of output synonym

: )- ( f -- f )
\ *G graphical end of output synonym (expected one flag to be left on the stack)
    STO, ;

\ *S Or-parsing
\ *P Logical ors are on different lines.
\ ** To avoid temporary variables the final outputs are at the bottom line.

: -+ ( f -- f )
\ *G End line and leave flag for consumation by following lines
    line-open @ if
        first-or @ 0= if
            SPR6 OR,
        then
        SPR6 STO,
        first-or off
        line-open off
    else
        abort" Line already closed, possible missplaced '-+' or '-||'"
    then ;

: -+- ( -- )
\ *G graphical join lines synonym
    SPR6 OR,
    first-or on
    ;

