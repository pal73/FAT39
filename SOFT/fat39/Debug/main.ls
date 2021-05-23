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
2362  004c 2716          	jreq	L1641
2363                     ; 91 	rele_stat_bell_cnt--;
2365  004e be02          	ldw	x,_rele_stat_bell_cnt
2366  0050 1d0001        	subw	x,#1
2367  0053 bf02          	ldw	_rele_stat_bell_cnt,x
2368                     ; 92 	if(rele_stat_bell_cnt==0)rele_stat_enable_cnt=300;
2370  0055 be02          	ldw	x,_rele_stat_bell_cnt
2371  0057 2605          	jrne	L3641
2374  0059 ae012c        	ldw	x,#300
2375  005c bf00          	ldw	_rele_stat_enable_cnt,x
2376  005e               L3641:
2377                     ; 93 	GPIOD->ODR|=(1<<4);
2379  005e 7218500f      	bset	20495,#4
2381  0062 2004          	jra	L5641
2382  0064               L1641:
2383                     ; 95 else GPIOD->ODR&=~(1<<4);
2385  0064 7219500f      	bres	20495,#4
2386  0068               L5641:
2387                     ; 97 if(rele_stat_enable_cnt) 
2389  0068 be00          	ldw	x,_rele_stat_enable_cnt
2390  006a 270d          	jreq	L7641
2391                     ; 99 	rele_stat_enable_cnt--;
2393  006c be00          	ldw	x,_rele_stat_enable_cnt
2394  006e 1d0001        	subw	x,#1
2395  0071 bf00          	ldw	_rele_stat_enable_cnt,x
2396                     ; 100 	GPIOB->ODR&=~(1<<5);
2398  0073 721b5005      	bres	20485,#5
2400  0077 2004          	jra	L1741
2401  0079               L7641:
2402                     ; 102 else GPIOB->ODR|=(1<<5);
2404  0079 721a5005      	bset	20485,#5
2405  007d               L1741:
2406                     ; 104 }
2409  007d 81            	ret
2470                     ; 107 long delay_ms(short in)
2470                     ; 108 {
2471                     	switch	.text
2472  007e               _delay_ms:
2474  007e 520c          	subw	sp,#12
2475       0000000c      OFST:	set	12
2478                     ; 111 i=((long)in)*100UL;
2480  0080 90ae0064      	ldw	y,#100
2481  0084 cd0000        	call	c_vmul
2483  0087 96            	ldw	x,sp
2484  0088 1c0005        	addw	x,#OFST-7
2485  008b cd0000        	call	c_rtol
2487                     ; 113 for(ii=0;ii<i;ii++)
2489  008e ae0000        	ldw	x,#0
2490  0091 1f0b          	ldw	(OFST-1,sp),x
2491  0093 ae0000        	ldw	x,#0
2492  0096 1f09          	ldw	(OFST-3,sp),x
2494  0098 2012          	jra	L1351
2495  009a               L5251:
2496                     ; 115 		iii++;
2498  009a 96            	ldw	x,sp
2499  009b 1c0001        	addw	x,#OFST-11
2500  009e a601          	ld	a,#1
2501  00a0 cd0000        	call	c_lgadc
2503                     ; 113 for(ii=0;ii<i;ii++)
2505  00a3 96            	ldw	x,sp
2506  00a4 1c0009        	addw	x,#OFST-3
2507  00a7 a601          	ld	a,#1
2508  00a9 cd0000        	call	c_lgadc
2510  00ac               L1351:
2513  00ac 9c            	rvf
2514  00ad 96            	ldw	x,sp
2515  00ae 1c0009        	addw	x,#OFST-3
2516  00b1 cd0000        	call	c_ltor
2518  00b4 96            	ldw	x,sp
2519  00b5 1c0005        	addw	x,#OFST-7
2520  00b8 cd0000        	call	c_lcmp
2522  00bb 2fdd          	jrslt	L5251
2523                     ; 118 }
2526  00bd 5b0c          	addw	sp,#12
2527  00bf 81            	ret
2550                     ; 121 void uart_init (void){
2551                     	switch	.text
2552  00c0               _uart_init:
2556                     ; 122 	GPIOD->DDR|=(1<<5);
2558  00c0 721a5011      	bset	20497,#5
2559                     ; 123 	GPIOD->CR1|=(1<<5);
2561  00c4 721a5012      	bset	20498,#5
2562                     ; 124 	GPIOD->CR2|=(1<<5);
2564  00c8 721a5013      	bset	20499,#5
2565                     ; 127 	GPIOD->DDR&=~(1<<6);
2567  00cc 721d5011      	bres	20497,#6
2568                     ; 128 	GPIOD->CR1&=~(1<<6);
2570  00d0 721d5012      	bres	20498,#6
2571                     ; 129 	GPIOD->CR2&=~(1<<6);
2573  00d4 721d5013      	bres	20499,#6
2574                     ; 132 	UART1->CR1&=~UART1_CR1_M;					
2576  00d8 72195234      	bres	21044,#4
2577                     ; 133 	UART1->CR3|= (0<<4) & UART1_CR3_STOP;	
2579  00dc c65236        	ld	a,21046
2580                     ; 134 	UART1->BRR2= 0x01;//0x03;
2582  00df 35015233      	mov	21043,#1
2583                     ; 135 	UART1->BRR1= 0x1a;//0x68;
2585  00e3 351a5232      	mov	21042,#26
2586                     ; 136 	UART1->CR2|= UART1_CR2_TEN | UART3_CR2_REN | UART3_CR2_RIEN;	
2588  00e7 c65235        	ld	a,21045
2589  00ea aa2c          	or	a,#44
2590  00ec c75235        	ld	21045,a
2591                     ; 137 }
2594  00ef 81            	ret
2712                     ; 140 void uart_out (char num,char data0,char data1,char data2,char data3,char data4,char data5){
2713                     	switch	.text
2714  00f0               _uart_out:
2716  00f0 89            	pushw	x
2717  00f1 520c          	subw	sp,#12
2718       0000000c      OFST:	set	12
2721                     ; 141 	char i=0,t=0,UOB[10];
2725  00f3 0f01          	clr	(OFST-11,sp)
2726                     ; 144 	UOB[0]=data0;
2728  00f5 9f            	ld	a,xl
2729  00f6 6b02          	ld	(OFST-10,sp),a
2730                     ; 145 	UOB[1]=data1;
2732  00f8 7b11          	ld	a,(OFST+5,sp)
2733  00fa 6b03          	ld	(OFST-9,sp),a
2734                     ; 146 	UOB[2]=data2;
2736  00fc 7b12          	ld	a,(OFST+6,sp)
2737  00fe 6b04          	ld	(OFST-8,sp),a
2738                     ; 147 	UOB[3]=data3;
2740  0100 7b13          	ld	a,(OFST+7,sp)
2741  0102 6b05          	ld	(OFST-7,sp),a
2742                     ; 148 	UOB[4]=data4;
2744  0104 7b14          	ld	a,(OFST+8,sp)
2745  0106 6b06          	ld	(OFST-6,sp),a
2746                     ; 149 	UOB[5]=data5;
2748  0108 7b15          	ld	a,(OFST+9,sp)
2749  010a 6b07          	ld	(OFST-5,sp),a
2750                     ; 150 	for (i=0;i<num;i++)
2752  010c 0f0c          	clr	(OFST+0,sp)
2754  010e 2013          	jra	L3361
2755  0110               L7261:
2756                     ; 152 		t^=UOB[i];
2758  0110 96            	ldw	x,sp
2759  0111 1c0002        	addw	x,#OFST-10
2760  0114 9f            	ld	a,xl
2761  0115 5e            	swapw	x
2762  0116 1b0c          	add	a,(OFST+0,sp)
2763  0118 2401          	jrnc	L02
2764  011a 5c            	incw	x
2765  011b               L02:
2766  011b 02            	rlwa	x,a
2767  011c 7b01          	ld	a,(OFST-11,sp)
2768  011e f8            	xor	a,	(x)
2769  011f 6b01          	ld	(OFST-11,sp),a
2770                     ; 150 	for (i=0;i<num;i++)
2772  0121 0c0c          	inc	(OFST+0,sp)
2773  0123               L3361:
2776  0123 7b0c          	ld	a,(OFST+0,sp)
2777  0125 110d          	cp	a,(OFST+1,sp)
2778  0127 25e7          	jrult	L7261
2779                     ; 154 	UOB[num]=num;
2781  0129 96            	ldw	x,sp
2782  012a 1c0002        	addw	x,#OFST-10
2783  012d 9f            	ld	a,xl
2784  012e 5e            	swapw	x
2785  012f 1b0d          	add	a,(OFST+1,sp)
2786  0131 2401          	jrnc	L22
2787  0133 5c            	incw	x
2788  0134               L22:
2789  0134 02            	rlwa	x,a
2790  0135 7b0d          	ld	a,(OFST+1,sp)
2791  0137 f7            	ld	(x),a
2792                     ; 155 	t^=UOB[num];
2794  0138 96            	ldw	x,sp
2795  0139 1c0002        	addw	x,#OFST-10
2796  013c 9f            	ld	a,xl
2797  013d 5e            	swapw	x
2798  013e 1b0d          	add	a,(OFST+1,sp)
2799  0140 2401          	jrnc	L42
2800  0142 5c            	incw	x
2801  0143               L42:
2802  0143 02            	rlwa	x,a
2803  0144 7b01          	ld	a,(OFST-11,sp)
2804  0146 f8            	xor	a,	(x)
2805  0147 6b01          	ld	(OFST-11,sp),a
2806                     ; 156 	UOB[num+1]=t;
2808  0149 96            	ldw	x,sp
2809  014a 1c0003        	addw	x,#OFST-9
2810  014d 9f            	ld	a,xl
2811  014e 5e            	swapw	x
2812  014f 1b0d          	add	a,(OFST+1,sp)
2813  0151 2401          	jrnc	L62
2814  0153 5c            	incw	x
2815  0154               L62:
2816  0154 02            	rlwa	x,a
2817  0155 7b01          	ld	a,(OFST-11,sp)
2818  0157 f7            	ld	(x),a
2819                     ; 157 	UOB[num+2]=END;
2821  0158 96            	ldw	x,sp
2822  0159 1c0004        	addw	x,#OFST-8
2823  015c 9f            	ld	a,xl
2824  015d 5e            	swapw	x
2825  015e 1b0d          	add	a,(OFST+1,sp)
2826  0160 2401          	jrnc	L03
2827  0162 5c            	incw	x
2828  0163               L03:
2829  0163 02            	rlwa	x,a
2830  0164 a60a          	ld	a,#10
2831  0166 f7            	ld	(x),a
2832                     ; 161 	for (i=0;i<num+3;i++)
2834  0167 0f0c          	clr	(OFST+0,sp)
2836  0169 2012          	jra	L3461
2837  016b               L7361:
2838                     ; 163 		putchar(UOB[i]);
2840  016b 96            	ldw	x,sp
2841  016c 1c0002        	addw	x,#OFST-10
2842  016f 9f            	ld	a,xl
2843  0170 5e            	swapw	x
2844  0171 1b0c          	add	a,(OFST+0,sp)
2845  0173 2401          	jrnc	L23
2846  0175 5c            	incw	x
2847  0176               L23:
2848  0176 02            	rlwa	x,a
2849  0177 f6            	ld	a,(x)
2850  0178 cd0254        	call	_putchar
2852                     ; 161 	for (i=0;i<num+3;i++)
2854  017b 0c0c          	inc	(OFST+0,sp)
2855  017d               L3461:
2858  017d 9c            	rvf
2859  017e 7b0c          	ld	a,(OFST+0,sp)
2860  0180 5f            	clrw	x
2861  0181 97            	ld	xl,a
2862  0182 7b0d          	ld	a,(OFST+1,sp)
2863  0184 905f          	clrw	y
2864  0186 9097          	ld	yl,a
2865  0188 72a90003      	addw	y,#3
2866  018c bf00          	ldw	c_x,x
2867  018e 90b300        	cpw	y,c_x
2868  0191 2cd8          	jrsgt	L7361
2869                     ; 166 	bOUT_FREE=0;	  	
2871  0193 72110004      	bres	_bOUT_FREE
2872                     ; 167 }
2875  0197 5b0e          	addw	sp,#14
2876  0199 81            	ret
2958                     ; 170 void uart_out_adr_block (unsigned long adress,char *ptr, char len)
2958                     ; 171 {
2959                     	switch	.text
2960  019a               _uart_out_adr_block:
2962  019a 5203          	subw	sp,#3
2963       00000003      OFST:	set	3
2966                     ; 175 t=0;
2968  019c 0f02          	clr	(OFST-1,sp)
2969                     ; 176 temp11=CMND;
2971                     ; 177 t^=temp11;
2973  019e 7b02          	ld	a,(OFST-1,sp)
2974  01a0 a816          	xor	a,	#22
2975  01a2 6b02          	ld	(OFST-1,sp),a
2976                     ; 178 putchar(temp11);
2978  01a4 a616          	ld	a,#22
2979  01a6 cd0254        	call	_putchar
2981                     ; 180 temp11=10;
2983                     ; 181 t^=temp11;
2985  01a9 7b02          	ld	a,(OFST-1,sp)
2986  01ab a80a          	xor	a,	#10
2987  01ad 6b02          	ld	(OFST-1,sp),a
2988                     ; 182 putchar(temp11);
2990  01af a60a          	ld	a,#10
2991  01b1 cd0254        	call	_putchar
2993                     ; 184 temp11=adress%256;//(*((char*)&adress));
2995  01b4 7b09          	ld	a,(OFST+6,sp)
2996  01b6 a4ff          	and	a,#255
2997  01b8 6b03          	ld	(OFST+0,sp),a
2998                     ; 185 t^=temp11;
3000  01ba 7b02          	ld	a,(OFST-1,sp)
3001  01bc 1803          	xor	a,	(OFST+0,sp)
3002  01be 6b02          	ld	(OFST-1,sp),a
3003                     ; 186 putchar(temp11);
3005  01c0 7b03          	ld	a,(OFST+0,sp)
3006  01c2 cd0254        	call	_putchar
3008                     ; 187 adress>>=8;
3010  01c5 96            	ldw	x,sp
3011  01c6 1c0006        	addw	x,#OFST+3
3012  01c9 a608          	ld	a,#8
3013  01cb cd0000        	call	c_lgursh
3015                     ; 188 temp11=adress%256;//(*(((char*)&adress)+1));
3017  01ce 7b09          	ld	a,(OFST+6,sp)
3018  01d0 a4ff          	and	a,#255
3019  01d2 6b03          	ld	(OFST+0,sp),a
3020                     ; 189 t^=temp11;
3022  01d4 7b02          	ld	a,(OFST-1,sp)
3023  01d6 1803          	xor	a,	(OFST+0,sp)
3024  01d8 6b02          	ld	(OFST-1,sp),a
3025                     ; 190 putchar(temp11);
3027  01da 7b03          	ld	a,(OFST+0,sp)
3028  01dc ad76          	call	_putchar
3030                     ; 191 adress>>=8;
3032  01de 96            	ldw	x,sp
3033  01df 1c0006        	addw	x,#OFST+3
3034  01e2 a608          	ld	a,#8
3035  01e4 cd0000        	call	c_lgursh
3037                     ; 192 temp11=adress%256;//(*(((char*)&adress)+2));
3039  01e7 7b09          	ld	a,(OFST+6,sp)
3040  01e9 a4ff          	and	a,#255
3041  01eb 6b03          	ld	(OFST+0,sp),a
3042                     ; 193 t^=temp11;
3044  01ed 7b02          	ld	a,(OFST-1,sp)
3045  01ef 1803          	xor	a,	(OFST+0,sp)
3046  01f1 6b02          	ld	(OFST-1,sp),a
3047                     ; 194 putchar(temp11);
3049  01f3 7b03          	ld	a,(OFST+0,sp)
3050  01f5 ad5d          	call	_putchar
3052                     ; 195 adress>>=8;
3054  01f7 96            	ldw	x,sp
3055  01f8 1c0006        	addw	x,#OFST+3
3056  01fb a608          	ld	a,#8
3057  01fd cd0000        	call	c_lgursh
3059                     ; 196 temp11=adress%256;//(*(((char*)&adress)+3));
3061  0200 7b09          	ld	a,(OFST+6,sp)
3062  0202 a4ff          	and	a,#255
3063  0204 6b03          	ld	(OFST+0,sp),a
3064                     ; 197 t^=temp11;
3066  0206 7b02          	ld	a,(OFST-1,sp)
3067  0208 1803          	xor	a,	(OFST+0,sp)
3068  020a 6b02          	ld	(OFST-1,sp),a
3069                     ; 198 putchar(temp11);
3071  020c 7b03          	ld	a,(OFST+0,sp)
3072  020e ad44          	call	_putchar
3074                     ; 201 for(i11=0;i11<len;i11++)
3076  0210 0f01          	clr	(OFST-2,sp)
3078  0212 201a          	jra	L5171
3079  0214               L1171:
3080                     ; 203 	temp11=ptr[i11];
3082  0214 7b0a          	ld	a,(OFST+7,sp)
3083  0216 97            	ld	xl,a
3084  0217 7b0b          	ld	a,(OFST+8,sp)
3085  0219 1b01          	add	a,(OFST-2,sp)
3086  021b 2401          	jrnc	L63
3087  021d 5c            	incw	x
3088  021e               L63:
3089  021e 02            	rlwa	x,a
3090  021f f6            	ld	a,(x)
3091  0220 6b03          	ld	(OFST+0,sp),a
3092                     ; 204 	t^=temp11;
3094  0222 7b02          	ld	a,(OFST-1,sp)
3095  0224 1803          	xor	a,	(OFST+0,sp)
3096  0226 6b02          	ld	(OFST-1,sp),a
3097                     ; 205 	putchar(temp11);
3099  0228 7b03          	ld	a,(OFST+0,sp)
3100  022a ad28          	call	_putchar
3102                     ; 201 for(i11=0;i11<len;i11++)
3104  022c 0c01          	inc	(OFST-2,sp)
3105  022e               L5171:
3108  022e 7b01          	ld	a,(OFST-2,sp)
3109  0230 110c          	cp	a,(OFST+9,sp)
3110  0232 25e0          	jrult	L1171
3111                     ; 208 temp11=(len+6);
3113  0234 7b0c          	ld	a,(OFST+9,sp)
3114  0236 ab06          	add	a,#6
3115  0238 6b03          	ld	(OFST+0,sp),a
3116                     ; 209 t^=temp11;
3118  023a 7b02          	ld	a,(OFST-1,sp)
3119  023c 1803          	xor	a,	(OFST+0,sp)
3120  023e 6b02          	ld	(OFST-1,sp),a
3121                     ; 210 putchar(temp11);
3123  0240 7b03          	ld	a,(OFST+0,sp)
3124  0242 ad10          	call	_putchar
3126                     ; 212 putchar(t);
3128  0244 7b02          	ld	a,(OFST-1,sp)
3129  0246 ad0c          	call	_putchar
3131                     ; 214 putchar(0x0a);
3133  0248 a60a          	ld	a,#10
3134  024a ad08          	call	_putchar
3136                     ; 216 bOUT_FREE=0;	   
3138  024c 72110004      	bres	_bOUT_FREE
3139                     ; 217 }
3142  0250 5b03          	addw	sp,#3
3143  0252 81            	ret
3166                     ; 219 void uart_in_an(void) 
3166                     ; 220 {
3167                     	switch	.text
3168  0253               _uart_in_an:
3172                     ; 222 }
3175  0253 81            	ret
3212                     ; 225 void putchar(char c)
3212                     ; 226 {
3213                     	switch	.text
3214  0254               _putchar:
3216  0254 88            	push	a
3217       00000000      OFST:	set	0
3220  0255               L1571:
3221                     ; 227 while (tx_counter == TX_BUFFER_SIZE);
3223  0255 b624          	ld	a,_tx_counter
3224  0257 a150          	cp	a,#80
3225  0259 27fa          	jreq	L1571
3226                     ; 229 if (tx_counter || ((UART1->SR & UART1_SR_TXE)==0))
3228  025b 3d24          	tnz	_tx_counter
3229  025d 2607          	jrne	L7571
3231  025f c65230        	ld	a,21040
3232  0262 a580          	bcp	a,#128
3233  0264 261d          	jrne	L5571
3234  0266               L7571:
3235                     ; 231    tx_buffer[tx_wr_index]=c;
3237  0266 5f            	clrw	x
3238  0267 b623          	ld	a,_tx_wr_index
3239  0269 2a01          	jrpl	L44
3240  026b 53            	cplw	x
3241  026c               L44:
3242  026c 97            	ld	xl,a
3243  026d 7b01          	ld	a,(OFST+1,sp)
3244  026f e704          	ld	(_tx_buffer,x),a
3245                     ; 232    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
3247  0271 3c23          	inc	_tx_wr_index
3248  0273 b623          	ld	a,_tx_wr_index
3249  0275 a150          	cp	a,#80
3250  0277 2602          	jrne	L1671
3253  0279 3f23          	clr	_tx_wr_index
3254  027b               L1671:
3255                     ; 233    ++tx_counter;
3257  027b 3c24          	inc	_tx_counter
3259  027d               L3671:
3260                     ; 237 UART1->CR2|= UART1_CR2_TIEN;
3262  027d 721e5235      	bset	21045,#7
3263                     ; 239 }
3266  0281 84            	pop	a
3267  0282 81            	ret
3268  0283               L5571:
3269                     ; 235 else UART1->DR=c;
3271  0283 7b01          	ld	a,(OFST+1,sp)
3272  0285 c75231        	ld	21041,a
3273  0288 20f3          	jra	L3671
3296                     ; 242 void spi_init(void){
3297                     	switch	.text
3298  028a               _spi_init:
3302                     ; 244 	GPIOA->DDR|=(1<<3);
3304  028a 72165002      	bset	20482,#3
3305                     ; 245 	GPIOA->CR1|=(1<<3);
3307  028e 72165003      	bset	20483,#3
3308                     ; 246 	GPIOA->CR2&=~(1<<3);
3310  0292 72175004      	bres	20484,#3
3311                     ; 247 	GPIOA->ODR|=(1<<3);	
3313  0296 72165000      	bset	20480,#3
3314                     ; 250 	GPIOB->DDR|=(1<<5);
3316  029a 721a5007      	bset	20487,#5
3317                     ; 251 	GPIOB->CR1|=(1<<5);
3319  029e 721a5008      	bset	20488,#5
3320                     ; 252 	GPIOB->CR2&=~(1<<5);
3322  02a2 721b5009      	bres	20489,#5
3323                     ; 253 	GPIOB->ODR|=(1<<5);	
3325  02a6 721a5005      	bset	20485,#5
3326                     ; 255 	GPIOC->DDR|=(1<<3);
3328  02aa 7216500c      	bset	20492,#3
3329                     ; 256 	GPIOC->CR1|=(1<<3);
3331  02ae 7216500d      	bset	20493,#3
3332                     ; 257 	GPIOC->CR2&=~(1<<3);
3334  02b2 7217500e      	bres	20494,#3
3335                     ; 258 	GPIOC->ODR|=(1<<3);	
3337  02b6 7216500a      	bset	20490,#3
3338                     ; 260 	GPIOC->DDR|=(1<<5);
3340  02ba 721a500c      	bset	20492,#5
3341                     ; 261 	GPIOC->CR1|=(1<<5);
3343  02be 721a500d      	bset	20493,#5
3344                     ; 262 	GPIOC->CR2|=(1<<5);
3346  02c2 721a500e      	bset	20494,#5
3347                     ; 263 	GPIOC->ODR|=(1<<5);	
3349  02c6 721a500a      	bset	20490,#5
3350                     ; 265 	GPIOC->DDR|=(1<<6);
3352  02ca 721c500c      	bset	20492,#6
3353                     ; 266 	GPIOC->CR1|=(1<<6);
3355  02ce 721c500d      	bset	20493,#6
3356                     ; 267 	GPIOC->CR2|=(1<<6);
3358  02d2 721c500e      	bset	20494,#6
3359                     ; 268 	GPIOC->ODR|=(1<<6);	
3361  02d6 721c500a      	bset	20490,#6
3362                     ; 270 	GPIOC->DDR&=~(1<<7);
3364  02da 721f500c      	bres	20492,#7
3365                     ; 271 	GPIOC->CR1&=~(1<<7);
3367  02de 721f500d      	bres	20493,#7
3368                     ; 272 	GPIOC->CR2&=~(1<<7);
3370  02e2 721f500e      	bres	20494,#7
3371                     ; 273 	GPIOC->ODR|=(1<<7);	
3373  02e6 721e500a      	bset	20490,#7
3374                     ; 275 	SPI->CR1= /*SPI_CR1_LSBFIRST |*/
3374                     ; 276 			SPI_CR1_SPE | 
3374                     ; 277 			( (4<< 3) & SPI_CR1_BR ) |
3374                     ; 278 			SPI_CR1_MSTR |
3374                     ; 279 			SPI_CR1_CPOL |
3374                     ; 280 			SPI_CR1_CPHA; 
3376  02ea 35675200      	mov	20992,#103
3377                     ; 282 	SPI->CR2= SPI_CR2_SSM | SPI_CR2_SSI;
3379  02ee 35035201      	mov	20993,#3
3380                     ; 283 	SPI->ICR= 0;	
3382  02f2 725f5202      	clr	20994
3383                     ; 284 }
3386  02f6 81            	ret
3429                     ; 287 char spi(char in){
3430                     	switch	.text
3431  02f7               _spi:
3433  02f7 88            	push	a
3434  02f8 88            	push	a
3435       00000001      OFST:	set	1
3438  02f9               L1202:
3439                     ; 289 	while(!((SPI->SR)&SPI_SR_TXE));
3441  02f9 c65203        	ld	a,20995
3442  02fc a502          	bcp	a,#2
3443  02fe 27f9          	jreq	L1202
3444                     ; 290 	SPI->DR=in;
3446  0300 7b02          	ld	a,(OFST+1,sp)
3447  0302 c75204        	ld	20996,a
3449  0305               L1302:
3450                     ; 291 	while(!((SPI->SR)&SPI_SR_RXNE));
3452  0305 c65203        	ld	a,20995
3453  0308 a501          	bcp	a,#1
3454  030a 27f9          	jreq	L1302
3455                     ; 292 	c=SPI->DR;	
3457  030c c65204        	ld	a,20996
3458  030f 6b01          	ld	(OFST+0,sp),a
3459                     ; 293 	return c;
3461  0311 7b01          	ld	a,(OFST+0,sp)
3464  0313 85            	popw	x
3465  0314 81            	ret
3488                     ; 298 void gpio_init(void){
3489                     	switch	.text
3490  0315               _gpio_init:
3494                     ; 308 	GPIOD->DDR|=(1<<2);
3496  0315 72145011      	bset	20497,#2
3497                     ; 309 	GPIOD->CR1|=(1<<2);
3499  0319 72145012      	bset	20498,#2
3500                     ; 310 	GPIOD->CR2|=(1<<2);
3502  031d 72145013      	bset	20499,#2
3503                     ; 311 	GPIOD->ODR&=~(1<<2);
3505  0321 7215500f      	bres	20495,#2
3506                     ; 313 	GPIOD->DDR|=(1<<4);
3508  0325 72185011      	bset	20497,#4
3509                     ; 314 	GPIOD->CR1|=(1<<4);
3511  0329 72185012      	bset	20498,#4
3512                     ; 315 	GPIOD->CR2&=~(1<<4);
3514  032d 72195013      	bres	20499,#4
3515                     ; 317 	GPIOC->DDR&=~(1<<4);
3517  0331 7219500c      	bres	20492,#4
3518                     ; 318 	GPIOC->CR1&=~(1<<4);
3520  0335 7219500d      	bres	20493,#4
3521                     ; 319 	GPIOC->CR2&=~(1<<4);
3523  0339 7219500e      	bres	20494,#4
3524                     ; 321 	GPIOB->DDR|=(1<<5);
3526  033d 721a5007      	bset	20487,#5
3527                     ; 322 	GPIOB->CR1|=(1<<5);
3529  0341 721a5008      	bset	20488,#5
3530                     ; 323 	GPIOB->CR2&=~(1<<5);
3532  0345 721b5009      	bres	20489,#5
3533                     ; 326 }
3536  0349 81            	ret
3573                     ; 335 @far @interrupt void TIM4_UPD_Interrupt (void) 
3573                     ; 336 {
3575                     	switch	.text
3576  034a               f_TIM4_UPD_Interrupt:
3580                     ; 367 	TIM2->CCR3H= 0x00;	
3582  034a 725f5315      	clr	21269
3583                     ; 368 	TIM2->CCR3L= 0x7f;//pwm_fade_in;
3585  034e 357f5316      	mov	21270,#127
3586                     ; 402 if(but_block_cnt)but_on_drv_cnt=0;
3588  0352 be04          	ldw	x,_but_block_cnt
3589  0354 2702          	jreq	L5502
3592  0356 3fb9          	clr	_but_on_drv_cnt
3593  0358               L5502:
3594                     ; 403 if((((GPIOC->IDR)&(1<<4))) && (but_on_drv_cnt<100)) 
3596  0358 c6500b        	ld	a,20491
3597  035b a510          	bcp	a,#16
3598  035d 272c          	jreq	L7502
3600  035f b6b9          	ld	a,_but_on_drv_cnt
3601  0361 a164          	cp	a,#100
3602  0363 2426          	jruge	L7502
3603                     ; 405 	but_on_drv_cnt++;
3605  0365 3cb9          	inc	_but_on_drv_cnt
3606                     ; 406 	if((but_on_drv_cnt>10)&&(bRELEASE))
3608  0367 b6b9          	ld	a,_but_on_drv_cnt
3609  0369 a10b          	cp	a,#11
3610  036b 2524          	jrult	L5602
3612                     	btst	_bRELEASE
3613  0372 241d          	jruge	L5602
3614                     ; 408 		bRELEASE=0;
3616  0374 72110001      	bres	_bRELEASE
3617                     ; 409 		bSTART=1;
3619  0378 72100000      	bset	_bSTART
3620                     ; 410 		if((!rele_stat_bell_cnt) && (!rele_stat_enable_cnt))	rele_stat_bell_cnt=30;
3622  037c be02          	ldw	x,_rele_stat_bell_cnt
3623  037e 2611          	jrne	L5602
3625  0380 be00          	ldw	x,_rele_stat_enable_cnt
3626  0382 260d          	jrne	L5602
3629  0384 ae001e        	ldw	x,#30
3630  0387 bf02          	ldw	_rele_stat_bell_cnt,x
3631  0389 2006          	jra	L5602
3632  038b               L7502:
3633                     ; 416 	but_on_drv_cnt=0;
3635  038b 3fb9          	clr	_but_on_drv_cnt
3636                     ; 417 	bRELEASE=1;
3638  038d 72100001      	bset	_bRELEASE
3639  0391               L5602:
3640                     ; 420 if(++t0_cnt0>=125)
3642  0391 3c00          	inc	_t0_cnt0
3643  0393 b600          	ld	a,_t0_cnt0
3644  0395 a17d          	cp	a,#125
3645  0397 2530          	jrult	L7602
3646                     ; 422   t0_cnt0=0;
3648  0399 3f00          	clr	_t0_cnt0
3649                     ; 423   b100Hz=1;
3651  039b 72100009      	bset	_b100Hz
3652                     ; 425 	if(++t0_cnt1>=10)
3654  039f 3c01          	inc	_t0_cnt1
3655  03a1 b601          	ld	a,_t0_cnt1
3656  03a3 a10a          	cp	a,#10
3657  03a5 2506          	jrult	L1702
3658                     ; 427 		t0_cnt1=0;
3660  03a7 3f01          	clr	_t0_cnt1
3661                     ; 428 		b10Hz=1;
3663  03a9 72100008      	bset	_b10Hz
3664  03ad               L1702:
3665                     ; 431 	if(++t0_cnt2>=20)
3667  03ad 3c02          	inc	_t0_cnt2
3668  03af b602          	ld	a,_t0_cnt2
3669  03b1 a114          	cp	a,#20
3670  03b3 2506          	jrult	L3702
3671                     ; 433 		t0_cnt2=0;
3673  03b5 3f02          	clr	_t0_cnt2
3674                     ; 434 		b5Hz=1;
3676  03b7 72100007      	bset	_b5Hz
3677  03bb               L3702:
3678                     ; 437 	if(++t0_cnt3>=100)
3680  03bb 3c03          	inc	_t0_cnt3
3681  03bd b603          	ld	a,_t0_cnt3
3682  03bf a164          	cp	a,#100
3683  03c1 2506          	jrult	L7602
3684                     ; 439 		t0_cnt3=0;
3686  03c3 3f03          	clr	_t0_cnt3
3687                     ; 440 		b1Hz=1;
3689  03c5 72100006      	bset	_b1Hz
3690  03c9               L7602:
3691                     ; 444 TIM4->SR1&=~TIM4_SR1_UIF;			// disable break interrupt
3693  03c9 72115344      	bres	21316,#0
3694                     ; 445 return;
3697  03cd 80            	iret
3723                     ; 449 @far @interrupt void UARTTxInterrupt (void) {
3724                     	switch	.text
3725  03ce               f_UARTTxInterrupt:
3729                     ; 451 	if (tx_counter){
3731  03ce 3d24          	tnz	_tx_counter
3732  03d0 271a          	jreq	L7012
3733                     ; 452 		--tx_counter;
3735  03d2 3a24          	dec	_tx_counter
3736                     ; 453 		UART1->DR=tx_buffer[tx_rd_index];
3738  03d4 5f            	clrw	x
3739  03d5 b622          	ld	a,_tx_rd_index
3740  03d7 2a01          	jrpl	L06
3741  03d9 53            	cplw	x
3742  03da               L06:
3743  03da 97            	ld	xl,a
3744  03db e604          	ld	a,(_tx_buffer,x)
3745  03dd c75231        	ld	21041,a
3746                     ; 454 		if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
3748  03e0 3c22          	inc	_tx_rd_index
3749  03e2 b622          	ld	a,_tx_rd_index
3750  03e4 a150          	cp	a,#80
3751  03e6 260c          	jrne	L3112
3754  03e8 3f22          	clr	_tx_rd_index
3755  03ea 2008          	jra	L3112
3756  03ec               L7012:
3757                     ; 457 		bOUT_FREE=1;
3759  03ec 72100004      	bset	_bOUT_FREE
3760                     ; 458 		UART1->CR2&= ~UART1_CR2_TIEN;
3762  03f0 721f5235      	bres	21045,#7
3763  03f4               L3112:
3764                     ; 460 }
3767  03f4 80            	iret
3796                     ; 463 @far @interrupt void UARTRxInterrupt (void) {
3797                     	switch	.text
3798  03f5               f_UARTRxInterrupt:
3802                     ; 468 	rx_status=UART1->SR;
3804  03f5 555230000a    	mov	_rx_status,21040
3805                     ; 469 	rx_data=UART1->DR;
3807  03fa 5552310009    	mov	_rx_data,21041
3808                     ; 471 	if (rx_status & (UART1_SR_RXNE)){
3810  03ff b60a          	ld	a,_rx_status
3811  0401 a520          	bcp	a,#32
3812  0403 272c          	jreq	L5212
3813                     ; 472 		rx_buffer[rx_wr_index]=rx_data;
3815  0405 be1e          	ldw	x,_rx_wr_index
3816  0407 b609          	ld	a,_rx_data
3817  0409 e754          	ld	(_rx_buffer,x),a
3818                     ; 473 		bRXIN=1;
3820  040b 72100003      	bset	_bRXIN
3821                     ; 474 		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
3823  040f be1e          	ldw	x,_rx_wr_index
3824  0411 1c0001        	addw	x,#1
3825  0414 bf1e          	ldw	_rx_wr_index,x
3826  0416 a30064        	cpw	x,#100
3827  0419 2603          	jrne	L7212
3830  041b 5f            	clrw	x
3831  041c bf1e          	ldw	_rx_wr_index,x
3832  041e               L7212:
3833                     ; 475 		if (++rx_counter == RX_BUFFER_SIZE){
3835  041e be20          	ldw	x,_rx_counter
3836  0420 1c0001        	addw	x,#1
3837  0423 bf20          	ldw	_rx_counter,x
3838  0425 a30064        	cpw	x,#100
3839  0428 2607          	jrne	L5212
3840                     ; 476 			rx_counter=0;
3842  042a 5f            	clrw	x
3843  042b bf20          	ldw	_rx_counter,x
3844                     ; 477 			rx_buffer_overflow=1;
3846  042d 72100002      	bset	_rx_buffer_overflow
3847  0431               L5212:
3848                     ; 480 }
3851  0431 80            	iret
3887                     ; 486 main()
3887                     ; 487 {
3889                     	switch	.text
3890  0432               _main:
3894                     ; 488 CLK->CKDIVR=0;
3896  0432 725f50c6      	clr	20678
3897                     ; 490 rele_cnt_index=0;
3899  0436 3fbb          	clr	_rele_cnt_index
3900                     ; 492 GPIOD->DDR&=~(1<<6);
3902  0438 721d5011      	bres	20497,#6
3903                     ; 493 GPIOD->CR1|=(1<<6);
3905  043c 721c5012      	bset	20498,#6
3906                     ; 494 GPIOD->CR2|=(1<<6);
3908  0440 721c5013      	bset	20499,#6
3909                     ; 496 GPIOD->DDR|=(1<<5);
3911  0444 721a5011      	bset	20497,#5
3912                     ; 497 GPIOD->CR1|=(1<<5);
3914  0448 721a5012      	bset	20498,#5
3915                     ; 498 GPIOD->CR2|=(1<<5);	
3917  044c 721a5013      	bset	20499,#5
3918                     ; 499 GPIOD->ODR|=(1<<5);
3920  0450 721a500f      	bset	20495,#5
3921                     ; 501 delay_ms(10);
3923  0454 ae000a        	ldw	x,#10
3924  0457 cd007e        	call	_delay_ms
3926                     ; 503 if(!(GPIOD->IDR&=(1<<6))) 
3928  045a c65010        	ld	a,20496
3929  045d a440          	and	a,#64
3930  045f c75010        	ld	20496,a
3931  0462 2606          	jrne	L3412
3932                     ; 505 	rele_cnt_index=1;
3934  0464 350100bb      	mov	_rele_cnt_index,#1
3936  0468 2018          	jra	L5412
3937  046a               L3412:
3938                     ; 509 	GPIOD->ODR&=~(1<<5);
3940  046a 721b500f      	bres	20495,#5
3941                     ; 510 	delay_ms(10);
3943  046e ae000a        	ldw	x,#10
3944  0471 cd007e        	call	_delay_ms
3946                     ; 511 	if(!(GPIOD->IDR&=(1<<6))) 
3948  0474 c65010        	ld	a,20496
3949  0477 a440          	and	a,#64
3950  0479 c75010        	ld	20496,a
3951  047c 2604          	jrne	L5412
3952                     ; 513 		rele_cnt_index=2;
3954  047e 350200bb      	mov	_rele_cnt_index,#2
3955  0482               L5412:
3956                     ; 517 gpio_init();
3958  0482 cd0315        	call	_gpio_init
3960                     ; 524 spi_init();
3962  0485 cd028a        	call	_spi_init
3964                     ; 526 t4_init();
3966  0488 cd0039        	call	_t4_init
3968                     ; 528 FLASH_DUKR=0xae;
3970  048b 35ae5064      	mov	_FLASH_DUKR,#174
3971                     ; 529 FLASH_DUKR=0x56;
3973  048f 35565064      	mov	_FLASH_DUKR,#86
3974                     ; 546 t2_init();
3976  0493 cd0000        	call	_t2_init
3978                     ; 550 enableInterrupts();	
3981  0496 9a            rim
3983  0497               L1512:
3984                     ; 558 	if(b100Hz)
3986                     	btst	_b100Hz
3987  049c 240f          	jruge	L5512
3988                     ; 560 		b100Hz=0;
3990  049e 72110009      	bres	_b100Hz
3991                     ; 562 		if(but_block_cnt)but_block_cnt--;
3993  04a2 be04          	ldw	x,_but_block_cnt
3994  04a4 2707          	jreq	L5512
3997  04a6 be04          	ldw	x,_but_block_cnt
3998  04a8 1d0001        	subw	x,#1
3999  04ab bf04          	ldw	_but_block_cnt,x
4000  04ad               L5512:
4001                     ; 567 	if(b10Hz)
4003                     	btst	_b10Hz
4004  04b2 2407          	jruge	L1612
4005                     ; 569 		b10Hz=0;
4007  04b4 72110008      	bres	_b10Hz
4008                     ; 571 		rele_drv();
4010  04b8 cd004a        	call	_rele_drv
4012  04bb               L1612:
4013                     ; 574 	if(b5Hz)
4015                     	btst	_b5Hz
4016  04c0 2404          	jruge	L3612
4017                     ; 576 		b5Hz=0;
4019  04c2 72110007      	bres	_b5Hz
4020  04c6               L3612:
4021                     ; 582 	if(b1Hz)
4023                     	btst	_b1Hz
4024  04cb 24ca          	jruge	L1512
4025                     ; 585 		b1Hz=0;
4027  04cd 72110006      	bres	_b1Hz
4028  04d1 20c4          	jra	L1512
4474                     	xdef	_main
4475                     	switch	.ubsct
4476  0000               _rele_stat_enable_cnt:
4477  0000 0000          	ds.b	2
4478                     	xdef	_rele_stat_enable_cnt
4479  0002               _rele_stat_bell_cnt:
4480  0002 0000          	ds.b	2
4481                     	xdef	_rele_stat_bell_cnt
4482                     .bit:	section	.data,bit
4483  0000               _bSTART:
4484  0000 00            	ds.b	1
4485                     	xdef	_bSTART
4486  0001               _bRELEASE:
4487  0001 00            	ds.b	1
4488                     	xdef	_bRELEASE
4489  0002               _rx_buffer_overflow:
4490  0002 00            	ds.b	1
4491                     	xdef	_rx_buffer_overflow
4492  0003               _bRXIN:
4493  0003 00            	ds.b	1
4494                     	xdef	_bRXIN
4495  0004               _bOUT_FREE:
4496  0004 00            	ds.b	1
4497                     	xdef	_bOUT_FREE
4498  0005               _play:
4499  0005 00            	ds.b	1
4500                     	xdef	_play
4501  0006               _b1Hz:
4502  0006 00            	ds.b	1
4503                     	xdef	_b1Hz
4504  0007               _b5Hz:
4505  0007 00            	ds.b	1
4506                     	xdef	_b5Hz
4507  0008               _b10Hz:
4508  0008 00            	ds.b	1
4509                     	xdef	_b10Hz
4510  0009               _b100Hz:
4511  0009 00            	ds.b	1
4512                     	xdef	_b100Hz
4513                     	switch	.ubsct
4514  0004               _but_block_cnt:
4515  0004 0000          	ds.b	2
4516                     	xdef	_but_block_cnt
4517                     	xdef	_memory_manufacturer
4518                     	xdef	_rele_cnt_const
4519                     	xdef	_rele_cnt_index
4520                     	xdef	_pwm_fade_in
4521  0006               _rx_offset:
4522  0006 00            	ds.b	1
4523                     	xdef	_rx_offset
4524  0007               _rele_cnt:
4525  0007 0000          	ds.b	2
4526                     	xdef	_rele_cnt
4527  0009               _rx_data:
4528  0009 00            	ds.b	1
4529                     	xdef	_rx_data
4530  000a               _rx_status:
4531  000a 00            	ds.b	1
4532                     	xdef	_rx_status
4533  000b               _file_lengt:
4534  000b 00000000      	ds.b	4
4535                     	xdef	_file_lengt
4536  000f               _current_byte_in_buffer:
4537  000f 0000          	ds.b	2
4538                     	xdef	_current_byte_in_buffer
4539  0011               _last_page:
4540  0011 0000          	ds.b	2
4541                     	xdef	_last_page
4542  0013               _current_page:
4543  0013 0000          	ds.b	2
4544                     	xdef	_current_page
4545  0015               _file_lengt_in_pages:
4546  0015 0000          	ds.b	2
4547                     	xdef	_file_lengt_in_pages
4548  0017               _mdr3:
4549  0017 00            	ds.b	1
4550                     	xdef	_mdr3
4551  0018               _mdr2:
4552  0018 00            	ds.b	1
4553                     	xdef	_mdr2
4554  0019               _mdr1:
4555  0019 00            	ds.b	1
4556                     	xdef	_mdr1
4557  001a               _mdr0:
4558  001a 00            	ds.b	1
4559                     	xdef	_mdr0
4560                     	xdef	_but_on_drv_cnt
4561                     	xdef	_but_drv_cnt
4562  001b               _sample:
4563  001b 00            	ds.b	1
4564                     	xdef	_sample
4565  001c               _rx_rd_index:
4566  001c 0000          	ds.b	2
4567                     	xdef	_rx_rd_index
4568  001e               _rx_wr_index:
4569  001e 0000          	ds.b	2
4570                     	xdef	_rx_wr_index
4571  0020               _rx_counter:
4572  0020 0000          	ds.b	2
4573                     	xdef	_rx_counter
4574                     	xdef	_rx_buffer
4575  0022               _tx_rd_index:
4576  0022 00            	ds.b	1
4577                     	xdef	_tx_rd_index
4578  0023               _tx_wr_index:
4579  0023 00            	ds.b	1
4580                     	xdef	_tx_wr_index
4581  0024               _tx_counter:
4582  0024 00            	ds.b	1
4583                     	xdef	_tx_counter
4584                     	xdef	_tx_buffer
4585  0025               _sample_cnt:
4586  0025 0000          	ds.b	2
4587                     	xdef	_sample_cnt
4588                     	xdef	_t0_cnt3
4589                     	xdef	_t0_cnt2
4590                     	xdef	_t0_cnt1
4591                     	xdef	_t0_cnt0
4592                     	xdef	_uart_in_an
4593                     	xdef	_gpio_init
4594                     	xdef	_spi_init
4595                     	xdef	_spi
4596                     	xdef	_uart_init
4597                     	xdef	f_UARTRxInterrupt
4598                     	xdef	f_UARTTxInterrupt
4599                     	xdef	_putchar
4600                     	xdef	_uart_out_adr_block
4601                     	xdef	_uart_out
4602                     	xdef	f_TIM4_UPD_Interrupt
4603                     	xdef	_delay_ms
4604                     	xdef	_rele_drv
4605                     	xdef	_t4_init
4606                     	xdef	_t2_init
4607                     	xref.b	c_x
4608                     	xref.b	c_y
4628                     	xref	c_lgursh
4629                     	xref	c_lcmp
4630                     	xref	c_ltor
4631                     	xref	c_lgadc
4632                     	xref	c_rtol
4633                     	xref	c_vmul
4634                     	end
