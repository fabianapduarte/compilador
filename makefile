all: compilador

compilador: lex.yy.c y.tab.c 
	gcc lex.yy.c y.tab.c -o compiler

lex.yy.c: ./src/lex.l
	flex ./src/lex.l

y.tab.c: ./src/parser.y  
	yacc ./src/parser.y -d -v

clean:
	rm -rf lex.yy.c y.tab.* compiler ./src/output.txt .src/y.output