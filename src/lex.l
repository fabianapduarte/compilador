%{
	#include <stdio.h>
  #include "y.tab.h"
  #include <string.h>

  extern int yyerror (char *msg); 
%}

%option noyylineno

DIGIT([0-9]+)
FLOAT([0-9]+\.[0-9]+)

CHAR\'([^"]|\\\")\'
STRING\"([^"]|\\\")*\"
IDENTIFIER[a-zA-Z](_|[a-zA-Z0-9])*

TRUE true
FALSE false
OBJECT\"object\"

ARRAY_INT\[(\s)?{DIGIT}((\s)?\,(\s)?{DIGIT}*(\s)?\]
ARRAY_BOOL\[(\s)?({TRUE}|{FALSE})(\s)?\,(\s)?({TRUE}|{FALSE})(\s)?\]
ARRAY_FLOAT\[(\s)?{FLOAT}((\s)?\,(\s)?{FLOAT}*(\s)?\]
ARRAY_CHAR\[((\s)?{CHAR}(\s)?)(\,(\s)?{CHAR}(\s)?)*\]
ARRAY_STRING\[((\s)?{STRING}(\s)?)(\,(\s)?{STRING}(\s)?)*\]

%%

[ \t]                     ;
\n                        { yylineno++; }

"if"                      { return(IF); }
"else"                    { return(ELSE); }
"elif"                    { return(ELIF); }
"do"                      { return(DO); }
"switch"                  { return(SWITCH); }
"case"                    { return(CASE); }
"for"                     { return(FOR); }
"while"                   { return(WHILE); }
"break"                   { return(BREAK); }
"continue"                { return(CONTINUE); }
"print"                   { return(PRINT); }
"func"                    { return(FUNC); }
"return"                  { return(RETURN); }
"global"                  { return(GLOBAL); }
"const"                   { return(CONST); }
"default"                 { return(DEFAULT); }

"or"                      { return(OR); }
"and"                     { return(AND); }
"not"                     { return(NOT); }

"("                       { return(yytext[0]); }
")"                       { return(yytext[0]); }
":"                       { return(yytext[0]); }
","                       { return(yytext[0]); }
"["                       { return(yytext[0]); }
"]"                       { return(yytext[0]); }
"{"                       { return(yytext[0]); }
"}"                       { return(yytext[0]); }
"."                       { return(yytext[0]); }

"="                       { return(ASSIGN); }
"=="                      { return(EQUAL); }
"!="                      { return(DIFFERENCE); }
">"                       { return(GREATER_THAN); }
">="                      { return(GREATER_THAN_OR_EQUAL); }
"<"                       { return(LESS_THAN); }
"<="                      { return(LESS_THAN_OR_EQUAL); }
"+"                       { return(SUM); }
"++"                      { return(INCREMENT); }
"-"                       { return(SUBTRACTION); }
"--"                      { return(DECREMENT); }
"*"                       { return(MULTIPLICATION); }
"**"                      { return(POWER); }
"/"                       { return(DIVISION); }
"%"                       { return(REST); }

"int"                     { yylval.sValue = strdup("int"); 
                            return TYPE; }
"bool"                    { yylval.sValue = strdup("bool"); 
                            return TYPE; }
"float"                   { yylval.sValue = strdup("float"); 
                            return TYPE; }
"char"                    { yylval.sValue = strdup("char"); 
                            return TYPE; }
"string"                  { yylval.sValue = strdup("string"); 
                            return TYPE; }
"array"                   { yylval.sValue = strdup("array"); 
                            return TYPE; }
{OBJECT}                  { yylval.sValue = strdup("object"); 
                            return TYPE; }
"void"                    { yylval.sValue = strdup("void"); 
                            return TYPE; }

{TRUE}                    { yylval.sValue = strdup(yytext);
                            return BOOL_LIT; }
{FALSE}                   { yylval.sValue = strdup(yytext);
                            return BOOL_LIT; }
{CHAR}                    { char* string = (char*)malloc(2 * sizeof(char));
                            string[0] = yytext[1];
                            string[1] = '\0';
                            yylval.sValue = string;
                            return CHAR_LIT; }
{STRING}                  { yylval.sValue = strndup(yytext + 1, strlen(yytext) - 2);
                            return STR_LIT; }
{DIGIT}                   { yylval.sValue = strdup(yytext); 
                            return INT_LIT; }
{FLOAT}                   { yylval.sValue = strdup(yytext); 
                            return FLOAT_LIT; }
{IDENTIFIER}              { yylval.sValue = strdup(yytext); 
                            return ID; }

.                         { yyerror("Invalid character."); }

%%

#ifndef yywrap

int yywrap(void) {
  return 1;
}

#endif