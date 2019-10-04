#include <stdint.h>
#include <stdbool.h>

#include "driverlib2.h"
/************************************************************
 * Este código es una modificación de la "Variante del EJ2, pero
 * manejando los pines por interrupción".
 *
 * Ahora se mejora el comportamiento respecto al apartado anterior
 * gracias al uso de interrupciones para gestionar la pulsación de
 * los botones en el instante en que el usuario las lleva a cabo
 ************************************************************/


#define MSEC 40000 //Valor para 1ms con SysCtlDelay()
#define MaxEst 3    //Variable auxiliar para establecer el numero de estados


//Definiciones para facilitar la lectura de los pulsadores
#define B1_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0)
#define B1_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0))
#define B2_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1)
#define B2_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1))


uint32_t reloj=0;
int estado;


/*********************************************************
 * Rutina de interrupción del puerto J.
 * Leo los pines, y en cada caso hago la función necesaria,
 * (incrementar o decrementar el estado)
 * Establezco 20ms de debouncing en cada caso
 * Y debo borrar el flag de interrupción al final.
 ********************************************************/
void rutina_interrupcion(void)
{
    if(B1_ON)
    {
        //Esperamos a que se suelte el boton
        while(B1_ON);
        //Debouncing
        SysCtlDelay(20*MSEC);
        //Actualizamos el estado
        estado++;
        if(estado==MaxEst) estado=0;
        //Borramos el flag de interrupsión
        GPIOIntClear(GPIO_PORTJ_BASE, GPIO_PIN_0);
    }
    if(B2_ON)
      {
        //Esperamos a que se suelte el boton
          while(B2_ON);
          //Debouncing
          SysCtlDelay(20*MSEC);
          //Actualizamos el estado
          estado--; if(estado==-1) estado=MaxEst - 1;
          //Borramos el flag de interrupsión
          GPIOIntClear(GPIO_PORTJ_BASE, GPIO_PIN_1);
      }

}


int main(void)
{
    int estado_ant;
    //Fijar velocidad a 120MHz
    reloj=SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_480), 120000000);

    //Habilitar los periféricos implicados: GPIO F, J, N
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOJ);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPION);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);

    //Definir tipo de pines
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_0 |GPIO_PIN_4); //F0 y F4: salidas
    GPIOPinTypeGPIOOutput(GPIO_PORTN_BASE, GPIO_PIN_0 |GPIO_PIN_1); //N0 y N1: salidas
    GPIOPinTypeGPIOInput(GPIO_PORTJ_BASE, GPIO_PIN_0|GPIO_PIN_1);   //J0 y J1: entradas
    GPIOPadConfigSet(GPIO_PORTJ_BASE,GPIO_PIN_0|GPIO_PIN_1,GPIO_STRENGTH_2MA,GPIO_PIN_TYPE_STD_WPU); //Pullup en J0 y J1

    //Inicializacion de las variables de estado.
    estado=0;
    estado_ant=0;

    GPIOIntEnable(GPIO_PORTJ_BASE, GPIO_PIN_0|GPIO_PIN_1);  // Habilitar pines de interrupción J0, J1
    GPIOIntRegister(GPIO_PORTJ_BASE, rutina_interrupcion);  //Registrar (definir) la rutina de interrupción
    IntEnable(INT_GPIOJ);                                   //Habilitar interrupción del pto J
    IntMasterEnable();                                      // Habilitar globalmente las ints

    while(1){

        if(estado != estado_ant)  //Para no estar continuamente accediendo a los puertos...
        {
            estado_ant=estado;
        }
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
    }
}
