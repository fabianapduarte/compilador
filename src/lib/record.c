#include "record.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylineno;

void freeRecord(record * r) {
  if (r) {
    if (r->code != NULL) free(r->code);
	  if (r->sValue != NULL) free(r->sValue);
    free(r);
  }
}

void addValue(record *r,  int type, char * value){
  r->type = type;
  if(type == INT){
    r->iValue = atoi(value);
  }else if 
  (type == FLOAT){
    r->fValue = atof(value);
  }else if 
  (type == STRING){
    r->sValue = value;
  }else if 
  (type == CHAR){
    r->cValue = value[0];
  }else if 
  (type == BOOL){
    r->sValue = value;
  }else {  }
}

record * createRecord(Stack *stack, char * name, int type, char * value) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  if(name == NULL){
    char nameTemp[20];
    sprintf(nameTemp, "temp_%d", yylineno);
    r->name = nameTemp;
  }else{
    r->name = name;
  }

  record * ret = pop(stack, name);
  if(ret != NULL){
    if(ret->type == type){
       addValue(ret, type, value);
       return ret;
    }
  }
  
  addValue(r, type, value);
  push(stack, r);
  return r;
}

void renameRecord(Stack * stack, record * r, char * name){
  r->name = name;
}

record * createBool(int value) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->bValue = value;
  r->type = BOOL;

  return r;
}

record * createString(char * value) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->sValue = strdup(value);
  r->type = STRING;

  return r;
}


void initialize(Stack* stack) {
    stack->top = -1;
}

void push(Stack* stack, record * value) {
    // if (isFull(stack)) {
    //     printf("Stack overflow.");
    //     return;
    // }
    
    stack->top++;
    // printf("add a posicao %i \n", stack->top);
    stack->data[stack->top] = value;
}

record * pop(Stack* stack, char * name) {
    // if (isEmpty(stack)) {
    //     printf("Stack underflow. Cannot pop.\n");
    //     return -1; // Valor inválido para representar erro
    // }

    int size = stack->top;
    record * r;
    while(stack->top >= 0){
      r = stack->data[stack->top];
      if(strcmp(name, r->name) == 0){
        stack->top = size;
        return r;
      }
      stack->top--;
    }
    stack->top = size;
    return NULL;
}

void printStack(Stack* stack){
  printf("Top = %i\n", stack->top);
  for (int i = 0; i < stack->top - 1; i++){
    printf("%s - %i\n", stack->data[i]->name, i);
  }
  
}