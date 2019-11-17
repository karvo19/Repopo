% Función de filtro de mediana
function imagenFiltrada = filtroMediana(Imagen,rMask)

% Se obtienen las dimensiones de la imagen para poder aplicar el filtro
[M,N,canal] = size(Imagen);

% Se inicializa la imagen filtrada con la mediana
imagenFiltrada = uint8(zeros(M,N,canal));

% Para poder aplicar el filtro, es necesario declarar el radio de la
% máscara
nPixelsMascara = (2*rMask + 1)^2; %Base de máscara por altura de máscara

% El algoritmo del filtro de la mediana se basa en coger la mediana de la
% intensidad entre los píxeles que forman la máscara
for RGB = 1:3
    for i = rMask+1 : M-rMask
        for j = rMask+1 : N-rMask
            imagenFiltrada(i,j,RGB) = median(reshape(Imagen(i-rMask:i+rMask,j-rMask:j+rMask,RGB),nPixelsMascara,1));
        end
    end
end