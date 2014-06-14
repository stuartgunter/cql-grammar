// Derived from http://cassandra.apache.org/doc/cql3/CQL.html

grammar CQL3;


IDENTIFIER
    : [a-zA-Z0-9_]+
    ;

CONSTANT
    : STRING
    | NUMBER
    | BOOLEAN
    | UUID
    | BLOB
    ;

VARIABLE
    : '?'
    | ':' IDENTIFIER
    ;

TERM
    : CONSTANT
    | COLLECTION
    | VARIABLE
    | FUNCTION '(' (TERM (',' TERM)*)? ')'
    ;

COLLECTION
    : MAP
    | SET
    | LIST
    ;

MAP
    : '{' ( TERM ':' TERM ( ',' TERM ':' TERM )* )? '}'
    ;

SET
    : '{' ( TERM ( ',' TERM )* )? '}'
    ;

LIST
    : '[' ( TERM ( ',' TERM )* )? ']'
    ;

FUNCTION
    : IDENTIFIER
    ;

PROPERTIES
    : PROPERTY (K_AND PROPERTY)*
    ;

PROPERTY
    : IDENTIFIER '=' ( IDENTIFIER | CONSTANT | MAP )
    ;

STRING
    : '\'' ( ~'\'' | '\'\'' )* '\''
    ;

NUMBER
    : INTEGER
    | FLOAT
    ;

INTEGER
    : '-'? DIGIT+
    ;

FLOAT
    : '-'? DIGIT+ ( '.' DIGIT* )? ( E [+-]? DIGIT+ )?
    | 'NaN'
    | 'Infinity'
    ;

BOOLEAN
    : K_TRUE
    | K_FALSE
    ;

UUID
    : HEX HEX HEX HEX HEX HEX HEX HEX '-' HEX HEX HEX HEX '-' HEX HEX HEX HEX '-' HEX HEX HEX HEX '-' HEX HEX HEX HEX HEX HEX HEX HEX HEX HEX HEX HEX
    ;

HEX
    : [0-9a-fA-F]
    ;

BLOB
    : [0][xX](HEX)+
    ;



statements
    : statement? (';' statement)*
    ;

statement
    : query
    ;

query
    : K_SELECT select_clause K_FROM table_name
    ;

select_clause
    : '*'
    ;

table_name
    : (IDENTIFIER '.')? IDENTIFIER
    ;




create_keyspace_stmt
    : K_CREATE K_KEYSPACE (K_IF K_NOT K_EXISTS)? IDENTIFIER K_WITH PROPERTIES
    ;


K_AND : A N D;
K_CREATE : C R E A T E;
K_EXISTS : E X I S T S;
K_FALSE : F A L S E;
K_FROM : F R O M;
K_IF : I F;
K_KEYSPACE : K E Y S P A C E;
K_NOT : N O T;
K_SELECT : S E L E C T;
K_TRUE : T R U E;
K_WITH : W I T H;


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

RESERVED : A D D
         | A L T E R
         | A N D
         | A N Y
         | A P P L Y
         | A S C
         | A U T H O R I Z E
         ;

SINGLE_LINE_COMMENT
    : '--' ~[\r\n]* -> channel(HIDDEN)
    ;

MULTILINE_COMMENT
    : '/*' .*? ( '*/' | EOF ) -> channel(HIDDEN)
    ;

SPACES
    : [ \u000B\t\r\n] -> channel(HIDDEN)
    ;

WS : [ \t\r\n] -> skip ;
