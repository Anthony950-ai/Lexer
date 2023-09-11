%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define YY_DECL int yylex()

int words = 0;
int chars = 0;
int lines = 0;

%}
//definitions for expression the lexer will encounter
letter      [a-zA-Z]
digit       [0-9]
quote       \"
ID          {letter}({letter}|{digit})*
delim       [ \t\n]
NUMBER         {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
STRING      {quote}([^\"]|(\"))+{quote}
ws          {delim}+
//recognition of different tokens analyzed in the language
%%


"/*"    				{
							int c;
							while((c = input()) != 0) {
								if(c == '*') {
									if((c = input()) == '/')
										break;
									else
										unput(c);
								}
							}
						}
						
"int"	{words++; chars += strlen(yytext);
		 printf("%s : TYPE\n", yytext);
		}

"string"    {
                words++; 
                chars += strlen(yytext);
                printf("%s : TYPE\n", yytext);
            }

"char"	{words++; chars += strlen(yytext);
		 printf("%s : TYPE\n", yytext);
		}
		
"write"	{words++; 
		 chars += strlen(yytext);
		 printf("%s : KEYWORD\n", yytext);
		}
"return"	{words++; 
		 chars += strlen(yytext);
		 printf("%s : KEYWORD\n", yytext);
		}
"foo"	{words++; chars += strlen(yytext);
		 printf("%s : IDENTIFIER\n",yytext);
		}
		
"["	{chars++;
		 printf("%s : LEFT_BRACKET\n", yytext);
		}

"]"	{chars++;
		 printf("%s : RIGHT_BRACKET\n", yytext);
		}
		
","	{chars++;
		 printf("%s : COMMA\n", yytext);
		}
		
"=="	{chars += 2;
		 printf("%s : EQ_EQ\n", yytext);
		}
		
"!="	{chars += 2;
		 printf("%s : NOT_EQ\n", yytext);
		}
		
"&&"	{chars += 2;
		 printf("%s : AND_AND\n", yytext);
		}
		
"<="	{chars += 2;
		 printf("%s : LESS_EQ\n", yytext);
		}
		
">="	{chars += 2;
		 printf("%s : GREATER_EQ\n", yytext);
		}
		
"<"	{chars++;
		 printf("%s : LESS\n", yytext);
		}
		
">"	{chars++;
		 printf("%s : GREATER\n", yytext);
		}		
{ID}	{words++; chars += strlen(yytext);
		 printf("%s : IDENTIFIER\n",yytext);
		}
			
{NUMBER}	{words++; chars += strlen(yytext);
			  printf("%s : NUMBER\n",yytext);
			}
			
";"		{chars++;
		 printf("%s : SEMICOLON\n", yytext);
		}
		
"="		{chars++;
		 printf("%s : EQ\n", yytext);
		}
		
"("         {
                chars++;
                printf("%s : LEFT_PAREN\n", yytext);
            }

")"         {
                chars++;
                printf("%s : RIGHT_PAREN\n", yytext);
            }

"{"         {
                chars++;
                printf("%s : LEFT_BRACE\n", yytext);
            }

"}"         {
                chars++;
                printf("%s : RIGHT_BRACE\n", yytext);
            }

"+"         {
                chars++;
                printf("%s : PLUS\n", yytext);
            }

"-"         {
                chars++;
                printf("%s : MINUS\n", yytext);
            }

"*"         {
                chars++;
                printf("%s : MULTIPLY\n", yytext);
            }

"/"         {
                chars++;
                printf("%s : DIVIDE\n", yytext);
            }

{STRING}    {
                words++; 
                chars += strlen(yytext);
                printf("%s : STRING\n",yytext);
            }

\n		{lines++; chars=0;}
[ \t]	{chars++;}
.		{chars++;
         printf("%s : Unrecognized symbol at line %d char %d\n", yytext,lines,chars);
		}
		


%%
//initialization of the lexer
int main(int argc, char**argv)
{
	#ifdef YYDEBUG
		yydebug = 1;
	#endif

	printf("Compiler started. \n\n");

	if (argc > 1){
	  if(!(yyin = fopen(argv[1], "r")))
          {
		perror(argv[1]);
		return(1);
	  }
	}
	yylex();
}
