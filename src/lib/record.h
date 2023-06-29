#ifndef RECORD
#define RECORD

struct record {
  char * code; /* field for storing the output code */
  char * type; /* field for type code */
};

typedef struct record record;
 
void freeRecord(record *);
record * createRecord(char *, char *);

#endif