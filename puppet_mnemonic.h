#ifndef PUPPET_MNEMONIC_H
#define PUPPET_MNEMONIC_H

#define MAX_ATTRIBUTES 10

typedef struct Attribute {
    char *key;
    char *value;
} Attribute;

typedef struct Instruction {
    char *mnemonic;
    Attribute attributes[MAX_ATTRIBUTES];
    int attribute_count;
} Instruction;

typedef struct Node {
    char *name;
    Instruction *instructions;
    int instruction_count;
    int instruction_capacity;
} Node;

int add_node_instruction(char *node_name, char *type, Attribute *attributes, int attribute_count);
void free_nodes(void);
void print_nodes(void);

#endif // PUPPET_MNEMONIC_H

