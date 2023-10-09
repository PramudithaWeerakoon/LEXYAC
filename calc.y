%{
#include <stdio.h>
#include <math.h>
#include <stdlib.h> // Include for exit() function

int yylex(void);
void yyerror(const char* msg);

double result = 0.0;
int syntax_error = 0; // Flag to track syntax errors

void display_instructions(); // Forward declaration

%}

%token NUMBER
%token COMMAND_ERROR // New token for invalid commands
%token EOL // Declare the EOL token
%token SQRT // Declare the SQRT token
%token EXPONENT // Declare the EXPONENT token for '^' operator
%token MODULO // Declare the MODULO token for '%' operator

%%

input: /* empty */
    | input line EOL {
        if (!syntax_error) {
            printf("\033[0;32mResult: %.2lf\n\033[0m", result); // Limit to two decimal points
        }
        printf("===========================================================\n");
        result = 0.0;
        syntax_error = 0; // Reset syntax error flag
        printf("Enter expressions or commands:\n");
    }
    | input command EOL
    | input error EOL { // Handle syntax errors
        syntax_error = 0; // Reset syntax error flag
        yyerrok; // Clear Bison's error flag
    }
    ;

line: expr { result = $1; }
    ;

expr:   NUMBER          { $$ = $1; }
    | expr '+' term    { $$ = $1 + $3; }
    | expr '-' term    { $$ = $1 - $3; }
    | expr '*' term    { $$ = $1 * $3; }
    | expr '/' term    { 
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | SQRT '(' expr ')' { $$ = sqrt($3); } // Handle square root
    | expr EXPONENT term { $$ = pow($1, $3); } // Handle exponentiation
    | expr MODULO term  { $$ = fmod($1, $3); } // Handle modulo operation
    ;

term:   factor          { $$ = $1; }
    | term '*' factor  { $$ = $1 * $3; }
    | term '/' factor  { 
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    ;

factor: NUMBER          { $$ = $1; }
    | '(' expr ')'     { $$ = $2; }
    ;

command: 'h' { display_instructions(); }
    | 'q' { exit(0); }
    | COMMAND_ERROR { yyerror("Invalid command"); }
    ;

%%

void yyerror(const char* msg) {
    static int error_count = 0;

    if (error_count == 0) {
        fprintf(stderr, "\033[1;31mError: %s\033[0m\n", msg);
        syntax_error = 1; // Set syntax_error flag to 1
    }

    error_count++;

    // Optionally, you can add logic here to handle or log errors as needed.
}

void display_instructions() {
    printf("User-Friendly Calculator\n");
    printf("- 'q' to quit\n");
    printf("- 'h' for help (show this message)\n");
    printf("Example expressions:\n");
    printf("\033[32mCorrect:\033[0m  10+20\n");
    printf("\033[31mIncorrect:\033[0m 10 + 20, 10+d, '10+20'\n");
    printf("===========================================================\n");
    printf("Supported operations:\n");
    printf("- Arithmetic: + - * / ^ (exponentiation) sqrt (square root) %% (modulo)\n");
    printf("Example expressions:\n");
    printf("  - Arithmetic: '2 + 3', '4 * 5', 'sqrt(9)', '2^3', '10 %% 3'\n");
    printf("This calculator was created by Ryan, Vihanga, Geemith, and Pramuditha © 2023.\n");
    printf("Enter expressions or commands:\n");
}

int main() {
    display_instructions();
    yyparse();
    return 0;
}

