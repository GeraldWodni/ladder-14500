\ prefix-invert tests

\ simulated inputs
: I5 true  ;
: I6 false ;

\ outputs
: O5 ." O5=" . ;
: O6 ." O6=" . ;

: test-inv-or->true
    ||- -| I5 |- -+
    ||- -| I6 |- -+- -( O5 )- -|| ;
test-inv-or->true

: test-inv-or->false
    ||- -|/ I5 |- -+
    ||- -|  I6 |- -+- -( O6 )- -|| ;
test-inv-or->false

