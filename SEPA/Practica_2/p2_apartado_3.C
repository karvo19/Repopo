
//#define PART_TM4C1294NCPDT
#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "inc/hw_gpio.h"
#include "inc/tm4c1294ncpdt.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "inc/tm4c1294ncpdt.h"
#include "driverlib/pin_map.h"
#include "driverlib/pwm.h"
#include "driverlib/interrupt.h"
#include "driverlib/timer.h"


/***********************************
 * Manejo de un motor paso a paso conectado en el boosterpack 1 (pines PK4, PK5, PM0, PG1)
 * donde se simula un segundero de un reloj. Puesto que los pasos del motor usado no son
 * divisibles entre 60, se hacen los ajustes necesarios al estilo de los años bisiestos,
 * es decir, sumando pasos extra para cubrir los decimales cada vez que pasamos por los cuartos
 * de minuto. Ademas se alterna entre 8 y pasos cada segundo.
 *************************************/

#define MSEC 40000
#define MaxEst 10

// Puertos necesarios (agrupados para facilitar el codigo)
uint32_t Puerto[]={
        GPIO_PORTK_BASE,
        GPIO_PORTK_BASE,
        GPIO_PORTM_BASE,
        GPIO_PORTG_BASE,

};
// Pines usados (agrupados para facilitar el codigo)
uint32_t Pin[]={
        GPIO_PIN_4,
        GPIO_PIN_5,
        GPIO_PIN_0,
        GPIO_PIN_1,
        };

// Secuencia de activacion de los pines para avanzar un paso (antihorario)
int Step[4][4]={0,1,0,0,
                0,0,1,0,
                0,0,0,1,
                1,0,0,0
};

#define B1_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0)
#define B1_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0))
#define B2_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1)
#define B2_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1))



int RELOJ;

// Variables para controlar el movimiento y la posicion del motor
volatile int secuencia = 0;
int paso = 0;

volatile int t_5ms = 0;
volatile int mov = 0;
volatile int aux = 0;
volatile int segundos = 0;
volatile int descuadre = 0;

#define FREC 200 //Frecuencia en hercios del tren de pulsos: 5ms


// Rutina de interrupcion del timer (cada 5 ms)
void IntTimer(void)
{
    int i;

    t_5ms ++;

    // Cuando pasa un segundo actualizamos las variables y damos los pasos necesarios
    if(t_5ms == 200)
    {
        mov = 1;
        t_5ms = 0;
        segundos ++;
        if(segundos == 60)
            segundos = 0;
        //Comprobamos si toca dar un paso extra para compensar los decimales
        if(!(segundos%15))
            descuadre = 1;
    }

    if(mov == 1 || descuadre == 1){
        // Damos los pasos al reves para que sean en sentido horario: secuencia --;
        secuencia --;
        if(secuencia==-1) secuencia=3;

        // Damos el paso siguiente
        for(i = 0; i < 4; i ++)
            GPIOPinWrite(Puerto[i],Pin[i],Pin[i]*Step[secuencia][i]);

        // Contabilizamos el paso dado
        paso ++;
        // Si el paso recien dado era para descuadrar, no debemos contabilizarlo
        if(descuadre == 1)
        {
            descuadre = 0;
            paso --;
        }
        // Dejamos de movernos si hemos dado los pasos necesarios para marcar el segundo
        if(paso == (8 + aux))
        {
            paso = 0;
            // Variable que alterna entre 0 y 1 para dar un paso mas de forma alternada cada segundo
            aux ^= 1;
            mov = 0;
        }
    }
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
}



int main(void)
{
	RELOJ=SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_480), 120000000);

	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOK);
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOJ);
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOG);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOM);


    SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);       //Habilita T0
    TimerClockSourceSet(TIMER0_BASE, TIMER_CLOCK_SYSTEM);   //T0 a 120MHz
    TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC);    //T0 periodico y conjunto (32b)
    TimerLoadSet(TIMER0_BASE, TIMER_A, 600000 - 1);     // Configuramos las interrupciones cada 5 ms
    TimerIntRegister(TIMER0_BASE,TIMER_A,IntTimer);

    IntEnable(INT_TIMER0A); //Habilitar las interrupciones globales de los timers

    TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);    // Habilitar las interrupciones de timeout
    IntMasterEnable();  //Habilitacion global de interrupciones

    TimerEnable(TIMER0_BASE, TIMER_A);  //Habilitar Timer0, 1, 2A y 2B


    GPIOPinTypeGPIOInput(GPIO_PORTJ_BASE, GPIO_PIN_0|GPIO_PIN_1);
    GPIOPadConfigSet(GPIO_PORTJ_BASE,GPIO_PIN_0|GPIO_PIN_1,GPIO_STRENGTH_2MA,GPIO_PIN_TYPE_STD_WPU);

    GPIOPinTypeGPIOOutput(GPIO_PORTK_BASE, GPIO_PIN_4|GPIO_PIN_5);
    GPIOPinTypeGPIOOutput(GPIO_PORTG_BASE, GPIO_PIN_1);
    GPIOPinTypeGPIOOutput(GPIO_PORTM_BASE, GPIO_PIN_0);

    // Configuracion del modo bajo consumo
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_TIMER0);  // Timer 0

    SysCtlPeripheralClockGating(true);                   //Habilitar el apagado selectivo de periféricos



	while(1){
	    // Estamos siempre en bajo consumo menos cuando se produce una interrupcion
	    SysCtlSleep();
	}
	return 0;
}
