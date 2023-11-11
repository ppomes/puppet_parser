%{
#include "puppet_mnemonic.h"
#include "puppet_parser.tab.h"
%}

%option yylineno

%%
"node"          { return TOK_NODE; }
"file"          { return TOK_FILE; }
"cron"          { return TOK_CRON; }
"{"             { return TOK_LEFT_BRACE; }
"}"             { return TOK_RIGHT_BRACE; }
"=>"            { return TOK_HASHROCKET; }
"="             { return TOK_EQUAL; }
"ensure"        { return TOK_ENSURE; }
"owner"         { return TOK_OWNER; }
"group"         { return TOK_GROUP; }
"mode"          { return TOK_MODE; }
"source"        { return TOK_SOURCE; }
":"             { return TOK_COLON; }
","             { return TOK_COMMA; }
"command"       { return TOK_COMMAND; }
"minute"        { return TOK_MINUTE; }
"hour"          { return TOK_HOUR; }
"monthday"      { return TOK_MONTHDAY; }
"month"         { return TOK_MONTH; }
"weekday"       { return TOK_WEEKDAY; }
[ \t\n]         ;  // Ignore spaces, tabs, and newlines
\'[^\']*\' { yylval.sval = strdup(yytext); return TOK_IDENTIFIER; }

.               { 
  fprintf(stderr, "Unrecognized character at line %d: %s\n", yylineno, yytext);
  return -1;
}
%%

