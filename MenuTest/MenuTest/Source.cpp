#include "Header.h"
MenuItem Null_Menu = { 0, 0, 0, 0, 0, { 0 } };
MenuItem* CurrentMenu;
//						LEFT			UP				RIGHT			DOWN			CMD	
MAKE_MENU(m_menuItem0,	NULL_ENTRY,		NULL_ENTRY,		m_menuItem1,	m_menuItem3,	&handler0,	"TopLeft");
MAKE_MENU(m_menuItem1, m_menuItem0,		NULL_ENTRY,		m_menuItem2,	m_menuItem4,	&handler1,	"TopMiddle");
MAKE_MENU(m_menuItem2, m_menuItem1,		NULL_ENTRY,		NULL_ENTRY,		m_menuItem5,	&handler2,	"TopRight");
MAKE_MENU(m_menuItem3,	NULL_ENTRY,		m_menuItem0,	m_menuItem4,	m_menuItem6,	&deffaultHandler,			"MiddleLeft");
MAKE_MENU(m_menuItem4,	m_menuItem3,	m_menuItem1,	m_menuItem5,	m_menuItem7,	&deffaultHandler,			"MiddleMiddle");
MAKE_MENU(m_menuItem5,	m_menuItem4,	m_menuItem2,	NULL_ENTRY,		m_menuItem8,	&deffaultHandler,			"MiddleRight");
MAKE_MENU(m_menuItem6,	NULL_ENTRY,		m_menuItem3,	m_menuItem7,	NULL_ENTRY,		&deffaultHandler,			"BottomLeft");
MAKE_MENU(m_menuItem7,	m_menuItem6,	m_menuItem4,	m_menuItem8,	NULL_ENTRY,		&deffaultHandler,			"BottomMiddle");
MAKE_MENU(m_menuItem8,	m_menuItem7,	m_menuItem5,	NULL_ENTRY,		NULL_ENTRY,		&deffaultHandler,			"BottomRight");

void handler0()
{
	printf("handler0");
}

void handler1()
{
	printf("handler1");
}

void handler2()
{
	printf("handler3");
}
void deffaultHandler()
{

}
int main()
{
	CurrentMenu = &m_menuItem0;
	while (true)
	{
		DisplayMenuItem(CurrentMenu);
		MoveMenuInDirection(GetMoveDirection());
	}
	return 0;
}

void MoveMenuInDirection(MoveDirection md)
{
	switch (md)
	{
	case Select:
		CurrentMenu->Select();
		break;
	case Left:
		if (CurrentMenu->Left != &Null_Menu)
			CurrentMenu = CurrentMenu->Left;
		break;
	case Up:
		if (CurrentMenu->Up != &Null_Menu)
			CurrentMenu = CurrentMenu->Up;
		break;
	case Down:
		if (CurrentMenu->Down != &Null_Menu)
			CurrentMenu = CurrentMenu->Down;
		break;
	case Right:
		if (CurrentMenu->Right != &Null_Menu)
			CurrentMenu = CurrentMenu->Right;
		break;
	}
}

void DisplayMenuItem(MenuItem* pItem)
{
	//system("cls");

	for (int i = 0; i < MaxMenuItemTextLength; i++)
		printf("*");
	printf("\n");
	
	int len = strlen(pItem->Text);
	printf("*");
	for (int i = 0; i < (MaxMenuItemTextLength - len) / 2 - 1; i++)
		printf(" ");
	printf("%s", pItem->Text);
	for (int i = 0; i < (MaxMenuItemTextLength - len + 1) / 2 - 1; i++)
		printf(" ");
	printf("*\n");
	
	for (int i = 0; i < MaxMenuItemTextLength; i++)
		printf("*");
}

MoveDirection GetMoveDirection()
{
	int c;
	while (true)
	{
		c = _getch();
		if (c == 0 || c == 0xE0)
		{
			c = _getch();
			switch (c)
			{
			case 75:
				return Left;
			case 72:
				return Up;
			case 77:
				return Right;
			case 80:
				return Down;
			}
		}
		else
		{
			switch (c)
			{
			case 13:
				return Select;
			}
		}
	}
}