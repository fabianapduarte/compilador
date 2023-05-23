%{
	#include<stdio.h>
%}

%option yylineno

DIGIT[0-9]+
CHAR[a-zA-Z]
IDENTIFIER[a-zA-Z][a-zA-Z0-0]*
SPACE[ ]
OPENP[(]
CLOSEP[)]
OPENB[{]
CLOSEB[}]

%%
if|else|elif|do|switch|case {printf("[%s] -> CONDITIONAL\n", yytext);}
for|while {printf("[%s] -> LOOPING\n", yytext);}
break|continue {printf("[%s] -> ESCAPES\n", yytext);}
bool|int|float|char|string|array|object {printf("[%s] -> VARIABLE TYPE\n", yytext);}
print {printf("[%s] -> OUTPUT\n", yytext);}
func {printf("[%s] -> FUNCTION\n", yytext);}
return {printf("[%s] -> FUNCTION RETURN\n", yytext);}
global {printf("[%s] -> GLOBAL ESCOPE\n", yytext);}
int({IDENTIFIER})|float({IDENTIFIER})|char({IDENTIFIER})|string({IDENTIFIER}) {printf("[%s] -> CONVERSION\n", yytext);}
const {printf("[%s] -> CONSTANT\n", yytext);}
default {printf("[%s] -> GLOBAL ESCOPE\n", yytext);}
true|false {printf("[%s] -> LOGICAL VALUE\n", yytext);}

"+" {printf("[%s] -> OP SUM\n", yytext);}
"-" {printf("[%s] -> OP SUBTRACTION\n", yytext);}
"*" {printf("[%s] -> OP MULTIPLICATION\n", yytext);}
"/" {printf("[%s] -> OP DIVISION\n", yytext);}
"%" {printf("[%s] -> OP REST\n", yytext);}
"**" {printf("[%s] -> OP POWER\n", yytext);}
"==" {printf("[%s] -> OP EQUALITY\n", yytext);}
"=" {printf("[%s] -> OP ASSIGNMENT\n", yytext);}
"!=" {printf("[%s] -> OP DIFFERENCE\n", yytext);}
"++" {printf("[%s] -> OP INCREMENT\n", yytext);}
"--" {printf("[%s] -> OP DECREMENT\n", yytext);}
">" {printf("[%s] -> OP GREATER THAN\n", yytext);}
"<" {printf("[%s] -> OP LESS THAN\n", yytext);}
">=" {printf("[%s] -> OP GREATER THAN OR EQUAL\n", yytext);}
"<=" {printf("[%s] -> OP LESS THAN OR EQUAL\n", yytext);}
or|and|not {printf("[%s] -> OP LOGICAL\n", yytext);}

{DIGIT} {printf("[%s] -> DIGIT\n", yytext);}
{IDENTIFIER} {printf("[%s] -> IDENTIFICADOR\n", yytext);}
{SPACE} {printf("[%s] -> WHITESPACE\n", yytext);}
{OPENP} {printf("[%s] -> OPEN PARENTHESES\n", yytext);}
{CLOSEP} {printf("[%s] -> CLOSE PARENTHESES\n", yytext);}
{OPENB} {printf("[%s] -> OPEN BRACKET\n", yytext);}
{CLOSEB} {printf("[%s] -> CLOSE BRACKET\n", yytext);}
{DIGIT}+{IDENTIFIER}+ {printf("[%s] -> INVALID IDENTIFIER\n", yytext);}

%%

#ifndef yywrap

int yywrap (void){
    return 1;
}

#endif

int main() {
  yylex();

  return 0;
}




