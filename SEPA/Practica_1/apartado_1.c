#include <stdint.h>
#include <stdbool.h>

#include "driverlib2.h"
/************************************************************
 * Primer ejemplo de manejo de pines de e/s, usando el HW de la placa
 * Los pines se definen para usar los leds y botones:
 *      LEDS: F0, F4, N0, N1
 *      BOTONES: J0, J1
 * Cuando se pulsa (y se suelta)un bot�n, cambia de estado,
 * entre los definidos en la matriz LED. El primer bot�n incrementa el estado
 * y el segundo lo decrementa. Al llegar al final, se satura.
 ************************************************************/


#define MSEC 40000 //Valor para 1ms con SysCtlDelay() cuando el reloj est� configurado a 120MHz
#define MaxEst 3    //Variable auxiliar para establecer el numero de estados


//Definiciones para facilitar la lectura de los pulsadores
#define B1_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0)
#define B1_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0))
#define B2_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1)
#define B2_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1))


uint32_t reloj=0;


int main(void)
{
    int estado;
    //Fijar velocidad del reloj a 120MHz
    reloj = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_480), 120000000);

    //Habilitar los perif�ricos implicados: GPIO F, J, N
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOJ);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPION);

    //Definir tipo de pines
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_0 |GPIO_PIN_4); //F0 y F4: salidas
    GPIOPinTypeGPIOOutput(GPIO_PORTN_BASE, GPIO_PIN_0 |GPIO_PIN_1); //N0 y N1: salidas
    GPIOPinTypeGPIOInput(GPIO_PORTJ_BASE, GPIO_PIN_0|GPIO_PIN_1);   //J0 y J1: entradas
    GPIOPadConfigSet(GPIO_PORTJ_BASE,GPIO_PIN_0|GPIO_PIN_1,GPIO_STRENGTH_2MA,GPIO_PIN_TYPE_STD_WPU); //Pullup en J0 y J1

    estado = 0; //Inicializacion de la variable de estado

    while(1){
        //Mediante una estructura switch-case ejecutamos la rutina
        //correspondiente al estado en el que nos encontremos
        switch(estado)
        {
        case 0:
            //Encendemos todos los leds y esperamos 100 ms
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, GPIO_PIN_1);
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, GPIO_PIN_0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, GPIO_PIN_4);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, GPIO_PIN_0);
            SysCtlDelay(100*MSEC);

            //Apagamos todos los leds durante 900 ms
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, 0);
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, 0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, 0);
            SysCtlDelay(900*MSEC);
            break;
        case 1:
            //Encendemos el primer led y esperamos 1 segundos
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, GPIO_PIN_1);
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, 0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, 0);
            SysCtlDelay(1000*MSEC);
            //Encendemos el siguiente led y esperamos 1 segundos
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, GPIO_PIN_0);
            SysCtlDelay(1000*MSEC);
            //Encendemos el siguiente led y esperamos 1 segundos
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, GPIO_PIN_4);
            SysCtlDelay(1000*MSEC);
            //Encendemos el ultimo led y esperamos 1 segundos
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, GPIO_PIN_0);
            SysCtlDelay(1000*MSEC);

            //Apagamos los 4 leds y esperamos 3 segundos
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, 0);
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, 0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, 0);
            SysCtlDelay(3000*MSEC);
            break;
        case 2:
            //Encendemos los leds en las posiciones impares durante 500 ms
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, GPIO_PIN_1);
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, GPIO_PIN_4);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, 0);
            SysCtlDelay(500*MSEC);

            //Encendemos los leds en las posiciones pares durante 500 ms
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, 0);
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, GPIO_PIN_0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, 0);
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, GPIO_PIN_0);
            SysCtlDelay(500*MSEC);
            break;
        default: break;
        }

        //Al salir terminar la rutina del estado actual comprobamos si hay algun boton
        //pulsado y lo gestionamos de ser as� actualizando consecuentemente el estado
        if(!(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0))){     //Si se aprieta el boton 1
            SysCtlDelay(10*MSEC);
            while(!(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0)));  //Debouncing...
            SysCtlDelay(10*MSEC);
            estado++; if(estado==MaxEst) estado=0;       //Incrementa el estado. Si m�ximo, vuelve a cero
        }
        if( !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1))){        //Si se aprieta el bot�n 2
            SysCtlDelay(10*MSEC);
            while( !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1))); //Debouncing..
            SysCtlDelay(10*MSEC);
            estado--; if(estado==-1) estado=MaxEst - 1;      //Decrementa el estado. Si menor que cero, salta a Max.
        }

    }
}
