#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct Condenser
{
	float Capacity;
	int Voltage;
	bool HasPolarity;
	float Price;
	unsigned int Quantity;
}Condenser;
Condenser ReadCondenserInfo();
void PrintCondenserInfo(Condenser);
void main_()
{
	Condenser condenser1 = ReadCondenserInfo();
	Condenser condenser2 = { 150, 25, true, 1.26, 1250 };
	PrintCondenserInfo(condenser2);
	
}

void PrintCondenserInfo(Condenser a)
{
	printf("%.1fuF %iV %s polarity (%u * %.3f$)\n", a.Capacity, a.Voltage, a.HasPolarity ? "Has" : "No", a.Quantity, a.Price);
}

Condenser ReadCondenserInfo()
{
	/*float Capacity;
	int Voltage;
	bool HasPolarity;
	float Price=0;
	unsigned int Quantity=0;
	char q, xxx;
	scanf_s("%f %i %c %f %u", &Capacity, &Voltage, &q, &xxx, &Price, &Quantity);
	unsigned int value = (unsigned int)xxx;
	HasPolarity = (q == 't') ? true : false;
	return Condenser{ Capacity, Voltage, HasPolarity, Price, Quantity };*/
	Condenser a;
	char q, xxx;
	scanf_s("%f %i %c %f %u", &a.Capacity, &a.Voltage, &q, &xxx, &a.Price, &a.Quantity);
	a.HasPolarity = (q == 't') ? true : false;	
	return a;
}
