%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <math.h>
  #include <stdbool.h>
  #include "./lib/record.h"

  int yylex(void);
  int yyerror(char *s);
  int yyerrorTk(char *s, char *t, int i);
  extern int yylineno;
  extern char * yytext;

  char * cat(char *, char *, char *, char *, char *);

  int countIntDigits(int);
  int countFloatDigits(float);

  struct Stack stack;
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

%type <sValue> stmt stmts
%type <rec> assign print casting
%type <rec> expr expr_eq expr_comp oper term factor

%start program

%%

program : stmts { 
                  FILE * out_file = fopen("output.c", "w");
                  fprintf(out_file, "#include <math.h>\n#include <stdio.h>\n\nint main(void) {\n%s\n}", $1);
                }
        ;

stmts :            { $$ = ""; }
      | stmt stmts { $$ = cat($1, "\n", $2, "", ""); }
      ;
      
stmt : assign {
        char * code, * newValue;
        if (strcmp($1->type, "char") == 0) newValue = cat("\'", $1->sValue, "\'", "", "");
        else if (strcmp($1->type, "string") == 0) newValue = cat("\"", $1->sValue, "\"", "", "");
        else newValue = cat($1->sValue, "", "", "", "");
        code = cat($1->code, " ", $1->name, " = ", newValue);
        code = cat(code, ";", "", "", "");
        $$ = code;
        free(newValue);
       }  
     | print {
        char * code, * output;
        if (strcmp($1->type, "bool") == 0) {
          if (strcmp($1->sValue, "0") == 0) output = cat("\"", "false", "\"", "", "");
          else output = cat("\"", "true", "\"", "", "");
        } else output = cat("\"", $1->sValue, "\"", "", "");
        code = cat("printf(\"%s\\n\", ", output, ");", "", "");
        $$ = code;
        free(output);
       }
     ;

print : PRINT '(' expr ')' { $$ = $3; }
      ;

assign : TYPE ID ASSIGN expr {
          if ((strcmp($1, "int") == 0)) {
            if ((strcmp($4->type, "int") == 0)) {
              $$ = createRecord(&stack, $2, "int", $4->sValue, "int");
              free($1);
            } else { yyerrorTk("Int required", "=", yylineno-1); }
          }
          else if ((strcmp($1, "bool") == 0)) {
            if ((strcmp($4->type, "bool") == 0)) {
              $$ = createRecord(&stack, $2, "bool", $4->sValue, "int");
              free($1);
            } else { yyerrorTk("Bool required", "=", yylineno-1); }
          }
          else if ((strcmp($1, "float") == 0)) {
            if ((strcmp($4->type, "float") == 0)) {
              $$ = createRecord(&stack, $2, "float", $4->sValue, "float");
              free($1);
            } else { yyerrorTk("Float required", "=", yylineno-1); }
          }
          else if ((strcmp($1, "char") == 0)) {
            if ((strcmp($4->type, "char") == 0)) {
              char * newChar = (char *) malloc(2 * sizeof(char));
              sprintf(newChar, "%s", $4->sValue);
              $$ = createRecord(&stack, $2, "char", newChar, "char");
              free($1);
            } else { yyerrorTk("Char required", "=", yylineno-1); }
          }
          else if ((strcmp($1, "string") == 0)) {
            if ((strcmp($4->type, "string") == 0)) {
              char * newString = (char *) malloc(strlen($4->sValue) * sizeof(char));
              sprintf(newString, "%s", $4->sValue);
              char * newName = (char *) malloc((strlen($2) + 3) * sizeof(char));
              sprintf(newName, "%s[%d]", $2, (int) strlen($4->sValue));
              $$ = createRecord(&stack, newName, "string", newString, "char");
              free($1);
            } else { yyerrorTk("String required", "=", yylineno-1); }
          }
          else { yyerrorTk("Wrong assign", "=", yylineno-1); }
         }
       ;
         
expr : NOT expr_eq { 
                  if (($2 != NULL) && strcmp($2->type, "bool") == 0) {
                    if(strcmp($2->sValue, "0") == 0){
                      setValue($2, "bool", "1", "int"); 
                    }else if(strcmp($2->sValue, "1") == 0){
                      setValue($2, "bool", "0", "int");
                    }
                    $$ = $2;
                  } else { yyerrorTk("Not a boolean", "=", yylineno-1); }
      }
     | expr_eq OR expr { 
                  if (($1 != NULL) && strcmp($1->type, "bool") == 0) {
                    if (($3 != NULL) && strcmp($3->type, "bool") == 0) {
                      char * boolString = (char *) malloc(1 * sizeof(char));
                      if((strcmp($1->sValue, "1") == 0) || (strcmp($3->sValue, "1") == 0)){
                        sprintf(boolString, "1");
                      }else{sprintf(boolString, "0");}
                      $$ = createRecord(&stack, NULL, "bool", boolString, "int");
                    }else{yyerrorTk("Not a boolean", "=", yylineno-1);}
                  } else { yyerrorTk("Not a boolean", "=", yylineno-1); }
     }
     | expr_eq AND expr { 
                  if (($1 != NULL) && strcmp($1->type, "bool") == 0) {
                    if (($3 != NULL) && strcmp($3->type, "bool") == 0) {
                      char * boolString = (char *) malloc(1 * sizeof(char));
                      if((strcmp($1->sValue, "1") == 0) && (strcmp($3->sValue, "1") == 0)){
                        sprintf(boolString, "1");
                      }else{sprintf(boolString, "0");}  
                      $$ = createRecord(&stack, NULL, "bool", boolString, "int");
                    }else{yyerrorTk("Not a boolean", "=", yylineno-1);}
                  } else { yyerrorTk("Not a boolean", "=", yylineno-1); }
     }
     | expr_eq { $$ = $1; }
     ;

expr_eq : expr_comp EQUAL expr_eq { 
              if($1!=NULL && $3!=NULL && (strcmp($1->type, $3->type) == 0)){
                  int compare = strcmp($1->sValue, $3->sValue);
                  if(compare == 0){
                    $$ = createRecord(&stack, NULL, "bool", "1", "int");
                  }else{
                    $$ = createRecord(&stack, NULL, "bool", "0", "int");
                  }
              }else{ yyerrorTk("Different types", "==", yylineno-1); }
        }
        | expr_comp DIFFERENCE expr_eq { 
              if($1!=NULL && $3!=NULL && (strcmp($1->type, $3->type) == 0)){
                  int compare = strcmp($1->sValue, $3->sValue);
                  if(compare != 0){
                    $$ = createRecord(&stack, NULL, "bool", "1", "int");
                  }else{
                    $$ = createRecord(&stack, NULL, "bool", "0", "int");
                  }
              }else{ yyerrorTk("Different types", "!=", yylineno-1); }
        }
        | expr_comp { $$ = $1; }
        ;

expr_comp : oper GREATER_THAN expr_comp { 
                        if(($1!=NULL && strcmp($1->type, "int") == 0) && ($3!=NULL && strcmp($3->type, "int") == 0)){
                            int compare = strcmp($1->sValue, $3->sValue);
                            if(compare == 1){
                              $$ = createRecord(&stack, NULL, "bool", "1", "int");
                            }else{
                              $$ = createRecord(&stack, NULL, "bool", "0", "int");
                            }
                        }else if
                        (($1!=NULL && strcmp($1->type, "float") == 0) && ($3!=NULL && strcmp($3->type, "float") == 0)){
                            int compare = strcmp($1->sValue, $3->sValue);
                            if(compare == 1){
                              $$ = createRecord(&stack, NULL, "bool", "1", "int");
                            }else{
                              $$ = createRecord(&stack, NULL, "bool", "0", "int");
                            }
                            
                        }else{ yyerrorTk("Different types", ">", yylineno-1); }
          }
          | oper GREATER_THAN_OR_EQUAL expr_comp { 
                        if(($1!=NULL && strcmp($1->type, "int") == 0) && ($3!=NULL && strcmp($3->type, "int") == 0)){
                            int compare = strcmp($1->sValue, $3->sValue);
                            if(compare == 1 || compare == 0){
                              $$ = createRecord(&stack, NULL, "bool", "1", "int");
                            }else{
                              $$ = createRecord(&stack, NULL, "bool", "0", "int");
                            }
                        }else if
                        (($1!=NULL && strcmp($1->type, "float") == 0) && ($3!=NULL && strcmp($3->type, "float") == 0)){
                            int compare = strcmp($1->sValue, $3->sValue);
                            if(compare == 1 || compare == 0){
                              $$ = createRecord(&stack, NULL, "bool", "1", "int");
                            }else{
                              $$ = createRecord(&stack, NULL, "bool", "0", "int");
                            }
                        }else{ yyerrorTk("Different types", ">=", yylineno-1); }
          }
          | oper LESS_THAN expr_comp { 
                        if(($1!=NULL && strcmp($1->type, "int") == 0) && ($3!=NULL && strcmp($3->type, "int") == 0)){
                            int compare = strcmp($1->sValue, $3->sValue);
                            if(compare == -1){
                              $$ = createRecord(&stack, NULL, "bool", "1", "int");
                            }else{
                              $$ = createRecord(&stack, NULL, "bool", "0", "int");
                            }
                        }else if
                        (($1!=NULL && strcmp($1->type, "float") == 0) && ($3!=NULL && strcmp($3->type, "float") == 0)){
                            int compare = strcmp($1->sValue, $3->sValue);
                            if(compare == -1){
                              $$ = createRecord(&stack, NULL, "bool", "1", "int");
                            }else{
                              $$ = createRecord(&stack, NULL, "bool", "0", "int");
                            }
                        }else{ yyerrorTk("Different types", "<", yylineno-1); }
          }
          | oper LESS_THAN_OR_EQUAL expr_comp { 
                        if(($1!=NULL && strcmp($1->type, "int") == 0) && ($3!=NULL && strcmp($3->type, "int") == 0)){
                            int compare = strcmp($1->sValue, $3->sValue);
                            if(compare == -1 || compare == 0){
                              $$ = createRecord(&stack, NULL, "bool", "1", "int");
                            }else{
                              $$ = createRecord(&stack, NULL, "bool", "0", "int");
                            }
                        }else if
                        (($1!=NULL && strcmp($1->type, "float") == 0) && ($3!=NULL && strcmp($3->type, "float") == 0)){
                            int compare = strcmp($1->sValue, $3->sValue);
                            if(compare == -1 || compare == 0){
                              $$ = createRecord(&stack, NULL, "bool", "1", "int");
                            }else{
                              $$ = createRecord(&stack, NULL, "bool", "0", "int");
                            }
                        }else{ yyerrorTk("Different types", "<=", yylineno-1); }
          }
          | oper { $$ = $1; }
          ;

oper : term SUM oper { 
                          if (strcmp($1->type, "int") == 0) {
                            if ((strcmp($3->type, "int") == 0)) {
                              int sum = atoi($1->sValue) + atoi($3->sValue);
                              char * sumString = (char *) malloc(countIntDigits(sum) * sizeof(char));
                              sprintf(sumString, "%d", sum);
                              $$ = createRecord(&stack, NULL, "int", sumString, "int");
                            }else { yyerrorTk("Different types", "+", yylineno-1); }
                          }
                          else if(strcmp($1->type, "float") == 0){
                            if((strcmp($3->type, "float") == 0)){
                              float sum = atof($1->sValue) + atof($3->sValue);
                              char * sumString = (char *) malloc(countFloatDigits(sum) * sizeof(char));
                              sprintf(sumString, "%f", sum);
                              $$ = createRecord(&stack, NULL, "float", sumString, "float");
                            }else { yyerrorTk("Different types", "+", yylineno-1); }
                          }
    }
     | term SUBTRACTION oper { 
                              if (strcmp($1->type, "int") == 0) {
                                if ((strcmp($3->type, "int") == 0)) {
                                  int sub = atoi($1->sValue) - atoi($3->sValue);
                                  char * subString = (char *) malloc(countIntDigits(sub) * sizeof(char));
                                  sprintf(subString, "%d", sub);
                                  $$ = createRecord(&stack, NULL, "int", subString, "int");
                                }else { yyerrorTk("Different types", "-", yylineno-1); }
                              }
                              else if(strcmp($1->type, "float") == 0){
                                if((strcmp($3->type, "float") == 0)){
                                  float sub = atof($1->sValue) - atof($3->sValue);
                                  char * subString = (char *) malloc(countFloatDigits(sub) * sizeof(char));
                                  sprintf(subString, "%f", sub);
                                  $$ = createRecord(&stack, NULL, "float", subString, "float");
                                }else { yyerrorTk("Different types", "-", yylineno-1); }
                              }
     }
     | term { $$ = $1; }
     ;

term : factor MULTIPLICATION term { 
                                    if (strcmp($1->type, "int") == 0) {
                                      if ((strcmp($3->type, "int") == 0)) {
                                        int mult = atoi($1->sValue) * atoi($3->sValue);
                                        char * multString = (char *) malloc(countIntDigits(mult) * sizeof(char));
                                        sprintf(multString, "%d", mult);
                                        $$ = createRecord(&stack, NULL, "int", multString, "int");
                                      }else { yyerrorTk("Different types", "*", yylineno-1); }
                                    }
                                    else if(strcmp($1->type, "float") == 0){
                                      if((strcmp($3->type, "float") == 0)){
                                        float mult = atof($1->sValue) * atof($3->sValue);
                                        char * multString = (char *) malloc(countFloatDigits(mult) * sizeof(char));
                                        sprintf(multString, "%f", mult);
                                        $$ = createRecord(&stack, NULL, "float", multString, "float");
                                      }else { yyerrorTk("Different types", "*", yylineno-1); }
                                    }
      }
     | factor DIVISION term       {
                                    if (strcmp($1->type, "int") == 0) {
                                      if ((strcmp($3->type, "int") == 0)) {
                                        int division = atoi($1->sValue) / atoi($3->sValue);
                                        char * divisionString = (char *) malloc(countIntDigits(division) * sizeof(char));
                                        sprintf(divisionString, "%d", division);
                                        $$ = createRecord(&stack, NULL, "int", divisionString, "int");
                                      }else { yyerrorTk("Different types", "/", yylineno-1); }
                                    }
                                    else if((strcmp($1->type, "float") == 0)){
                                      if((strcmp($3->type, "float") == 0)){
                                        float division = atof($1->sValue) / atof($3->sValue);
                                        char * divisionString = (char *) malloc(countFloatDigits(division) * sizeof(char));
                                        sprintf(divisionString, "%f", division);
                                        $$ = createRecord(&stack, NULL, "float", divisionString, "float");
                                      }else{ yyerrorTk("Different types", "/", yylineno-1); }
                                    }
                                  }
     | factor POWER term          {
                                    if (strcmp($1->type, "int") == 0) {
                                      if ((strcmp($3->type, "int") == 0)) {
                                        float powVar = pow(strtod($1->sValue, NULL), strtod($3->sValue, NULL));
                                        char * powString = (char *) malloc(countFloatDigits(powVar) * sizeof(char));
                                        sprintf(powString, "%f", powVar);
                                        $$ = createRecord(&stack, NULL, "int", powString, "int");
                                      }else { yyerrorTk("Different types", "**", yylineno-1); }
                                    }
                                    else if((strcmp($1->type, "float") == 0)){
                                      if((strcmp($3->type, "float") == 0)){
                                        float powVar = pow(strtod($1->sValue, NULL), strtod($3->sValue, NULL));
                                        char * powString = (char *) malloc(countFloatDigits(powVar) * sizeof(char));
                                        sprintf(powString, "%f", powVar);
                                        $$ = createRecord(&stack, NULL, "float", powString, "float");
                                      }else{ yyerrorTk("Different types", "**", yylineno-1); }
                                    }
                                    
                                  }
     | factor REST term           {
                                    if (strcmp($1->type, "int") == 0) {
                                      if ((strcmp($3->type, "int") == 0)) {
                                        int rest = atoi($1->sValue) % atoi($3->sValue);
                                        char * restString = (char *) malloc(countIntDigits(rest) * sizeof(char));
                                        sprintf(restString, "%d", rest);
                                        $$ = createRecord(&stack, NULL, "int", restString, "int");
                                      }else { yyerrorTk("Different types", "%", yylineno-1); }
                                    }
                                    else if((strcmp($1->type, "float") == 0)){
                                      if((strcmp($3->type, "float") == 0)){
                                        float rest = atoi($1->sValue) % atoi($3->sValue);
                                        char * restString = (char *) malloc(countFloatDigits(rest) * sizeof(char));
                                        sprintf(restString, "%f", rest);
                                        $$ = createRecord(&stack, NULL, "float", restString, "float");
                                      }else{ yyerrorTk("Different types", "%", yylineno-1); }
                                    }
                                  }
     | factor                     { $$ = $1; }
     ;

factor : '(' expr ')' { $$ = $2; }
       | casting      { $$ = $1; }
       | ID           {
                        struct record * id = search(&stack, $1);
                        if (id != NULL) $$ = id;
                        else yyerrorTk("Identifier not found", $1, yylineno);
                      }
       | BOOL_LIT     {
                        char * boolString = (char *) malloc(1 * sizeof(char));
                        if ((strcmp($1, "true") == 0)) sprintf(boolString, "1");
                        else sprintf(boolString, "0");
                        $$ = createRecord(&stack, NULL, "bool", boolString, "int");
                      }
       | INT_LIT      { $$ = createRecord(&stack, NULL, "int", $1, "int"); }
       | FLOAT_LIT    { $$ = createRecord(&stack, NULL, "float", $1, "float"); }
       | STR_LIT      { $$ = createRecord(&stack, NULL, "string", $1, "char"); }
       | CHAR_LIT     { $$ = createRecord(&stack, NULL, "char", $1, "char"); }
       ;

casting : TYPE '(' expr ')' {
                              if ((strcmp($1, "int") == 0)) {
                                if ((strcmp($3->type, "float") == 0)) {
                                  float numberFloat = atof($3->sValue);
                                  int numberInt = (int) numberFloat;
                                  char * numberString = (char *) malloc(countIntDigits(numberInt) * sizeof(char));
                                  sprintf(numberString, "%d", numberInt);
                                  $$ = createRecord(&stack, NULL, "int", numberString, "int");
                                  free($1);
                                } else { yyerrorTk("Incorrect type conversion: expected float", $1, yylineno); }
                              }
                              else if ((strcmp($1, "float") == 0)) {
                                if ((strcmp($3->type, "int") == 0)) {
                                  int numberInt = atoi($3->sValue);
                                  float numberFloat = (float) numberInt;
                                  char * numberString = (char *) malloc(countFloatDigits(numberFloat) * sizeof(char));
                                  sprintf(numberString, "%f", numberFloat);
                                  $$ = createRecord(&stack, NULL, "float", numberString, "float");
                                  free($1);
                                } else { yyerrorTk("Incorrect type conversion: expected int", $1, yylineno); }
                              }
                              else if ((strcmp($1, "string") == 0)) {
                                if (strcmp($3->type, "int") == 0 || strcmp($3->type, "float") == 0 || strcmp($3->type, "char") == 0) {
                                  $$ = createRecord(&stack, NULL, "string", $3->sValue, "char");
                                  free($1);
                                }
                                else { yyerrorTk("Incorrect type conversion: expected int, float or char", $1, yylineno); }
                              }
                              else { yyerrorTk("Unsupported conversion", $1, yylineno); }
                            }
        ;

%%

int main(void) {
  initialize(&stack);
	return yyparse();
}

int yyerror(char *msg) {
	fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}

int yyerrorTk(char *msg, char* tkn, int line) {
	fprintf(stderr, "%d: %s at '%s'\n", line, msg, tkn);
	exit(0);
}

char * cat(char * s1, char * s2, char * s3, char * s4, char * s5){
  int tam;
  char * output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5) + 1;
  output = (char *) malloc(sizeof(char) * tam);
  
  if (!output){
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }
  
  sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);
  
  return output;
}

int countIntDigits(int number) {
  int count = 0;
  do {
    number /= 10;
    ++count;
  } while (number != 0);
  return count;
}

int countFloatDigits(float num) {
  int count = 0;
  int number = (int) num;
  do {
    number /= 10;
    ++count;
  } while (number != 0);
  return count+5;
}