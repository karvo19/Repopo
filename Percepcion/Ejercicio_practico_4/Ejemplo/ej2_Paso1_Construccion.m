% Constructor del clasificador por distancia. Ejemplo de la transparencia 32.
%
% Obtiene los prototipos para ser usados por un clasificador de distancia
%

% Número de clases:
nClases = 4;

% Supongo que los datos de entrenamiento proporcionados son una matriz de valores M.
% La primera fila contiene los valores de x1 para cada patrón.
% La segunda fila contiene los valores de x2 para cada patrón.
% La tercera fila indica la clase a la que pertenece el patrón.
%  M = [ x1 x1 x1 x1 ...
%        x2 x2 x2 x2 ...
%        C  C  C  C  ... ]
%
M = [ 0.70 0.77 0.10 0.08 0.77 -0.90 -0.87 0.60 0.80;
      0.82 0.76 0.50 0.54 0.11  0.45  0.48 0.05 0.07;
      4    4    1    1    3     2     2    3    3    ];

% Tamaño de M
[nf, nPatrones] = size(M);  % se supone nf=3

% Cálculo de los prototipos como valores medios (centroides) de cada clase:
sumaPorClase = zeros (2, nClases);
nPatronesPorClase = zeros (1, nClases);

for nPatron = 1:nPatrones
   % Patrón y clase a la que pertenece:
   x = M(1:2,nPatron);
   clase = M(3,nPatron);
   % Se incrementa la suma con los valores x1, x2 del patrón actual:
   sumaPorClase(:,clase) = sumaPorClase(:,clase) + x;
   % Se incrementa el contador de la clase en 1:
   nPatronesPorClase(clase) = nPatronesPorClase(clase) + 1;
end

% El resultado de la media es una matriz de vectores prototipo:
Mprototipos = zeros (2,nClases);
Mprototipos(1,:) = sumaPorClase(1,:)./nPatronesPorClase;
Mprototipos(2,:) = sumaPorClase(2,:)./nPatronesPorClase;


% Mostramos gráficamente los patrones:
figure; hold on;
for nPatron = 1:nPatrones
    x     = M(1:2,nPatron);
    clase = M(3,nPatron);
    
     % Dibujo del resultado:
    if clase == 1
        plot(x(1),x(2), 'b.', 'MarkerSize', 24);
    elseif clase == 2
        plot(x(1),x(2), 'r.', 'MarkerSize', 24);
    elseif clase == 3
        plot(x(1),x(2), 'Color', [0,0.5,0], 'Marker', '.', 'MarkerSize', 24);
    elseif clase == 4
        plot(x(1),x(2), 'Color', [0.5,0,0.5], 'Marker', '.', 'MarkerSize', 24);
    end
end

% Mostramos gráficamente los prototipos (centroides):
for clase = 1:nClases
   z = Mprototipos(:,clase);
   plot (z(1), z(2), 'bx', 'MarkerSize', 18);
end

grid; xlabel('x1'); ylabel('x2'); hold off;
axis([-1 1 0 1]);