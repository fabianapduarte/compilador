# Analisador Léxico

## Sobre o projeto

Trabalho desenvolvido para a disciplina de Engenharia de Linguagens, cujo objetivo é construir um analisador léxico, necessário para iniciar o processo de compilação da linguagem de programação proposta pelo grupo.

---

## Como executar

Para gerar o analisador léxico, verique se o Flex está instalado na máquina.

Em seguida, execute os seguintes passos:

```bash

$ cd src
$ flex lex.l
$ gcc -o analisadorLexico lex.yy.c

# Para executar com as entradas
$ ./analisadorLexico < ../inputs/olaMundo.txt
$ ./analisadorLexico < ../inputs/mergeSort.txt

```

---

## Autores

- Bruno Moura
- Fabiana Pereira
- João Dantas
- Samuel Costa
