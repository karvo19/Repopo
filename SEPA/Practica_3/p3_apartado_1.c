#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>

#include "inc/hw_memmap.h"
#include "inc/hw_ints.h"
#include "inc/hw_types.h"
#include "inc/hw_i2c.h"

#include "driverlib/debug.h"
#include "driverlib/gpio.h"
#include "driverlib/interrupt.h"
#include "driverlib/pin_map.h"
#include "driverlib/rom.h"
#include "driverlib/rom_map.h"
#include "driverlib/sysctl.h"
#include "driverlib/uart.h"
#include "driverlib/timer.h"
#include "driverlib/i2c.h"
#include "driverlib/systick.h"

#include "utils/uartstdio.h"
#include "utils/uartstdio.c"

#include "HAL_I2C.h"
#include "sensorlib2.h"


void Timer0IntHandler(void);


int RELOJ;

char Cambia = 0;

char string[80];
int DevID = 0;




 // BMI160/BMM150
 struct bmi160_mag_xyz_s32_t s_magcompXYZ;

uint8_t Sensor_OK = 0;
#define BP 2
uint8_t Opt_OK, Tmp_OK, Bme_OK, Bmi_OK;

float pi = 3.141592654;
float angulo;


int main(void)
{
    RELOJ = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_480), 120000000);

    // Configuracion del timer para escribir datos por pantalla cada medio segundo
    SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
    TimerClockSourceSet(TIMER0_BASE, TIMER_CLOCK_SYSTEM);
    TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC);
    TimerLoadSet(TIMER0_BASE, TIMER_A, RELOJ/2 -1);
    TimerIntRegister(TIMER0_BASE, TIMER_A,Timer0IntHandler);
    IntEnable(INT_TIMER0A);
    TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    IntMasterEnable();
    TimerEnable(TIMER0_BASE, TIMER_A);

    // Configuracion de al UART para comunicarnos con el ordenador por puerto serie
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);
    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    UARTStdioConfig(0, 115200, RELOJ);

    // Deteccion de al posición en la que está pinchado el sensors BoosterPack
    if(Detecta_BP(1))
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
                 }

    // Comunicamos el estado de los sensores por si ha habido un error
     UARTprintf("\033[2J \033[1;1H Inicializando OPT3001... ");
     Sensor_OK = Test_I2C_Dir(OPT3001_SLAVE_ADDRESS);
     if(!Sensor_OK)
     {
         UARTprintf("Error en OPT3001\n");
         Opt_OK=0;

     }
     else
     {
         OPT3001_init();
         UARTprintf("Hecho!\n");
         UARTprintf("Leyendo DevID... ");
         DevID=OPT3001_readDeviceId();
         UARTprintf("DevID= 0X%x \n", DevID);
         Opt_OK = 1;
     }
     UARTprintf("Inicializando ahora el TMP007...");
     Sensor_OK = Test_I2C_Dir(TMP007_I2C_ADDRESS);
     if(!Sensor_OK)
     {
         UARTprintf("Error  en TMP007\n");
         Tmp_OK = 0;
     }
     else
     {
         sensorTmp007Init();
         UARTprintf("Hecho! \nLeyendo DevID... ");
         DevID=sensorTmp007DevID();
         UARTprintf("DevID= 0X%x \n", DevID);
         sensorTmp007Enable(true);
         Tmp_OK = 1;
     }
     UARTprintf("Inicializando BME280... ");
     Sensor_OK=Test_I2C_Dir(BME280_I2C_ADDRESS2);
     if(!Sensor_OK)
     {
         UARTprintf("Error en BME280\n");
         Bme_OK = 0;
     }
     else
     {
         bme280_data_readout_template();
         bme280_set_power_mode(BME280_NORMAL_MODE);
         UARTprintf("Hecho! \nLeyendo DevID... ");
         readI2C(BME280_I2C_ADDRESS2,BME280_CHIP_ID_REG, &DevID, 1);
         UARTprintf("DevID= 0X%x \n", DevID);
         Bme_OK = 1;
     }
     Sensor_OK = Test_I2C_Dir(BMI160_I2C_ADDR2);
     if(!Sensor_OK)
     {
         UARTprintf("Error en BMI160\n");
         Bmi_OK = 0;
     }
     else
     {
         UARTprintf("Inicializando BMI160, modo NAVIGATION... ");
         bmi160_initialize_sensor();
         bmi160_config_running_mode(APPLICATION_NAVIGATION);
         UARTprintf("Hecho! \nLeyendo DevID... ");
         readI2C(BMI160_I2C_ADDR2,BMI160_USER_CHIP_ID_ADDR, &DevID, 1);
         UARTprintf("DevID= 0X%x \n", DevID);
         Bmi_OK = 1;
     }

     // Bucle principal
    while(1)
    {
        // Si el sensor está listo, leemos el magnetómetro
        if(Bmi_OK)
        {
            bmi160_bmm150_mag_compensate_xyz(&s_magcompXYZ);
        }

        // Calculamos el angulo al que esta apuntando el magnetómetro
        if(s_magcompXYZ.x == 0)
        {
            // Si la componente x es cero, estamos en +-90 grados
            if(s_magcompXYZ.y > 0)   angulo = pi/2.0;
            else        angulo = 3.0*pi/2.0;
        }
        else
        {
            // Si la componnente x no es cero, aplicamos la arcotangente de y/x
            angulo = atanf((float)s_magcompXYZ.y/(float)s_magcompXYZ.x);

            // Ahora identificamos el cuadrante a partir de los signos de x e y
            if(s_magcompXYZ.x > 0 && s_magcompXYZ.y > 0)          angulo = angulo;
            else if(s_magcompXYZ.x < 0 && s_magcompXYZ.y > 0)     angulo += pi;
            else if(s_magcompXYZ.x < 0 && s_magcompXYZ.y < 0)     angulo += pi;
            else if(s_magcompXYZ.x > 0 && s_magcompXYZ.y < 0)     angulo += 2*pi;
        }

        // Imprimimos los datos por pantalla cada medio segundo
        if(Cambia == 1)
        {
            Cambia = 0;
            sprintf(string, "Angulo = %f (rad)\n",angulo);
            UARTprintf(string);
        }
    }

    return 0;
}

// En la rutina de interrupcion solo cambiaos la variable que permite imprimir por pantalla y borramos el flag
void Timer0IntHandler(void)
{
	TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT); //Borra flag
	Cambia = 1;
}

