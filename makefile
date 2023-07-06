all: compilador

compilador: src/lex.yy.c src/y.tab.c 
	gcc src/lex.yy.c src/y.tab.c src/lib/record.c -o src/compilador -lm

src/lex.yy.c: src/lex.l
	flex -o src/lex.yy.c src/lex.l

src/y.tab.c: src/parser.y  
	yacc -o src/y.tab.c -d -v -t src/parser.y

clean:
	rm -rf src/lex.yy.c src/y.tab.* src/compilador src/output.txt src/y.output

run:
	./src/compilador < ./inputs/$(in)
	gcc output.c -o ./output
	./output
