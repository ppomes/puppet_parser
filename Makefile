CC = gcc
CFLAGS = -Wall
LDFLAGS = -lfl

all: puppet_parser

puppet_parser: puppet_parser.tab.c lex.yy.c main.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

puppet_parser.tab.c: puppet_parser.y
	bison -d $<

lex.yy.c: puppet_lexer.l puppet_parser.tab.c
	flex -d $<

clean:
	rm -f puppet_parser puppet_parser.tab.c puppet_parser.tab.h lex.yy.c

.PHONY: clean

