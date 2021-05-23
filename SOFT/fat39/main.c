//#define ATMEL
//#define ST
#define LAMPA_MAGNITOFON
//#define LAMPA15
//#define SIMPLE_PROGRAM
#include "stm8s.h"
#include "main.h"
#include "cmd.c"
#include <iostm8s103.h> 

#define CS_ON	GPIOC->ODR&=~(1<<3);
#define CS_OFF	GPIOC->ODR|=(1<<3);
#define ST_CS_ON	GPIOB->ODR&=~(1<<5);
#define ST_CS_OFF	GPIOB->ODR|=(1<<5);
#define TX_BUFFER_SIZE	80
#define RX_BUFFER_SIZE	100

char t0_cnt0=0,t0_cnt1=0,t0_cnt2=0,t0_cnt3=0;
signed short sample_cnt;
char tx_buffer[TX_BUFFER_SIZE]={0};
signed char tx_counter;
signed char tx_wr_index,tx_rd_index;
char rx_buffer[RX_BUFFER_SIZE]={0};
signed short rx_counter;
signed short rx_wr_index,rx_rd_index;
char sample;
char but_drv_cnt=0;
char but_on_drv_cnt=0;
char mdr0,mdr1,mdr2,mdr3;
unsigned int file_lengt_in_pages,current_page,last_page,current_byte_in_buffer;
unsigned long file_lengt;
char rx_status;
char rx_data;
signed short rele_cnt;
char rx_offset;
unsigned char pwm_fade_in=0;
unsigned char rele_cnt_index=0;
const char rele_cnt_const[]={30,50,70};
char memory_manufacturer='S';
short but_block_cnt;

_Bool b100Hz, b10Hz, b5Hz, b1Hz;
_Bool play;
_Bool bOUT_FREE;
_Bool bRXIN;
_Bool rx_buffer_overflow;
_Bool bRELEASE;
_Bool bSTART;


short rele_stat_bell_cnt,rele_stat_enable_cnt;

//-----------------------------------------------
void t2_init(void){
	TIM2->PSCR = 0;
	TIM2->ARRH= 0x00;
	TIM2->ARRL= 0xff;
	TIM2->CCR1H= 0x00;	
	TIM2->CCR1L= 200;
	TIM2->CCR2H= 0x00;	
	TIM2->CCR2L= 200;
	TIM2->CCR3H= 0x00;	
	TIM2->CCR3L= 50;
	
	//TIM2->CCMR1= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
	TIM2->CCMR2= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
	TIM2->CCMR3= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
	TIM2->CCER1= /*TIM2_CCER1_CC1E | TIM2_CCER1_CC1P |*/ TIM2_CCER1_CC2E | TIM2_CCER1_CC2P; //OC1, OC2 output pins enabled
	//TIM2->CCER2= TIM2_CCER2_CC3E | TIM2_CCER2_CC3P; //OC1, OC2 output pins enabled
	TIM2->CCER2= TIM2_CCER2_CC3E /*| TIM2_CCER2_CC3P*/; //OC1, OC2 output pins enabled
	
	TIM2->CR1=(TIM2_CR1_CEN | TIM2_CR1_ARPE);	
	
}

//-----------------------------------------------
void t4_init(void){
	TIM4->PSCR = 3;
	TIM4->ARR= 158;
	TIM4->IER|= TIM4_IER_UIE;					// enable break interrupt
	
	TIM4->CR1=(TIM4_CR1_URS | TIM4_CR1_CEN | TIM4_CR1_ARPE);	
	
}

//-----------------------------------------------
void rele_drv(void)
{
if(rele_stat_bell_cnt) 
	{
	rele_stat_bell_cnt--;
	if(rele_stat_bell_cnt==0)rele_stat_enable_cnt=300;
	GPIOD->ODR|=(1<<4);
	}
else GPIOD->ODR&=~(1<<4);

if(rele_stat_enable_cnt) 
	{
	rele_stat_enable_cnt--;
	GPIOB->ODR&=~(1<<5);
	}
else GPIOB->ODR|=(1<<5);

}

//-----------------------------------------------
long delay_ms(short in)
{
long i,ii,iii;

i=((long)in)*100UL;

for(ii=0;ii<i;ii++)
	{
		iii++;
	}

}

//-----------------------------------------------
void uart_init (void){
	GPIOD->DDR|=(1<<5);
	GPIOD->CR1|=(1<<5);
	GPIOD->CR2|=(1<<5);
	//GPIOD->ODR|=(1<<5);	

	GPIOD->DDR&=~(1<<6);
	GPIOD->CR1&=~(1<<6);
	GPIOD->CR2&=~(1<<6);
	//GPIOD->ODR|=(1<<6);	
	
	UART1->CR1&=~UART1_CR1_M;					
	UART1->CR3|= (0<<4) & UART1_CR3_STOP;	
	UART1->BRR2= 0x01;//0x03;
	UART1->BRR1= 0x1a;//0x68;
	UART1->CR2|= UART1_CR2_TEN | UART3_CR2_REN | UART3_CR2_RIEN;	
}

//-----------------------------------------------
void uart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5){
	char i=0,t=0,UOB[10];
	
	
	UOB[0]=data0;
	UOB[1]=data1;
	UOB[2]=data2;
	UOB[3]=data3;
	UOB[4]=data4;
	UOB[5]=data5;
	for (i=0;i<num;i++)
		{
		t^=UOB[i];
		}    
	UOB[num]=num;
	t^=UOB[num];
	UOB[num+1]=t;
	UOB[num+2]=END;
	
	
	
	for (i=0;i<num+3;i++)
		{
		putchar(UOB[i]);
		} 

	bOUT_FREE=0;	  	
}

//-----------------------------------------------
void uart_out_adr_block (unsigned long adress,char *ptr, char len)
{
//char UOB[100]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
char temp11,t,i11;

t=0;
temp11=CMND;
t^=temp11;
putchar(temp11);

temp11=10;
t^=temp11;
putchar(temp11);

temp11=adress%256;//(*((char*)&adress));
t^=temp11;
putchar(temp11);
adress>>=8;
temp11=adress%256;//(*(((char*)&adress)+1));
t^=temp11;
putchar(temp11);
adress>>=8;
temp11=adress%256;//(*(((char*)&adress)+2));
t^=temp11;
putchar(temp11);
adress>>=8;
temp11=adress%256;//(*(((char*)&adress)+3));
t^=temp11;
putchar(temp11);


for(i11=0;i11<len;i11++)
	{
	temp11=ptr[i11];
	t^=temp11;
	putchar(temp11);
	}
	
temp11=(len+6);
t^=temp11;
putchar(temp11);

putchar(t);

putchar(0x0a);
	
bOUT_FREE=0;	   
}
//-----------------------------------------------
void uart_in_an(void) 
{

}

//-----------------------------------------------
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
///#asm("cli")
if (tx_counter || ((UART1->SR & UART1_SR_TXE)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else UART1->DR=c;

UART1->CR2|= UART1_CR2_TIEN;
///#asm("sei")
}

//-----------------------------------------------
void spi_init(void){

	GPIOA->DDR|=(1<<3);
	GPIOA->CR1|=(1<<3);
	GPIOA->CR2&=~(1<<3);
	GPIOA->ODR|=(1<<3);	


	GPIOB->DDR|=(1<<5);
	GPIOB->CR1|=(1<<5);
	GPIOB->CR2&=~(1<<5);
	GPIOB->ODR|=(1<<5);	

	GPIOC->DDR|=(1<<3);
	GPIOC->CR1|=(1<<3);
	GPIOC->CR2&=~(1<<3);
	GPIOC->ODR|=(1<<3);	
	
	GPIOC->DDR|=(1<<5);
	GPIOC->CR1|=(1<<5);
	GPIOC->CR2|=(1<<5);
	GPIOC->ODR|=(1<<5);	
	
	GPIOC->DDR|=(1<<6);
	GPIOC->CR1|=(1<<6);
	GPIOC->CR2|=(1<<6);
	GPIOC->ODR|=(1<<6);	

	GPIOC->DDR&=~(1<<7);
	GPIOC->CR1&=~(1<<7);
	GPIOC->CR2&=~(1<<7);
	GPIOC->ODR|=(1<<7);	
	
	SPI->CR1= /*SPI_CR1_LSBFIRST |*/
			SPI_CR1_SPE | 
			( (4<< 3) & SPI_CR1_BR ) |
			SPI_CR1_MSTR |
			SPI_CR1_CPOL |
			SPI_CR1_CPHA; 
			
	SPI->CR2= SPI_CR2_SSM | SPI_CR2_SSI;
	SPI->ICR= 0;	
}

//-----------------------------------------------
char spi(char in){
	char c;
	while(!((SPI->SR)&SPI_SR_TXE));
	SPI->DR=in;
	while(!((SPI->SR)&SPI_SR_RXNE));
	c=SPI->DR;	
	return c;
}


//-----------------------------------------------
void gpio_init(void){
/*	GPIOB->DDR=0xff;
	GPIOB->CR1=0xff;
	GPIOB->CR2=0;
	GPIOB->ODR=0;
	*/
	///GPIOD->DDR|=(1<<2);
	///GPIOD->CR1|=(1<<2);
	///GPIOD->CR2&=~(1<<2);
	///GPIOD->ODR&=~(1<<2);
	GPIOD->DDR|=(1<<2);
	GPIOD->CR1|=(1<<2);
	GPIOD->CR2|=(1<<2);
	GPIOD->ODR&=~(1<<2);

	GPIOD->DDR|=(1<<4);
	GPIOD->CR1|=(1<<4);
	GPIOD->CR2&=~(1<<4);

	GPIOC->DDR&=~(1<<4);
	GPIOC->CR1&=~(1<<4);
	GPIOC->CR2&=~(1<<4);
	
	GPIOB->DDR|=(1<<5);
	GPIOB->CR1|=(1<<5);
	GPIOB->CR2&=~(1<<5);
	

}




//***********************************************
//***********************************************
//***********************************************
//***********************************************
@far @interrupt void TIM4_UPD_Interrupt (void) 
{
/*if(play) 
	{
	TIM2->CCR3H= 0x00;	
	TIM2->CCR3L= sample;
	sample_cnt++;
	if(sample_cnt>=256) 
		{
		sample_cnt=0;
		}
	
	sample=buff[sample_cnt];
		
	if(sample_cnt==132)	
		{
		bBUFF_LOAD=1;
		}

	if(sample_cnt==5) 
		{
		bBUFF_READ_H=1;
    }
    	
	if(sample_cnt==150) 
		{
		bBUFF_READ_L=1;
    } 
	}

else if(!bSTART) 
	{*/
	TIM2->CCR3H= 0x00;	
	TIM2->CCR3L= 0x7f;//pwm_fade_in;
/*	}*/

	
/*	
	
#ifdef OLD_BUT	
if(((GPIOC->IDR)&(1<<4))) 
	{
	but_on_drv_cnt++;
	}
else	
	{
	bRELEASE=1;
	}
	
but_drv_cnt++;
if(but_drv_cnt>20)
	{
	but_drv_cnt=0;
	if(but_on_drv_cnt>12) 
		{
		#ifdef LAMPA_MAGNITOFON
		if(!but_block_cnt)
			{
			//bSTART=1;
				but_on_drv_cnt=0;
			}
		#endif
		}
	}
#endif	
*/

if(but_block_cnt)but_on_drv_cnt=0;
if((((GPIOC->IDR)&(1<<4))) && (but_on_drv_cnt<100)) 
	{
	but_on_drv_cnt++;
	if((but_on_drv_cnt>10)&&(bRELEASE))
		{
		bRELEASE=0;
		bSTART=1;
		if((!rele_stat_bell_cnt) && (!rele_stat_enable_cnt))	rele_stat_bell_cnt=30;
		
		}
	}
else 
	{
	but_on_drv_cnt=0;
	bRELEASE=1;
	}

if(++t0_cnt0>=125)
	{
  t0_cnt0=0;
  b100Hz=1;

	if(++t0_cnt1>=10)
		{
		t0_cnt1=0;
		b10Hz=1;
		}
		
	if(++t0_cnt2>=20)
		{
		t0_cnt2=0;
		b5Hz=1;
		}
		
	if(++t0_cnt3>=100)
		{
		t0_cnt3=0;
		b1Hz=1;
		}
	}

TIM4->SR1&=~TIM4_SR1_UIF;			// disable break interrupt
return;
}

//***********************************************
@far @interrupt void UARTTxInterrupt (void) {

	if (tx_counter){
		--tx_counter;
		UART1->DR=tx_buffer[tx_rd_index];
		if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	}
	else {
		bOUT_FREE=1;
		UART1->CR2&= ~UART1_CR2_TIEN;
	}
}

//***********************************************
@far @interrupt void UARTRxInterrupt (void) {

	//char status=0,data=0;
	
	//GPIOD->ODR^=(1<<4);
	rx_status=UART1->SR;
	rx_data=UART1->DR;
	
	if (rx_status & (UART1_SR_RXNE)){
		rx_buffer[rx_wr_index]=rx_data;
		bRXIN=1;
		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
		if (++rx_counter == RX_BUFFER_SIZE){
			rx_counter=0;
			rx_buffer_overflow=1;
		}
	}
}

//===============================================
//===============================================
//===============================================
//===============================================
main()
{
CLK->CKDIVR=0;

rele_cnt_index=0;

GPIOD->DDR&=~(1<<6);
GPIOD->CR1|=(1<<6);
GPIOD->CR2|=(1<<6);
//GPIOD->ODR&=~(1<<6);
GPIOD->DDR|=(1<<5);
GPIOD->CR1|=(1<<5);
GPIOD->CR2|=(1<<5);	
GPIOD->ODR|=(1<<5);
	
delay_ms(10);
	
if(!(GPIOD->IDR&=(1<<6))) 
	{
	rele_cnt_index=1;
	}
else	
	{
	GPIOD->ODR&=~(1<<5);
	delay_ms(10);
	if(!(GPIOD->IDR&=(1<<6))) 
		{
		rele_cnt_index=2;
		}
	}
		
gpio_init();
//delay_ms(100);
//delay_ms(100);
//delay_ms(100);
//delay_ms(100);
//delay_ms(100);
	
spi_init();
	
t4_init();
	
FLASH_DUKR=0xae;
FLASH_DUKR=0x56;
	
//GPIOD->DDR|=(1<<5);
//GPIOD->CR1=0xff;
//GPIOD->CR2=0;


//uart_init();

//ST_RDID_read();
//if(mdr0==0x20) memory_manufacturer='S';	
//else 
	//{
	//DF_mf_dev_read();
	//if(mdr0==0x1F) memory_manufacturer='A';
	//}
		
t2_init();

//ST_WREN();

enableInterrupts();	
	
while (1)
	{
			

					
			
	if(b100Hz)
		{
		b100Hz=0;
				
		if(but_block_cnt)but_block_cnt--;
				

		}  
			
	if(b10Hz)
		{
		b10Hz=0;
		
		rele_drv();
		}
			
	if(b5Hz)
		{
		b5Hz=0;
		
		//GPIOD->ODR^=(1<<4);
		//GPIOD->ODR^=(1<<4);
		}
			
	if(b1Hz)
		{
		long temp_L;
		b1Hz=0;
		
		/*if(rele_stat_bell==1)rele_stat_bell=0;
		else rele_stat_bell=1;*/
		}
	}
}