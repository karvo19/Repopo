% Constructor

% Número de clases:
nClases = 10;

% Supongo que los datos de entrenamiento proporcionados son una matriz de valores M.
% La primera fila contiene los valores de x1 para cada patrón.
% La segunda fila contiene los valores de x2 para cada patrón.
% La tercera fila indica la clase a la que pertenece el patrón.
%  M = [ x1 x1 x1 x1 ...
%        x2 x2 x2 x2 ...
%        C  C  C  C  ... ]
%
MatrizEntrenamiento;

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
Mprototipos = zeros (7,nClases);
Mprototipos(1,:) = sumaPorClase(1,:)./nPatronesPorClase;
Mprototipos(2,:) = sumaPorClase(2,:)./nPatronesPorClase;
Mprototipos(3,:) = sumaPorClase(3,:)./nPatronesPorClase;
Mprototipos(4,:) = sumaPorClase(4,:)./nPatronesPorClase;
Mprototipos(5,:) = sumaPorClase(5,:)./nPatronesPorClase;
Mprototipos(6,:) = sumaPorClase(6,:)./nPatronesPorClase;
Mprototipos(7,:) = sumaPorClase(7,:)./nPatronesPorClase;


% Mostramos gráficamente los patrones:
figure; hold on;
for nPatron = 1:nPatrones
    x     = MatrizEntrenamiento(1:7,nPatron);
    clase = MatrizEntrenamiento(3,nPatron);
    
    aux1=1;
    aux2=2;
    aux3=4;
    
     % Dibujo del resultado:
    if clase == 1
        plot3(x(aux1),x(aux2),x(aux3), 'b.', 'MarkerSize', 24);
        
    elseif clase == 2
        plot(x(aux1),x(aux2),x(aux3), 'r.', 'MarkerSize', 24);
    elseif clase == 3
        plot(x(aux1),x(aux2),x(aux3), 'Color', [0,1,0], 'Marker', '.', 'MarkerSize', 24);
    elseif clase == 4
        plot(x(aux1),x(aux2),x(aux3), 'Color', [0.4,0.4,0.4], 'Marker', '.', 'MarkerSize', 24);
    elseif clase == 5
        plot(x(aux1),x(aux2),x(aux3), 'Color', [0.8,0,0.8], 'Marker', '.', 'MarkerSize', 24);
    elseif clase == 6
        plot(x(aux1),x(aux2),x(aux3), 'Color', [0.5,0.8,0.2], 'Marker', '.', 'MarkerSize', 24);
    elseif clase == 7
        plot(x(aux1),x(aux2),x(aux3), 'Color', [0.2,0.9,0.5], 'Marker', '.', 'MarkerSize', 24);
    elseif clase == 8
        plot(x(aux1),x(aux2),x(aux3), 'Color', [0.9,0.2,0.5], 'Marker', '.', 'MarkerSize', 24);
    elseif clase == 9
        plot(x(aux1),x(aux2),x(aux3), 'Color', [0.7,0.7,0.1], 'Marker', '.', 'MarkerSize', 24);
    elseif clase == 10
        plot(x(aux1),x(aux2),x(aux3), 'Color', [0.9,0.1,0.9], 'Marker', '.', 'MarkerSize', 24);
    end
end

figure();
% Mostramos gráficamente los prototipos (centroides):
for clase = 1:nClases
   z = Mprototipos(:,clase);
   plot3(z(aux1), z(aux2), z(aux3), 'bx', 'MarkerSize', 18);
   if clase == 10
       text (z(aux1), z(aux2)+0.01, z(aux3)+0.01, sprintf('0'), 'FontSize', 24 ); hold on;
   else
       text (z(aux1), z(aux2)+0.01, z(aux3)+0.01, sprintf('%d', clase), 'FontSize', 24 ); hold on;
   end
end

grid; xlabel('x1'); ylabel('x2'); zlabel('x5'); hold off;
axis([0 1 0 1 0 1]);