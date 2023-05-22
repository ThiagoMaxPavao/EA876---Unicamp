DIGIT [0-9]
%%
[1-9]{DIGIT}*		printf ("Dec");
0[0-7]*			printf ("Oct");
0x[0-9A-Fa-f]+		printf ("Hex");
<<EOF>>			return 0;
%%
