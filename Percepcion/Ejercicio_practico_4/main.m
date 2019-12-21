%% Ejercicio pr�ctico 4 Sistemas de percepci�n: Reconocimiento de objetos
% Programa principal
clc
% Se a�ade la ruta de las imag�nes de entrenamiento
addpath ./Entrenamiento;

% En primer lugar, ser� necesario cargar las im�genes de entrenamiento y
% las pasamos a blanco y negro con un umbral normalizado a elegir:
e0 = imread ('e0.png');
e1 = imread ('e1.png');
e2 = imread ('e2.png');
e3 = imread ('e3.png');
e4 = imread ('e4.png');
e5 = imread ('e5.png');
e6 = imread ('e6.png');
e7 = imread ('e7.png');
e8 = imread ('e8.png');
e9 = imread ('e9.png');

% A blanco y negro con un umbral normalizado de 0.5:
umbralBW = 0.5;

e0bw = uint8(not(im2bw(e0,umbralBW))); 
e1bw = uint8(not(im2bw(e1,umbralBW)));
e2bw = uint8(not(im2bw(e2,umbralBW)));
e3bw = uint8(not(im2bw(e3,umbralBW)));
e4bw = uint8(not(im2bw(e4,umbralBW)));
e5bw = uint8(not(im2bw(e5,umbralBW)));
e6bw = uint8(not(im2bw(e6,umbralBW)));
e7bw = uint8(not(im2bw(e7,umbralBW)));
e8bw = uint8(not(im2bw(e8,umbralBW)));
e9bw = uint8(not(im2bw(e9,umbralBW)));


% return;

% Ahora, es necesario hacer el etiquetado de las im�genes para poder
% hacer el entrenamiento de los d�gitos:

% Se van a meter en una matriz de tres dimensiones la informaci�n de los
% etiquetados para que sea m�s c�modo de trabajar con ella
nClases=10;
[M,N]=size(e0bw);
et=zeros(M,N,nClases);

et(:,:,1)=bwlabel(e1bw);
et(:,:,2)=bwlabel(e2bw);
et(:,:,3)=bwlabel(e3bw);
et(:,:,4)=bwlabel(e4bw);
et(:,:,5)=bwlabel(e5bw);
et(:,:,6)=bwlabel(e6bw);
et(:,:,7)=bwlabel(e7bw);
et(:,:,8)=bwlabel(e8bw);
et(:,:,9)=bwlabel(e9bw);
et(:,:,10)=bwlabel(e0bw);

% return;


% Ahora, ser� necesario hacer el entrenamiento de cada uno de los d�gitos.

% Teniendo en cuenta que estamos trabajando exclusivamente con n�meros del
% 0 al 9, ser�n necesarios hacer la clasificaci�n con 10 clases distintas.

% Se puede notar que en cada una de las im�genes de entrenamiento hay 24
% patrones, por lo que ser�n necesarios 24 patrones * 10 clases = 240
% columnas.

% En cuanto a las caracter�sticas a usar para hacer el clasificador, se
% recurrir�n a los momentos de Hu que mayor informaci�n nos ofrezcan por lo
% que, a priori, se van a considerar los 8 momentos de Hu (7 filas + 1 fila
% para identificar la clase del patr�n)

% MatrizPatrones = zeros (8,240);
MatrizPatrones = [];
for i=1:10
    Patrones_i = Entrenador(et(:,:,i),i);
    MatrizPatrones = [MatrizPatrones, Patrones_i];
end

return;
