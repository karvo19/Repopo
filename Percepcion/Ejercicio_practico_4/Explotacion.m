%% Ejercicio pr�ctico 4 Sistemas de percepci�n: Reconocimiento de objetos
% Explotaci�n


% Es necesario saber el tama�o de MomentosHuDigitosEscalados, que son los
% d�gitos que se han le�do de la imagen de las matr�culas

[nf, nPatrones] = size(MomentosHuDigitosEscalados);
clasesPertenecientes = zeros(nPatrones);

for patron = 1:nPatrones
    % Patr�n actual:
    x1 = MomentosHuDigitosEscalados(1,patron);
    x2 = MomentosHuDigitosEscalados(2,patron);
    x3 = MomentosHuDigitosEscalados(3,patron);
    x4 = MomentosHuDigitosEscalados(4,patron);
    x5 = MomentosHuDigitosEscalados(5,patron);
    x6 = MomentosHuDigitosEscalados(6,patron);
    x7 = MomentosHuDigitosEscalados(7,patron);
    
    
    % A continuaci�n, se decide qu� caracter�sticas se desean usar
    % TENER EN CUENTA QUE EN CONSTRUCTOR HABR�A QUE MODIFICAR Mprototipos
    % (comentar y descomentar las caracter�sticas que se desean)
    x = [x1, x3, x4, x6]';
    
    % C�lculo las distancias del patr�n a cada prototipo:
    distancias = zeros (1,nClases);
    for clase = 1:nClases
       z = Mprototipos(:,clase);
       distancias(clase) = norm(z - x);
    end
    
    % B�squeda de la m�nima distancia:
    [minDist, claseK_TrasClasif] = min (distancias);
    clasesPertenecientes(patron) = claseK_TrasClasif;
end


figure();
% Se muestra la imagen original de las matr�culas
imshow(f);hold on;

% Se calculan los centros de masa de los d�gitos (etiquetados) para saber
% d�nde habr�a que poner los d�gitos que se identifican
cdmasa = calculaCDMasa(fet2);

for n = 1:nPatrones    
    if clasesPertenecientes(n) == 10
        text (cdmasa(1,n), cdmasa(2,n), sprintf('0'), 'Color', 'g','FontSize', 24 );
    else
        text (cdmasa(1,n), cdmasa(2,n), sprintf('%d', clasesPertenecientes(n)), 'Color', 'g','FontSize', 24 );
    end
end