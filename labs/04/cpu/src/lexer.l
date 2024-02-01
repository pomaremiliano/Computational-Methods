%{
#include "y.tab.h"
%}

%%
digit 		 	[0-9]
number 		 	{digit}+
move 		 	"move"
turn 		 	"turn"
ahead 		 	"ahead"
degrees 	 	"degrees"
please 		 	"please"
robot 		 	"robot"
and 		 	"and"
then 		 	"then"
blocks 		 	"blocks"
comma 		 	","
[ \t\n] 	 	{ /* Ignore whitespace */ }
%%

%%
{please} {return PLEASE;}
{robot} {return ROBOT;}
{move} {return MOVE;}
{turn} {return TURN;}
{ahead} {return AHEAD;}
{degrees} {return DEGREES;}
{and} {return AND;}	
{then} {return THEN;}
{blocks} {return BLOCKS;}
{number} {yylval = atoi(yytext); return NUMBER;}
{comma} {return COMMA;}
. {printf("Unrecognized character: %s\n", yytext);}
%%

