% Clasificador final.
%
% Clasifica una patrón muestra concreto por el discriminante basado en distancias
% usando para ello unos prototipos dados.

% Me proporcionan el vector de características a clasificar x, por ejemplo:
% x = [0.2; 0.6];

% Pregunto el vector de características:
x(1,1) = input('Introduzca característica x1 ');
x(2,1) = input('Introduzca característica x2 ');

% Se dispone de la matriz de prototipos:
[nx, nClases] = size(Mprototipos);

% Cálculo de las distancias del x a cada prototipo:
distancias = zeros(1, nClases);
for clase = 1:nClases
   z = Mprototipos(:,clase);
   distancias(clase) = norm (z-x);
end
[minDist, claseK] = min (distancias);

fprintf('La clase asignada es %d\n', claseK);


% Dibujo comprobatorio:
figure;
hold on
for clase = 1:nClases
    z = Mprototipos(:,clase);
    plot (z(1), z(2), 'bx', 'MarkerSize', 18)    
    text (z(1), z(2)+0.05, sprintf('%d', clase), 'FontSize', 24 );
end
plot (x(1), x(2), 'go', 'MarkerSize', 16);
grid;
xlabel('x1'); ylabel('x2'); hold off;
axis([-1 1 0 1 ]);