/*
* Copyright 2014 Stuart Gunter
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// Derived from http://cassandra.apache.org/doc/cql3/CQL.html


grammar CQL3;


statements
    : statement ( ';'+ statement )* ';'+
    ;

statement
    : drop_keyspace_stmt
    | create_keyspace_stmt
    | alter_keyspace_stmt
    | use_stmt
    | create_table_stmt
    | alter_table_stmt
    | drop_table_stmt
    | truncate_table_stmt
    | create_index_stmt
    | drop_index_stmt
    ;

create_keyspace_stmt
    : K_CREATE K_KEYSPACE (K_IF K_NOT K_EXISTS)? keyspace_name K_WITH properties
    ;

alter_keyspace_stmt
    : K_ALTER K_KEYSPACE keyspace_name K_WITH properties
    ;

drop_keyspace_stmt
    : K_DROP K_KEYSPACE (K_IF K_EXISTS)? keyspace_name
    ;

use_stmt
    : K_USE keyspace_name
    ;

create_table_stmt
    : K_CREATE (K_TABLE | K_COLUMNFAMILY) (K_IF K_NOT K_EXISTS)? table_name column_definitions (K_WITH table_options)?
    ;

alter_table_stmt
    : K_ALTER (K_TABLE | K_COLUMNFAMILY) table_name alter_table_instruction
    ;

alter_table_instruction
    : K_ALTER column_name K_TYPE column_type
    | K_ADD column_name column_type
    | K_DROP column_name
    | K_WITH table_options
    ;

drop_table_stmt
    : K_DROP K_TABLE (K_IF K_EXISTS)? table_name
    ;

truncate_table_stmt
    : K_TRUNCATE table_name
    ;

create_index_stmt
    : K_CREATE (K_CUSTOM)? K_INDEX (K_IF K_NOT K_EXISTS)? index_name? K_ON table_name '(' column_name ')'
      (K_USING index_class (K_WITH index_options)?)?
    ;

drop_index_stmt
    : K_DROP K_INDEX (K_IF K_EXISTS)? index_name
    ;

index_name
    : IDENTIFIER
    ;

index_class
    : STRING
    ;

index_options
    : K_OPTIONS '=' MAP
    ;

table_name
    : (keyspace_name '.')? IDENTIFIER
    ;

column_name
    : IDENTIFIER
    ;

table_options
    : table_option (K_AND table_option)*
    ;

table_option
    : property
    | K_COMPACT K_STORAGE
    | K_CLUSTERING K_ORDER
    ;

column_definitions
    : '(' column_definition (',' column_definition)* ')'
    ;

column_definition
    : column_name column_type (K_STATIC)? (K_PRIMARY K_KEY)?
    | K_PRIMARY K_KEY primary_key
    ;

column_type
    : data_type
    ;

primary_key
    : '(' partition_key (',' column_name)* ')'
    ;

partition_key
    : column_name
    | '(' column_name (',' column_name)* ')'
    ;

keyspace_name
    : IDENTIFIER
    ;

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
    | FUNCTION
    ;

COLLECTION
    : MAP
    | SET
    | LIST
    ;

MAP
    : '{' (TERM ':' TERM (',' TERM ':' TERM)*)? '}'
    ;

SET
    : '{' (TERM (',' TERM)*)? '}'
    ;

LIST
    : '[' (TERM (',' TERM)*)? ']'
    ;

FUNCTION
    : IDENTIFIER '(' (TERM (',' TERM)*)? ')'
    ;

properties
    : property (K_AND property)*
    ;

property
    : property_name '=' property_value
    ;

property_name
    : IDENTIFIER
    ;

property_value
    : IDENTIFIER
    | CONSTANT
    | MAP
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
    : '0' X (HEX)+
    ;


data_type
    : native_type
    | collection_type
    | STRING
    ;

native_type
    : 'ascii'
    | 'bigint'
    | 'blob'
    | 'boolean'
    | 'counter'
    | 'decimal'
    | 'double'
    | 'float'
    | 'inet'
    | 'int'
    | 'text'
    | 'timestamp'
    | 'timeuuid'
    | 'uuid'
    | 'varchar'
    | 'varint'
    ;

collection_type
    : 'list' '<' native_type '>'
    | 'set' '<' native_type '>'
    | 'map' '<' native_type ',' native_type '>'
    ;



keyword
    : reserved_keyword
    | non_reserved_keyword
    ;


non_reserved_keyword
    : K_CLUSTERING
    | K_COMPACT
    | K_KEY
    | K_STORAGE
    | K_TYPE
    ;

reserved_keyword
    : K_ADD
    | K_ALTER
    | K_AND
    | K_COLUMNFAMILY
    | K_CREATE
    | K_CUSTOM // docs don't specify whether this is reserved or not, playing it safe
    | K_DROP
    | K_EXISTS // docs don't specify whether this is reserved or not, playing it safe
    | K_FALSE // docs don't specify whether this is reserved or not, playing it safe
    | K_FROM
    | K_IF // docs don't specify whether this is reserved or not, playing it safe
    | K_INDEX
    | K_KEYSPACE
    | K_NOT // docs don't specify whether this is reserved or not, playing it safe
    | K_OPTIONS // docs don't specify whether this is reserved or not, playing it safe
    | K_ORDER
    | K_PRIMARY
    | K_SELECT
    | K_STATIC // docs don't specify whether this is reserved or not, playing it safe
    | K_TABLE
    | K_TRUE // docs don't specify whether this is reserved or not, playing it safe
    | K_TRUNCATE
    | K_USE
    | K_WITH
    ;


K_ADD:          A D D;
K_ALTER:        A L T E R;
K_AND:          A N D;
K_CLUSTERING:   C L U S T E R I N G;
K_COLUMNFAMILY: C O L U M N F A M I L Y;
K_COMPACT:      C O M P A C T;
K_CREATE:       C R E A T E;
K_CUSTOM:       C U S T O M;
K_DROP:         D R O P;
K_EXISTS:       E X I S T S;
K_FALSE:        F A L S E;
K_FROM:         F R O M;
K_IF:           I F;
K_INDEX:        I N D E X;
K_KEY:          K E Y;
K_KEYSPACE:     K E Y S P A C E;
K_NOT:          N O T;
K_ON:           O N;
K_OPTIONS:      O P T I O N S;
K_ORDER:        O R D E R;
K_PRIMARY:      P R I M A R Y;
K_SELECT:       S E L E C T;
K_STATIC:       S T A T I C;
K_STORAGE:      S T O R A G E;
K_TABLE:        T A B L E;
K_TRUE:         T R U E;
K_TRUNCATE:     T R U N C A T E;
K_TYPE:         T Y P E;
K_USE:          U S E;
K_USING:        U S I N G;
K_WITH:         W I T H;


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

SINGLE_LINE_COMMENT
    : ('--'|'//') ~[\r\n]* -> channel(HIDDEN)
    ;

MULTILINE_COMMENT
    : '/*' .*? ( '*/' | EOF ) -> channel(HIDDEN)
    ;

WS
    : [ \t\r\n] -> skip
    ;
