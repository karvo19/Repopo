function plantillaResultanteEt = limpiaPlantilla(plantillaEt,masa,a,b)

% Se va a hacer una función en la que, a partir de ciertas relaciones
% geométricas, se van a descartar ciertas etiquetas de la plantilla que se
% pasa como parámetro de la función.

% Si se desea hacer la relación área/masa, se puede comprobar que las
% letras D de la matrícula rondan el valor de 0.325 aproximadamente, los
% dígitos de los distintos números se encuentran alrededor de 0.4-0.8 y los
% bordes de las matrículas tienen un valor mayor que 3. Por tanto, se van a
% descartar aquellos índices de la plantilla etiquetada en la que dicha
% relación no se encuentre entre 0.4 y 0.8:


%0.5533 (1); 0.53 (9); 0.4824 (8); 0.60 (7);
%D de la matrícula: 0.3249
%Borde de la matrícula: 3.27, 3.30


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

% Ahora, una vez eliminados los bordes de las matrículas y las D, se
% necesita volver a etiquetar la imagen. Hay que tener en cuenta que ahora
% las intensidades de dicha imagen están entre 1 y cualquier valor, ya que
% se parte de una imagen etiquetada. Para poder hacer de nuevo el
% etiquetado, es necesario binarizar la imagen primero y, para ello, hay
% que establecer un umbral:

umbralBW = 0.001; %Umbral normalizado debe ser menor a 1/255

% La plantilla resultante sería:
plantillaResultante = uint8(im2bw(plantillaEt,umbralBW)); 

% Etiquetada:
plantillaResultanteEt = bwlabel(plantillaResultante);

end