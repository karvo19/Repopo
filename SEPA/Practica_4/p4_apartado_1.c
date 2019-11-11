#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_types.h"
#include "inc/hw_memmap.h"
#include "inc/hw_gpio.h"
#include "driverlib/ssi.h"
#include "driverlib/sysctl.h"
#include "driverlib/pin_map.h"
#include "driverlib/rom_map.h"
#include "driverlib/gpio.h"
#include "FT800_TIVA.h"

#include "driverlib2.h"


//Definiciones para facilitar la lectura de los pulsadores
#define B1_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0)
#define B1_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_0))
#define B2_OFF GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1)
#define B2_ON !(GPIOPinRead(GPIO_PORTJ_BASE,GPIO_PIN_1))


#define dword long
#define byte char


#define MSEC 40000

// Variables para el uso de la pantalla tactil
char chipid = 0;                        // Holds value of Chip ID read from the FT800

unsigned long cmdBufferRd = 0x00000000;         // Store the value read from the REG_CMD_READ register
unsigned long cmdBufferWr = 0x00000000;         // Store the value read from the REG_CMD_WRITE register
unsigned int t=0;


int Fin_Rx = 0;
char Buffer_Rx;
unsigned long POSX, POSY, BufferXY;
unsigned long POSYANT = 0;
unsigned int CMD_Offset = 0;
unsigned long REG_TT[6];
const unsigned long REG_CAL[6]={21959,177,4294145463,14,4294950369,16094853};


#define NUM_SSI_DATA            3

int RELOJ;

// Variables auxiliares para los botones
volatile int B1press = 0, B2press = 0;


// Rutina de interrupcion de los botones
void rutina_interrupcion(void)
{
    if(B1_ON){  //Si se pulsa B1 -> Max_pos
        SysCtlDelay(10*MSEC);
        B1press = 1;
        GPIOIntClear(GPIO_PORTJ_BASE, GPIO_PIN_0);
    }
    else if(B2_ON){ //Si se pulsa B2 -> Min_pos
        SysCtlDelay(10*MSEC);
        B2press = 1;
        GPIOIntClear(GPIO_PORTJ_BASE, GPIO_PIN_1);
    }
}

int main(void)
{
    int i;

    RELOJ = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_480), 120000000);

    HAL_Init_SPI(2, RELOJ);  //Boosterpack a usar, Velocidad del MC

    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOJ);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPION);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);

    // Configuracion de los leds
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_0 |GPIO_PIN_4); //F0 y F4: salidas
    GPIOPinTypeGPIOOutput(GPIO_PORTN_BASE, GPIO_PIN_0 |GPIO_PIN_1); //N0 y N1: salidas

    // Ponemos resistencias de pull-up en los pulsadores
    GPIOPinTypeGPIOInput(GPIO_PORTJ_BASE, GPIO_PIN_0|GPIO_PIN_1);
    GPIOPadConfigSet(GPIO_PORTJ_BASE,GPIO_PIN_0|GPIO_PIN_1,GPIO_STRENGTH_2MA,GPIO_PIN_TYPE_STD_WPU);


    // Configuracion de las interrupciones en los pulsadores
    GPIOIntEnable(GPIO_PORTJ_BASE, GPIO_PIN_0|GPIO_PIN_1);  //Habilitar pines de interrupción J0, J1
    GPIOIntRegister(GPIO_PORTJ_BASE, rutina_interrupcion);  //Registrar (definir) la rutina de interrupción
    IntEnable(INT_GPIOJ);                                   //Habilitar interrupción del pto J
    IntMasterEnable();                                      //Habilitar globalmente las ints


    Inicia_pantalla();
    // Note: Keep SPI below 11MHz here

    // =======================================================================
    // Delay before we begin to display anything
    // =======================================================================

    SysCtlDelay(RELOJ/3);

    // ================================================================================================================
    // PANTALLA INICIAL
    // ================================================================================================================


    // Borramos la pantalla y la rellenamos del color indicado (gris)
    Nueva_pantalla(0x10,0x10,0x10);

    // Marco rectangular anaranjado al filo de la pantalla
    ComColor(255,160,6);
    ComLineWidth(5);
    Comando(CMD_BEGIN_RECTS);
    ComVertex2ff(10,10);
    ComVertex2ff(310,230);

    // Hacemos un rectangulo verde que hará las veces de fondo
    ComColor(65,202,42);
    ComVertex2ff(12,12);
    ComVertex2ff(308,228);
    Comando(CMD_END);

    // Imprimimos texto informativo inicial
    ComColor(0xff,0xff,0xff);
    ComTXT(160,50, 22, OPT_CENTERX,"PRACTICA 4 APARTADO 1");
    ComTXT(160,100, 22, OPT_CENTERX," SEPA GIERM. 2019 ");
    ComTXT(160,150, 20, OPT_CENTERX,"BOTONES");

    // Pintamos cuatro rectangulos blancos para hacer un marco alrededor del texto
    Comando(CMD_BEGIN_LINES);
    ComVertex2ff(40,40);
    ComVertex2ff(280,40);
    ComVertex2ff(280,40);
    ComVertex2ff(280,200);
    ComVertex2ff(280,200);
    ComVertex2ff(40,200);
    ComVertex2ff(40,200);
    ComVertex2ff(40,40);
    Comando(CMD_END);

    // Comando para proceder a pintar por pantalla
    Dibuja();

    // Esperamos a que alguien toque la pantalla para continuar
    Espera_pant();

    for(i=0;i<6;i++)	Esc_Reg(REG_TOUCH_TRANSFORM_A+4*i, REG_CAL[i]);

    while(1)
    {
        // Lee la posicion del dedo y la escribe en dos var globales x e y
        Lee_pantalla();

        // Borramos el contenido de la pantalla y lo rellenamos de gris
        Nueva_pantalla(0x10,0x10,0x10);

        // Pintamos un gradiente de claro a oscuro en el fondo
        ComGradient(0,0,GRIS_CLARO,0,240,GRIS_OSCURO);

        // Pintamos rectangulo rojo del fondo
        ComColor(0xff,0x00,0x00);
        Comando(CMD_BEGIN_RECTS);
        ComVertex2ff(5,5);
        ComVertex2ff(315,235);
        Comando(CMD_END);

        // Pintamos el rectangulo blanco para el texto
        ComColor(0xFF,0xFF,0xFF);
        Comando(CMD_BEGIN_RECTS);
        ComVertex2ff(30,70);
        ComVertex2ff(290,100);
        Comando(CMD_END);

        // Texto "BOTONES" sobre el cuadro blanco del texto
        ComColor(0x00,0x00,0x00);
        ComTXT(160,30, 22, OPT_CENTERX,"BOTONES:");

        // Botones tactiles, apretados o no en funcion de la posicion actual del dedo
        ComColor(0xff,0xff,0xff);
        if(POSX>30 && POSX<80 && POSY>150 && POSY<200) // Boton 1
        {
            // Pitamos el boton apretado
            ComButton(30,150,50,50,20,256,"B1");
            // Encendemos el led 1
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, GPIO_PIN_0);
        }
        else
        {
            // Pintamos el boton sin pulsar
            ComButton(30,150,50,50,20,0,"B1");
            // Apagamos el led 1
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_0, 0);
        }
        if(POSX>100 && POSX<150 && POSY>150 && POSY<200) //Boton Left
        {
            // Pitamos el boton apretado
            ComButton(100,150,50,50,20,256,"B2");
            // Encendemos el led 2
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, GPIO_PIN_4);
        }
        else
        {
            // Pintamos el boton sin pulsar
            ComButton(100,150,50,50,20,0,"B2");
            // Apagamos el led 2
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_4, 0);
        }
        if(POSX>170 && POSX<220 && POSY>150 && POSY<200) //Boton Left
        {
            // Pitamos el boton apretado
            ComButton(170,150,50,50,20,256,"B3");
            // Encendemos el led 3
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, GPIO_PIN_0);
        }
        else
        {
            // Pintamos el boton sin pulsar
            ComButton(170,150,50,50,20,0,"B3");
            // Apagamos el led 3
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_0, 0);
        }
        if(POSX>240 && POSX<290 && POSY>150 && POSY<200) //Boton Left
        {
            // Pitamos el boton apretado
            ComButton(240,150,50,50,20,256,"B4");
            // Encendemos el led 4
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, GPIO_PIN_1);
        }
        else
        {
            // Pintamos el boton sin pulsar
            ComButton(240,150,50,50,20,0,"B4");
            // Apagamos el led 4
            GPIOPinWrite(GPIO_PORTN_BASE, GPIO_PIN_1, 0);
        }


        // Si estamos pulsando un boton fisico, mostramos el mensaje
        if(B1_OFF)          B1press = 0;
        if(B2_OFF)          B2press = 0;
        if(B1press)
        {
            ComColor(0x00,0x00,0x00);
            ComTXT(160,75, 22, OPT_CENTERX,"HAS PULSADO B1");
        }
        if(B2press)
        {
            ComColor(0x00,0x00,0x00);
            ComTXT(160,75, 22, OPT_CENTERX,"HAS PULSADO B2");
        }

        // Damos la orden para que se pinte todo lo anterior por pantalla
        Dibuja();
    }

}
