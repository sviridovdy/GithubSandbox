/*******************************************************
This program was created by the
CodeWizardAVR V3.08 Evaluation
Automatic Program Generator
© Copyright 1998-2013 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 24.02.2014
Author  : 
Company : 
Comments: 


Chip type               : ATmega64A
Program type            : Application
AVR Core Clock frequency: 7,372800 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*******************************************************/

#include <mega64a.h>
#include <alcd.h>
#include <delay.h>
#include <math.h>
#include <stdlib.h>

#define SENSOR_UP      PINA.1
#define SENSOR_RIGHT   PINE.0
#define SENSOR_DOWN    PINE.7
#define SENSOR_LEFT    PINA.2
#define SENSOR_SELECT  PINA.3

#define SENS_IN_UP     PORTA.2
#define SENS_IN_RIGHT  PORTE.0
#define SENS_IN_DOWN   PORTE.7
#define SENS_IN_LEFT   PORTA.1
#define SENS_IN_SELECT PORTA.3

#define SENS_PIN_UP      DDRA.2
#define SENS_PIN_RIGHT   DDRE.0
#define SENS_PIN_DOWN    DDRE.7
#define SENS_PIN_LEFT    DDRA.1
#define SENS_PIN_SELECT  DDRA.3

#define KeyCount 5

#define NULL_ENTRU Null_Menu

void DefaultMenuHandler(){ }
unsigned int* Sensor_Read();
float TimeConst[KeyCount];
typedef struct MenuItemNode
    {
    struct MenuItemNode* Left;
    struct MenuItemNode* Up;
    struct MenuItemNode* Right;
    struct MenuItemNode* Down;
    void(*Select) ();
    const char Text[8];
    } MenuItem;           
    
typedef enum KeyAction
{
    None,
    MoveLeft,
    MoveUp,
    MoveRight,
    MoveDown,
    Select   
} KeyAction;

void MoveIfNotNullMenuEntry(MenuItem*);    
   
#define MAKE_MENU(Name, Left, Up, Right, Down, Select, Text)\    
        extern MenuItem Left;                         \    
        extern MenuItem Up;                           \
        extern MenuItem Right;                        \
        extern MenuItem Down;                         \
        MenuItem Name =  { (MenuItem*)&Left, (MenuItem*)&Up, (MenuItem*)&Right, (MenuItem*)&Down, Select, {Text} }          




MenuItem Null_Menu = {0, 0, 0, 0, 0, {0}};

MenuItem* CurrentMenu;

//                  Left            Up              Right           Down            Command 
MAKE_MENU(M1,       NULL_ENTRU,     NULL_ENTRU,     M1_1,           M2,             DefaultMenuHandler,      "TopLeft");
MAKE_MENU(M2,       NULL_ENTRU,     M1,             M2_1,           M3,             DefaultMenuHandler,      "TopLeft");
MAKE_MENU(M3,       NULL_ENTRU,     M2,             M3_1,           NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
// Підменю М1
MAKE_MENU(M1_1,     M1,             NULL_ENTRU,     NULL_ENTRU,     M1_2,           DefaultMenuHandler,      "TopLeft");
MAKE_MENU(M1_2,     M1,             M1_1,           NULL_ENTRU,     M1_3,           DefaultMenuHandler,      "TopLeft");
MAKE_MENU(M1_3,     M3,             M1_1,           NULL_ENTRU,     NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
// Мідменю М2
MAKE_MENU(M2_1,     M2,             NULL_ENTRU,     M2_1_1,         M2_2,           DefaultMenuHandler,      "TopLeft");
MAKE_MENU(M2_2,     M2,             M2_1,           M2_2_1,         M2_3,           DefaultMenuHandler,      "TopLeft");
MAKE_MENU(M2_3,     M2,             M2_2,           NULL_ENTRU,     NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
//Підменю М3
MAKE_MENU(M3_1,     M3,             NULL_ENTRU,     NULL_ENTRU,     M3_2,           DefaultMenuHandler,      "TopLeft");
MAKE_MENU(M3_2,     M3,             M3_1,           M3_2_1,         NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
// Підменю М2.1
MAKE_MENU(M2_1_1,   M2_1,           NULL_ENTRU,     NULL_ENTRU,     M2_1_2,         DefaultMenuHandler,      "TopLeft");
MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
//Підменю М2.2
MAKE_MENU(M2_2_1,   M2_2,           NULL_ENTRU,     NULL_ENTRU,     NULL_ENTRU,     DefaultMenuHandler,      "TopLeft");
// GПідменю М2.3
/*
MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
MAKE_MENU(M2_1_2,   M2_1,           M2_1_1,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");
*/
// Підменю М3.2
MAKE_MENU(M3_2_1,   M3_2,           NULL_ENTRU,     NULL_ENTRU,     M3_2_2,         0,      "TopLeft");
MAKE_MENU(M3_2_2,   M3_2,           M3_2_1,         NULL_ENTRU,     M3_2_3,         0,      "TopLeft");
MAKE_MENU(M3_2_3,   M3_2,           M3_2_2,         NULL_ENTRU,     NULL_ENTRU,     0,      "TopLeft");

unsigned int* SensorRead()
{
    unsigned int* Time_Value = (unsigned int*) malloc(5 * sizeof(unsigned int));
    void* portsValue[] = {&SENSOR_UP, &SENSOR_DOWN};    
    void* ports[] = {&SENS_IN_UP, &SENS_IN_DOWN};
    void* portsDirection[] = {&SENS_PIN_UP, &SENS_PIN_DOWN};
    int i, j;
    i = 0;  
    for (i = 0; i< 5; i++)
    {
        unsigned long int time, sum = 0;
        for (j = 0; j< 32; j++)
        {
            time = 0;
            *((int*)portsDirection[i]) = 1;
            ports[i] = 0;
            delay_us(100);
            *((int*)portsDirection[i]) = 0;
            while (portsValue[i] == 0)
            {
                time++;
            }
            sum += time;
            *((int*)portsDirection[i]) = 1;
        }
        Time_Value[i] = sum;
    }
    return Time_Value;         
}

unsigned int* Sensor_Read() //функція для зчитування значення часу заряду конденсатора
{
    int i, j; 
    // число, яке буде сумаю значнь часу зарядки кожного конденсатора, 
                                  //використовується в подальшому для перевірки чи не натиснута кнопка
    unsigned long int time, sum; //змінна, яка буде мати поточне значення часу заряду кожного конденсатора
    unsigned int* Time_Value = (unsigned int*) malloc(5 * sizeof(unsigned int));
    sum=0;
    j = 0;
    for (i = 0; i< 32; i++)
    {
        time = 0;
        SENS_PIN_UP = 1;
        SENS_IN_UP = 0;
        delay_us(100);
        SENS_PIN_UP = 0;
        while (SENSOR_UP == 0)
        {
            time++;
        }
        sum += time;
        SENS_PIN_UP = 1;
    }
           Time_Value[j]=sum;
           j++;
     for (i=0; i<=31; i++)
       {
         time=0;
         sum=0;
         SENS_PIN_RIGHT=1;
         SENS_IN_RIGHT=0;
         delay_us(100);
         SENS_PIN_RIGHT=0;
         while (SENSOR_RIGHT==0)
           {
           time++;
           }
         sum += time;
         SENS_PIN_RIGHT=1;    
       }
        Time_Value[j]=sum;
        j++;
     for (i=0; i<=31; i++)
       {
     time=0;
     sum=0;
     SENS_PIN_DOWN=1;
     SENS_IN_DOWN=0;
     delay_us(100);
     SENS_PIN_DOWN=0;
     while (SENSOR_DOWN==0)
      {
       time++;
      }
     sum += time;
     SENS_PIN_DOWN=1;
     }
        Time_Value[j]=sum;
        j++;
     for (i=0; i<=31; i++)
       {
     time=0;
     sum=0;
     SENS_PIN_LEFT=1;
     SENS_IN_LEFT=0;
     delay_us(100);
     SENS_PIN_LEFT=0;
     while (SENSOR_LEFT==0)
      {
       time++;
      }
     sum += time;
     SENS_PIN_LEFT=1;
    }
        Time_Value[j]=sum;
        j++;
     for (i=0; i<=31; i++)
       {
     time=0;
     sum=0;
     SENS_PIN_SELECT=1;
     SENS_IN_SELECT=0;
     delay_us(100);
     SENS_PIN_SELECT=0;
     while (SENSOR_SELECT==0)
      {
       time++;
      }
     sum += time;
     SENS_PIN_SELECT=1;
    }
            Time_Value[j]=sum;
            j++;
         return Time_Value;         
}

KeyAction Key_Press()     // Функція для перевірки чи натиснута кнопка, повертає натиснуту кнопку
{
    unsigned int* currentValue = Sensor_Read();
    int pressedKeyCount = 0;   
    int keyCoeffs[] = {2,2,2,2,2};
    int pressedKeyIndex;
    int i;
    for (i = 0; i < 5; i++)
    {
        if (currentValue[i] >= keyCoeffs[i]*TimeConst[i])
        {
            pressedKeyIndex = i;
            pressedKeyCount++;
        }
    }
    
    // Тут може бути програма для виконання спеціальний програм, виклик яких здійснюється одночасним 
    // натисканням кількох кномпок на певний час
          
    if(pressedKeyCount > 1) return None;   //якщо натиснуто більше як 1 кнопка, тоді нічого не робити
    switch(pressedKeyIndex)
    {
        case 0: return MoveLeft;
        case 1: return MoveUp;
        case 2: return MoveRight;
        case 3: return MoveDown;
        case 4: return Select;
    }              
}

void Sensor_Calibration() // Функція для калібрування сенсорів
{
    unsigned int* currentValue = Sensor_Read();            
    int j=0;
    for (j = 0; j < KeyCount; j++)
    {
        TimeConst[j]=floor((currentValue[j] >> 5) + 0.5); 
    }       
}       

void MoveMenu(KeyAction action)
{
    switch(action)
    {
        case MoveLeft:                         
        MoveIfNotNullMenuEntry(CurrentMenu->Left);            
        break;
        case MoveUp:
        MoveIfNotNullMenuEntry(CurrentMenu->Up);
        break;
        case MoveRight:
        MoveIfNotNullMenuEntry(CurrentMenu->Right);
        break;
        case MoveDown:
        MoveIfNotNullMenuEntry(CurrentMenu->Down);
        break;         
    }
}

void MoveIfNotNullMenuEntry(MenuItem* menu)
{
    if(menu != &NULL_ENTRU)
        CurrentMenu = menu;
}
        
void LCD_MENU_OUT(char* text)   //функція для виводу інформації на дисплей
{
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts(text);
} 

interrupt [TIM3_OVF] void timer3_ovf_isr(void)// Timer3 overflow interrupt service routine
{


}

interrupt [TIM3_COMPC] void timer3_compc_isr(void)// Timer3 output compare C interrupt service routine
{
    KeyAction action = Key_Press();
    switch(action)
    {
        case None: return;
        case Select: 
        {
            CurrentMenu->Select();
            return;
        }          
        default:
        {
            MoveMenu(action);
            LCD_MENU_OUT(CurrentMenu->Text);            
        }
    }
}

void main(void)
{

DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

DDRE=(1<<DDE7) | (1<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (1<<DDE1) | (1<<DDE0);
PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);

DDRF=(1<<DDF7) | (1<<DDF6) | (1<<DDF5) | (1<<DDF4) | (1<<DDF3) | (1<<DDF2) | (1<<DDF1) | (1<<DDF0);
PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);

DDRG=(1<<DDG4) | (1<<DDG3) | (1<<DDG2) | (1<<DDG1) | (1<<DDG0);
PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0<<AS0;
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 7372,800 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// OC1C output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,13563 us
// Output Pulse(s):
// OC1A Period: 0,13563 us// OC1B Period: 0,13563 us// OC1C Period: 0,13563 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<COM1C1) | (0<<COM1C0) | (1<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: 7,200 kHz
// Mode: Fast PWM top=ICR3
// OC3A output: Disconnected
// OC3B output: Disconnected
// OC3C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,13889 ms
// Timer3 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: On
TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (1<<WGM31) | (0<<WGM30);
TCCR3B=(0<<ICNC3) | (0<<ICES3) | (1<<WGM33) | (1<<WGM32) | (1<<CS32) | (0<<CS31) | (1<<CS30);
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (1<<TOIE3) | (1<<OCIE3C) | (0<<OCIE1C);


EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);


UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);


UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);

ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);


ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);




// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 5
// RD - PORTD Bit 1
// EN - PORTD Bit 4
// D4 - PORTA Bit 6
// D5 - PORTA Bit 3
// D6 - PORTA Bit 5
// D7 - PORTA Bit 4
// Characters/line: 8
lcd_init(8);


//  автоматична настройка кожного сенсора
   delay_ms(1);    
   Sensor_Calibration();
   
#asm("sei")

while (1)
      {
      // lcd_init() – инициализация дисплея 
    //  lcd_clear() – очистка экрана
    //  lcd_gotoxy(0,0) – перемещение по координатам х,у, где х-столбец, у-строка
    ///  lcd_putsf, lcd_putchar – вывод текста
    ///  lcd_puts – вывод текста с переменными
      }
}
