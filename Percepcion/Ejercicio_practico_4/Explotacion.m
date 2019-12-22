%% Ejercicio práctico 4 Sistemas de percepción: Reconocimiento de objetos
% Explotación


% Cargamos en 'M' el conjunto de patrones a determinar, con la misma estructura:             
% MomentosHuDigitosEscalados;
[nf, nPatrones] = size(MomentosHuDigitosEscalados);  % se supone nf=3
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
    
    x = [x1, x3, x4, x6]'; % Decidimos cuales vamos a usar
    
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

%%
clc

figure();
imshow(f);hold on;
cdmasa = calculaCDMasa(fet2);

for n = 1:nPatrones    
    if clasesPertenecientes(n) == 10
        text (cdmasa(1,n), cdmasa(2,n), sprintf('0'), 'Color', 'g','FontSize', 24 );
    else
        text (cdmasa(1,n), cdmasa(2,n), sprintf('%d', clasesPertenecientes(n)), 'Color', 'g','FontSize', 24 );
    end
end