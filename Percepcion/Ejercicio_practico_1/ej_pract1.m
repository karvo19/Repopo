% Ejercicio práctico 1 Sistemas de percepción

% En primer lugar, se va a hacer una matriz que simule el tablero de
% ajedrez que se desea proyectar en el sensor de la cámara.

% Se va a considerar que hay una separación entre puntos de 10cm
% equidistantes tanto en el eje horizontal como en vertical:

%i --> fila; j --> columna

Naj = 8;             %Número de columnas de tablero de ajedrez
Maj = 5;             %Número de filas de tablero de ajedrez
M_P = zeros(3,Naj*Maj);   %Matriz de puntos inicialmente relleno de ceros
separacion=0.1;      %m

for j=1:Maj          %Por filas del tablero
    for i=1:Naj      %Por columnas del tablero
        M_P(:,(i+(j-1)*Naj)) = [separacion*(i-1) separacion*(j-1) 0];    %10cm=0.1m,  z=0
    end
end


plot(M_P(1,:),M_P(2,:),'*'); grid; hold on;     %Mostramos el tablero
rectangle('Position', [0 0 separacion*(Naj-1) separacion*(Maj-1)]);

% Parámetros de la cámara
f = 4.2e-3;             %Distancia focal (m)               

N = 4128;               %Número de píxeles horizontales
M = 3096;               %Número de píxeles verticales

w = 4.96e-3;            %Anchura de sensor de la cámara
h = 3.52-3;             %Altura de sensor de la cámara

u0 = round(N/2) + 1;    %Offset de u (proyección en lente)
v0 = round(M/2) -2;     %Offset de v (proyección en lente)

rho_x = w/N;
rho_y = h/M;

fx = f/rho_x;
fy = f/rho_y;
s = 0;                  %Skew=0

A = [fx s*fx u0
      0   fy v0
      0    0  1];

  % Matrices de rotación
% Rz = [cos(pi/2) -sin(pi/2)   0
%       sin(pi/2)  cos(pi/2)   0
%             0           0      1];
% 
% Rx = [       1          0           0
%              0    cos(-pi/2) -sin(-pi/2)
%              0    sin(-pi/2)  cos(-pi/2)];


  
%Coeficientes de distorsión
%Radial
kr1=0.144; kr2=-0.307;

%Tangencial
kt1=-0.0032; kt2=0.0017;

%% Procedimiento del ejercicio sin distorsión en la lente

