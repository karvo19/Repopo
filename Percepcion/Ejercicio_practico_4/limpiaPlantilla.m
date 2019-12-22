function plantillaResultanteEt = limpiaPlantilla(plantillaEt,masa,a,b)

% Se va a hacer una funci�n en la que, a partir de ciertas relaciones
% geom�tricas, se van a descartar ciertas etiquetas de la plantilla que se
% pasa como par�metro de la funci�n.

% Si se desea hacer la relaci�n �rea/masa, se puede comprobar que las
% letras D de la matr�cula rondan el valor de 0.325 aproximadamente, los
% d�gitos de los distintos n�meros se encuentran alrededor de 0.4-0.8 y los
% bordes de las matr�culas tienen un valor mayor que 3. Por tanto, se van a
% descartar aquellos �ndices de la plantilla etiquetada en la que dicha
% relaci�n no se encuentre entre 0.4 y 0.8:


%0.5533 (1); 0.53 (9); 0.4824 (8); 0.60 (7);
%D de la matr�cula: 0.3249
%Borde de la matr�cula: 3.27, 3.30


[M,N] = size(plantillaEt);
nEtiqs=max(max(plantillaEt));

for i=1:nEtiqs
    if ( ((a(i)*b(i) / masa(i)) < 0.4) || ((a(i)*b(i) / masa(i)) > 3) )
        for j=1:M
            for k=1:N
                if (plantillaEt(j,k)==i)
                    plantillaEt(j,k)=0;
                end
            end
        end
    end
end

% Ahora, una vez eliminados los bordes de las matr�culas y las D, se
% necesita volver a etiquetar la imagen. Hay que tener en cuenta que ahora
% las intensidades de dicha imagen est�n entre 1 y cualquier valor, ya que
% se parte de una imagen etiquetada. Para poder hacer de nuevo el
% etiquetado, es necesario binarizar la imagen primero y, para ello, hay
% que establecer un umbral:

umbralBW = 0.001; %Umbral normalizado debe ser menor a 1/255

% La plantilla resultante ser�a:
plantillaResultante = uint8(im2bw(plantillaEt,umbralBW)); 

% Etiquetada:
plantillaResultanteEt = bwlabel(plantillaResultante);

end