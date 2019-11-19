function plantillaCerrada = cierraImagen(plantilla, mascara)

    plantillaCerrada = dilataImagen(plantilla, mascara);
    plantillaCerrada = erosionaImagen(plantillaCerrada, mascara);
