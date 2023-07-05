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

  char * cat(char *, char *, char *, char *, char *);
%}

%union {
  char * sValue;
  struct record * rec;
};

%token <sValue> TYPE ID STR_LIT BOOL_LIT INT_LIT FLOAT_LIT CHAR_LIT

%token GLOBAL CONST ASSIGN
%token FOR WHILE DO IF CONTINUE
%token ELIF ELSE SWITCH CASE DEFAULT BREAK
%token FUNC RETURN PRINT PARSEINT PARSEFLOAT PARSECHAR PARSESTRING
%token OR AND NOT EQUAL DIFFERENCE GREATER_THAN GREATER_THAN_OR_EQUAL LESS_THAN LESS_THAN_OR_EQUAL
%token SUM INCREMENT SUBTRACTION DECREMENT MULTIPLICATION POWER DIVISION REST

%type <rec> program stmt stmts assign print
%type <rec> factor expr expr_eq expr_comp oper term decl_var
/* %type <rec> function stmt stmts args args_aux 
%type <rec> assign decl_var decl_const decl_global term factor oper_incr_decr atr_list 
%type <rec> loop for do_while while
%type <rec> conditional else elif_list elif if_then switch cases case */

%start program

%%

program : stmts { /*printf("%d", $1->iValue);*/
                    // printf("%s\n", record->code);
                    freeRecord($1);
                }
        ;

stmts :            { $$ = createRecord("", VOID); }
      | stmt stmts { $$ = $1; }
      ;
      
stmt : /*function {$$ = createString($1);}*/
     decl_var {$$;}
     /*| decl_const 
     | decl_global*/
      assign { /*$$->iValue = $1->iValue;*/ }
     | print { $$ = $1; }
     /*| loop 
     | conditional*/
     ;

print : PRINT '(' factor ')'  { 
          if($3->type == INT){
               printf("%d\n", $3->iValue);
          }else if 
          ($3->type == FLOAT){
               printf("%f\n", $3->fValue); 
          }else if 
          ($3->type == CHAR){
               printf("%c\n", $3->cValue); 
          }else if 
          ($3->type == STRING){
               printf("%s\n", $3->sValue); 
          }else{
               yyerror("Incorrect types");
          }
     }
      /* | PRINT '(' STR_LIT ')'      { printf("%s\n", $3); }
      | PRINT '(' CHAR_LIT ')'     { printf("%s\n", $3); }
      | PRINT '(' INT_LIT ')'      { printf("%s\n", $3); }
      | PRINT '(' FLOAT_LIT ')'    { printf("%s\n", $3); }
      | PRINT '(' BOOL_LIT ')'     { printf("%s\n", $3); } */
      ;


decl_var : TYPE ID ASSIGN expr { printf("%s %s = %s", $1, $2, $4->code); }
         ; 

/*decl_const : CONST TYPE ID ASSIGN expr { printf("const %s %s = %s", $2, $3, $5->code); }
           ;

decl_global : GLOBAL TYPE ID ASSIGN expr { printf("global %s %s = %s", $2, $3, $5->code); }
            ;*/

/* function : TYPE FUNC ID '(' args ')' '{' stmts '}'
{
    // Ação do analisador semântico

    // Verificar a existência e declaração da função
    if (!functionExists($3)) {
        // Erro: Função não declarada
        printf("Erro: Função '%s' não declarada\n", $3);
        YYERROR;
    }

    // Verificar os tipos dos argumentos
    if (!checkArgumentTypes($3, $5)) {
        // Erro: Tipos inválidos dos argumentos
        printf("Erro: Tipos inválidos dos argumentos na função '%s'\n", $3);
        YYERROR;
    }

    // Realizar outras verificações semânticas e ações necessárias

    // Se necessário, você pode retornar algum valor específico associado à regra
    $$ = createFunctionNode($3, $2, $5, $8);
    $$ = createRecord();
}  
; */

/* args : {$$->code = strdup("");}
     | args_aux {$$ = $1;}
     ;

args_aux : TYPE ID { printf("%s %s", $1, $2); }
         | TYPE ID ',' args_aux { printf("%s %s; %s", $1, $2, $4->sValue); }
         ; */

assign :  ID ASSIGN expr { 
          $$->iValue = $3->iValue; 
          // char *id = (char*) malloc(strlen($1) * sizeof(char));
          // char *expr = (char*) malloc(strlen($3) * sizeof(char));

          // char *concatCode = (char*) malloc((strlen($1) + strlen($3) + 2) * sizeof(char));
          // strcpy(concatCode, id);
          // strcat(concatCode, expr);
          // free(id);
          // free(expr);
          // $$->code = concatCode;
     }
          |TYPE ID ASSIGN expr {
               if((strcmp($1, "int") == 0)){
                    if($4->type == INT){
                         $$ = $4; 
                    }else{ yyerror("Int required"); }
               }
               else if(strcmp($1, "float") == 0){
                    if($4->type == FLOAT){
                         $$ = $4; 
                    }else{ yyerror("Float required"); }
               }
               else if(strcmp($1, "bool") == 0){
                    if($4->type == BOOL){
                         $$ = $4; 
                    }else{ yyerror("Bool required"); }
               }
               else if(strcmp($1, "string") == 0){
                    if($4->type == STRING){
                         $$ = $4; 
                    }else{ yyerror("String required"); }
               }
               else if(strcmp($1, "char") == 0){
                    if($4->type == CHAR){
                         $$ = $4; 
                    }else{ yyerror("Char required"); }
               }
               else{ yyerror("Wrong assign"); }
          } 
       ;

/*atr_list : TYPE 
         | TOKEN ',' INT_LIT 
         ;*/
         
expr : NOT expr_eq { $$->bValue = !$2; }
     | expr_eq OR expr { $$->bValue = $1 || $3; }
     | expr_eq AND expr { $$->bValue = $1 && $3; }
     | expr_eq {$$->iValue = $1->iValue;}
     ;

expr_eq : expr_comp EQUAL expr_eq { $$->bValue = $1 == $3; }
        | expr_comp DIFFERENCE expr_eq { $$->bValue = $1 != $3; }
        | expr_comp {$$->iValue = $1->iValue;}
        ;

expr_comp : oper GREATER_THAN expr_comp { $$->bValue = $1 > $3; }
          | oper GREATER_THAN_OR_EQUAL expr_comp { $$->bValue = $1 >= $3; }
          | oper LESS_THAN expr_comp { $$->bValue = $1 < $3; }
          | oper LESS_THAN_OR_EQUAL expr_comp { $$->bValue = $1 <= $3; }
          | oper {$$->iValue = $1->iValue;}
          ;

oper : term SUM oper { 
          if(($1->type == INT) && ($3->type == INT)){
               $$->iValue = $1->iValue + $3->iValue; 
          }else if
          (($1->type == FLOAT) && ($3->type == FLOAT)){
               $$->fValue = $1->fValue + $3->fValue; 
          }else{yyerror("Incorrect types");}
     }
     | term SUBTRACTION oper { 
          if(($1->type == INT) && ($3->type == INT)){
               $$->iValue = $1->iValue - $3->iValue;
          }else if
          (($1->type == FLOAT) && ($3->type == FLOAT)){
               $$->fValue = $1->fValue - $3->fValue;
          }else{yyerror("Incorrect types");} 
     }
     | term { 
          $$ = $1;
          // if($1->type == INT){
          //      $$->iValue = $1->iValue; 
          // }else if
          // ($1->type == FLOAT){
          //      $$->fValue = $1->fValue; 
          // }else{yyerror("Incorrect types");} 
     }
     ;

term : factor MULTIPLICATION term { 
          if(($1->type == INT) && ($3->type == INT)){
               $$->iValue = $1->iValue * $3->iValue; 
          }else if
          (($1->type == FLOAT) && ($3->type == FLOAT)){
               $$->fValue = $1->fValue * $3->fValue; 
          }else{yyerror("Incorrect types");}
     }
     | factor DIVISION term { 
          if(($1->type == INT) && ($3->type == INT)){
               $$->iValue = $1->iValue / $3->iValue; 
          }else if
          (($1->type == FLOAT) && ($3->type == FLOAT)){
               $$->fValue = $1->fValue / $3->fValue; 
          }else{yyerror("Incorrect types");}
     }
     /*| factor REST term { $$->iValue = atoi($1->code) % atoi($3->code); }*/
     /*Ta com erro de tipo aqui nessa potencia, to arredondando pra int por ora*/
     /*| factor POWER term { $$->dValue = pow(atof($1->code), atof ($3->code)); }*/
     | factor {
          $$ = $1;
          // if($1->type == INT){
          //      $$->iValue = $1->iValue; 
          // }else if($1->type == FLOAT){
          //      $$->fValue = $1->fValue; 
          // }
     }
     ;

factor : /*'(' expr ')' { $$ = ($2); }
       | oper_incr_decr { $$ = $1; }
       | ID { $$->code = $1; }
       |*/ 
       BOOL_LIT { 
               if(strcmp($1, "false") == 0){
                    $$ = createBool(0); 
                    free($1);
               }else if (strcmp($1, "true") == 0){
                    $$ = createBool(1); 
                    free($1);
               }else{
                    yyerror("Incorrect bool type assignment");
               }
       }
       | INT_LIT    { $$ = createInt(atoi($1)); free($1); }
       | FLOAT_LIT  { $$ = createFloat(atof($1)); free($1); }
       | STR_LIT    { $$ = createString($1); free($1); }
       | CHAR_LIT   { $$ = createChar($1); free($1); }
       ;

/*oper_incr_decr : ID INCREMENT { $$->iValue = atoi($1)+1; }
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

char * cat(char * s1, char * s2, char * s3, char * s4, char * s5){
  int tam;
  char * output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5)+ 1;
  output = (char *) malloc(sizeof(char) * tam);
  
  if (!output){
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }
  
  sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);
  
  return output;
}