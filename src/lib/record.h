#ifndef RECORD
#define RECORD

#define MAX_SIZE 100

struct record {
  char * code; /* field for storing the output code */
  int type; /* field for type code */
  char * name;
  int iValue;
  float fValue;
  int bValue;
  char cValue;
  char * sValue;
};

enum types {
  INT,
  FLOAT,
  CHAR,
  STRING,
  OBJECT,
  ARRAY,
  VOID,
  BOOL,
  FUNCTION
};
typedef struct record record;

typedef struct Stack{
    struct record* data[MAX_SIZE];
    int top;
} Stack;
 
void freeRecord(record *);
record * createRecord(Stack*, char *, int, char *);
record * createInt(int);
record * createFloat(float);
record * createBool(int);
record * createChar(char *);
record * createString(char *);
void renameRecord(Stack *, record *, char *);
void exprCode(record *);

void initialize(Stack *stack);
int isEmpty(Stack* stack);
int isFull(Stack* stack);
void push(Stack* stack, record * value);
record * pop(Stack* stack, char * name);
void printStack(Stack* stack);

#endif