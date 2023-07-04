#ifndef RECORD
#define RECORD

struct record {
  char * code; /* field for storing the output code */
  int type; /* field for type code */
  int iValue;
  float fValue;
  int bValue;
  char cValue;
  char * sValue;
};

// enum bool {
//   FALSE,
//   TRUE
// };

enum types {
  INT,
  FLOAT,
  CHAR,
  STRING,
  OBJECT,
  ARRAY,
  VOID,
  BOOL
};

typedef struct record record;
 
void freeRecord(record *);
record * createRecord(char *, int);
record * createInt(int);
record * createFloat(float);
record * createBool(int);
record * createChar(char);
record * createString(char *);

#endif