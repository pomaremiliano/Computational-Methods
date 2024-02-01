%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(char *);
int yylex(void);
int yyin;
int yyparse(void);
extern FILE *yyin;

#define GRID_SIZE 10

int current_x = 0, current_y = 0; // Robot's position
int direction = 0; // 0: North, 1: East, 2: South, 3: West

%}

%token ROBOT PLEASE MOVE BLOCKS AHEAD AND THEN TURN NUMBER ANGLE

%%
commands:
	| commands command
	;

command:
	ROBOT PLEASE action
	;

action:
	move_action
	| move_action AND THEN turn_action
	;

move_action:
	MOVE NUMBER BLOCKS AHEAD
	{
		move_robot($2);
	}
	;

turn_action:
	TURN ANGLE
	{
		turn_robot($2);
	}
	;

%%

void yyerror(char *s) {
	fprintf(stderr, "Error: %s\n", s);
}

void move_robot(int blocks) {
    int i;
    if (current_x < 0 || current_x >= GRID_SIZE || current_y < 0 || current_y >= GRID_SIZE) {
        printf("Robot is out of the grid\n");
        exit(1);
    }
    for (i = 0; i < blocks; i++) {
        switch (direction) {
            case 0: // North
                current_y++;
                break;
            case 1: // East
                current_x++;
                break;
            case 2: // South
                current_y--;
                break;
            case 3: // West
                current_x--;
                break;
        }
    }
}

void turn_robot(int angle) {
    direction = (direction + angle) % 4;
    if (direction < 0) {
        direction += 4;
    }
}

int main(void) {
    FILE *f = fopen("instruction.esm", "r");
    if (!f) {
        fprintf(stderr, "Error: cannot open input file\n");
        return 1;
    }
    yyin = f;
    yyparse();
    printf("Robot's position: (%d, %d)\n", current_x, current_y);
    return 0;
}
