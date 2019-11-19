function plantillaAbierta = abreImagen(plantilla, mascara)

    plantillaAbierta = erosionaImagen(plantilla, mascara);
    plantillaAbierta = dilataImagen(plantillaAbierta, mascara);

