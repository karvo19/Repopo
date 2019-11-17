% Función para sacar la plantilla de cada color
function [pR,pG,pB,pY,pO,pK] = plantillaBinaria(ImagenHSV,uR,uG,uB,uY,uO,uK)

% Se declaran los umbrales
umbral = zeros (3,2,6);

umbral(:,:,1) = uR;
umbral(:,:,2) = uG;
umbral(:,:,3) = uB;
umbral(:,:,4) = uY;
umbral(:,:,5) = uO;
umbral(:,:,6) = uK;

% Se inicializa la matriz de las plantillas de colores
[M,N,canal] = size(ImagenHSV);
pColores = zeros (M,N,6);

for color = 1 : 6
    for i = 1 : M             %Filas
        for j = 1 : N         %Columnas
            % Si el límite del Hmin es mayor que el límite de Hmax
            if (umbral(1,1,color) > umbral(1,2,color))
                %Si está dentro del umbral para H, S o V, se pone a 1
                if((ImagenHSV(i,j,1) >= umbral(1,1,color))  ||  (ImagenHSV(i,j,1) <= umbral(1,2,color)))            %H
                    if((ImagenHSV(i,j,2) >= umbral(2,1,color))  &&  (ImagenHSV(i,j,2) <= umbral(2,2,color)))
                        if((ImagenHSV(i,j,3) >= umbral(3,1,color))  &&  (ImagenHSV(i,j,3) <= umbral(3,2,color)))
                            pColores(i,j,color) = 1;     % Entonces la plantilla en ese pixel en concreto para ese color vale 1 (SOLO UN CANAL)
                        end
                    end
                end
            else
                if((ImagenHSV(i,j,1) >= umbral(1,1,color))  &&  (ImagenHSV(i,j,1) <= umbral(1,2,color)))
                    if((ImagenHSV(i,j,2) >= umbral(2,1,color))  &&  (ImagenHSV(i,j,2) <= umbral(2,2,color)))
                        if((ImagenHSV(i,j,3) >= umbral(3,1,color))  &&  (ImagenHSV(i,j,3) <= umbral(3,2,color)))
                            pColores(i,j,color) = 1;     % Entonces la plantilla en ese pixel en concreto para ese color vale 1 (SOLO UN CANAL)
                        end
                    end
                end
            end
        end
    end
end
pR = pColores(:,:,1);
pG = pColores(:,:,2);
pB = pColores(:,:,3);
pY = pColores(:,:,4);
pO = pColores(:,:,5);
pK = pColores(:,:,6);