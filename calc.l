%{
#include "calc.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

extern double result;

%}

%%

[ \t]+              /* skip whitespace */
[0-9]+(\.[0-9]*)?   { yylval = atof(yytext); return NUMBER; }
"sqrt"              { yylval = 0.0; return SQRT; }
"^"                 { return EXPONENT; } // Recognize '^' as the EXPONENT token
"%"                 { return MODULO; } // Recognize '%' as the MODULO token
\n                  { return EOL; }
.                   { return yytext[0]; }

%%

int yywrap(void) {
    return 1;
}

