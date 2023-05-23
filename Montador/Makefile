montador.out: lex.yy.c
	gcc -o montador.out lex.yy.c -lfl

lex.yy.c: montador.l
	flex montador.l

clean:
	rm -f montador.out lex.yy.c
