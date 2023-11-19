%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "puppet_mnemonic.h"

extern int yylex(void);
extern void yyerror(const char *s);

char current_node[256];

Attribute temp_attributes[MAX_ATTRIBUTES];
int temp_attribute_count = 0;

void add_attribute(const char *key, const char *value) {
    if (temp_attribute_count < MAX_ATTRIBUTES) {
        temp_attributes[temp_attribute_count].key = strdup(key);
        temp_attributes[temp_attribute_count].value = strdup(value);
        temp_attribute_count++;
    }
}


%}

%token TOK_NODE
%token TOK_FILE
%token TOK_CRON
%token TOK_LEFT_BRACE
%token TOK_RIGHT_BRACE
%token TOK_EQUAL
%token <sval> TOK_ENSURE
%token <sval> TOK_OWNER
%token <sval> TOK_GROUP
%token <sval> TOK_MODE
%token <sval> TOK_SOURCE
%token TOK_COLON
%token <sval> TOK_IDENTIFIER
%token <sval> TOK_STRING
%token TOK_HASHROCKET
%token <sval>TOK_COMMA
%token <sval> TOK_COMMAND
%token <sval> TOK_MINUTE
%token <sval> TOK_HOUR
%token <sval> TOK_MONTHDAY
%token <sval> TOK_MONTH
%token <sval> TOK_WEEKDAY

%union {
    char *sval;
    Attribute attr; 
}
%type <sval> resource_declaration resource_type_declaration
%type <sval> attribute_value


%start manifest  // Definition of the start symbol

%%

manifest:
  node_declaration
  | resource_declaration
  | manifest node_declaration
  | manifest resource_declaration
  ;

node_declaration:
  TOK_NODE TOK_IDENTIFIER { strcpy(current_node,$2); } TOK_LEFT_BRACE manifest TOK_RIGHT_BRACE
  ;

resource_declaration:
  resource_type_declaration TOK_LEFT_BRACE TOK_IDENTIFIER TOK_COLON attribute_declarations TOK_RIGHT_BRACE
    {
      if (add_node_instruction(current_node, $1, temp_attributes, temp_attribute_count) == -1) {
          yyerror("Error adding resource instruction");
          YYABORT;
      }
      temp_attribute_count = 0; 
    }
  ;

resource_type_declaration:
  TOK_FILE { $$ = "file"; }
  | TOK_CRON { $$ = "cron"; }
  ;

attribute_declarations:
  attribute_declaration
  | attribute_declarations TOK_COMMA attribute_declaration
  ;

attribute_declaration:
  file_attribute
  | cron_attribute
  ;

file_attribute:
  TOK_ENSURE TOK_HASHROCKET attribute_value   { add_attribute("ensure", $3); }
  | TOK_OWNER TOK_HASHROCKET attribute_value  { add_attribute("owner", $3); }
  | TOK_GROUP TOK_HASHROCKET attribute_value  { add_attribute("group", $3); }
  | TOK_MODE TOK_HASHROCKET attribute_value   { add_attribute("mode", $3); }
  | TOK_SOURCE TOK_HASHROCKET attribute_value { add_attribute("source", $3); }
  ;

cron_attribute:
  TOK_COMMAND TOK_HASHROCKET attribute_value { add_attribute("command", $3); }
  | TOK_MINUTE TOK_HASHROCKET attribute_value { add_attribute("minute", $3); }
  | TOK_HOUR TOK_HASHROCKET attribute_value   { add_attribute("hour", $3); }
  | TOK_MONTHDAY TOK_HASHROCKET attribute_value { add_attribute("monthday", $3); }
  | TOK_MONTH TOK_HASHROCKET attribute_value { add_attribute("month", $3); }
  | TOK_WEEKDAY TOK_HASHROCKET attribute_value { add_attribute("weekday", $3); }
  ;

attribute_value:
  TOK_STRING { $$ = $1; }
  | TOK_IDENTIFIER { $$ = $1; }
  ;




%%
