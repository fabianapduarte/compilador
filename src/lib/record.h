#ifndef RECORD
#define RECORD

struct record {
  char * code; /* field for storing the output code */
  char * type; /* field for type code */
  int iValue;
  double dValue;
  int bValue;
};

typedef struct record record;
 
void freeRecord(record *);
record * createRecord(char *, char *);

#endif