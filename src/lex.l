%{
	#include<stdio.h>
%}

%option yylineno

DIGIT[0-9]+
CHAR[a-zA-Z]
IDENTIFIER[a-zA-Z](_|[a-zA-Z0-9])*
SPACE[ ]
OPENP[\(]
CLOSEP[\)]
OPENB[\{]
CLOSEB[\}]
OPENBKT[\[]
CLOSEBKT[\]]

%%
if {printf("[%s] -> if\n", yytext);}
else {printf("[%s] -> else\n", yytext);}
elif {printf("[%s] -> elif\n", yytext);}
do {printf("[%s] -> do\n", yytext);}
switch {printf("[%s] -> switch\n", yytext);}
case {printf("[%s] -> case\n", yytext);}

for {printf("[%s] -> LOOPING FOR\n", yytext);}
while {printf("[%s] -> LOOPING WHILE\n", yytext);}
break {printf("[%s] -> ESCAPE break\n", yytext);}
continue {printf("[%s] -> ESCAPE continue\n", yytext);}

bool {printf("[%s] -> VARIABLE TYPE bool\n", yytext);}
int {printf("[%s] -> VARIABLE TYPE int\n", yytext);}
float {printf("[%s] -> VARIABLE TYPE float\n", yytext);}
char {printf("[%s] -> VARIABLE TYPE char\n", yytext);}
string {printf("[%s] -> VARIABLE TYPE string\n", yytext);}
array {printf("[%s] -> VARIABLE TYPE array\n", yytext);}
object {printf("[%s] -> VARIABLE TYPE object\n", yytext);}

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
or {printf("[%s] -> OP LOGICAL OR \n", yytext);}
and {printf("[%s] -> OP LOGICAL AND \n", yytext);}
not {printf("[%s] -> OP LOGICAL NOT \n", yytext);}

{DIGIT} {printf("[%s] -> DIGIT\n", yytext);}
{IDENTIFIER} {printf("[%s] -> IDENTIFICADOR\n", yytext);}
{SPACE} {printf("[%s] -> WHITESPACE\n", yytext);}
{OPENP} {printf("[%s] -> OPEN PARENTHESES\n", yytext);}
{CLOSEP} {printf("[%s] -> CLOSE PARENTHESES\n", yytext);}
{OPENB} {printf("[%s] -> OPEN BRACE\n", yytext);}
{CLOSEB} {printf("[%s] -> CLOSE BRACE\n", yytext);}
{OPENBKT} {printf("[%s] -> OPEN BRACKET\n", yytext);}
{CLOSEBKT} {printf("[%s] -> CLOSE BRACKET\n", yytext);}
"," { printf("[%s] -> COMMA\n", yytext); }
\n  { }
.   { printf("[%s] -> INVALID IDENTIFIER\n", yytext); }

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