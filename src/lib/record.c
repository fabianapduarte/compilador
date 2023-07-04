#include "record.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void freeRecord(record * r) {
  if (r) {
    if (r->code != NULL) free(r->code);
	  if (r->sValue != NULL) free(r->sValue);
    free(r);
  }
}

record * createRecord(char * code, int type) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->code = strdup(code);
  r->type = type;

  return r;
}

record * createInt(int value) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->iValue = value;
  r->type = INT;

  return r;
}

record * createFloat(float value) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->fValue = value;
  r->type = FLOAT;

  return r;
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

record * createChar(char value) {
  record * r = (record *) malloc(sizeof(record));

  if (!r) {
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }

  r->cValue = value;
  r->type = CHAR;

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