%{
#include <stdio.h>
#include <stdlib.h>
%}

%token TOK_NODE
%token TOK_FILE
%token TOK_CRON
%token TOK_LEFT_BRACE
%token TOK_RIGHT_BRACE
%token TOK_EQUAL
%token TOK_ENSURE
%token TOK_OWNER
%token TOK_GROUP
%token TOK_MODE
%token TOK_SOURCE
%token TOK_COLON
%token TOK_IDENTIFIER
%token TOK_STRING
%token TOK_HASHROCKET
%token TOK_COMMA
%token TOK_COMMAND
%token TOK_MINUTE
%token TOK_HOUR
%token TOK_MONTHDAY
%token TOK_MONTH
%token TOK_WEEKDAY


%union {
  char *sval;  // You can customize the type according to your needs
}

%start manifest  // Definition of the start symbol

%%

manifest:
  node_declaration
  | resource_declaration
  | manifest node_declaration
  | manifest resource_declaration
  ;

node_declaration:
  TOK_NODE TOK_IDENTIFIER TOK_LEFT_BRACE manifest TOK_RIGHT_BRACE
  ;

resource_declaration:
  resource_type_declaration TOK_LEFT_BRACE TOK_IDENTIFIER TOK_COLON attribute_declarations TOK_RIGHT_BRACE
  ;

resource_type_declaration:
  TOK_FILE
  | TOK_CRON
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
  TOK_ENSURE TOK_HASHROCKET attribute_value
  | TOK_OWNER TOK_HASHROCKET attribute_value
  | TOK_GROUP TOK_HASHROCKET attribute_value
  | TOK_MODE TOK_HASHROCKET attribute_value
  | TOK_SOURCE TOK_HASHROCKET attribute_value
  ;

cron_attribute:
  TOK_COMMAND TOK_HASHROCKET attribute_value
  | TOK_MINUTE TOK_HASHROCKET attribute_value
  | TOK_HOUR TOK_HASHROCKET attribute_value
  | TOK_MONTHDAY TOK_HASHROCKET attribute_value
  | TOK_MONTH TOK_HASHROCKET attribute_value
  | TOK_WEEKDAY TOK_HASHROCKET attribute_value
  ;

attribute_value:
  TOK_STRING
  | TOK_IDENTIFIER
  ;




%%
