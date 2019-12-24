%% Ejercicio práctico 4 Sistemas de percepción: Reconocimiento de objetos
% Programa principal
% Preparación:
clc
% Se añade la ruta de las imagénes de entrenamiento
addpath ./Entrenamiento;

% Comenzaremos con la preparacion de las muestras conocidas que servirán de
% entrenamiento para construir el clasificador. El proceso de preparación
% consistirá en tratar y etiquetar la imagen, seguido del calculo de las
% características a usar para la clasificacion, en este caso, los momentos
% de Hu.

% En primer lugar, será necesario cargar las imágenes de entrenamiento y
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
umbralBW = 0.3;

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

% Ahora, es necesario hacer el etiquetado de las imágenes para poder
% hacer el entrenamiento de los dígitos:

% Se van a meter en una matriz de tres dimensiones la información de los
% etiquetados para que sea más cómodo de trabajar con ella
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


% Ahora, será necesario hacer el entrenamiento de cada uno de los dígitos.

% Teniendo en cuenta que estamos trabajando exclusivamente con números del
% 0 al 9, serán necesarios hacer la clasificación con 10 clases distintas.

% Se puede notar que en cada una de las imágenes de entrenamiento hay 24
% patrones, por lo que serán necesarios 24 patrones * 10 clases = 240
% columnas.

% En cuanto a las características a usar para hacer el clasificador, se
% recurrirán a los momentos de Hu que mayor información nos ofrezcan por lo
% que, a priori, se van a considerar los 8 momentos de Hu (7 filas + 1 fila
% para identificar la clase del patrón)

% MatrizPatrones = zeros (8,240);
MatrizPatrones = zeros(7,24,10); 
MediasPatrones = zeros(7,10); %Filas--> momentos de Hu 7; Columnas --> dígitos 10
MatrizEntrenamiento = []; %PARA CONSTRUCTOR


for i=1:10
    MatrizPatrones(:,:,i) = Entrenador(et(:,:,i));
    MatrizEntrenamiento(1:7,1+24*(i-1):24*i) = MatrizPatrones(:,:,i);
    MatrizEntrenamiento(8,1+24*(i-1):24*i) = i*ones(1,24);
    MediasPatrones(:,i) = calculaMediaPatron(MatrizPatrones(:,:,i));
end

MatrizEntrenamiento(1:7,:) = escaladoHu(MatrizEntrenamiento);

%return;
% Las medias están puestas como vector columna y nos interesa que esté como
% vector fila:
MediasPatrones = MediasPatrones';
% return;

%% Preparacion del conjunto a explotar.

% Lectura de matrícula:
f = imread('matriculas.png');
umbralMatBW = 0.45;
fbw = uint8(not(im2bw(f,umbralMatBW)));
figure();
imshow(fbw,[]);

% Ahora, es necesario identificar el marco de la matrícula para eliminarla
% de los objetos de estudio. Para ello, se va a identificar dentro de todas
% las etiquetas de esta última imagen, cuál no cumple cierta condición. La
% matrícula se caracteriza por ser, por ejemplo, (área / masa) es mucho
% mayor que cualquier dígito.

% Para calcular el área, se van a emplear los ejes principales de cada
% número, ya que las matrículas se encuentran giradas y, de esta forma, se
% calcularía de forma más precisa el área de cada etiqueta.

fet = bwlabel(fbw);
figure();
imshow(fet,[]);

% Ahora, sacamos la información necesaria para poder obtener la masa de
% cada etiqueta, además de sus ejes principales de inercia y también se
% obtendrán los ángulos girados de cada etiqueta en caso de que sea
% necesario posteriormente operar con ellos.

[masa_et,a_et,b_et,ang_et] = informacionGeometrica(fet);

% return;

fet2 = limpiaPlantilla(fet,masa_et,a_et,b_et);

figure();
imshow(fet2,[]);

% return;

%% 
% Una vez etiquetados los digitos de la imagen a explotar, es necesario
% analizar uno a uno e ir interpretando gracias al entrenamiento a qué
% dígito se corresponde.

% Para ello, será necesario calcular los momentos de Hu de cada dígito:

MomentosHuDigitos = calculaMomentosHu(fet2);

% Se puede apreciar que cada momento de Hu tiene un rango muy distinto de
% valores numéricos, por lo que es necesario hacer un escalado de ellas,
% por ejemplo, entre 0 y 1:

MomentosHuDigitosEscalados = zeros(size(fet2));

MomentosHuDigitosEscalados = escaladoHu(MomentosHuDigitos);

%% Clasificador

% Ahora ya disponemos de todos los datos necesarios cargados en memoria,
% tanto de los patrones como de la imagen que se quiere clasificar.
%
% Usaremos lo datos (momentos de Hu) de los patrones para construir el
% clasificador y validarlo, con el paso intermedio de decidir que
% subconjunto de características nos arroja un PCI mas favorable.

Constructor;
Validacion;

% Hecho esto pasamos a la explotacion, cotejando las caracteristicas de los
% digitos a explotar con la disponible en la matriz de prototipos
% generada por el constructor.

Explotacion;