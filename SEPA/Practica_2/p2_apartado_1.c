#include <stdint.h>
#include <stdbool.h>

#include "driverlib2.h"

/***********************************
 Manejo del servomotor mediante pwm, interrupciones y modos de bajo consumo.
 El micro se encuentra en modo bajo consumo, solo con el pwm y
 los botones habilitados, y cuando estos ultimos producen una interrupcion,
 se activa el  timer para que cuente un segundo y luego vuelve a dormirse.

 *************************************/

#define MSEC 40000
#define MaxEst 10


#define B1_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0)
#define B1_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0))
#define B2_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1)
#define B2_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1))


volatile int Max_pos = 4200; //3750
volatile int Min_pos = 1300; //1875
volatile int Mid_pos;
volatile int pos;

int RELOJ, PeriodoPWM;
int t;

// Rutina de interrupcion para el timer 0 (temporizamos un milisegundo)
void IntTimer0(void)
{
    t++;
    // Si ha pasado un segundo
    if(t >= 1000)
    {
        t = 0;
        // Volvemos a la posicion de reposo
        pos = Mid_pos;
        // Desabilitamos el timer 0 hasta que se vuelva a necesitar
        SysCtlPeripheralSleepDisable(SYSCTL_PERIPH_TIMER0);  // Timer 0
    }
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
}

void rutina_interrupcion(void)
{
    // Habilitamos el timer durante el bajo consumo para temporizar un segundo a partir de este instante
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_TIMER0);  // Timer 0
    if(B1_ON){  //Si se pulsa B1 -> Max_pos
        SysCtlDelay(10*MSEC);
        // Configuramos el pwm para ir hacia la posicion maxima
        pos = Max_pos;
        t = 0;
        GPIOIntClear(GPIO_PORTJ_BASE, GPIO_PIN_0);
    }
    else if(B2_ON){ //Si se pulsa B2 -> Min_pos
        SysCtlDelay(10*MSEC);
        // Configuramos el pwm para ir hacia la posicion minima
        pos = Min_pos;
        t = 0;
        GPIOIntClear(GPIO_PORTJ_BASE, GPIO_PIN_1);
    }
}

int main(void)
{
    // Configuracion del reloj
	RELOJ=SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_480), 120000000);

	// Habilitamos los puertos que vamos a necesitar
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOK);
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOJ);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_PWM0);

    // Configuracion del TIMER
    SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);       //Habilita T0

    TimerClockSourceSet(TIMER0_BASE, TIMER_CLOCK_SYSTEM);   //T0 a 120MHz
    TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC);    //T0 periodico y conjunto (32b)
    TimerLoadSet(TIMER0_BASE, TIMER_A, 120000 - 1);  //Para cada ms

    TimerIntRegister(TIMER0_BASE,TIMER_A,IntTimer0);
    IntEnable(INT_TIMER0A); //Habilitar las interrupciones globales de los timers
    TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);    // Habilitar las interrupciones de timeout
    IntMasterEnable();  //Habilitacion global de interrupciones
    TimerEnable(TIMER0_BASE, TIMER_A);  //Habilitar Timer0, 1A

    // Configuracion del modo bajo consumo
    // Perifericos que deben permanecer encendidos
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_PWM0);    // Modulador PWM
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_GPIOK);   // PWM6
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_GPIOJ);   // Botones

    // El Timer 0 permanece apagado la mayoria del tiempo
    // Habilitaremos el Timer 0 cuando nos convenga
    SysCtlPeripheralSleepDisable(SYSCTL_PERIPH_TIMER0);  // Timer 0
    SysCtlPeripheralClockGating(true);                   //Habilitar el apagado selectivo de periféricos

    // Configuracion de las interrupciones
    GPIOIntEnable(GPIO_PORTJ_BASE, GPIO_PIN_0|GPIO_PIN_1);  //Habilitar pines de interrupción J0, J1
    GPIOIntRegister(GPIO_PORTJ_BASE, rutina_interrupcion);  //Registrar (definir) la rutina de interrupción
    IntEnable(INT_GPIOJ);                                   //Habilitar interrupción del pto J
    IntMasterEnable();                                      //Habilitar globalmente las ints

	PWMClockSet(PWM0_BASE,PWM_SYSCLK_DIV_64);	// al PWM le llega un reloj de 1.875MHz

	GPIOPinConfigure(GPIO_PK4_M0PWM6);			//Configurar el pin a PWM
    GPIOPinTypePWM(GPIO_PORTK_BASE, GPIO_PIN_4);

    // Ponemos resistencias de pull-up en los pulsadores
    GPIOPinTypeGPIOInput(GPIO_PORTJ_BASE, GPIO_PIN_0|GPIO_PIN_1);
    GPIOPadConfigSet(GPIO_PORTJ_BASE,GPIO_PIN_0|GPIO_PIN_1,GPIO_STRENGTH_2MA,GPIO_PIN_TYPE_STD_WPU);

    //Configurar el pwm0, contador descendente y sin sincronización (actualización automática)
    PWMGenConfigure(PWM0_BASE, PWM_GEN_3, PWM_GEN_MODE_DOWN | PWM_GEN_MODE_NO_SYNC);

	PeriodoPWM=37499; // 50Hz  a 1.875MHz

	// Inicializamos la variable del tiempo
	t = 0;

	// Calculamos la posicion media
	Mid_pos = (Max_pos + Min_pos)>>1;

	// Llevamos inicialmente el servo a la posicion central
	pos = Mid_pos;

    PWMGenPeriodSet(PWM0_BASE, PWM_GEN_3, PeriodoPWM); //frec:50Hz
    PWMPulseWidthSet(PWM0_BASE, PWM_OUT_6, Mid_pos); 	//Inicialmente, 1ms

    PWMGenEnable(PWM0_BASE, PWM_GEN_3);		//Habilita el generador 0

    PWMOutputState(PWM0_BASE, PWM_OUT_6_BIT , true);	//Habilita la salida 1

    while(1){
        PWMPulseWidthSet(PWM0_BASE, PWM_OUT_6, pos); // Ejecutamos el movimiento
        SysCtlSleep();                               // Entramos en el modo bajo consumo
    }
	return 0;
}


