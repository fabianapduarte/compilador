# Analisador Léxico e Sintático

## Sobre o projeto

Trabalho desenvolvido para a disciplina de Engenharia de Linguagens, cujo objetivo é construir um compilador (com analisador léxico e sintático), necessário para iniciar o processo de compilação da linguagem de programação proposta pelo grupo.

---
## Descrição da linguagem

    A linguagem proposta está inserida no domínio de programação de sistemas para web com foco em back-end, visando facilidade de escrita e boa legibilidade, implementando manipulação de strings, tipagem estática e portabilidade.

    A linguagem é C-Based e fortemente tipada, entretanto visa uma sintáxe mais simples, buscando referências em JavaScript e Python. Portanto, a prioridade é o desempenho do programador diante da facilidade de escrita.

    Possui os tipos primitivos: int, float, char, string, boo, array e object

    Por ser fortemente tipada a linguagem não implementa conversões implicitas, possuindo as seguintes conversões explícitas:

    float(<int>)
    int(<float>) - int(<char>) - int(<string>)
    string(<int>) - string(<float>) - string(<char>) - string(<bool>)
- Para variáveis globais existe a palavra reservada:
    - global <_tipo_> 
- Operadores lógicos, aritméticos e relacionais
    - Incremento e decremento
        - ++, -- (Unário - pós-fixado)
    - Negação de sinal, incremento e decremento e negação
        - -, ++, --, not (Unário - prefixado)
    - Exponenciação
        - ** (Binário)
    - Multiplicação, divisão e módulo
        - *, /, % (Binário)
    - Soma e subtração
        - +, – (Binário)
    - Menor, maior, menor ou igual e maior ou igual
        - <, >, <=, >= (Binário)
    - Igualdade e desigualdade
        - ==, !=  (Binário)
    - Operadores OU, AND
        - or, and (Binário)
---

## Exemplos de programas
    Os exemplos de programas escritos na linguagem se encontram na pasta inputs.

---
## Principais estruturas de dados e funções utilizadas na compilação
- Foi utilizada a estrutura de pilha para trabalhar com os elementos da tabela de símbolos
    - Os elementos da pilha por sua vez são do tipo struct e possui os campos de nome, tipo e valor (record)
- Internamente o tipo booleano é implementado utilizando inteiro como flag.
---

## Design da implementação:
    Transformação do código-fonte em unidades léxicas
        - Captura de palavras reservadas e expressões regulares
        (src/parser.y)
    Tratamento de estruturas condicionais e de repetição;

    Tratamento de subprogramas;
        - 
    Verificações realizadas (tipos, faixas, declaração em duplicidade, etc)
        - A lingaguem realiza verificação de tipos e declarações de duplicidade por intermédio da pilha
---

## Manual de uso do compilador

Para gerar o compilador, verique se o Flex e o Yacc estão instalados na máquina.

Em seguida, execute os seguintes passos:

```bash

$ make all

# Para executar com as entradas
$ make run in=<nome_do_aquivo>.txt

# Para limpar os arquivos gerados
$ make clean
```

Ou alternativamente:

```bash

$ cd src
$ flex lex.l
$ yacc -d -v parser.y
$ gcc y.tab.c lex.yy.c -o compilador -lm

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
