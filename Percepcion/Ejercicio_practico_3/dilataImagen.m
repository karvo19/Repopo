function plantillaDilatada = dilataImagen(plantilla,mascara)

% Función que hace la erosión de una plantilla dado la máscara que se desee

% Dimensiones de la plantilla
[M,N] = size(plantilla);

% Obtenemos el radio de la mascara
radioMask = floor(size(mascara.Neighborhood)/2);

% Inicializamos a cero la imagen dilatada resultante
plantillaDilatada = zeros(M,N);

% Procedemos a operar con la mascara sobre la plantilla
% Recorremos pixel a pixel la imagen a dilatar
for y = 1+radioMask:M-radioMask
    for x = 1+radioMask:N-radioMask
        % Si al multiplicar la mascara por el area alrededor del pixel
        % actual resulta algun 1, el pixel actual debe ponerse a 1
        if(sum(sum(mascara.Neighborhood.*plantilla(y-radioMask:y+radioMask,x-radioMask:x+radioMask))))
            plantillaDilatada(y,x) = 1;
        end
    end
end