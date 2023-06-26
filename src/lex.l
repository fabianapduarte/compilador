%{
	#include <stdio.h>
  #include "y.tab.h"
  #include <string.h>
%}

%option yylineno

DIGIT[0-9]+
CHAR\'[a-zA-Z0-9\s\-\_]?\'
STRING\"([a-zA-Z0-9]|\s|\-|\_)*\"
IDENTIFIER[a-zA-Z](_|[a-zA-Z0-9])*
PRINT[print\(\s*[\w\s"]*\s*\)]

%%

[ \t\n]                   ;

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
{PRINT}                   { return(PRINT); }
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

"int"                     { yylval.type = strdup("int"); 
                            return TYPE; }
"bool"                    { yylval.type = strdup("bool"); 
                            return TYPE; }
"float"                   { yylval.type = strdup("float"); 
                            return TYPE; }
"char"                    { yylval.type = strdup("char"); 
                            return TYPE; }
"string"                  { yylval.type = strdup("string"); 
                            return TYPE; }
"array"                   { yylval.type = strdup("array"); 
                            return TYPE; }
"object"                  { yylval.type = strdup("object"); 
                            return TYPE; }
"void"                    { yylval.type = strdup("void"); 
                            return TYPE; }

"true"                    { yylval.bValue = true;
                            return LITERAL; }
"false"                   { yylval.bValue = false;
                            return LITERAL; }
\"{CHAR}\"                { yylval.cValue = yytext[1];
                            return LITERAL; }
\"{STRING}\"              { yylval.sValue = strndup(yytext + 1, strlen(yytext) - 2); ;
                            return LITERAL; }
{DIGIT}                   { yylval.iValue = atoi(yytext); 
                            return LITERAL; }
{IDENTIFIER}              { yylval.id = strdup(yytext); 
                            return ID; }

.                         { yyerror("Invalid character."); }

%%

#ifndef yywrap

int yywrap(void) {
  return 1;
}

#endif

int main() {
  yylex();

  return 0;
}