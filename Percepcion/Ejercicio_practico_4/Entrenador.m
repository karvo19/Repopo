function MatrizPatrones = Entrenador(img)


% Entrenador: a partir de una imagen en blanco y negro etiquetada y el
% n�mero de la clase al que pertenece, se agrupan seg�n ciertas
% caracter�sticas en una matriz (en este caso, los momentos de Hu) y se
% devuelve una matriz en la que se almacenan los patrones.


%Es necesario ir etiqueta a etiqueta e ir calculando los momentos de Hu
%para cada etiqueta. Se considera inicialmente que se van a trabajar con
%los 7 momentos de Hu, por lo que MatrizPatrones tendr� 7+1 filas
% [M,N]=size(img);

nEtiqs = max(max(img));

MatrizPatrones = zeros(8,nEtiqs);

% Se obtienen los momentos de Hu de cada patr�n y se devuelve
MatrizPatrones = calculaMomentosHu(img);

end