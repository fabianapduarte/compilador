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

%type <sValue> body
%type <sValue> function
%type <sValue> subpgrm subpgrms args args_aux
%type <sValue> assign decl_var decl_const decl_global expr term factor expr_incr_decr
%type <sValue> loop for do_while while
/* %type <sValue> conditional if_else if_elif if_then switch cases case */



%start program

%%

program : subpgrms body {printf("%s%s\n", $1, $2);};

subpgrms : {$$ = strdup("");} 
         | subpgrm body {printf("%s\n%s", $1, $2);} 
         ;

subpgrm : function {$$ = $1;} | decl_var | decl_const | decl_global | assign | loop;

decl_var : TYPE ID ASSIGN expr { printf("%s %s = %s", $1, $2, $4); }
         ; 

decl_const : CONST TYPE ID ASSIGN expr { printf("const %s %s = %s", $2, $3, $5); }
           ;

decl_global : GLOBAL TYPE ID ASSIGN expr { printf("global %s %s = %s", $2, $3, $5); }
            ;

function : TYPE FUNC ID '(' args ')' '{' body '}' {printf("%s FUNC %s(%s)", $1, $3, $5);}  
         ;

args : {$$ = strdup("");}
     | args_aux {$$ = $1;}
     ;

args_aux : TYPE ID { printf("%s %s", $1, $2); }
         | TYPE ID ',' args_aux { printf("%s %s; %s", $1, $2, $4); }
         ;

body : { $$ = strdup(""); }
     ;

assign : ID ASSIGN expr { $$ = $3; }
       ;

expr : term SUM expr { $$ = $1 + $3; }
     | term SUBTRACTION expr { $$ = $1 - $3; }
     | term { $$ = $1; }
     ;

term : factor MULTIPLICATION term { $$ = $1 * $3; }
     | factor DIVISION term { $$ = $1 / $3; }
     | factor REST term { $$ = $1 % $3; }
     | factor POWER term { $$ = pow($1, $3); }
     | factor { $$ = $1; }
     ;

factor : '(' expr ')' { $$ = ($2); }
       | expr_incr_decr { $$ = $1; }
       | ID { $$ = $1; }
       | LITERAL { $$ = $1; }
       ;

expr_incr_decr : ID INCREMENT { $$ = $1++; }
               | ID DECREMENT { $$ = $1--; } 
               | INCREMENT ID { $$ = ++$2; }
               | DECREMENT ID { $$ = --$2; }
               ;

/* conditionals : conditional | conditional conditionals; */

/* conditional : if_else { $$ = $1; }
            | if_elif { $$ = $1; }
            | if_then { $$ = $1; }
            | switch { $$ = $1; }
            ;

if_else : if_then ELSE '{' subpgrms '}' { printf("%s ELSE {}", $1) }
        ;

if_elif : if_then ELIF '(' expr ')' '{' subpgrms '}' ELSE '{' subpgrms '}' { printf("%s ELIF (%s) ELSE {}", $1, $4) }
        | 
        ;

if_then : IF '(' expr ')' '{' subpgrms '}' { printf("IF (%s) {}", $3) }
        ;

switch : SWITCH '(' ID ')' '{' cases DEFAULT ':' subpgrms BREAK '}'
       ;

cases : case | case cases
      ;

case : CASE ID ':' subpgrms BREAK */
     ;

loop : for { $$ = $1; }
     | while { $$ = $1; }
     | do_while { $$ = $1; }
     ;

for : FOR '(' decl_var ';' expr ';' expr_incr_decr ')' '{' subpgrms '}' { printf("FOR (%s; %s; %s)", $3, $5, $7); }
    ;

while : WHILE '(' expr ')' '{' subpgrms '}' { printf("WHILE (%s) {}", $3); }
      ;

do_while : DO '{' subpgrms '}' WHILE '(' expr ')' { printf("DO {} WHILE (%s)", $7); }
         ;

%%

int main(void) {
	return yyparse();
}

int yyerror(char *msg) {
	fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}