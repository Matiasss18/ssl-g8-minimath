/* minimath.l */
%{ 
#include <stdio.h> 
#include <string.h> 

/* Token definitions for clarity and for parser integration */ 
typedef enum { 
    TOKEN_SI, 
    TOKEN_SINO, 
    TOKEN_IMPRIMIR, 
    TOKEN_DEF, 
    TOKEN_INICIO, 
    TOKEN_FIN, 
    TOKEN_IDENTIFICADOR, 
    TOKEN_NUMERO_ENTERO, 
    TOKEN_CADENA_TEXTO, 
    TOKEN_IGUAL, 
    TOKEN_LPAREN, 
    TOKEN_RPAREN, 
    TOKEN_LBRACKET, 
    TOKEN_RBRACKET, 
    TOKEN_ASTERISCO, 
    TOKEN_SLASH, 
    TOKEN_MAS, 
    TOKEN_MENOS, 
    TOKEN_PUNTO_Y_COMA, 
    TOKEN_ERROR 
} TokenType; 

/* Function to print token information */ 
void print_token(TokenType type, const char* text); 

%} 

/* Options */ 
%option noyywrap 
%option yylineno 

/* Regular Expression Definitions */ 
LETRA        [a-zA-Z] 
DIGITO       [0-9] 
LETRA_GRIEGA [Α-Ωα-ω] 
IDENTIFICADOR_VALIDO ({LETRA}|_)({LETRA}|{DIGITO}|_){0,15} 
IDENTIFICADOR_LARGO  ({LETRA}|_)({LETRA}|{DIGITO}|_){16,} 

%%

"si"            { print_token(TOKEN_SI, yytext); } 
"sino"          { print_token(TOKEN_SINO, yytext); } 
"imprimir"      { print_token(TOKEN_IMPRIMIR, yytext); } 
"def"           { print_token(TOKEN_DEF, yytext); } 
"INICIO"        { print_token(TOKEN_INICIO, yytext); } 
"FIN"           { print_token(TOKEN_FIN, yytext); } 

{IDENTIFICADOR_LARGO} { 
    printf("Error: Identificador '%s' en la línea %d excede la longitud máxima de 16 caracteres.\n", yytext, yylineno); 
}

{IDENTIFICADOR_VALIDO} { print_token(TOKEN_IDENTIFICADOR, yytext); } 
{LETRA_GRIEGA}         { print_token(TOKEN_IDENTIFICADOR, yytext); } 

{DIGITO}+       { print_token(TOKEN_NUMERO_ENTERO, yytext); } 
'([^']*)'       { print_token(TOKEN_CADENA_TEXTO, yytext); } 

"="             { print_token(TOKEN_IGUAL, yytext); } 
"("             { print_token(TOKEN_LPAREN, yytext); } 
")"             { print_token(TOKEN_RPAREN, yytext); } 
"["             { print_token(TOKEN_LBRACKET, yytext); } 
"]"             { print_token(TOKEN_RBRACKET, yytext); } 
"*"             { print_token(TOKEN_ASTERISCO, yytext); } 
"/"             { print_token(TOKEN_SLASH, yytext); } 
"+"             { print_token(TOKEN_MAS, yytext); } 
"-"             { print_token(TOKEN_MENOS, yytext); } 
";"             { print_token(TOKEN_PUNTO_Y_COMA, yytext); } 

[ 	]+        { /* Ignorar espacios en blanco */ } 
"\n"            { yylineno++; } 

.               { printf("Error: Caracter inesperado '%s' en la línea %d\n", yytext, yylineno); print_token(TOKEN_ERROR, yytext); } 

%%

void print_token(TokenType type, const char* text) { 
    const char* type_str; 
    switch(type) { 
        case TOKEN_SI: type_str = "Palabra reservada (si)"; break; 
        case TOKEN_SINO: type_str = "Palabra reservada (sino)"; break; 
        case TOKEN_IMPRIMIR: type_str = "Palabra reservada (imprimir)"; break; 
        case TOKEN_DEF: type_str = "Palabra reservada (def)"; break; 
        case TOKEN_INICIO: type_str = "Palabra reservada (INICIO)"; break; 
        case TOKEN_FIN: type_str = "Palabra reservada (FIN)"; break; 
        case TOKEN_IDENTIFICADOR: type_str = "Identificador"; break; 
        case TOKEN_NUMERO_ENTERO: type_str = "Número entero"; break; 
        case TOKEN_CADENA_TEXTO: type_str = "Cadena de texto"; break; 
        case TOKEN_IGUAL: type_str = "Símbolo (=)"; break; 
        case TOKEN_LPAREN: type_str = "Símbolo (("; break; 
        case TOKEN_RPAREN: type_str = "Símbolo ()"; break; 
        case TOKEN_LBRACKET: type_str = "Símbolo ([)"; break; 
        case TOKEN_RBRACKET: type_str = "Símbolo (])"; break; 
        case TOKEN_ASTERISCO: type_str = "Símbolo (*)"; break; 
        case TOKEN_SLASH: type_str = "Símbolo (/"; break; 
        case TOKEN_MAS: type_str = "Símbolo (+)"; break; 
        case TOKEN_MENOS: type_str = "Símbolo (-)"; break; 
        case TOKEN_PUNTO_Y_COMA: type_str = "Fin de sentencia (;)"; break; 
        case TOKEN_ERROR: type_str = "Error"; break; 
        default: type_str = "Desconocido"; break; 
    } 
    printf("Token: %-30s Lexema: '%s'\n", type_str, text); 
} 

int main(int argc, char *argv[]) { 
    if (argc > 1) { 
        FILE *file = fopen(argv[1], "r"); 
        if (!file) { 
            perror("Error al abrir el archivo"); 
            return 1; 
        } 
        yyin = file; 
    } else { 
        printf("Usando entrada estándar. Presione Ctrl+D para finalizar.\n"); 
        yyin = stdin; 
    } 

    yylex(); 

    if (argc > 1) { 
        fclose(yyin); 
    } 

    return 0; 
} 
