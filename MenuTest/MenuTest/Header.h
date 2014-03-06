#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#define MaxMenuItemTextLength 16

#define NULL_ENTRY Null_Menu

#define MAKE_MENU(Name, Left, Up, Right, Down, Select, Text)	\
	extern MenuItem Left;										\
	extern MenuItem Up;											\
	extern MenuItem Right;										\
	extern MenuItem Down;										\
	MenuItem Name = { (MenuItem*)&Left, (MenuItem*)&Up, (MenuItem*)&Right, (MenuItem*)&Down, Select, { Text } }

typedef struct MenuItem
{
	MenuItem* Left;
	MenuItem* Up;
	MenuItem* Right;
	MenuItem* Down;
	void(*Select) ();
	const char Text[MaxMenuItemTextLength];
} MenuItem;

typedef enum MoveDirection
{
	Left,
	Up,
	Down,
	Right,
	Select
} MoveDirection;

MoveDirection GetMoveDirection();
void MoveMenuInDirection(MoveDirection md);
void DisplayMenuItem(MenuItem* pItem);

void handler0();
void handler1();
void handler2();
void deffaultHandler();