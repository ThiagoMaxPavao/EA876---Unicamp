%{
#define H 300
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

[0-9A-Fa-f]+	{ return H; }

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

// converte uma string de numero hexadecimal em um inteiro, 
// parando ao encontrar o primeiro caractere que não é um digito na base 16.
int strToInt (char *str) {
	int valor = 0;
	int digit;

	while( (digit = charToDigit(*str++)) != -1 ) {
		valor = valor * 0x10 + digit;
	}

	return valor;
}

int main(int argc, char *argv[]){
	FILE *fin, *fout;
	int tipoToken, n_bytes;
	
	// Configura arquivo de entrada
	if (argc == 2) {
		if (fin = fopen(argv[1],"r"))
			yyin = fin;
		else
			perror(argv[0]);
	} else
		yyin = stdin;

	// Configura arquivo de saida
	fout = fopen("entrada.mem", "w");
	fputs("\x03\x4E\x44\x52", fout);
	n_bytes = 4;

	// Extracao de tokens e montagem
	while ( (tipoToken = yylex()) != X ) {
		unsigned char byte;
		switch (tipoToken) {
			case H:
				byte = strToInt(yytext);
				break;
			case W:
				continue; 	// ignora espaco em branco/indetacoes e quebras de linha.
							// Alem de outros caracteres nao reconhecidos
			default:
				byte = tipoToken;
				break;
		}

		fputc(byte, fout);
		fputc(0x00, fout);
		n_bytes += 2;
	}

	// Completa o arquivo com zeros ate alcancar 516
	while(n_bytes++ < 516) fputc(0x00, fout);

	fclose(fout);

	return 0;
}
