%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  int yylex(void);
  extern int yylineno;
  extern char * yytext;

%}

%union {
	int    iValue; 	/* integer value */
  float  fValue; 	/* float value */
  bool   bValue; 	/* bool value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
  char * type;    /* type value */
  char * id;      /* identfier */
};

%token <id> ID
%token <type> TYPE
%token <sValue> FUNC WHILE DO IF ELIF ELSE SWITCH CASE FOR BREAK CONTINUE PRINT RETURN GLOBAL CONST DEFAULT OR AND NOT ASSIGN EQUAL DIFFERENCE GREATER_THAN GREATER_THAN_OR_EQUAL LESS_THAN LESS_THAN_OR_EQUAL SUM INCREMENT SUBTRACTION DECREMENT MULTIPLICATION POWER DIVISION REST PARSEINT PARSEFLOAT PARSECHAR PARSESTRING LITERAL

%type <sValue> body
%type <sValue> function
%type <sValue> subpgrm
%type <sValue> subpgrms args args_aux assign expression decl_var binary_op term factor expr_incr_decr conditional conditionals if_else if_elif if_then switch cases case loops loop for while do_while

%start program

%%
program : subpgrms body {printf("%s%s\n", $1, $2);};

subpgrms : {$$ = strdup("");} 
         | subpgrm subpgrms {printf("%s\n%s", $1, $2);} 
         ;

subpgrm : function {$$ = $1;} | decl_var | assign | conditionals | loops;

decl_var : TYPE ID ASSIGN expression { printf("%s %s = %s", $1, $2, $4); }
         ;

function : TYPE FUNC ID '(' args ')' '{' body '}' {printf("%s FUNC %s(%s)", $1, $3, $5);}  
         ;

args : {$$ = strdup("");}
     | args_aux {$$ = $1;}
     ;

args_aux : TYPE ID {printf("%s %s", $1, $2);}
         | TYPE ID ',' args_aux {printf("%s %s; %s", $1, $2, $4);}
         ;                     

body : {$$ = strdup("");} ;

assign : TYPE ID ASSIGN expression ;

expression : ID | LITERAL | binary_op ;

binary_op : binary_op SUM term | binary_op SUBTRACTION term | term ;

term : term MULTIPLICATION factor | term DIVISION factor | factor;

factor : '(' expression ')' | expr_incr_decr | ID;

expr_incr_decr : ID INCREMENT | ID DECREMENT | INCREMENT ID | DECREMENT ID;

conditionals : conditional | conditional conditionals;

conditional : if_else | if_elif | if_then | switch;

if_else : if_then ELSE '{' subpgrms '}';

if_elif : if_then ELIF '(' expression ')' '{' subpgrms '}' ;

if_then : IF '(' expression ')' '{' subpgrms '}';

switch : SWITCH '(' ID ')' '{' cases DEFAULT ':' subpgrms BREAK '}' ;

cases: case | case cases;

case : CASE ID ':' subpgrms BREAK;

loops : loop | loop loops ;

loop : for | while | do_while ;

for : FOR '(' decl_var ';' expression ';' expr_incr_decr ')' subpgrms;

while : WHILE '(' expression ')' '{' subpgrms '}';

do_while : DO '{' subpgrms '}' WHILE '(' expression ')';

%%

int main(void) {
	return yyparse();
}

int yyerror(char *msg) {
	fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}