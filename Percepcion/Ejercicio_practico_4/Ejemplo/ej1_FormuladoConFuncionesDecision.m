% Probador del clasificador de mínima distancia para serparar 3 clases.
% Implementa el clasificador para el ejemplo de la transparencia 30.
% Realiza una prueba exhaustiva del clasificador en todo el espacio de las características.
numPuntos = 6000;

figure;
hold on;

% Definición de los prototipos (uno por clase):
z1 = [2    1.4]';
z2 = [4.7  4]';
z3 = [7.8  8]';

plot([z1(1) z2(1) z3(1)], [z1(2) z2(2) z3(2)],'gx','MarkerSize',15,'LineWidth',3);
axis([0 10 0 10]); grid;
%return;


% Definición de los pesos de las funciones de descisión:
w1 = [z1; -0.5*norm(z1)^2]; 
w2 = [z2; -0.5*norm(z2)^2]; 
w3 = [z3; -0.5*norm(z3)^2]; 


for punto = 1:numPuntos
    % punto actual aleatorio
    x1 = rand(1)*10;  % valor en [0, 10]
    x2 = rand(1)*10;  % valor en [0, 10]
    xA = [x1 x2 1]';  % Vector de características ampliado.
    
    % Cálculo las distancias al cuadrado del xo a cada prototipo
    fd1 = w1' * xA;
    fd2 = w2' * xA;
    fd3 = w3' * xA;

    [fdMax, clase] = max ([fd1,fd2,fd3]);

    % dibujo del resultado
    if clase == 1
        plot (x1, x2, 'b.');
    end
    if clase == 2
        plot (x1, x2, 'r.');
    end
    if clase == 3
        plot (x1, x2, '.','Color',[1,1,1]*0.9);
    end
end

xlabel('x1');
ylabel('x2');
hold off;

