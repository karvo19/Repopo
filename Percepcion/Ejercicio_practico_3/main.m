% Ejercicio Practico 3
clc
clear all
% En primer lugar, a�adimos la imagen
f = imread ('imagenDePartida.png');

figure(1);
imshow(f);
title('Imagen de partida');

% Antes de ver los l�mites de cada color, se va a aplicar un filtro de la
% mediana para tener una intensidad de las figuras a identificar no tan
% dispar

% Hay que elegir el radio de la m�scara con la que se quiere operar
% rMask = 1;
% gMediana1 = filtroMediana(f,rMask);
% figure(2);
% imshow(gMediana1);
% title('Filtro de la media con m�scara de radio 1');

rMask = 2;
gMediana = filtroMediana(f,rMask);
figure(3);
imshow(gMediana);
title('Filtro de la media con m�scara de radio 2');

% Ahora, hacemos el Threshold para saber los umbrales.
% Se trabajar� con HSV
[uR,uG,uB,uY,uO,uK] = umbralesHSV(gMediana);

% Se har� ahora una imagen por separado de cada color y, si es necesario,
% se aplicar�n m�todos morfol�gicos para identificar cada una de las
% figuras de inter�s
imHSV = rgb2hsv(gMediana);

% Se recorrer� pixel a pixel la imagen una vez por cada color e
% identificando los umbrales de H, S, V de cada uno de ellos para obtener
% la plantilla de cada color. Se emplea la funci�n plantillaBinaria
[pR,pG,pB,pY,pO,pK] = plantillaBinaria(imHSV,uR,uG,uB,uY,uO,uK);

% imshow(pR);
% pause();
% imshow(pG);
% pause();
% imshow(pB);
% pause();
% imshow(pY);
% pause();
% imshow(pO);
% pause();
% imshow(pK);

%%

% El elemento estructurante con el que se trabajar� para aplicar m�todos
% morfol�gicos seg�n los umbrales HSV ser� de un disco de radio arbitrario:
maskDisco3 = strel('disk',3);
maskDisco4 = strel('disk',4);
maskDisco5 = strel('disk',5);

% Viendo los resultados de cada plantilla, se operar� sobre cada una de
% ellas de forma distinta

% -----------------------------------------HACER FUNCION DE OPENING Y DE CLOSING

pRadj = imopen(pR,maskDisco3);
% imshow([pR,pRadj]);
% pause();
pGadj = imopen(pG,maskDisco3);
% imshow([pG,pGadj]);
% pause();
pBadj = imopen(pB,maskDisco3);
% imshow([pB,pBadj]);
% pause();
pYadj = imopen(pY,maskDisco5);
% imshow([pY,pYadj]);
% pause();
pOadj = imopen(pO,maskDisco3);
pOadj = imclose(pOadj,maskDisco5);
% imshow([pO,pOadj]);
% pause();
pKadj = imopen(pK,maskDisco4);
pKadj = imclose(pKadj,maskDisco5);
% imshow([pK,pKadj]);
% pause();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Se hace el etiquetado de las figuras en cada caso:
pRetiq = bwlabel(pRadj);
pGetiq = bwlabel(pGadj);
pBetiq = bwlabel(pBadj);
pYetiq = bwlabel(pYadj);
pOetiq = bwlabel(pOadj);
pKetiq = bwlabel(pKadj);

imshow(pRetiq,[]);
pause();
imshow(pGetiq,[]);
pause();
imshow(pBetiq,[]);
pause();
imshow(pYetiq,[]);
pause();
imshow(pOetiq,[]);
pause();
imshow(pKetiq,[]);

% Ahora, se har� el bounding box de cada color
BoundingBox(pRetiq,f);
pause();
BoundingBox(pGetiq,f);
pause();
BoundingBox(pBetiq,f);
pause();
BoundingBox(pYetiq,f);
pause();
BoundingBox(pOetiq,f);
pause();
BoundingBox(pKetiq,f);