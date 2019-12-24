%% Ejercicio práctico 4 Sistemas de percepción: Reconocimiento de objetos
% Validación



% Inicio --> constructor

% Tamaño de M
[nf, nPatrones] = size(MatrizEntrenamiento);  % se supone nf=3

% Cálculo de los prototipos como valores medios (centroides) de cada clase:
sumaPorClase = zeros (7, nClases);
nPatronesPorClase = zeros (1, nClases);

for nPatron = 1:nPatrones
   % Patrón y clase a la que pertenece:
   x = MatrizEntrenamiento(1:7,nPatron);
   clase = MatrizEntrenamiento(8,nPatron);
   % Se incrementa la suma con los valores x1, x2 del patrón actual:
   sumaPorClase(:,clase) = sumaPorClase(:,clase) + x;
   % Se incrementa el contador de la clase en 1:
   nPatronesPorClase(clase) = nPatronesPorClase(clase) + 1;
end

% El resultado de la media es una matriz de vectores prototipo:
Mprototipos = zeros (3,nClases);
i = 1;
Mprototipos(i,:) = sumaPorClase(1,:)./nPatronesPorClase; i = i + 1;
% Mprototipos(i,:) = sumaPorClase(2,:)./nPatronesPorClase; i = i + 1;
Mprototipos(i,:) = sumaPorClase(3,:)./nPatronesPorClase; i = i + 1;
Mprototipos(i,:) = sumaPorClase(4,:)./nPatronesPorClase; i = i + 1;
% Mprototipos(i,:) = sumaPorClase(5,:)./nPatronesPorClase; i = i + 1;
Mprototipos(i,:) = sumaPorClase(6,:)./nPatronesPorClase; i = i + 1;
% Mprototipos(i,:) = sumaPorClase(7,:)./nPatronesPorClase; i = i + 1;





% -------------------------------------------------------------


% Validación

% Rango admitido de las características:
rangoX1 = [0, 1];
rangoX2 = [0, 1];
rangoX3 = [0, 1];

% Cargamos en 'M' el conjunto de patrones de validación, con la misma estructura:             
% MatrizEntrenamiento;
[nf, nPatrones] = size(MatrizEntrenamiento);  % se supone nf=3

nClasifIncorrectas = 0;

figure; hold on;

for patron = 1:nPatrones
    % Patrón actual:
    x1 = MatrizEntrenamiento(1,patron);
    x2 = MatrizEntrenamiento(2,patron);
    x3 = MatrizEntrenamiento(3,patron);
    x4 = MatrizEntrenamiento(4,patron);
    x5 = MatrizEntrenamiento(5,patron);
    x6 = MatrizEntrenamiento(6,patron);
    x7 = MatrizEntrenamiento(7,patron);
    
    
    claseK = MatrizEntrenamiento(8,patron);
    x = [x1, x3, x4, x6]'; % Decidimos cuales vamos a usar
    
    % Cálculo las distancias del patrón a cada prototipo:
    distancias = zeros (1,nClases);
    for clase = 1:nClases
       z = Mprototipos(:,clase);
       distancias(clase) = norm(z - x);
    end
    
    % Búsqueda de la mínima distancia:
    [minDist, claseK_TrasClasif] = min (distancias);

    % Con '.' los correctamente clasificados, con '*' los incorrectos:
    if claseK_TrasClasif == claseK
       marcador = 'o';
    else
       nClasifIncorrectas = nClasifIncorrectas + 1;
       marcador = '*';
    end
    
    % Dibujo del resultado:
    if claseK_TrasClasif == 1
        plot3(x(1,:),x(2,:),x(3,:), 'Color', 'b', 'Marker', marcador);
    elseif claseK_TrasClasif == 2
        plot3(x(1,:),x(2,:),x(3,:), 'Color', 'r', 'Marker', marcador);
    elseif claseK_TrasClasif == 3
        plot3(x(1,:),x(2,:),x(3,:), 'Color', [0,1,0], 'Marker', marcador);
    elseif claseK_TrasClasif == 4
        plot3(x(1,:),x(2,:),x(3,:), 'Color', [0.4,0.4,0.4], 'Marker', marcador);
    elseif claseK_TrasClasif == 5
        plot3(x(1,:),x(2,:),x(3,:), 'Color', [0.8,0,0.8], 'Marker', marcador);
    elseif claseK_TrasClasif == 6
        plot3(x(1,:),x(2,:),x(3,:), 'Color', [0.5,0.8,0.2], 'Marker', marcador);
    elseif claseK_TrasClasif == 7
        plot3(x(1,:),x(2,:),x(3,:), 'Color', [0.2,0.9,0.5], 'Marker', marcador);
    elseif claseK_TrasClasif == 8
        plot3(x(1,:),x(2,:),x(3,:), 'Color', [0.9,0.2,0.5], 'Marker', marcador);
    elseif claseK_TrasClasif == 9
        plot3(x1,x2,x3, 'Color', [0.7,0.7,0.1], 'Marker', marcador);
    elseif claseK_TrasClasif == 10
        plot3(x1,x2,x3, 'Color', [0.9,0.1,0.9], 'Marker', marcador);
    end
end

for clase = 1:nClases
    z = Mprototipos(:,clase);
    plot3 (z(1), z(2), z(3), 'kx', 'MarkerSize', 18);
    
    if clase == 10
        text (z(1), z(2)+0.01, z(3)+0.01, sprintf('0'), 'FontSize', 24 );
    else
        text (z(1), z(2)+0.01, z(3)+0.01, sprintf('%d', clase), 'FontSize', 24 );
    end
end

xlabel('x1');  ylabel('x2'); zlabel('x3'); hold off;
axis([0 1 0 1 0 1]);

PCI = 100 * nClasifIncorrectas / nPatrones;
['Número de clasificaciones incorrectas: PCI = ', num2str(PCI), '%']
['PCI = ', num2str(PCI), '%']