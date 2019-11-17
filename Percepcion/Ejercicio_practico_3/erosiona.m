function plantillaErosionada = erosiona(plantilla,mascara)

% Funci�n que hace la erosi�n de una plantilla dado la m�scara que se desee

% Dimensiones de la plantilla
[M,N] = size(plantilla)
radioMask = ceil(size(mascara.Neighborhood)/2)

% Tama�o de la m�scara
radioMask = size(mascara)
for y = 1+radioMask:M-radioMask
    for x = 1+radioMask:N-radioMask
        plantillaErosionada(y,x) = min(min(plantilla(y-radioMask:y+radioMask;x-radioMask:x+radioMask)));
    end
end
