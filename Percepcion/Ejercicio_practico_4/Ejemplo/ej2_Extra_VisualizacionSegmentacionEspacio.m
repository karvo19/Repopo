% Probador del clasificador por mínima distancia.
%
% Realiza una prueba exhaustiva del clasificador
clc;
disp('Prueba exhaustiva del clasificador');
disp('Se necesita las variables nClases y Mprototipos (use constructor)');

nPatrones = 6000;

figure; hold on;

for patron = 1:nPatrones
    % Patrón actual aleatorio:
    x1 = (rand(1)-0.5)*2;  % valor en [ -1, 1]
    x2 = rand(1);          % valor en [  0, 1]
    x = [x1; x2];
    
    % Cálculo las distancias al cuadrado del patrón a cada prototipo:
    distancias = zeros (1,nClases);
    for clase = 1:nClases
       z = Mprototipos(:,clase);
       distancias(clase) = norm (z-x);
    end
    
    % Búsqueda de la mínima distancia:
    [minDist, claseK] = min (distancias);

    % Dibujo del resultado:
    if claseK == 1
        plot(x1,x2, 'b.');
    elseif claseK == 2
        plot(x1,x2, 'r.');
    elseif claseK == 3
        plot( x1,x2, 'Color', [0,0.5,0], 'Marker', '.');
    elseif claseK == 4
        plot(x1,x2, 'Color', [0.5,0,0.5], 'Marker', '.');
    end
end

for clase = 1:nClases
    z = Mprototipos(:,clase);
    plot (z(1), z(2), 'kx', 'MarkerSize', 18);
    text (z(1), z(2)+0.05, sprintf('%d', clase), 'FontSize', 24 );
end

xlabel('x1');  ylabel('x2');  hold off;
axis([-1 1 0 1]);