function plantillaAbierta = abreImagen(plantilla, mascara)

    % El cierre consiste en concatenar las operaciones de erosionado y
    % dilatado en ese mismo orden
    plantillaAbierta = erosionaImagen(plantilla, mascara);
    plantillaAbierta = dilataImagen(plantillaAbierta, mascara);

