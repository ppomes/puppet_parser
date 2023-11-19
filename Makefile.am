# Generated sources
BUILT_SOURCES = puppet_parser.tab.c puppet_parser.tab.h lex.yy.c
CLEANFILES = $(BUILT_SOURCES) 

# Main target
bin_PROGRAMS = puppet_parser

# Sources
#puppet_parser_SOURCES = main.c puppet_mnemonic.c puppet_parser.y puppet_lexer.l
puppet_parser_SOURCES = main.c puppet_mnemonic.c puppet_parser.tab.c lex.yy.c

puppet_parser.tab.c: puppet_parser.y
	$(BISON) -d $<

lex.yy.c: puppet_lexer.l puppet_parser.tab.c
	$(FLEX) -d $<

# Flex/Bison flags
AM_YFLAGS = -d -Wno-yacc
AM_LFLAGS = -8
