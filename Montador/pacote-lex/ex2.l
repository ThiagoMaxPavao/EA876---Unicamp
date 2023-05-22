DIGIT [0-9]
%%
[1-9]{DIGIT}*		printf ("Dec");
0[0-7]*			printf ("Oct");
0x[0-9A-Fa-f]+		printf ("Hex");
<<EOF>>			return 0;
%%
int main(int argc, char *argv[]){
	FILE *fin;
	if (argc == 2) {
		if (fin = fopen(argv[1],"r"))
			yyin = fin;
		else
			perror(argv[0]);
	} else
		yyin = stdin;

	yylex ();
	return (0);
}
