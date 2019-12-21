% Probador del clasificador por mínima distancia.
%
% Realiza una prueba exhaustiva del clasificador
clc;
disp('Prueba del clasificador');
disp('Se necesita las variables nClases y Mprototipos (use constructor)');

% Rango admitido de las características:
rangoX1 = [-1, 1];
rangoX2 = [ 0, 1];

% Cargamos en 'M' el conjunto de patrones de validación, con la misma estructura:             
M = CargaPatronesConjuntoValidacion (Mprototipos, nClases, [rangoX1; rangoX2]);
[nf, nPatrones] = size(M);  % se supone nf=3

nClasifIncorrectas = 0;

figure; hold on;

for patron = 1:nPatrones
    % Patrón actual:
    x1 = M(1,patron);
    x2 = M(2,patron);
    claseK = M(3,patron);
    x = [x1, x2]';
    
    % Cálculo las distancias del patrón a cada prototipo:
    distancias = zeros (1,nClases);
    for clase = 1:nClases
       z = Mprototipos(:,clase);
       distancias(clase) = norm (z-x);
    end
    
    % Búsqueda de la mínima distancia:
    [minDist, claseK_TrasClasif] = min (distancias);

    % Con '.' los correctamente clasificados, con '*' los incorrectos:
    if claseK_TrasClasif == claseK
       marcador = '.';
    else
       nClasifIncorrectas = nClasifIncorrectas + 1;
       marcador = '*';
    end
    
    % Dibujo del resultado:
    if claseK_TrasClasif == 1
        plot(x1,x2, 'Color', 'b', 'Marker', marcador);
    elseif claseK_TrasClasif == 2
        plot(x1,x2, 'Color', 'r', 'Marker', marcador);
    elseif claseK_TrasClasif == 3
        plot( x1,x2, 'Color', [0,0.5,0], 'Marker', marcador);
    elseif claseK_TrasClasif == 4
        plot(x1,x2, 'Color', [0.5,0,0.5], 'Marker', marcador);
    end
end

for clase = 1:nClases
    z = Mprototipos(:,clase);
    plot (z(1), z(2), 'kx', 'MarkerSize', 18);
    text (z(1), z(2)+0.05, sprintf('%d', clase), 'FontSize', 24 );
end

xlabel('x1');  ylabel('x2');  hold off;
axis([-1 1 0 1]);

PCI = 100 * nClasifIncorrectas / nPatrones;
['Número de clasificaciones incorrectas: PCI = ', num2str(PCI), '%']