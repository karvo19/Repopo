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
% pause();
imshow(pGetiq,[]);
% pause();
imshow(pBetiq,[]);
% pause();
imshow(pYetiq,[]);
% pause();
imshow(pOetiq,[]);
% pause();
imshow(pKetiq,[]);

% Ahora, se har� el bounding box de cada color
figure();
imshow(f);
BoundingBox(pRetiq,'r');
% pause();
imshow(f);
BoundingBox(pGetiq,'r');
% pause();
imshow(f);
BoundingBox(pBetiq,'r');
% pause();
imshow(f);
BoundingBox(pYetiq,'r');
% pause();
imshow(f);
BoundingBox(pOetiq,'r');
% pause();
imshow(f);
BoundingBox(pKetiq,'r');

% -------------------------------------------------------------------------

% Asignamos los momentos de orden 0, 1 y 2 a cada uno de los colores usando
% la funci�n calculaMomentos
[masaR,cdmR,inerciaR] = calculaMomentos(pRetiq);
[masaG,cdmG,inerciaG] = calculaMomentos(pGetiq);
[masaB,cdmB,inerciaB] = calculaMomentos(pBetiq);
[masaY,cdmY,inerciaY] = calculaMomentos(pYetiq);
[masaO,cdmO,inerciaO] = calculaMomentos(pOetiq);
[masaK,cdmK,inerciaK] = calculaMomentos(pKetiq);

% Se representa ahora el centro de masas de cada color en cada caso
figure();
imshow(f);
BoundingBox(pRetiq,'r');
viscircles(cdmR',(2*ones(max(max(pRetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
pause();

imshow(f);
BoundingBox(pGetiq,'r');
viscircles(cdmG',(2*ones(max(max(pGetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
pause();

imshow(f);
BoundingBox(pBetiq,'r');
viscircles(cdmB',(2*ones(max(max(pBetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
pause();

imshow(f);
BoundingBox(pYetiq,'r');
viscircles(cdmY',(2*ones(max(max(pYetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
pause();

imshow(f);
BoundingBox(pOetiq,'r');
viscircles(cdmO',(2*ones(max(max(pOetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
pause();

imshow(f);
BoundingBox(pKetiq,'r');
viscircles(cdmK',(2*ones(max(max(pKetiq)),1)),'LineWidth',1.5,'EdgeColor','w');

% Es necesario hacer un promedio de las masas de cada plantilla, ya que se
% puede apreciar en las figuras que se da a veces la ocasi�n de que se
% juntan m�s de un objeto y, con este promedio, se podr� estudiar el caso
% en el que m�s de un objeto se junta, con el fin de separarlos

% Promediado de la masa de cada color
masaRprom = sum(masaR)/(max(size(masaR)));
masaGprom = sum(masaG)/(max(size(masaG)));
masaBprom = sum(masaB)/(max(size(masaB)));
masaYprom = sum(masaY)/(max(size(masaY)));
masaOprom = sum(masaO)/(max(size(masaO)));
masaKprom = sum(masaK)/(max(size(masaK)));



% Ahora, se identifican las masas que est�n juntas y se aplican
% transformaciones morfol�gicas para separarlas

% Se cierran todas las ventanas anteriormente creadas
close all;

% Para color rojo
figure();
imshow(f); hold on;
BoundingBox(pRetiq,'r');
viscircles(cdmR',(2*ones(max(max(pRetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
%----------- Para pruebas solo ejecutar lo de dentro ---------------
for i = 1:(max(max(pRetiq)))
    if (floor(masaR(i)/masaRprom))
        separaObjetos(pRetiq, i, 9);
    end
end
%-------------------------------------------------------------------
hold off;

% Para color verde
figure();
imshow(f); hold on;
BoundingBox(pGetiq,'r');
viscircles(cdmG',(2*ones(max(max(pGetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
%----------- Para pruebas solo ejecutar lo de dentro ---------------
for i = 1:(max(max(pGetiq)))
    if (floor(masaG(i)/masaGprom))
        separaObjetos(pGetiq, i, 10);
    end
end
%-------------------------------------------------------------------
hold off;


% Para color azul
figure();
imshow(f); hold on;
BoundingBox(pBetiq,'r');
viscircles(cdmB',(2*ones(max(max(pBetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
%----------- Para pruebas solo ejecutar lo de dentro ---------------
for i = 1:(max(max(pBetiq)))
    if (floor(masaB(i)/masaBprom))
        separaObjetos(pBetiq, i, 9);
    end
end
%-------------------------------------------------------------------
hold off;

% Para color naranja
figure();
imshow(f); hold on;
BoundingBox(pOetiq,'r');
viscircles(cdmO',(2*ones(max(max(pOetiq)),1)),'LineWidth',1.5,'EdgeColor','w');
%----------- Para pruebas solo ejecutar lo de dentro ---------------
for i = 1:(max(max(pOetiq)))
    if (floor((masaO(i)/masaOprom)-0.1))        % El -0.1 es para evitar que salga el objeto m�s grande
        separaObjetos(pOetiq, i, 9);
    end
end
%-------------------------------------------------------------------
hold off;
