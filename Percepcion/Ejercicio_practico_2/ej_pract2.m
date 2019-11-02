% ------------------------------------------------------------------------
% Ejercicio práctico 2 - Eliminación de distorsión en imagen
% ------------------------------------------------------------------------


%------------------------ Parámetros de la cámara -----------------------
f = 4.2e-3; %Distancia focal

N = 1000;
M = 1000;

u0 = N/2 + 1;
v0 = M/2 - 2;

% Sensor de la cámara
w = 4.96e-3;
h = 3.52e-3;

% K de distorsión radial:
% Lente 1:
% kr1 = -0.4320;

% Lente 2
% kr1 = 0.4320;

% Dimensiones efectivas del píxel:
rho_x = w/N;
rho_y = h/M;

% Longitudes focales efectivas:
fx = f/rho_x;
fy = f/rho_y;


% ---------------------------------------------------------------------

% Leemos la imagen distorsionada
% Imagen 1
f1 = double(imread('chessBoardDistorted1.jpg'));

% Imagen 2
f2 = double(imread('chessBoardDistorted2.jpg'));

% Se inicializan las matrices con color gris tanto para el interpolador del
% vecino más cercano como para el bilineal
vecino = double(128*ones([N,M]));
bilineal = double(128*ones([N,M]));

% Correccion de imagen 1
% function [vecino, bilineal] = corrige(imagen_distorsionada)
kr1 = -0.4320;
imagen_distorsionada = f1;
corrige;
fv1 = vecino;
fb1 = bilineal;

vecino = double(128*ones([N,M]));
bilineal = double(128*ones([N,M]));


% Correccion de imagen 2
kr1 = 0.4320;
imagen_distorsionada = f2;
%[fv2, fb2] = corrige(f2);
corrige;
fv2 = vecino;
fb2 = bilineal;

figure(1);
imshow(uint8([f1,fv1,fb1]));
figure(2);
imshow(uint8(abs(fv1-fb1)));

figure(3);
imshow(uint8([f2,fv2,fb2]));
figure(4);
imshow(uint8(abs(fv2-fb2)));