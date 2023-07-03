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
%token FOR WHILE DO IF CONTINUE
%token ELIF ELSE SWITCH CASE DEFAULT BREAK
%token FUNC RETURN PRINT PARSEINT PARSEFLOAT PARSECHAR PARSESTRING
%token OR AND NOT EQUAL DIFFERENCE GREATER_THAN GREATER_THAN_OR_EQUAL LESS_THAN LESS_THAN_OR_EQUAL
%token SUM INCREMENT SUBTRACTION DECREMENT MULTIPLICATION POWER DIVISION REST

%type <rec> stmts 
/* %type <rec> function stmt stmts args args_aux
%type <rec> assign decl_var decl_const decl_global expr expr_eq expr_comp oper term factor oper_incr_decr atr_list
%type <rec> loop for do_while while
%type <rec> conditional else elif_list elif if_then switch cases case */

%start program

%%

program : stmts {printf("%s\n", $1->code);
     freeRecord($1);
};

stmts : {$$ = createRecord("null program", "");}
      | STR_LIT {$$ = createRecord($1, "string"); 
      free($1);}
      ;

/*stmts : {$$->code = strdup("");} 
      | stmt stmts {printf("%s\n%s", $1->code, $2->code);} 
      ;
      
stmt : function {$$ = $1;} | decl_var | decl_const | decl_global | assign | loop | conditional;

decl_var : TYPE ID ASSIGN expr { printf("%s %s = %s", $1, $2, $4->code); }
         ; 

decl_const : CONST TYPE ID ASSIGN expr { printf("const %s %s = %s", $2, $3, $5->code); }
           ;

decl_global : GLOBAL TYPE ID ASSIGN expr { printf("global %s %s = %s", $2, $3, $5->code); }
            ;

function : TYPE FUNC ID '(' args ')' '{' stmts '}' {printf("%s FUNC %s(%s)", $1, $3, $5->code);}  
         ;

args : {$$->code = strdup("");}
     | args_aux {$$ = $1;}
     ;

args_aux : TYPE ID { printf("%s %s", $1, $2); }
         | TYPE ID ',' args_aux { printf("%s %s; %s", $1, $2, $4->code); }
         ;

assign : ID ASSIGN expr { $$ = $3; }
       /*| TYPE ID ASSIGN { atr_list }*/
       ;

/*atr_list : TYPE 
         | elements COMMA INTEGER
         ;*/

/*expr : NOT expr_eq { $$->bValue = !$2; }
     | expr_eq OR expr { $$->bValue = $1 || $3; }
     | expr_eq AND expr { $$->bValue = $1 && $3; }
     | expr_eq
     ;

expr_eq : expr_comp EQUAL expr_eq { $$->bValue = $1 == $3; }
        | expr_comp DIFFERENCE expr_eq { $$->bValue = $1 != $3; }
        | expr_comp
        ;

expr_comp : oper GREATER_THAN expr_comp { $$->bValue = $1 > $3; }
          | oper GREATER_THAN_OR_EQUAL expr_comp { $$->bValue = $1 >= $3; }
          | oper LESS_THAN expr_comp { $$->bValue = $1 < $3; }
          | oper LESS_THAN_OR_EQUAL expr_comp { $$->bValue = $1 <= $3; }
          | oper
          ;

oper : term SUM oper { $$->iValue = atoi($1->code) + atoi($3->code); }
     | term SUBTRACTION oper { $$->iValue = atoi($1->code) - atoi($3->code); }
     | term { $$->iValue = $1->iValue; }
     ;

term : factor MULTIPLICATION term { $$->iValue = atoi($1->code) * atoi($3->code); }
     | factor DIVISION term { $$->iValue = atoi($1->code) / atoi($3->code); }
     | factor REST term { $$->iValue = atoi($1->code) % atoi($3->code); }
     /*Ta com erro de tipo aqui nessa potencia, to arredondando pra int por ora*/
     /* | factor POWER term { $$->dValue = pow(atof($1->code), atof ($3->code)); }
     | factor { $$->iValue = $1->iValue; }
     ;

factor : '(' expr ')' { $$ = ($2); }
       | oper_incr_decr { $$ = $1; }
       | ID { $$->code = $1; }
       | BOOL_LIT { $$->code = $1; }
       | INT_LIT { $$->code = $1; }
       | FLOAT_INT { $$->code = $1; }
       | STR_LIT { $$->code = $1; }
       | CHAR_LIT { $$->code = $1; }
       ;

oper_incr_decr : ID INCREMENT { $$->iValue = atoi($1)+1; }
               | ID DECREMENT { $$->iValue = atoi($1)-1; } 
               | INCREMENT ID { $$->iValue = atoi($2)+1; }
               | DECREMENT ID { $$->iValue = atoi($2)-1; }
               ;

conditional : if_then { $$ = $1; }
            | if_then else { $$ = $1; }
            | if_then elif_list else { $$ = $1; }
            | switch { $$ = $1; }
            ;

else : ELSE '{' stmts '}' { printf("\nELSE {}"); }
     ;

elif_list : elif { $$ = $1; }
          | elif elif_list { $$ = $1; }
          ;

elif : ELIF '(' expr ')' '{' stmts '}' { printf("ELIF (%s) ELSE {}", $3->code); }
     ;

if_then : IF '(' expr ')' '{' stmts '}' { printf("IF (%s) {}", $3->code); }
        ;

switch : SWITCH '(' ID ')' '{' cases DEFAULT ':' stmts BREAK '}' { printf("switch") ;}
       ;

cases : case | case cases { printf("case");}
      ;

case : CASE ID ':' stmts BREAK {printf("case id");}
     ;

loop : for { $$ = $1; }
     | while { $$ = $1; }
     | do_while { $$ = $1; }
     ;

for : FOR '(' decl_var ';' expr ';' oper_incr_decr ')' '{' stmts '}' { printf("FOR (%s; %s; %s)", $3->code, $5->code, $7->code); }
    ;

while : WHILE '(' expr ')' '{' stmts '}' { printf("WHILE (%s) {}", $3->code); }
      ;

do_while : DO '{' stmts '}' WHILE '(' expr ')' { printf("DO {} WHILE (%s)", $7->code); }
         ; */ 

%%

int main(void) {
	return yyparse();
}

int yyerror(char *msg) {
	fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}