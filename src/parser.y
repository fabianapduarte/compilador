%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <math.h>
  #include <stdbool.h>
  #include "./lib/record.h"

  int yylex(void);
  int yyerror(char *s);
  extern int yylineno;
  extern char * yytext;
%}

%union {
  char * sValue;
  struct record * rec;
};

%token <sValue> TYPE ID STR_LIT BOOL_LIT INT_LIT FLOAT_INT CHAR_LIT OBJ_LIT ARR_LIT

%token GLOBAL CONST ASSIGN
%token FOR WHILE DO IF SWITCH CASE DEFAULT BREAK CONTINUE
%token <sValue> ELIF ELSE 
%token FUNC RETURN PRINT PARSEINT PARSEFLOAT PARSECHAR PARSESTRING
%token OR AND NOT EQUAL DIFFERENCE GREATER_THAN GREATER_THAN_OR_EQUAL LESS_THAN LESS_THAN_OR_EQUAL
%token SUM INCREMENT SUBTRACTION DECREMENT MULTIPLICATION POWER DIVISION REST

%type <rec> function stmt stmts args args_aux
%type <rec> assign decl_var decl_const decl_global expr expr_eq expr_comp oper term factor oper_incr_decr atr_list
%type <rec> loop for do_while while
%type <rec> conditional else elif_list elif if_then switch cases case

%start program

%%

program : stmts {printf("%s%s\n", $1);};

stmts : {$$ = strdup("");} 
      | stmt stmts {printf("%s\n%s", $1, $2);} 
      ;
      
stmt : function {$$ = $1;} | decl_var | decl_const | decl_global | assign | loop | conditional;

decl_var : TYPE ID ASSIGN expr { printf("%s %s = %s", $1, $2, $4); }
         ; 

decl_const : CONST TYPE ID ASSIGN expr { printf("const %s %s = %s", $2, $3, $5); }
           ;

decl_global : GLOBAL TYPE ID ASSIGN expr { printf("global %s %s = %s", $2, $3, $5); }
            ;

function : TYPE FUNC ID '(' args ')' '{' stmts '}' {printf("%s FUNC %s(%s)", $1, $3, $5);}  
         ;

args : {$$ = strdup("");}
     | args_aux {$$ = $1;}
     ;

args_aux : TYPE ID { printf("%s %s", $1, $2); }
         | TYPE ID ',' args_aux { printf("%s %s; %s", $1, $2, $4); }
         ;

assign : ID ASSIGN expr { $$ = $3; }
       /*| TYPE ID ASSIGN { atr_list }*/
       ;

/*atr_list : TYPE 
         | elements COMMA INTEGER
         ;*/

expr : NOT expr_eq { $$ = !$2; }
     | expr_eq OR expr { $$ = $1 || $3; }
     | expr_eq AND expr { $$ = $1 && $3; }
     | expr_eq
     ;

expr_eq : expr_comp EQUAL expr_eq { $$ = $1 == $3; }
        | expr_comp DIFFERENCE expr_eq { $$ = $1 != $3; }
        | expr_comp
        ;

expr_comp : oper GREATER_THAN expr_comp { $$ = $1 > $3; }
          | oper GREATER_THAN_OR_EQUAL expr_comp { $$ = $1 >= $3; }
          | oper LESS_THAN expr_comp { $$ = $1 < $3; }
          | oper LESS_THAN_OR_EQUAL expr_comp { $$ = $1 <= $3; }
          | oper
          ;

oper : term SUM oper { $$ = atoi($1->code) + atoi($3->code); }
     | term SUBTRACTION oper { $$ = atoi($1->code) - atoi($3->code); }
     | term { $$ = $1; }
     ;

term : factor MULTIPLICATION term { $$ = atoi($1->code) * atoi($3->code); }
     | factor DIVISION term { $$ = atoi($1->code) / atoi($3->code); }
     | factor REST term { $$ = atoi($1->code) % atoi($3->code); }
     /*Ta com erro de tipo aqui nessa potencia, to arredondando pra int por ora*/
     | factor POWER term { $$ = (int) pow(atof($1->code), atof ($3->code)); }
     | factor { $$ = $1; }
     ;

factor : '(' expr ')' { $$ = ($2); }
       | oper_incr_decr { $$ = $1; }
       | ID { $$ = $1; }
       | BOOL_LIT { $$ = $1; }
       | INT_LIT { $$ = $1; }
       | FLOAT_INT { $$ = $1; }
       | STR_LIT { $$ = $1; }
       | CHAR_LIT { $$ = $1; }
       ;

oper_incr_decr : ID INCREMENT { $$ = atoi($1)+1; }
               | ID DECREMENT { $$ = atoi($1)-1; } 
               | INCREMENT ID { $$ = atoi($2)+1; }
               | DECREMENT ID { $$ = atoi($2)-1; }
               ;

conditional : if_then { $$ = $1; }
            | if_then else { $$ = $1; }
            | if_then elif_list else { $$ = $1; }
            | switch { $$ = $1; }
            ;

else : ELSE '{' stmts '}' { printf("\nELSE {}", $1); }
     ;

elif_list : elif { $$ = $1; }
          | elif elif_list { $$ = $1; }
          ;

elif : ELIF '(' expr ')' '{' stmts '}' { printf("%s ELIF (%s) ELSE {}", $1, $3); }
     ;

if_then : IF '(' expr ')' '{' stmts '}' { printf("IF (%s) {}", $3); }
        ;

switch : SWITCH '(' ID ')' '{' cases DEFAULT ':' stmts BREAK '}'
       ;

cases : case | case cases
      ;

case : CASE ID ':' stmts BREAK
     ;

loop : for { $$ = $1; }
     | while { $$ = $1; }
     | do_while { $$ = $1; }
     ;

for : FOR '(' decl_var ';' expr ';' oper_incr_decr ')' '{' stmts '}' { printf("FOR (%s; %s; %s)", $3, $5->code, $7->code); }
    ;

while : WHILE '(' expr ')' '{' stmts '}' { printf("WHILE (%s) {}", $3); }
      ;

do_while : DO '{' stmts '}' WHILE '(' expr ')' { printf("DO {} WHILE (%s)", $7); }
         ;

%%

int main(void) {
	return yyparse();
}

int yyerror(char *msg) {
	fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}