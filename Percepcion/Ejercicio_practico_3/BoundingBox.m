function BoundingBox (pEtiq,Imagen)

%Se averiguan las dimensiones de la plantilla
[M,N]=size(pEtiq);

%El n�mero m�ximo de etiquetas:
etiq = max(max(pEtiq));

%Se inicializan las variables de xMin, xMax, yMin, yMax
for i=1:etiq
    xMax(i) = 0;
    xMin(i) = N;
    yMax(i) = 0;
    yMin(i) = M;
    
    % Bucle componente a componente que, seg�n el valor de la etiqueta,
    % establece un valor m�nimo y un m�ximo para cada coordenada
    for y=1:M
        for x=1:N
            if (pEtiq(y,x)==(i))
                if (x<xMin(i))
                    xMin(i)=x;
                end
                if (x>xMax(i))
                    xMax(i)=x;
                end
                if (y<yMin(i))
                    yMin(i)=y;
                end
                if (y>yMax(i))
                    yMax(i)=y;
                end
            end
        end
    end
end

% BB es el vector de coordenadas m�nimas y m�ximas
BB=[xMin;xMax;yMin;yMax];

figure();
imshow(Imagen);

% Se hace el cuadro que rodea a cada etiqueta
for i = 1:etiq
    rectangle('Position',[xMin(i) yMin(i) (xMax(i)-xMin(i)) (yMax(i)-yMin(i))],'LineWidth',2);
end