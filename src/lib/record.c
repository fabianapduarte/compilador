#include "record.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylineno;

int tempVar = 0;

void freeRecord(record * r) {
  if (r) {
    if (r->code != NULL) free(r->code);
	  if (r->sValue != NULL) free(r->sValue);
    if (r->type != NULL) free(r->type);
    if (r->name != NULL) free(r->name);
    free(r);
  }
}

void setValue(record *r, char * value) {
  r->sValue = value;
}

record * createRecord(Stack * stack, char * name, char * type, char * value, char * code, char * input) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  if (name == NULL) {
    char * nameTemp = (char *) malloc(20 * sizeof(char));
    sprintf(nameTemp, "st_temp_var_%d", tempVar);
    r->name = nameTemp;
    tempVar++;
  } else {
    r->name = name;
  }

  if (input == NULL) {
    r->input = "false";
  } else {
    r->input = input;
  }
  
  r->type = type;
  r->sValue = value;
  r->code = code;

  record * ret = search(stack, name);
  if (ret != NULL) {
    if (strcmp(ret->type, type) == 0) {
      setRecord(ret, type, value, code);
      return ret;
    }
  }
  
  push(stack, r);
  return r;
}

void setRecord(record * r, char * type, char * value, char * code) {
  r->type = type;
  r->sValue = value;
  r->code = code;
}

void renameRecord(Stack * stack, record * r, char * name){
  r->name = name;
}

record * copyRecord(record * origem, record * destino){
  destino->code = origem->code;
  destino->type = origem->type;
  destino->name = origem->name;
  destino->sValue = origem->sValue;
  destino->input = origem->input;

  return destino;
}

void initialize(Stack* stack) {
  stack->top = -1;
}

void push(Stack* stack, record * value) {
  stack->top++;
  stack->data[stack->top] = value;
}

record * search(Stack* stack, char * name) {
  int size = stack->top;
  record * r;
  if (name != NULL) {
    while (size >= 0) {
      r = stack->data[size];
      if (strcmp(name, r->name) == 0) {
        return r;
      }
      size--;
    }
  }
  
  return NULL;
}

record * searchInput(Stack* stack, char * name) {
  int size = stack->top;
  record * r;
  if (name != NULL) {
    while (size >= 0) {
      r = stack->data[size];
      if ((strcmp(name, r->name) == 0) && (strcmp("true", r->input) == 0)) {
        return r;
      }
      size--;
    }
  }
  
  return NULL;
}

void printStack(Stack* stack){
  printf("Top = %i\n", stack->top);
  for (int i = 0; i < stack->top - 1; i++){
    printf("Nome: %s - Posicao: %i - Valor: %s - Tipo: %s, Input: %s\n", 
    stack->data[i]->name, i, stack->data[i]->sValue, stack->data[i]->type, stack->data[i]->input);
  }
}