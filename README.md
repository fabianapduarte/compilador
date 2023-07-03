# Analisador Léxico e Sintático

## Sobre o projeto

Trabalho desenvolvido para a disciplina de Engenharia de Linguagens, cujo objetivo é construir um analisador léxico e sintático, necessário para iniciar o processo de compilação da linguagem de programação proposta pelo grupo.

---

## Como executar

Para gerar o analisador léxico e sintático, verique se o Flex e o Yacc estão instalados na máquina.

Em seguida, execute os seguintes passos:

```bash

$ make

# Para executar com as entradas
$ make run in=<nome_do_aquivo>.txt
```

Ou alternativamente:

```bash

$ cd src
$ flex lex.l
$ yacc -d -v parser.y
$ gcc y.tab.c lex.yy.c -o compilador

# Para executar com as entradas
$ ./compilador < ../inputs/olaMundo.txt
$ ./compilador < ../inputs/mergeSort.txt

```

---

## Autores

- Bruno Moura
- Fabiana Pereira
- João Dantas
- Samuel Costa
