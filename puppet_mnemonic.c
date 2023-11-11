#include "puppet_mnemonic.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NODES 1024
#define INITIAL_INSTRUCTION_CAPACITY 10

static Node nodes[MAX_NODES];
static int node_count = 0;

Node *find_or_create_node(char *node_name) {
    for (int i = 0; i < node_count; ++i) {
        if (strcmp(nodes[i].name, node_name) == 0) {
            return &nodes[i];
        }
    }
    if (node_count >= MAX_NODES) {
        return NULL; // Capacité maximale atteinte
    }
    nodes[node_count].name = strdup(node_name);
    nodes[node_count].instructions = malloc(INITIAL_INSTRUCTION_CAPACITY * sizeof(Instruction));
    nodes[node_count].instruction_count = 0;
    nodes[node_count].instruction_capacity = INITIAL_INSTRUCTION_CAPACITY;
    return &nodes[node_count++];
}

int add_node_instruction(char *node_name, char *type, Attribute *attributes, int attribute_count) {
    Node *node = find_or_create_node(node_name);
    if (!node || node->instruction_count >= node->instruction_capacity) {
        return -1;
    }

    Instruction *instr = &node->instructions[node->instruction_count];
    instr->mnemonic = strdup(type);
    instr->attribute_count = attribute_count;
    for (int i = 0; i < attribute_count; ++i) {
        instr->attributes[i].key = strdup(attributes[i].key);
        instr->attributes[i].value = strdup(attributes[i].value);
    }
    node->instruction_count++;
    return 0;
}


void free_nodes() {
    for (int i = 0; i < node_count; ++i) {
        for (int j = 0; j < nodes[i].instruction_count; ++j) {
            free(nodes[i].instructions[j].mnemonic);
            for (int k = 0; k < nodes[i].instructions[j].attribute_count; ++k) {
                free(nodes[i].instructions[j].attributes[k].key);
                free(nodes[i].instructions[j].attributes[k].value);
            }
        }
        free(nodes[i].instructions);
        free(nodes[i].name);
    }
}

void print_nodes() {
    for (int i = 0; i < node_count; ++i) {
        printf("Node: %s\n", nodes[i].name);
        for (int j = 0; j < nodes[i].instruction_count; ++j) {
            printf("  %s ", nodes[i].instructions[j].mnemonic);
            for (int k = 0; k < nodes[i].instructions[j].attribute_count; ++k) {
                printf("%s=%s ", nodes[i].instructions[j].attributes[k].key, nodes[i].instructions[j].attributes[k].value);
            }
            printf("\n");
        }
    }
}

