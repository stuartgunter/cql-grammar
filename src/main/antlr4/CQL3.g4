// http://cassandra.apache.org/doc/cql3/CQL.html

grammar CQL3;


statements: statement? (';' statement)* ;

statement: select_statement ;

select_statement: K_SELECT select_clause K_FROM table_name ;

select_clause: '*' ;

table_name: (IDENTIFIER '.')? IDENTIFIER ;

IDENTIFIER: [a-zA-Z_] [a-zA-Z_0-9]* ;


K_SELECT : S E L E C T;
K_FROM : F R O M;


fragment DIGIT : [0-9];
fragment A : [aA];
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];


WS : [ \t\r\n] -> skip ;
