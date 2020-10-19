
#pragma used+
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSR=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb WDTCR=0x21;
sfrb PLLCSR=0x29;
sfrb OCR1C=0x2b;
sfrb OCR1B=0x2c;
sfrb OCR1A=0x2d;
sfrb TCNT1=0x2e;
sfrb TCCR1B=0x2f;
sfrb TCCR1A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb SP=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_mask=0x18
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned char m1=0;
unsigned char m2=0;
unsigned char runph3=0;

unsigned int adcsum=0;
unsigned int coutt0=0;
unsigned int coutt1=0;

interrupt [2] void ext_int0_isr(void)
{
if (PINA.2==1)
coutt0=(adcsum/6.6),TCNT0=(255-coutt0); 
if (PINA.3==1)
coutt1=(adcsum/13.1),TCNT1=(255-coutt1); 
if (runph3==1)
m1=1;
if ((m1==1)&&(runph3==1))
m2=1,m1=0,runph3=0,TCNT0=(255-coutt0);   
}

interrupt [7] void timer0_ovf_isr(void)
{
runph3=1;
if (m2==1)
m2=0,PINB.1=0,delay_us(30),PINB.1=1,delay_us(15),PINB.1=0,delay_us(30),PINB.1=1;
else
PINA.2=0,delay_us(30),PINA.2=1,delay_us(15),PINA.2=0,delay_us(30),PINA.2=1;
TCNT0=0x00;
}

interrupt [6] void timer1_ovf_isr(void)
{
PINA.3=0,delay_us(30),PINA.3=1,delay_us(15),PINA.3=0,delay_us(30),PINA.3=1;
TCNT1=0x00;
}

unsigned int adc_data[0-0+1];

interrupt [12] void adc_isr(void)
{
static unsigned char input_index=0;
adc_data[input_index]=ADCW;
if (++input_index > (0-0))
input_index=0;
ADMUX=(0 | (0x00 & 0xff))+input_index;
adcsum=adc_data[0];
delay_us(10);
ADCSR|=0x40;
}

void main(void)
{
PORTA=0x00,DDRA=0x0E;

PORTB=0x00,DDRB=0x02;

TCCR0=0x04,TCNT0=0x00;

PLLCSR=0x00,TCCR1A=0x00,TCCR1B=0x0A,TCNT1=0x00,OCR1A=0x00,OCR1B=0x00,OCR1C=0x00;

GIMSK=0x40,MCUCR=0x01,GIFR=0x40;

TIMSK=0x06;

USICR=0x00;

ACSR=0x80;

ADMUX=0 | (0x00 & 0xff),ADCSR=0xCD;

#asm("sei")

while (1)
{

};
}
