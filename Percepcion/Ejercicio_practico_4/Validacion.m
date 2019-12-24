%% Ejercicio práctico 4 Sistemas de percepción: Reconocimiento de objetos
% Validación

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
    
    % A continuación, se decide qué características se desean usar
    % TENER EN CUENTA QUE EN CONSTRUCTOR HABRÍA QUE MODIFICAR Mprototipos
    % (comentar y descomentar las características que se desean)
    x = [x1, x3, x4, x6]';
    
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

% Se pintan los centroides
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

% Se adaptan los ejes a 0 1 porque se reescalaron los momentos de Hu
axis([0 1 0 1 0 1]);

% Cálculo del PCI
PCI = 100 * nClasifIncorrectas / nPatrones;
['Número de clasificaciones incorrectas', num2str(PCI), '%']
['PCI = ', num2str(PCI), '%']