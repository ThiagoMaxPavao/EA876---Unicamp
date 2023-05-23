%{
#define D 300
#define W 301
#define X 399
%}

%%

NOP		{ return 0; }
STA		{ return 16; }
LDA		{ return 32; }
ADD		{ return 48; }
OR		{ return 64; }
AND		{ return 80; }
NOT		{ return 96; }
JMP		{ return 128; }
JN		{ return 144; }
JZ		{ return 160; }
HLT		{ return 240; }

[1-9][0-9]*		{ return D; }

[ \n\t]+	{ return W; }
.			{ return W; }
<<EOF>>		{ return X; }

%%

int main(int argc, char *argv[]){
	FILE *fin;
	int tipoToken;
	
	if (argc == 2) {
		if (fin = fopen(argv[1],"r"))
			yyin = fin;
		else
			perror(argv[0]);
	} else
		yyin = stdin;

	while (( tipoToken = yylex()) != X) {
		switch (tipoToken) {
			case D:
				printf("numero decimal\n");
				break;
			case W: // ignora espaco em branco/indetacoes e quebras de linha
				break;
			default:
				printf("instrucao: %d\n", tipoToken);
				break;
		}
	}

	return 0;
}
