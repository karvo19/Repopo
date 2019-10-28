#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>
#include "driverlib2.h"

// #include "HAL_I2C.h"
#include "utils/uartstdio.h"

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

// Variables para la monitorizacion
volatile int horas,minutos,segundos,milisegundos;
volatile int A,B;
char string[120];
volatile int aux;

int RELOJ, PeriodoPWM;
int t;

// Rutina de interrupcion para el timer 0 (temporizamos un segundo)
void IntTimer0(void)
{
    t++;
    milisegundos ++;
    if (milisegundos >= 1000)
    {
        milisegundos = 0;
        segundos ++;
        if (segundos == 60)
        {
            segundos = 0;
            minutos ++;
            if (minutos == 60)
            {
                minutos = 0;
                horas ++;
            }
        }
    }

    // Si ha pasado un segundo
    if(t >= 1000)
    {
        t = 0;
        // Volvemos a la posicion de reposo
        pos = Mid_pos;
        // Desabilitamos el timer 0 hasta que se vuelva a necesitar
    }
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
}

void rutina_interrupcion(void)
{
    aux = 0;
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_TIMER0);  // Timer 0
    if(B1_ON){  //Si se pulsa B1 -> Max_pos
        SysCtlDelay(10*MSEC);
        // Configuramos el pwm para ir hacia la posicion maxima
        pos = Max_pos;
        t = 0;
        A ++;
        GPIOIntClear(GPIO_PORTJ_BASE, GPIO_PIN_0);
    }
    else if(B2_ON){ //Si se pulsa B2 -> Min_pos
        SysCtlDelay(10*MSEC);
        // Configuramos el pwm para ir hacia la posicion minima
        pos = Min_pos;
        t = 0;
        B ++;
        //sprintf(string,"%d piezas tipo A / %d piezas tipo B\n\n",A, B);
        //UARTprintf(string);
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
    // Como ahora hay que monitorizar el tiempo en el que llega cada pieza, el timer 0 debe permanecer encendido
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_PWM0);    // Modulador PWM
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_GPIOK);   // PWM6
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_GPIOJ);   // Botones
    SysCtlPeripheralSleepEnable(SYSCTL_PERIPH_TIMER0);  // Timer 0

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


    // Configuracion de la uart para la monitorizacion
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);
    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    UARTStdioConfig(0, 115200, RELOJ);

    /*if(Detecta_BP(1))
    {
        UARTprintf("\n--------------------------------------");
        UARTprintf("\n  BOOSTERPACK detectado en posicion 1");
        UARTprintf("\n   Configurando puerto I2C0");
        UARTprintf("\n--------------------------------------");
        Conf_Boosterpack(1, RELOJ);
    }
    else if(Detecta_BP(2))
    {
        UARTprintf("\n--------------------------------------");
        UARTprintf("\n  BOOSTERPACK detectado en posicion 2");
        UARTprintf("\n   Configurando puerto I2C2");
        UARTprintf("\n--------------------------------------");
        Conf_Boosterpack(2, RELOJ);
    }
    else
    {
        UARTprintf("\n--------------------------------------");
        UARTprintf("\n  Ningun BOOSTERPACK detectado   :-/  ");
        UARTprintf("\n              Saliendo");
        UARTprintf("\n--------------------------------------");
        return 0;
    }*/



    PeriodoPWM=37499; // 50Hz  a 1.875MHz

    // Inicializamos la variable del tiempo
    t = 0;

    A = 0;
    B = 0;
    // Reseteamos las variables temporales
    horas = 0;
    minutos = 0;
    segundos = 0;
    milisegundos = 0;
    aux = 0;

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
        if(pos == Max_pos && aux == 0)
        {
            sprintf(string,"[%d:%d:%d] Pieza tipo A detectada. \n %d piezas tipo A / %d piezas tipo B \n \n",horas, minutos, segundos, A, B);
            UARTprintf(string);
            aux = 1;
        }
        if(pos == Min_pos && aux == 0)
        {
            sprintf(string,"[%d:%d:%d] Pieza tipo B detectada. \n %d piezas tipo A / %d piezas tipo B \n \n",horas, minutos, segundos, A, B);
            UARTprintf(string);
            aux = 1;
        }
        SysCtlSleep();                               // Entramos en el modo bajo consumo
    }
    return 0;
}


