#include "record.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylineno;
int yydebug = 0;

void freeRecord(record * r) {
  if (r) {
    if (r->code != NULL) free(r->code);
	  if (r->sValue != NULL) free(r->sValue);
    if (r->type != NULL) free(r->type);
    free(r);
  }
}

void setValue(record *r, char * type, char * value, char * code) {
  r->type = type;
  r->sValue = value;
  r->code = code;
}

record * createRecord(Stack * stack, char * name, char * type, char * value, char * code) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  if (name == NULL) {
    char * nameTemp = (char *) malloc(20 * sizeof(char));
    sprintf(nameTemp, "temp_%d", yylineno);
    r->name = nameTemp;
  } else {
    r->name = name;
  }
  
  r->type = type;
  r->sValue = value;
  r->code = code;

  record * ret = search(stack, name);
  if (ret != NULL) {
    if (strcmp(ret->type, type) == 0) {
      setValue(ret, type, value, code);
      return ret;
    }
  }
  
  setValue(r, type, value, code);
  push(stack, r);
  return r;
}

void renameRecord(Stack * stack, record * r, char * name){
  r->name = name;
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

void printStack(Stack* stack){
  printf("Top = %i\n", stack->top);
  for (int i = 0; i < stack->top - 1; i++){
    printf("%s - %i\n", stack->data[i]->name, i);
  }
}