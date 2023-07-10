#ifndef RECORD
#define RECORD

#define MAX_SIZE 100

struct record {
  char * code;     /* field for storing the output code */
  char * type;     /* field for type code */
  char * name;     /* field for variable name */
  char * sValue;   /* field for variable value */
  char * input;    /* field for variable input */
};

typedef struct record record;

typedef struct Stack{
  struct record* data[MAX_SIZE];
  int top;
} Stack;
 
void freeRecord(record *);
record * createRecord(Stack *, char *, char *, char *, char *, char *);
void setRecord(record *, char *, char *, char *);
void setValue(record *, char *);
void renameRecord(Stack *, record *, char *);
record * copyRecord(record * origem, record * destino);

void initialize(Stack *);
int isEmpty(Stack*);
int isFull(Stack*);
void push(Stack*, record *);
record * search(Stack*, char *);
void printStack(Stack*);

#endif