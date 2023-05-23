%{
#define B 300
#define O 301
#define D 302
#define H 303
#define W 310
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

1[01]*b|0b[01]+	{ return B; }
0[0-7]*			{ return O; }
[1-9][0-9]*		{ return D; }
0x[0-9A-Fa-f]+	{ return H; }

[ \n\t]+	{ return W; }
.			{ return W; }
<<EOF>>		{ return X; }

%%

int charToDigit(char c) {
	if(c >= '0' && c <= '9') return c - '0';
	if(c >= 'a' && c <= 'f') return c - 'a' + 10;
	if(c >= 'A' && c <= 'F') return c - 'A' + 10;
	return -1;
}

// converte uma string de numero (base n) em um inteiro, 
// parando ao encontrar o primeiro caractere que não é um digito na base especificada.
int strToInt (char *str, int n) {
	int valor = 0;
	int digit;

	while( (digit = charToDigit(*str++)) != -1 && digit < n ) {
		valor = valor * n + digit;
	}

	return valor;
}

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

	while (( tipoToken = yylex() ) != X) {
		switch (tipoToken) {
			case B:
				printf("numero binario: %d\n", strToInt(*yytext == '1' ? yytext : yytext + 2, 2));
				break;
			case O:
				printf("numero octal: %d\n", strToInt(yytext, 8));
				break;
			case D:
				printf("numero decimal: %d\n", strToInt(yytext, 10));
				break;
			case H:
				printf("numero hexadecimal: %d\n", strToInt(yytext + 2, 16));
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
