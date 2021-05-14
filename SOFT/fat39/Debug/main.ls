   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32.1 - 30 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
2173                     	bsct
2174  0000               _t0_cnt0:
2175  0000 00            	dc.b	0
2176  0001               _t0_cnt1:
2177  0001 00            	dc.b	0
2178  0002               _t0_cnt2:
2179  0002 00            	dc.b	0
2180  0003               _t0_cnt3:
2181  0003 00            	dc.b	0
2182  0004               _tx_buffer:
2183  0004 00            	dc.b	0
2184  0005 000000000000  	ds.b	79
2185  0054               _rx_buffer:
2186  0054 00            	dc.b	0
2187  0055 000000000000  	ds.b	99
2188  00b8               _but_drv_cnt:
2189  00b8 00            	dc.b	0
2190  00b9               _but_on_drv_cnt:
2191  00b9 00            	dc.b	0
2192  00ba               _pwm_fade_in:
2193  00ba 00            	dc.b	0
2194  00bb               _rele_cnt_index:
2195  00bb 00            	dc.b	0
2196                     .const:	section	.text
2197  0000               _rele_cnt_const:
2198  0000 1e            	dc.b	30
2199  0001 32            	dc.b	50
2200  0002 46            	dc.b	70
2201                     	bsct
2202  00bc               _memory_manufacturer:
2203  00bc 53            	dc.b	83
2232                     ; 54 void t2_init(void){
2234                     	switch	.text
2235  0000               _t2_init:
2239                     ; 55 	TIM2->PSCR = 0;
2241  0000 725f530e      	clr	21262
2242                     ; 56 	TIM2->ARRH= 0x00;
2244  0004 725f530f      	clr	21263
2245                     ; 57 	TIM2->ARRL= 0xff;
2247  0008 35ff5310      	mov	21264,#255
2248                     ; 58 	TIM2->CCR1H= 0x00;	
2250  000c 725f5311      	clr	21265
2251                     ; 59 	TIM2->CCR1L= 200;
2253  0010 35c85312      	mov	21266,#200
2254                     ; 60 	TIM2->CCR2H= 0x00;	
2256  0014 725f5313      	clr	21267
2257                     ; 61 	TIM2->CCR2L= 200;
2259  0018 35c85314      	mov	21268,#200
2260                     ; 62 	TIM2->CCR3H= 0x00;	
2262  001c 725f5315      	clr	21269
2263                     ; 63 	TIM2->CCR3L= 50;
2265  0020 35325316      	mov	21270,#50
2266                     ; 66 	TIM2->CCMR2= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
2268  0024 35685308      	mov	21256,#104
2269                     ; 67 	TIM2->CCMR3= ((6<<4) & TIM2_CCMR_OCM) | TIM2_CCMR_OCxPE; //OC2 toggle mode, prelouded
2271  0028 35685309      	mov	21257,#104
2272                     ; 68 	TIM2->CCER1= /*TIM2_CCER1_CC1E | TIM2_CCER1_CC1P |*/ TIM2_CCER1_CC2E | TIM2_CCER1_CC2P; //OC1, OC2 output pins enabled
2274  002c 3530530a      	mov	21258,#48
2275                     ; 70 	TIM2->CCER2= TIM2_CCER2_CC3E /*| TIM2_CCER2_CC3P*/; //OC1, OC2 output pins enabled
2277  0030 3501530b      	mov	21259,#1
2278                     ; 72 	TIM2->CR1=(TIM2_CR1_CEN | TIM2_CR1_ARPE);	
2280  0034 35815300      	mov	21248,#129
2281                     ; 74 }
2284  0038 81            	ret
2307                     ; 77 void t4_init(void){
2308                     	switch	.text
2309  0039               _t4_init:
2313                     ; 78 	TIM4->PSCR = 3;
2315  0039 35035347      	mov	21319,#3
2316                     ; 79 	TIM4->ARR= 158;
2318  003d 359e5348      	mov	21320,#158
2319                     ; 80 	TIM4->IER|= TIM4_IER_UIE;					// enable break interrupt
2321  0041 72105343      	bset	21315,#0
2322                     ; 82 	TIM4->CR1=(TIM4_CR1_URS | TIM4_CR1_CEN | TIM4_CR1_ARPE);	
2324  0045 35855340      	mov	21312,#133
2325                     ; 84 }
2328  0049 81            	ret
2353                     ; 87 void rele_drv(void)
2353                     ; 88 {
2354                     	switch	.text
2355  004a               _rele_drv:
2359                     ; 89 if(rele_stat_bell_cnt) 
2361  004a be02          	ldw	x,_rele_stat_bell_cnt
2362  004c 270d          	jreq	L1641
2363                     ; 91 	rele_stat_bell_cnt--;
2365  004e be02          	ldw	x,_rele_stat_bell_cnt
2366  0050 1d0001        	subw	x,#1
2367  0053 bf02          	ldw	_rele_stat_bell_cnt,x
2368                     ; 92 	GPIOD->ODR|=(1<<4);
2370  0055 7218500f      	bset	20495,#4
2372  0059 2004          	jra	L3641
2373  005b               L1641:
2374                     ; 94 else GPIOD->ODR&=~(1<<4);
2376  005b 7219500f      	bres	20495,#4
2377  005f               L3641:
2378                     ; 96 if(rele_stat_enable_cnt) 
2380  005f be00          	ldw	x,_rele_stat_enable_cnt
2381  0061 270d          	jreq	L5641
2382                     ; 98 	rele_stat_enable_cnt--;
2384  0063 be00          	ldw	x,_rele_stat_enable_cnt
2385  0065 1d0001        	subw	x,#1
2386  0068 bf00          	ldw	_rele_stat_enable_cnt,x
2387                     ; 99 	GPIOD->ODR|=(1<<5);
2389  006a 721a500f      	bset	20495,#5
2391  006e 2004          	jra	L7641
2392  0070               L5641:
2393                     ; 101 else GPIOD->ODR&=~(1<<5);
2395  0070 721b500f      	bres	20495,#5
2396  0074               L7641:
2397                     ; 103 }
2400  0074 81            	ret
2461                     ; 106 long delay_ms(short in)
2461                     ; 107 {
2462                     	switch	.text
2463  0075               _delay_ms:
2465  0075 520c          	subw	sp,#12
2466       0000000c      OFST:	set	12
2469                     ; 110 i=((long)in)*100UL;
2471  0077 90ae0064      	ldw	y,#100
2472  007b cd0000        	call	c_vmul
2474  007e 96            	ldw	x,sp
2475  007f 1c0005        	addw	x,#OFST-7
2476  0082 cd0000        	call	c_rtol
2478                     ; 112 for(ii=0;ii<i;ii++)
2480  0085 ae0000        	ldw	x,#0
2481  0088 1f0b          	ldw	(OFST-1,sp),x
2482  008a ae0000        	ldw	x,#0
2483  008d 1f09          	ldw	(OFST-3,sp),x
2485  008f 2012          	jra	L7251
2486  0091               L3251:
2487                     ; 114 		iii++;
2489  0091 96            	ldw	x,sp
2490  0092 1c0001        	addw	x,#OFST-11
2491  0095 a601          	ld	a,#1
2492  0097 cd0000        	call	c_lgadc
2494                     ; 112 for(ii=0;ii<i;ii++)
2496  009a 96            	ldw	x,sp
2497  009b 1c0009        	addw	x,#OFST-3
2498  009e a601          	ld	a,#1
2499  00a0 cd0000        	call	c_lgadc
2501  00a3               L7251:
2504  00a3 9c            	rvf
2505  00a4 96            	ldw	x,sp
2506  00a5 1c0009        	addw	x,#OFST-3
2507  00a8 cd0000        	call	c_ltor
2509  00ab 96            	ldw	x,sp
2510  00ac 1c0005        	addw	x,#OFST-7
2511  00af cd0000        	call	c_lcmp
2513  00b2 2fdd          	jrslt	L3251
2514                     ; 117 }
2517  00b4 5b0c          	addw	sp,#12
2518  00b6 81            	ret
2541                     ; 120 void uart_init (void){
2542                     	switch	.text
2543  00b7               _uart_init:
2547                     ; 121 	GPIOD->DDR|=(1<<5);
2549  00b7 721a5011      	bset	20497,#5
2550                     ; 122 	GPIOD->CR1|=(1<<5);
2552  00bb 721a5012      	bset	20498,#5
2553                     ; 123 	GPIOD->CR2|=(1<<5);
2555  00bf 721a5013      	bset	20499,#5
2556                     ; 126 	GPIOD->DDR&=~(1<<6);
2558  00c3 721d5011      	bres	20497,#6
2559                     ; 127 	GPIOD->CR1&=~(1<<6);
2561  00c7 721d5012      	bres	20498,#6
2562                     ; 128 	GPIOD->CR2&=~(1<<6);
2564  00cb 721d5013      	bres	20499,#6
2565                     ; 131 	UART1->CR1&=~UART1_CR1_M;					
2567  00cf 72195234      	bres	21044,#4
2568                     ; 132 	UART1->CR3|= (0<<4) & UART1_CR3_STOP;	
2570  00d3 c65236        	ld	a,21046
2571                     ; 133 	UART1->BRR2= 0x01;//0x03;
2573  00d6 35015233      	mov	21043,#1
2574                     ; 134 	UART1->BRR1= 0x1a;//0x68;
2576  00da 351a5232      	mov	21042,#26
2577                     ; 135 	UART1->CR2|= UART1_CR2_TEN | UART3_CR2_REN | UART3_CR2_RIEN;	
2579  00de c65235        	ld	a,21045
2580  00e1 aa2c          	or	a,#44
2581  00e3 c75235        	ld	21045,a
2582                     ; 136 }
2585  00e6 81            	ret
2703                     ; 139 void uart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5){
2704                     	switch	.text
2705  00e7               _uart_out:
2707  00e7 89            	pushw	x
2708  00e8 520c          	subw	sp,#12
2709       0000000c      OFST:	set	12
2712                     ; 140 	char i=0,t=0,UOB[10];
2716  00ea 0f01          	clr	(OFST-11,sp)
2717                     ; 143 	UOB[0]=data0;
2719  00ec 9f            	ld	a,xl
2720  00ed 6b02          	ld	(OFST-10,sp),a
2721                     ; 144 	UOB[1]=data1;
2723  00ef 7b11          	ld	a,(OFST+5,sp)
2724  00f1 6b03          	ld	(OFST-9,sp),a
2725                     ; 145 	UOB[2]=data2;
2727  00f3 7b12          	ld	a,(OFST+6,sp)
2728  00f5 6b04          	ld	(OFST-8,sp),a
2729                     ; 146 	UOB[3]=data3;
2731  00f7 7b13          	ld	a,(OFST+7,sp)
2732  00f9 6b05          	ld	(OFST-7,sp),a
2733                     ; 147 	UOB[4]=data4;
2735  00fb 7b14          	ld	a,(OFST+8,sp)
2736  00fd 6b06          	ld	(OFST-6,sp),a
2737                     ; 148 	UOB[5]=data5;
2739  00ff 7b15          	ld	a,(OFST+9,sp)
2740  0101 6b07          	ld	(OFST-5,sp),a
2741                     ; 149 	for (i=0;i<num;i++)
2743  0103 0f0c          	clr	(OFST+0,sp)
2745  0105 2013          	jra	L1361
2746  0107               L5261:
2747                     ; 151 		t^=UOB[i];
2749  0107 96            	ldw	x,sp
2750  0108 1c0002        	addw	x,#OFST-10
2751  010b 9f            	ld	a,xl
2752  010c 5e            	swapw	x
2753  010d 1b0c          	add	a,(OFST+0,sp)
2754  010f 2401          	jrnc	L02
2755  0111 5c            	incw	x
2756  0112               L02:
2757  0112 02            	rlwa	x,a
2758  0113 7b01          	ld	a,(OFST-11,sp)
2759  0115 f8            	xor	a,	(x)
2760  0116 6b01          	ld	(OFST-11,sp),a
2761                     ; 149 	for (i=0;i<num;i++)
2763  0118 0c0c          	inc	(OFST+0,sp)
2764  011a               L1361:
2767  011a 7b0c          	ld	a,(OFST+0,sp)
2768  011c 110d          	cp	a,(OFST+1,sp)
2769  011e 25e7          	jrult	L5261
2770                     ; 153 	UOB[num]=num;
2772  0120 96            	ldw	x,sp
2773  0121 1c0002        	addw	x,#OFST-10
2774  0124 9f            	ld	a,xl
2775  0125 5e            	swapw	x
2776  0126 1b0d          	add	a,(OFST+1,sp)
2777  0128 2401          	jrnc	L22
2778  012a 5c            	incw	x
2779  012b               L22:
2780  012b 02            	rlwa	x,a
2781  012c 7b0d          	ld	a,(OFST+1,sp)
2782  012e f7            	ld	(x),a
2783                     ; 154 	t^=UOB[num];
2785  012f 96            	ldw	x,sp
2786  0130 1c0002        	addw	x,#OFST-10
2787  0133 9f            	ld	a,xl
2788  0134 5e            	swapw	x
2789  0135 1b0d          	add	a,(OFST+1,sp)
2790  0137 2401          	jrnc	L42
2791  0139 5c            	incw	x
2792  013a               L42:
2793  013a 02            	rlwa	x,a
2794  013b 7b01          	ld	a,(OFST-11,sp)
2795  013d f8            	xor	a,	(x)
2796  013e 6b01          	ld	(OFST-11,sp),a
2797                     ; 155 	UOB[num+1]=t;
2799  0140 96            	ldw	x,sp
2800  0141 1c0003        	addw	x,#OFST-9
2801  0144 9f            	ld	a,xl
2802  0145 5e            	swapw	x
2803  0146 1b0d          	add	a,(OFST+1,sp)
2804  0148 2401          	jrnc	L62
2805  014a 5c            	incw	x
2806  014b               L62:
2807  014b 02            	rlwa	x,a
2808  014c 7b01          	ld	a,(OFST-11,sp)
2809  014e f7            	ld	(x),a
2810                     ; 156 	UOB[num+2]=END;
2812  014f 96            	ldw	x,sp
2813  0150 1c0004        	addw	x,#OFST-8
2814  0153 9f            	ld	a,xl
2815  0154 5e            	swapw	x
2816  0155 1b0d          	add	a,(OFST+1,sp)
2817  0157 2401          	jrnc	L03
2818  0159 5c            	incw	x
2819  015a               L03:
2820  015a 02            	rlwa	x,a
2821  015b a60a          	ld	a,#10
2822  015d f7            	ld	(x),a
2823                     ; 160 	for (i=0;i<num+3;i++)
2825  015e 0f0c          	clr	(OFST+0,sp)
2827  0160 2012          	jra	L1461
2828  0162               L5361:
2829                     ; 162 		putchar(UOB[i]);
2831  0162 96            	ldw	x,sp
2832  0163 1c0002        	addw	x,#OFST-10
2833  0166 9f            	ld	a,xl
2834  0167 5e            	swapw	x
2835  0168 1b0c          	add	a,(OFST+0,sp)
2836  016a 2401          	jrnc	L23
2837  016c 5c            	incw	x
2838  016d               L23:
2839  016d 02            	rlwa	x,a
2840  016e f6            	ld	a,(x)
2841  016f cd024b        	call	_putchar
2843                     ; 160 	for (i=0;i<num+3;i++)
2845  0172 0c0c          	inc	(OFST+0,sp)
2846  0174               L1461:
2849  0174 9c            	rvf
2850  0175 7b0c          	ld	a,(OFST+0,sp)
2851  0177 5f            	clrw	x
2852  0178 97            	ld	xl,a
2853  0179 7b0d          	ld	a,(OFST+1,sp)
2854  017b 905f          	clrw	y
2855  017d 9097          	ld	yl,a
2856  017f 72a90003      	addw	y,#3
2857  0183 bf00          	ldw	c_x,x
2858  0185 90b300        	cpw	y,c_x
2859  0188 2cd8          	jrsgt	L5361
2860                     ; 165 	bOUT_FREE=0;	  	
2862  018a 72110004      	bres	_bOUT_FREE
2863                     ; 166 }
2866  018e 5b0e          	addw	sp,#14
2867  0190 81            	ret
2949                     ; 169 void uart_out_adr_block (unsigned long adress,char *ptr, char len)
2949                     ; 170 {
2950                     	switch	.text
2951  0191               _uart_out_adr_block:
2953  0191 5203          	subw	sp,#3
2954       00000003      OFST:	set	3
2957                     ; 174 t=0;
2959  0193 0f02          	clr	(OFST-1,sp)
2960                     ; 175 temp11=CMND;
2962                     ; 176 t^=temp11;
2964  0195 7b02          	ld	a,(OFST-1,sp)
2965  0197 a816          	xor	a,	#22
2966  0199 6b02          	ld	(OFST-1,sp),a
2967                     ; 177 putchar(temp11);
2969  019b a616          	ld	a,#22
2970  019d cd024b        	call	_putchar
2972                     ; 179 temp11=10;
2974                     ; 180 t^=temp11;
2976  01a0 7b02          	ld	a,(OFST-1,sp)
2977  01a2 a80a          	xor	a,	#10
2978  01a4 6b02          	ld	(OFST-1,sp),a
2979                     ; 181 putchar(temp11);
2981  01a6 a60a          	ld	a,#10
2982  01a8 cd024b        	call	_putchar
2984                     ; 183 temp11=adress%256;//(*((char*)&adress));
2986  01ab 7b09          	ld	a,(OFST+6,sp)
2987  01ad a4ff          	and	a,#255
2988  01af 6b03          	ld	(OFST+0,sp),a
2989                     ; 184 t^=temp11;
2991  01b1 7b02          	ld	a,(OFST-1,sp)
2992  01b3 1803          	xor	a,	(OFST+0,sp)
2993  01b5 6b02          	ld	(OFST-1,sp),a
2994                     ; 185 putchar(temp11);
2996  01b7 7b03          	ld	a,(OFST+0,sp)
2997  01b9 cd024b        	call	_putchar
2999                     ; 186 adress>>=8;
3001  01bc 96            	ldw	x,sp
3002  01bd 1c0006        	addw	x,#OFST+3
3003  01c0 a608          	ld	a,#8
3004  01c2 cd0000        	call	c_lgursh
3006                     ; 187 temp11=adress%256;//(*(((char*)&adress)+1));
3008  01c5 7b09          	ld	a,(OFST+6,sp)
3009  01c7 a4ff          	and	a,#255
3010  01c9 6b03          	ld	(OFST+0,sp),a
3011                     ; 188 t^=temp11;
3013  01cb 7b02          	ld	a,(OFST-1,sp)
3014  01cd 1803          	xor	a,	(OFST+0,sp)
3015  01cf 6b02          	ld	(OFST-1,sp),a
3016                     ; 189 putchar(temp11);
3018  01d1 7b03          	ld	a,(OFST+0,sp)
3019  01d3 ad76          	call	_putchar
3021                     ; 190 adress>>=8;
3023  01d5 96            	ldw	x,sp
3024  01d6 1c0006        	addw	x,#OFST+3
3025  01d9 a608          	ld	a,#8
3026  01db cd0000        	call	c_lgursh
3028                     ; 191 temp11=adress%256;//(*(((char*)&adress)+2));
3030  01de 7b09          	ld	a,(OFST+6,sp)
3031  01e0 a4ff          	and	a,#255
3032  01e2 6b03          	ld	(OFST+0,sp),a
3033                     ; 192 t^=temp11;
3035  01e4 7b02          	ld	a,(OFST-1,sp)
3036  01e6 1803          	xor	a,	(OFST+0,sp)
3037  01e8 6b02          	ld	(OFST-1,sp),a
3038                     ; 193 putchar(temp11);
3040  01ea 7b03          	ld	a,(OFST+0,sp)
3041  01ec ad5d          	call	_putchar
3043                     ; 194 adress>>=8;
3045  01ee 96            	ldw	x,sp
3046  01ef 1c0006        	addw	x,#OFST+3
3047  01f2 a608          	ld	a,#8
3048  01f4 cd0000        	call	c_lgursh
3050                     ; 195 temp11=adress%256;//(*(((char*)&adress)+3));
3052  01f7 7b09          	ld	a,(OFST+6,sp)
3053  01f9 a4ff          	and	a,#255
3054  01fb 6b03          	ld	(OFST+0,sp),a
3055                     ; 196 t^=temp11;
3057  01fd 7b02          	ld	a,(OFST-1,sp)
3058  01ff 1803          	xor	a,	(OFST+0,sp)
3059  0201 6b02          	ld	(OFST-1,sp),a
3060                     ; 197 putchar(temp11);
3062  0203 7b03          	ld	a,(OFST+0,sp)
3063  0205 ad44          	call	_putchar
3065                     ; 200 for(i11=0;i11<len;i11++)
3067  0207 0f01          	clr	(OFST-2,sp)
3069  0209 201a          	jra	L3171
3070  020b               L7071:
3071                     ; 202 	temp11=ptr[i11];
3073  020b 7b0a          	ld	a,(OFST+7,sp)
3074  020d 97            	ld	xl,a
3075  020e 7b0b          	ld	a,(OFST+8,sp)
3076  0210 1b01          	add	a,(OFST-2,sp)
3077  0212 2401          	jrnc	L63
3078  0214 5c            	incw	x
3079  0215               L63:
3080  0215 02            	rlwa	x,a
3081  0216 f6            	ld	a,(x)
3082  0217 6b03          	ld	(OFST+0,sp),a
3083                     ; 203 	t^=temp11;
3085  0219 7b02          	ld	a,(OFST-1,sp)
3086  021b 1803          	xor	a,	(OFST+0,sp)
3087  021d 6b02          	ld	(OFST-1,sp),a
3088                     ; 204 	putchar(temp11);
3090  021f 7b03          	ld	a,(OFST+0,sp)
3091  0221 ad28          	call	_putchar
3093                     ; 200 for(i11=0;i11<len;i11++)
3095  0223 0c01          	inc	(OFST-2,sp)
3096  0225               L3171:
3099  0225 7b01          	ld	a,(OFST-2,sp)
3100  0227 110c          	cp	a,(OFST+9,sp)
3101  0229 25e0          	jrult	L7071
3102                     ; 207 temp11=(len+6);
3104  022b 7b0c          	ld	a,(OFST+9,sp)
3105  022d ab06          	add	a,#6
3106  022f 6b03          	ld	(OFST+0,sp),a
3107                     ; 208 t^=temp11;
3109  0231 7b02          	ld	a,(OFST-1,sp)
3110  0233 1803          	xor	a,	(OFST+0,sp)
3111  0235 6b02          	ld	(OFST-1,sp),a
3112                     ; 209 putchar(temp11);
3114  0237 7b03          	ld	a,(OFST+0,sp)
3115  0239 ad10          	call	_putchar
3117                     ; 211 putchar(t);
3119  023b 7b02          	ld	a,(OFST-1,sp)
3120  023d ad0c          	call	_putchar
3122                     ; 213 putchar(0x0a);
3124  023f a60a          	ld	a,#10
3125  0241 ad08          	call	_putchar
3127                     ; 215 bOUT_FREE=0;	   
3129  0243 72110004      	bres	_bOUT_FREE
3130                     ; 216 }
3133  0247 5b03          	addw	sp,#3
3134  0249 81            	ret
3157                     ; 218 void uart_in_an(void) 
3157                     ; 219 {
3158                     	switch	.text
3159  024a               _uart_in_an:
3163                     ; 221 }
3166  024a 81            	ret
3203                     ; 224 void putchar(char c)
3203                     ; 225 {
3204                     	switch	.text
3205  024b               _putchar:
3207  024b 88            	push	a
3208       00000000      OFST:	set	0
3211  024c               L7471:
3212                     ; 226 while (tx_counter == TX_BUFFER_SIZE);
3214  024c b624          	ld	a,_tx_counter
3215  024e a150          	cp	a,#80
3216  0250 27fa          	jreq	L7471
3217                     ; 228 if (tx_counter || ((UART1->SR & UART1_SR_TXE)==0))
3219  0252 3d24          	tnz	_tx_counter
3220  0254 2607          	jrne	L5571
3222  0256 c65230        	ld	a,21040
3223  0259 a580          	bcp	a,#128
3224  025b 261d          	jrne	L3571
3225  025d               L5571:
3226                     ; 230    tx_buffer[tx_wr_index]=c;
3228  025d 5f            	clrw	x
3229  025e b623          	ld	a,_tx_wr_index
3230  0260 2a01          	jrpl	L44
3231  0262 53            	cplw	x
3232  0263               L44:
3233  0263 97            	ld	xl,a
3234  0264 7b01          	ld	a,(OFST+1,sp)
3235  0266 e704          	ld	(_tx_buffer,x),a
3236                     ; 231    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
3238  0268 3c23          	inc	_tx_wr_index
3239  026a b623          	ld	a,_tx_wr_index
3240  026c a150          	cp	a,#80
3241  026e 2602          	jrne	L7571
3244  0270 3f23          	clr	_tx_wr_index
3245  0272               L7571:
3246                     ; 232    ++tx_counter;
3248  0272 3c24          	inc	_tx_counter
3250  0274               L1671:
3251                     ; 236 UART1->CR2|= UART1_CR2_TIEN;
3253  0274 721e5235      	bset	21045,#7
3254                     ; 238 }
3257  0278 84            	pop	a
3258  0279 81            	ret
3259  027a               L3571:
3260                     ; 234 else UART1->DR=c;
3262  027a 7b01          	ld	a,(OFST+1,sp)
3263  027c c75231        	ld	21041,a
3264  027f 20f3          	jra	L1671
3287                     ; 241 void spi_init(void){
3288                     	switch	.text
3289  0281               _spi_init:
3293                     ; 243 	GPIOA->DDR|=(1<<3);
3295  0281 72165002      	bset	20482,#3
3296                     ; 244 	GPIOA->CR1|=(1<<3);
3298  0285 72165003      	bset	20483,#3
3299                     ; 245 	GPIOA->CR2&=~(1<<3);
3301  0289 72175004      	bres	20484,#3
3302                     ; 246 	GPIOA->ODR|=(1<<3);	
3304  028d 72165000      	bset	20480,#3
3305                     ; 249 	GPIOB->DDR|=(1<<5);
3307  0291 721a5007      	bset	20487,#5
3308                     ; 250 	GPIOB->CR1|=(1<<5);
3310  0295 721a5008      	bset	20488,#5
3311                     ; 251 	GPIOB->CR2&=~(1<<5);
3313  0299 721b5009      	bres	20489,#5
3314                     ; 252 	GPIOB->ODR|=(1<<5);	
3316  029d 721a5005      	bset	20485,#5
3317                     ; 254 	GPIOC->DDR|=(1<<3);
3319  02a1 7216500c      	bset	20492,#3
3320                     ; 255 	GPIOC->CR1|=(1<<3);
3322  02a5 7216500d      	bset	20493,#3
3323                     ; 256 	GPIOC->CR2&=~(1<<3);
3325  02a9 7217500e      	bres	20494,#3
3326                     ; 257 	GPIOC->ODR|=(1<<3);	
3328  02ad 7216500a      	bset	20490,#3
3329                     ; 259 	GPIOC->DDR|=(1<<5);
3331  02b1 721a500c      	bset	20492,#5
3332                     ; 260 	GPIOC->CR1|=(1<<5);
3334  02b5 721a500d      	bset	20493,#5
3335                     ; 261 	GPIOC->CR2|=(1<<5);
3337  02b9 721a500e      	bset	20494,#5
3338                     ; 262 	GPIOC->ODR|=(1<<5);	
3340  02bd 721a500a      	bset	20490,#5
3341                     ; 264 	GPIOC->DDR|=(1<<6);
3343  02c1 721c500c      	bset	20492,#6
3344                     ; 265 	GPIOC->CR1|=(1<<6);
3346  02c5 721c500d      	bset	20493,#6
3347                     ; 266 	GPIOC->CR2|=(1<<6);
3349  02c9 721c500e      	bset	20494,#6
3350                     ; 267 	GPIOC->ODR|=(1<<6);	
3352  02cd 721c500a      	bset	20490,#6
3353                     ; 269 	GPIOC->DDR&=~(1<<7);
3355  02d1 721f500c      	bres	20492,#7
3356                     ; 270 	GPIOC->CR1&=~(1<<7);
3358  02d5 721f500d      	bres	20493,#7
3359                     ; 271 	GPIOC->CR2&=~(1<<7);
3361  02d9 721f500e      	bres	20494,#7
3362                     ; 272 	GPIOC->ODR|=(1<<7);	
3364  02dd 721e500a      	bset	20490,#7
3365                     ; 274 	SPI->CR1= /*SPI_CR1_LSBFIRST |*/
3365                     ; 275 			SPI_CR1_SPE | 
3365                     ; 276 			( (4<< 3) & SPI_CR1_BR ) |
3365                     ; 277 			SPI_CR1_MSTR |
3365                     ; 278 			SPI_CR1_CPOL |
3365                     ; 279 			SPI_CR1_CPHA; 
3367  02e1 35675200      	mov	20992,#103
3368                     ; 281 	SPI->CR2= SPI_CR2_SSM | SPI_CR2_SSI;
3370  02e5 35035201      	mov	20993,#3
3371                     ; 282 	SPI->ICR= 0;	
3373  02e9 725f5202      	clr	20994
3374                     ; 283 }
3377  02ed 81            	ret
3420                     ; 286 char spi(char in){
3421                     	switch	.text
3422  02ee               _spi:
3424  02ee 88            	push	a
3425  02ef 88            	push	a
3426       00000001      OFST:	set	1
3429  02f0               L7102:
3430                     ; 288 	while(!((SPI->SR)&SPI_SR_TXE));
3432  02f0 c65203        	ld	a,20995
3433  02f3 a502          	bcp	a,#2
3434  02f5 27f9          	jreq	L7102
3435                     ; 289 	SPI->DR=in;
3437  02f7 7b02          	ld	a,(OFST+1,sp)
3438  02f9 c75204        	ld	20996,a
3440  02fc               L7202:
3441                     ; 290 	while(!((SPI->SR)&SPI_SR_RXNE));
3443  02fc c65203        	ld	a,20995
3444  02ff a501          	bcp	a,#1
3445  0301 27f9          	jreq	L7202
3446                     ; 291 	c=SPI->DR;	
3448  0303 c65204        	ld	a,20996
3449  0306 6b01          	ld	(OFST+0,sp),a
3450                     ; 292 	return c;
3452  0308 7b01          	ld	a,(OFST+0,sp)
3455  030a 85            	popw	x
3456  030b 81            	ret
3479                     ; 297 void gpio_init(void){
3480                     	switch	.text
3481  030c               _gpio_init:
3485                     ; 307 	GPIOD->DDR|=(1<<2);
3487  030c 72145011      	bset	20497,#2
3488                     ; 308 	GPIOD->CR1|=(1<<2);
3490  0310 72145012      	bset	20498,#2
3491                     ; 309 	GPIOD->CR2|=(1<<2);
3493  0314 72145013      	bset	20499,#2
3494                     ; 310 	GPIOD->ODR&=~(1<<2);
3496  0318 7215500f      	bres	20495,#2
3497                     ; 312 	GPIOD->DDR|=(1<<4);
3499  031c 72185011      	bset	20497,#4
3500                     ; 313 	GPIOD->CR1|=(1<<4);
3502  0320 72185012      	bset	20498,#4
3503                     ; 314 	GPIOD->CR2&=~(1<<4);
3505  0324 72195013      	bres	20499,#4
3506                     ; 316 	GPIOC->DDR&=~(1<<4);
3508  0328 7219500c      	bres	20492,#4
3509                     ; 317 	GPIOC->CR1&=~(1<<4);
3511  032c 7219500d      	bres	20493,#4
3512                     ; 318 	GPIOC->CR2&=~(1<<4);
3514  0330 7219500e      	bres	20494,#4
3515                     ; 322 }
3518  0334 81            	ret
3555                     ; 331 @far @interrupt void TIM4_UPD_Interrupt (void) 
3555                     ; 332 {
3557                     	switch	.text
3558  0335               f_TIM4_UPD_Interrupt:
3562                     ; 363 	TIM2->CCR3H= 0x00;	
3564  0335 725f5315      	clr	21269
3565                     ; 364 	TIM2->CCR3L= 0x7f;//pwm_fade_in;
3567  0339 357f5316      	mov	21270,#127
3568                     ; 398 if(but_block_cnt)but_on_drv_cnt=0;
3570  033d be04          	ldw	x,_but_block_cnt
3571  033f 2702          	jreq	L3502
3574  0341 3fb9          	clr	_but_on_drv_cnt
3575  0343               L3502:
3576                     ; 399 if((((GPIOC->IDR)&(1<<4))) && (but_on_drv_cnt<100)) 
3578  0343 c6500b        	ld	a,20491
3579  0346 a510          	bcp	a,#16
3580  0348 2729          	jreq	L5502
3582  034a b6b9          	ld	a,_but_on_drv_cnt
3583  034c a164          	cp	a,#100
3584  034e 2423          	jruge	L5502
3585                     ; 401 	but_on_drv_cnt++;
3587  0350 3cb9          	inc	_but_on_drv_cnt
3588                     ; 402 	if((but_on_drv_cnt>2)&&(bRELEASE))
3590  0352 b6b9          	ld	a,_but_on_drv_cnt
3591  0354 a103          	cp	a,#3
3592  0356 2521          	jrult	L1602
3594                     	btst	_bRELEASE
3595  035d 241a          	jruge	L1602
3596                     ; 404 		bRELEASE=0;
3598  035f 72110001      	bres	_bRELEASE
3599                     ; 405 		bSTART=1;
3601  0363 72100000      	bset	_bSTART
3602                     ; 406 		rele_stat_bell_cnt=30;
3604  0367 ae001e        	ldw	x,#30
3605  036a bf02          	ldw	_rele_stat_bell_cnt,x
3606                     ; 407 		rele_stat_enable_cnt=300;
3608  036c ae012c        	ldw	x,#300
3609  036f bf00          	ldw	_rele_stat_enable_cnt,x
3610  0371 2006          	jra	L1602
3611  0373               L5502:
3612                     ; 412 	but_on_drv_cnt=0;
3614  0373 3fb9          	clr	_but_on_drv_cnt
3615                     ; 413 	bRELEASE=1;
3617  0375 72100001      	bset	_bRELEASE
3618  0379               L1602:
3619                     ; 416 if(++t0_cnt0>=125)
3621  0379 3c00          	inc	_t0_cnt0
3622  037b b600          	ld	a,_t0_cnt0
3623  037d a17d          	cp	a,#125
3624  037f 2530          	jrult	L3602
3625                     ; 418   t0_cnt0=0;
3627  0381 3f00          	clr	_t0_cnt0
3628                     ; 419   b100Hz=1;
3630  0383 72100009      	bset	_b100Hz
3631                     ; 421 	if(++t0_cnt1>=10)
3633  0387 3c01          	inc	_t0_cnt1
3634  0389 b601          	ld	a,_t0_cnt1
3635  038b a10a          	cp	a,#10
3636  038d 2506          	jrult	L5602
3637                     ; 423 		t0_cnt1=0;
3639  038f 3f01          	clr	_t0_cnt1
3640                     ; 424 		b10Hz=1;
3642  0391 72100008      	bset	_b10Hz
3643  0395               L5602:
3644                     ; 427 	if(++t0_cnt2>=20)
3646  0395 3c02          	inc	_t0_cnt2
3647  0397 b602          	ld	a,_t0_cnt2
3648  0399 a114          	cp	a,#20
3649  039b 2506          	jrult	L7602
3650                     ; 429 		t0_cnt2=0;
3652  039d 3f02          	clr	_t0_cnt2
3653                     ; 430 		b5Hz=1;
3655  039f 72100007      	bset	_b5Hz
3656  03a3               L7602:
3657                     ; 433 	if(++t0_cnt3>=100)
3659  03a3 3c03          	inc	_t0_cnt3
3660  03a5 b603          	ld	a,_t0_cnt3
3661  03a7 a164          	cp	a,#100
3662  03a9 2506          	jrult	L3602
3663                     ; 435 		t0_cnt3=0;
3665  03ab 3f03          	clr	_t0_cnt3
3666                     ; 436 		b1Hz=1;
3668  03ad 72100006      	bset	_b1Hz
3669  03b1               L3602:
3670                     ; 440 TIM4->SR1&=~TIM4_SR1_UIF;			// disable break interrupt
3672  03b1 72115344      	bres	21316,#0
3673                     ; 441 return;
3676  03b5 80            	iret
3702                     ; 445 @far @interrupt void UARTTxInterrupt (void) {
3703                     	switch	.text
3704  03b6               f_UARTTxInterrupt:
3708                     ; 447 	if (tx_counter){
3710  03b6 3d24          	tnz	_tx_counter
3711  03b8 271a          	jreq	L3012
3712                     ; 448 		--tx_counter;
3714  03ba 3a24          	dec	_tx_counter
3715                     ; 449 		UART1->DR=tx_buffer[tx_rd_index];
3717  03bc 5f            	clrw	x
3718  03bd b622          	ld	a,_tx_rd_index
3719  03bf 2a01          	jrpl	L06
3720  03c1 53            	cplw	x
3721  03c2               L06:
3722  03c2 97            	ld	xl,a
3723  03c3 e604          	ld	a,(_tx_buffer,x)
3724  03c5 c75231        	ld	21041,a
3725                     ; 450 		if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
3727  03c8 3c22          	inc	_tx_rd_index
3728  03ca b622          	ld	a,_tx_rd_index
3729  03cc a150          	cp	a,#80
3730  03ce 260c          	jrne	L7012
3733  03d0 3f22          	clr	_tx_rd_index
3734  03d2 2008          	jra	L7012
3735  03d4               L3012:
3736                     ; 453 		bOUT_FREE=1;
3738  03d4 72100004      	bset	_bOUT_FREE
3739                     ; 454 		UART1->CR2&= ~UART1_CR2_TIEN;
3741  03d8 721f5235      	bres	21045,#7
3742  03dc               L7012:
3743                     ; 456 }
3746  03dc 80            	iret
3775                     ; 459 @far @interrupt void UARTRxInterrupt (void) {
3776                     	switch	.text
3777  03dd               f_UARTRxInterrupt:
3781                     ; 464 	rx_status=UART1->SR;
3783  03dd 555230000a    	mov	_rx_status,21040
3784                     ; 465 	rx_data=UART1->DR;
3786  03e2 5552310009    	mov	_rx_data,21041
3787                     ; 467 	if (rx_status & (UART1_SR_RXNE)){
3789  03e7 b60a          	ld	a,_rx_status
3790  03e9 a520          	bcp	a,#32
3791  03eb 272c          	jreq	L1212
3792                     ; 468 		rx_buffer[rx_wr_index]=rx_data;
3794  03ed be1e          	ldw	x,_rx_wr_index
3795  03ef b609          	ld	a,_rx_data
3796  03f1 e754          	ld	(_rx_buffer,x),a
3797                     ; 469 		bRXIN=1;
3799  03f3 72100003      	bset	_bRXIN
3800                     ; 470 		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
3802  03f7 be1e          	ldw	x,_rx_wr_index
3803  03f9 1c0001        	addw	x,#1
3804  03fc bf1e          	ldw	_rx_wr_index,x
3805  03fe a30064        	cpw	x,#100
3806  0401 2603          	jrne	L3212
3809  0403 5f            	clrw	x
3810  0404 bf1e          	ldw	_rx_wr_index,x
3811  0406               L3212:
3812                     ; 471 		if (++rx_counter == RX_BUFFER_SIZE){
3814  0406 be20          	ldw	x,_rx_counter
3815  0408 1c0001        	addw	x,#1
3816  040b bf20          	ldw	_rx_counter,x
3817  040d a30064        	cpw	x,#100
3818  0410 2607          	jrne	L1212
3819                     ; 472 			rx_counter=0;
3821  0412 5f            	clrw	x
3822  0413 bf20          	ldw	_rx_counter,x
3823                     ; 473 			rx_buffer_overflow=1;
3825  0415 72100002      	bset	_rx_buffer_overflow
3826  0419               L1212:
3827                     ; 476 }
3830  0419 80            	iret
3866                     ; 482 main()
3866                     ; 483 {
3868                     	switch	.text
3869  041a               _main:
3873                     ; 484 CLK->CKDIVR=0;
3875  041a 725f50c6      	clr	20678
3876                     ; 486 rele_cnt_index=0;
3878  041e 3fbb          	clr	_rele_cnt_index
3879                     ; 488 GPIOD->DDR&=~(1<<6);
3881  0420 721d5011      	bres	20497,#6
3882                     ; 489 GPIOD->CR1|=(1<<6);
3884  0424 721c5012      	bset	20498,#6
3885                     ; 490 GPIOD->CR2|=(1<<6);
3887  0428 721c5013      	bset	20499,#6
3888                     ; 492 GPIOD->DDR|=(1<<5);
3890  042c 721a5011      	bset	20497,#5
3891                     ; 493 GPIOD->CR1|=(1<<5);
3893  0430 721a5012      	bset	20498,#5
3894                     ; 494 GPIOD->CR2|=(1<<5);	
3896  0434 721a5013      	bset	20499,#5
3897                     ; 495 GPIOD->ODR|=(1<<5);
3899  0438 721a500f      	bset	20495,#5
3900                     ; 497 delay_ms(10);
3902  043c ae000a        	ldw	x,#10
3903  043f cd0075        	call	_delay_ms
3905                     ; 499 if(!(GPIOD->IDR&=(1<<6))) 
3907  0442 c65010        	ld	a,20496
3908  0445 a440          	and	a,#64
3909  0447 c75010        	ld	20496,a
3910  044a 2606          	jrne	L7312
3911                     ; 501 	rele_cnt_index=1;
3913  044c 350100bb      	mov	_rele_cnt_index,#1
3915  0450 2018          	jra	L1412
3916  0452               L7312:
3917                     ; 505 	GPIOD->ODR&=~(1<<5);
3919  0452 721b500f      	bres	20495,#5
3920                     ; 506 	delay_ms(10);
3922  0456 ae000a        	ldw	x,#10
3923  0459 cd0075        	call	_delay_ms
3925                     ; 507 	if(!(GPIOD->IDR&=(1<<6))) 
3927  045c c65010        	ld	a,20496
3928  045f a440          	and	a,#64
3929  0461 c75010        	ld	20496,a
3930  0464 2604          	jrne	L1412
3931                     ; 509 		rele_cnt_index=2;
3933  0466 350200bb      	mov	_rele_cnt_index,#2
3934  046a               L1412:
3935                     ; 513 gpio_init();
3937  046a cd030c        	call	_gpio_init
3939                     ; 520 spi_init();
3941  046d cd0281        	call	_spi_init
3943                     ; 522 t4_init();
3945  0470 cd0039        	call	_t4_init
3947                     ; 524 FLASH_DUKR=0xae;
3949  0473 35ae5064      	mov	_FLASH_DUKR,#174
3950                     ; 525 FLASH_DUKR=0x56;
3952  0477 35565064      	mov	_FLASH_DUKR,#86
3953                     ; 542 t2_init();
3955  047b cd0000        	call	_t2_init
3957                     ; 546 enableInterrupts();	
3960  047e 9a            rim
3962  047f               L5412:
3963                     ; 554 	if(b100Hz)
3965                     	btst	_b100Hz
3966  0484 240f          	jruge	L1512
3967                     ; 556 		b100Hz=0;
3969  0486 72110009      	bres	_b100Hz
3970                     ; 558 		if(but_block_cnt)but_block_cnt--;
3972  048a be04          	ldw	x,_but_block_cnt
3973  048c 2707          	jreq	L1512
3976  048e be04          	ldw	x,_but_block_cnt
3977  0490 1d0001        	subw	x,#1
3978  0493 bf04          	ldw	_but_block_cnt,x
3979  0495               L1512:
3980                     ; 563 	if(b10Hz)
3982                     	btst	_b10Hz
3983  049a 2407          	jruge	L5512
3984                     ; 565 		b10Hz=0;
3986  049c 72110008      	bres	_b10Hz
3987                     ; 567 		rele_drv();
3989  04a0 cd004a        	call	_rele_drv
3991  04a3               L5512:
3992                     ; 570 	if(b5Hz)
3994                     	btst	_b5Hz
3995  04a8 2404          	jruge	L7512
3996                     ; 572 		b5Hz=0;
3998  04aa 72110007      	bres	_b5Hz
3999  04ae               L7512:
4000                     ; 578 	if(b1Hz)
4002                     	btst	_b1Hz
4003  04b3 24ca          	jruge	L5412
4004                     ; 581 		b1Hz=0;
4006  04b5 72110006      	bres	_b1Hz
4007  04b9 20c4          	jra	L5412
4453                     	xdef	_main
4454                     	switch	.ubsct
4455  0000               _rele_stat_enable_cnt:
4456  0000 0000          	ds.b	2
4457                     	xdef	_rele_stat_enable_cnt
4458  0002               _rele_stat_bell_cnt:
4459  0002 0000          	ds.b	2
4460                     	xdef	_rele_stat_bell_cnt
4461                     .bit:	section	.data,bit
4462  0000               _bSTART:
4463  0000 00            	ds.b	1
4464                     	xdef	_bSTART
4465  0001               _bRELEASE:
4466  0001 00            	ds.b	1
4467                     	xdef	_bRELEASE
4468  0002               _rx_buffer_overflow:
4469  0002 00            	ds.b	1
4470                     	xdef	_rx_buffer_overflow
4471  0003               _bRXIN:
4472  0003 00            	ds.b	1
4473                     	xdef	_bRXIN
4474  0004               _bOUT_FREE:
4475  0004 00            	ds.b	1
4476                     	xdef	_bOUT_FREE
4477  0005               _play:
4478  0005 00            	ds.b	1
4479                     	xdef	_play
4480  0006               _b1Hz:
4481  0006 00            	ds.b	1
4482                     	xdef	_b1Hz
4483  0007               _b5Hz:
4484  0007 00            	ds.b	1
4485                     	xdef	_b5Hz
4486  0008               _b10Hz:
4487  0008 00            	ds.b	1
4488                     	xdef	_b10Hz
4489  0009               _b100Hz:
4490  0009 00            	ds.b	1
4491                     	xdef	_b100Hz
4492                     	switch	.ubsct
4493  0004               _but_block_cnt:
4494  0004 0000          	ds.b	2
4495                     	xdef	_but_block_cnt
4496                     	xdef	_memory_manufacturer
4497                     	xdef	_rele_cnt_const
4498                     	xdef	_rele_cnt_index
4499                     	xdef	_pwm_fade_in
4500  0006               _rx_offset:
4501  0006 00            	ds.b	1
4502                     	xdef	_rx_offset
4503  0007               _rele_cnt:
4504  0007 0000          	ds.b	2
4505                     	xdef	_rele_cnt
4506  0009               _rx_data:
4507  0009 00            	ds.b	1
4508                     	xdef	_rx_data
4509  000a               _rx_status:
4510  000a 00            	ds.b	1
4511                     	xdef	_rx_status
4512  000b               _file_lengt:
4513  000b 00000000      	ds.b	4
4514                     	xdef	_file_lengt
4515  000f               _current_byte_in_buffer:
4516  000f 0000          	ds.b	2
4517                     	xdef	_current_byte_in_buffer
4518  0011               _last_page:
4519  0011 0000          	ds.b	2
4520                     	xdef	_last_page
4521  0013               _current_page:
4522  0013 0000          	ds.b	2
4523                     	xdef	_current_page
4524  0015               _file_lengt_in_pages:
4525  0015 0000          	ds.b	2
4526                     	xdef	_file_lengt_in_pages
4527  0017               _mdr3:
4528  0017 00            	ds.b	1
4529                     	xdef	_mdr3
4530  0018               _mdr2:
4531  0018 00            	ds.b	1
4532                     	xdef	_mdr2
4533  0019               _mdr1:
4534  0019 00            	ds.b	1
4535                     	xdef	_mdr1
4536  001a               _mdr0:
4537  001a 00            	ds.b	1
4538                     	xdef	_mdr0
4539                     	xdef	_but_on_drv_cnt
4540                     	xdef	_but_drv_cnt
4541  001b               _sample:
4542  001b 00            	ds.b	1
4543                     	xdef	_sample
4544  001c               _rx_rd_index:
4545  001c 0000          	ds.b	2
4546                     	xdef	_rx_rd_index
4547  001e               _rx_wr_index:
4548  001e 0000          	ds.b	2
4549                     	xdef	_rx_wr_index
4550  0020               _rx_counter:
4551  0020 0000          	ds.b	2
4552                     	xdef	_rx_counter
4553                     	xdef	_rx_buffer
4554  0022               _tx_rd_index:
4555  0022 00            	ds.b	1
4556                     	xdef	_tx_rd_index
4557  0023               _tx_wr_index:
4558  0023 00            	ds.b	1
4559                     	xdef	_tx_wr_index
4560  0024               _tx_counter:
4561  0024 00            	ds.b	1
4562                     	xdef	_tx_counter
4563                     	xdef	_tx_buffer
4564  0025               _sample_cnt:
4565  0025 0000          	ds.b	2
4566                     	xdef	_sample_cnt
4567                     	xdef	_t0_cnt3
4568                     	xdef	_t0_cnt2
4569                     	xdef	_t0_cnt1
4570                     	xdef	_t0_cnt0
4571                     	xdef	_uart_in_an
4572                     	xdef	_gpio_init
4573                     	xdef	_spi_init
4574                     	xdef	_spi
4575                     	xdef	_uart_init
4576                     	xdef	f_UARTRxInterrupt
4577                     	xdef	f_UARTTxInterrupt
4578                     	xdef	_putchar
4579                     	xdef	_uart_out_adr_block
4580                     	xdef	_uart_out
4581                     	xdef	f_TIM4_UPD_Interrupt
4582                     	xdef	_delay_ms
4583                     	xdef	_rele_drv
4584                     	xdef	_t4_init
4585                     	xdef	_t2_init
4586                     	xref.b	c_x
4587                     	xref.b	c_y
4607                     	xref	c_lgursh
4608                     	xref	c_lcmp
4609                     	xref	c_ltor
4610                     	xref	c_lgadc
4611                     	xref	c_rtol
4612                     	xref	c_vmul
4613                     	end
