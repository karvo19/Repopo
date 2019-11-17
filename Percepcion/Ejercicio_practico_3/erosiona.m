function plantillaErosionada = erosiona(plantilla,mascara)

% Función que hace la erosión de una plantilla dado la máscara que se desee

% Dimensiones de la plantilla
[M,N] = size(plantilla)
radioMask = ceil(size(mascara.Neighborhood)/2)

% Tamaño de la máscara
radioMask = size(mascara)
for y = 1+radioMask:M-radioMask
    for x = 1+radioMask:N-radioMask
        plantillaErosionada(y,x) = min(min(plantilla(y-radioMask:y+radioMask;x-radioMask:x+radioMask)));
    end
end
