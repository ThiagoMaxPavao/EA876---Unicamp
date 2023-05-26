%{
// instrucoes e opcodes
#define NOP 0
#define STA 16
#define LDA 32
#define ADD 48
#define OR  64
#define AND 80
#define NOT 96
#define JMP 128
#define JN  144
#define JZ  160
#define HLT 240

#define H 300 // numero hexadecimal, escrito sem 0x
#define X 399 // fim do arquivo
%}

%%

NOP		{ return NOP; }
STA		{ return STA; }
LDA		{ return LDA; }
ADD		{ return ADD; }
OR		{ return OR;  }
AND		{ return AND; }
NOT		{ return NOT; }
JMP		{ return JMP; }
JN		{ return JN;  }
JZ		{ return JZ;  }
HLT		{ return HLT; }

[0-9A-Fa-f]+    { return H; }
<<EOF>>		    { return X; }

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

void montaNomeSaida(char *inName, char *outName) {
	int i = 0;
	char c;

	do {
		c = outName[i] = inName[i];
		i++;
	} while( c != '.' );

	outName[i++] = 'm';
	outName[i++] = 'e';
	outName[i++] = 'm';
	outName[i++] = 0;

	return;
}

int main(int argc, char *argv[]){
	FILE *fin, *fout;
	int tipoToken, index = 0;
	char programBytes[516] = {0}, // inicializa vetor preenchido com zeros
		 outName[50], error = 0;
	
	// Configura arquivo de entrada
	if (argc == 2) {
		if (fin = fopen(argv[1],"r"))
			yyin = fin;
		else
			perror(argv[0]);
	} else
		yyin = stdin;

	// cabecalho do arquivo
	programBytes[index++] = 0x03;
	programBytes[index++] = 0x4E;
	programBytes[index++] = 0x44;
	programBytes[index++] = 0x52;

	// Extracao de tokens e montagem
	while ( (tipoToken = yylex()) != X && !error ) {
		switch (tipoToken) {
			case NOP:
            case NOT:
            case HLT:
                programBytes[index] = tipoToken;
				index += 2;
				break;
			case STA:
            case LDA:
            case ADD:
			case OR:
            case AND:
            case JMP:
            case JN:
            case JZ:
                programBytes[index] = tipoToken;
				index += 2;

                if( yylex() != H ) error = 1;// faltando endereco em instrucao que exige
                else {
					programBytes[index] = strToInt(yytext); // tem endereco, insere no vetor
					index += 2;
				}
				
                break;
            case H: // numero sem instrucao que o exigisse
                error = 1;
                break;
			default:
				break;
		}
	}

    if(error) { // retorna codigo de erro caso tenha ocorrido. Sem criar arquivo de saida
		printf("Erro no codigo. Encerrando...\n");
		return 1;
	}

	// Caso nao haja erro no codigo
	// Escreve no arquivo de saida
	montaNomeSaida(argv[1], outName);
	fout = fopen(outName, "w");
	fwrite(programBytes, 1, 516, fout);
	fclose(fout);

	return 0;
}
