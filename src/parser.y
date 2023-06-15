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
	};

%token <sValue> ID
%token <sValue> TYPE
%token <iValue> NUMBER
%token FUNCTION PROCEDURE BEGIN_TOKEN END_TOKEN WHILE DO IF THEN ELSE ASSIGN 

%type <sValue> body
%type <sValue> procedure
%type <sValue> function
%type <sValue> subpgrm
%type <sValue> subpgrms args args_aux ids ids_aux

%start programa

%%
program : subpgrms body {printf("%s%s\n", $1, $2);};

subpgrms : {$$ = strdup("");} 
         | subpgrm subpgrms {printf("%s\n%s", $1, $2);} 
         ;

subpgrm : function  {$$ = $1;} 
        | procedure {$$ = $1;} 
        ;

function : FUNCTION ID '(' args ')' ':' TYPE body {printf("FUNCTION %s(%s) : %s %s", $2, $4, $7, $8);}  
         ;

procedure : PROCEDURE ID '(' args ')' body {printf("PROCEDURE %s() %s", $2, $6);} 
          ;

args : {$$ = strdup("");}
     | args_aux {$$ = $1;}
     ;

args_aux : TYPE ids {printf("%s %s", $1, $2);}
         | TYPE ids ';' args_aux {printf("%s %s; %s", $1, $2, $4);}
         ;                  

ids :         {$$ = strdup("");}
    | ids_aux {$$ = $1;}
    ;

ids_aux : ID             {$$ = $1;}
        | ID ',' ids_aux {printf("%s, %s", $1, $3);}
        ;            

corpo : BEGIN_TOKEN END_TOKEN {$$ = strdup("BEGIN END");} 
      ;  

%%

int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}