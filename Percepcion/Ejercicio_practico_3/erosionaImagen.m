function plantillaErosionada = erosionaImagen(plantilla,mascara)

% Función que hace la erosión de una plantilla dado la máscara que se desee

% Dimensiones de la plantilla
[M,N] = size(plantilla);

% Obtencion del radio de la plantilla
radioMask = floor(size(mascara.Neighborhood)/2);

% Inicializamos a cero la imagen erosionada resultante
plantillaErosionada = zeros(M,N);

% Procedemos a operar con la mascara sobre la plantilla
% Recorremos pixel a pixel la imagen a erosionar
for y = 1+radioMask:M-radioMask
    for x = 1+radioMask:N-radioMask
        % Si el resultado de multiplicar la mascara por el area de la
        % imagen alrededor del pixel actual es exactamente igual que la
        % propia mascara, el pixel actual debe ponerse a 1
        if(mascara.Neighborhood.*plantilla(y-radioMask:y+radioMask,x-radioMask:x+radioMask) == mascara.Neighborhood)
           plantillaErosionada(y,x) = 1; 
        end
    end
end
