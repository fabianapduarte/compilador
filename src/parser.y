%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <math.h>
  #include <stdbool.h>

  int yylex(void);
  extern int yylineno;
  extern char * yytext;
%}

%union {
  int iValue; 	/* integer value */
  float fValue; 	/* float value */
  int bValue; 	/* bool value */
  char cValue; 	/* char value */
  char * sValue;  /* string value */
  char * type;    /* type value */
};

%token <type> TYPE
%token <sValue> ID GLOBAL CONST ASSIGN LITERAL
%token <sValue> FOR WHILE DO IF ELIF ELSE SWITCH CASE DEFAULT BREAK CONTINUE
%token <sValue> FUNC RETURN PRINT PARSEINT PARSEFLOAT PARSECHAR PARSESTRING
%token <sValue> OR AND NOT EQUAL DIFFERENCE GREATER_THAN GREATER_THAN_OR_EQUAL LESS_THAN LESS_THAN_OR_EQUAL
%token <sValue> SUM INCREMENT SUBTRACTION DECREMENT MULTIPLICATION POWER DIVISION REST

%type <sValue> function
%type <sValue> stmt stmts args args_aux
%type <sValue> assign decl_var decl_const decl_global expr expr_eq expr_comp oper term factor oper_incr_decr
%type <sValue> loop for do_while while
%type <sValue> conditional else elif_list elif if_then switch cases case

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
       ;

expr : NOT expr_eq { $$ = !$2 }
     | expr_eq OR expr { $$ = $1 || $3 }
     | expr_eq AND expr { $$ = $1 && $3 }
     | expr_eq
     ;

expr_eq : expr_comp EQUAL expr_eq { $$ = $1 == $3 }
        | expr_comp DIFFERENCE expr_eq { $$ = $1 != $3 }
        | expr_comp
        ;

expr_comp : oper GREATER_THAN expr_comp { $$ = $1 > $3 }
          | oper GREATER_THAN_OR_EQUAL expr_comp { $$ = $1 >= $3 }
          | oper LESS_THAN expr_comp { $$ = $1 < $3 }
          | oper LESS_THAN_OR_EQUAL expr_comp { $$ = $1 <= $3 }
          | oper
          ;

oper : term SUM oper { $$ = $1 + $3; }
     | term SUBTRACTION oper { $$ = $1 - $3; }
     | term { $$ = $1; }
     ;

term : factor MULTIPLICATION term { $$ = $1 * $3; }
     | factor DIVISION term { $$ = $1 / $3; }
     | factor REST term { $$ = $1 % $3; }
     | factor POWER term { $$ = pow($1, $3); }
     | factor { $$ = $1; }
     ;

factor : '(' expr ')' { $$ = ($2); }
       | oper_incr_decr { $$ = $1; }
       | ID { $$ = $1; }
       | LITERAL { $$ = $1; }
       ;

oper_incr_decr : ID INCREMENT { $$ = $1++; }
               | ID DECREMENT { $$ = $1--; } 
               | INCREMENT ID { $$ = ++$2; }
               | DECREMENT ID { $$ = --$2; }
               ;

conditional : if_then { $$ = $1; }
            | if_then else { $$ = $1; }
            | if_then elif_list else { $$ = $1; }
            | switch { $$ = $1; }
            ;

else : ELSE '{' stmts '}' { printf("\nELSE {}", $1); }
     ;

elif_list : { $$ = NULL; }
          | elif elif_list { $$ = $1; }
          ;

elif : ELIF '(' expr ')' '{' stmts '}' { printf("%s ELIF (%s) ELSE {}", $1, $3); }
     ;

if_then : IF '(' expr ')' '{' stmts '}' { printf("IF (%s) {}", $3) }
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

for : FOR '(' decl_var ';' expr ';' oper_incr_decr ')' '{' stmts '}' { printf("FOR (%s; %s; %s)", $3, $5, $7); }
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