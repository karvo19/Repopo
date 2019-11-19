function plantillaCerrada = cierraImagen(plantilla, mascara)

    % El cierre consiste en concatenar las operaciones de dilatado y
    % erosionado en ese mismo orden
    plantillaCerrada = dilataImagen(plantilla, mascara);
    plantillaCerrada = erosionaImagen(plantillaCerrada, mascara);
