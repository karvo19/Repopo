%% Ejercicio práctico 4 Sistemas de percepción: Reconocimiento de objetos
% Explotación


% Es necesario saber el tamaño de MomentosHuDigitosEscalados, que son los
% dígitos que se han leído de la imagen de las matrículas

[nf, nPatrones] = size(MomentosHuDigitosEscalados);
clasesPertenecientes = zeros(nPatrones);

for patron = 1:nPatrones
    % Patrón actual:
    x1 = MomentosHuDigitosEscalados(1,patron);
    x2 = MomentosHuDigitosEscalados(2,patron);
    x3 = MomentosHuDigitosEscalados(3,patron);
    x4 = MomentosHuDigitosEscalados(4,patron);
    x5 = MomentosHuDigitosEscalados(5,patron);
    x6 = MomentosHuDigitosEscalados(6,patron);
    x7 = MomentosHuDigitosEscalados(7,patron);
    
    
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
    clasesPertenecientes(patron) = claseK_TrasClasif;
end


figure();
% Se muestra la imagen original de las matrículas
imshow(f);hold on;

% Se calculan los centros de masa de los dígitos (etiquetados) para saber
% dónde habría que poner los dígitos que se identifican
cdmasa = calculaCDMasa(fet2);

for n = 1:nPatrones    
    if clasesPertenecientes(n) == 10
        text (cdmasa(1,n), cdmasa(2,n), sprintf('0'), 'Color', 'g','FontSize', 24 );
    else
        text (cdmasa(1,n), cdmasa(2,n), sprintf('%d', clasesPertenecientes(n)), 'Color', 'g','FontSize', 24 );
    end
end