% Ejercicio pr�ctico 1 Sistemas de percepci�n

% En primer lugar, se va a hacer una matriz que simule el tablero de
% ajedrez que se desea proyectar en el sensor de la c�mara.

% Se va a considerar que hay una separaci�n entre puntos de 10cm
% equidistantes tanto en el eje horizontal como en vertical:
clear all
close all
clc
%i --> fila; j --> columna

Naj = 8;             %N�mero de columnas de tablero de ajedrez
Maj = 5;             %N�mero de filas de tablero de ajedrez
M_P = zeros(3,Naj*Maj);   %Matriz de puntos inicialmente relleno de ceros
separacion=0.1;      %m

%�ngulos de euler de la c�mara:
alpha=180*(pi/180);  %x
beta=0;              %y
gamma=0;             %z

%Posici�n inicial de la c�mara:
x=0.5;
y=0.5;
z=2;


for j=1:Maj          %Por filas del tablero
    for i=1:Naj      %Por columnas del tablero
        wM_P(:,(i+(j-1)*Naj)) = [separacion*(i-1) separacion*(j-1) 0];
        wM_P_(:,(i+(j-1)*Naj))=[wM_P(:,(i+(j-1)*Naj));1];        %Matriz en homog�neas
    end
end

figure(1);
plot(wM_P(1,:),wM_P(2,:),'*'); grid; hold on;     %Mostramos el tablero
title('Representaci�n del tablero');
xlabel('Horizontal (m)'); ylabel('Horizontal (m)');
rectangle('Position', [0 0 separacion*(Naj-1) separacion*(Maj-1)]);

% Par�metros de la c�mara
f = 4.2e-3;             %Distancia focal (m)               

N = 4128;               %N�mero de p�xeles horizontales
M = 3096;               %N�mero de p�xeles verticales

w = 4.96e-3;            %Anchura de sensor de la c�mara
h = 3.52e-3;             %Altura de sensor de la c�mara

u0 = round(N/2) + 1;    %Offset de u (proyecci�n en lente)
v0 = round(M/2) -2;     %Offset de v (proyecci�n en lente)

rho_x = w/N;            %Anchura efectiva del p�xel
rho_y = h/M;            %Altura efectiva del p�xel

fx = f/rho_x;           %Distancia efectiva horizontal (m)
fy = f/rho_y;           %Distancia efectiva vertical (m)
s = 0;                  %Skew=0

A = [fx s*fx u0
      0   fy v0
      0    0  1];

  % Matrices de rotaci�n
Rx = [       1          0           0
             0    cos(alpha) -sin(alpha)
             0    sin(alpha)  cos(alpha)];
Ry = [       cos(beta)          0           sin(beta)
             0                  1             0
             -sin(beta)         0           cos(beta)];
Rz = [cos(gamma) -sin(gamma)   0
      sin(gamma)  cos(gamma)   0
            0           0      1];

  
%Coeficientes de distorsi�n
%Radial
kr1 = 0.144; kr2 = -0.307;


%Tangencial
kt1 = -0.0032; kt2 = 0.0017;

%% Procedimiento del ejercicio sin distorsi�n en la lente

%Matriz de rotaci�n de la c�mara respecto al mundo (rotaci�n x 180�):
wRc = Rx*Ry*Rz;

%Matriz de traslaci�n de la c�mara respecto al mundo:
wtc = [x y z]';

%Por tanto, la matriz de transformaci�n homog�nea quedar�a (PRIMERO
%TRASLADAR, LUEGO ROTAR): 
wTc = [eye(3) [wtc]; [0 0 0 1]]*[wRc [0;0;0]; [0 0 0 1]];

%Para poner la matriz de transformaci�n homog�nea respecto a la c�mara:
cTw = inv(wTc);

%De donde se obtienen los par�metros extr�nsecos:
cRw = cTw(1:3,1:3);
ctw = cTw(1:3,4);

%Ahora, se calculan los puntos proyectados homog�neos respecto a la
%c�mara:

mp_ = A*[cRw ctw]*wM_P_;

%La matriz de puntos proyectados queda, por tanto:
for i=1:Naj*Maj
    mp(:,i) = mp_(1:2,i)/mp_(3,i);
end

figure(2);
plot(mp(1,:),mp(2,:),'*'); grid; hold on;     %Mostramos el tablero
title('Proyecci�n de la imagen captada por el sensor de la c�mara SIN DISTORSI�N');
xlabel('pix'); ylabel('pix');
rectangle('Position', [0 0 N M]); hold off;


%% Procedimiento del ejercicio con distorsi�n en la lente

%En primer lugar, es necesario poner los puntos del tablero de ajedrez
%(wM_P) referenciados al sistema de referencia de la c�mara (cM_P):

%Matriz de rotaci�n de la c�mara respecto al mundo (rotaci�n x 180�):
wRc = Rx*Ry*Rz;

%Matriz de traslaci�n de la c�mara respecto al mundo:
wtc = [x y z]';

%Por tanto, la matriz de transformaci�n homog�nea quedar�a (PRIMERO
%TRASLADAR, LUEGO ROTAR): 
wTc = [eye(3) [wtc]; [0 0 0 1]]*[wRc [0;0;0]; [0 0 0 1]];

%Para poner la matriz de transformaci�n homog�nea respecto a la c�mara:
cTw = inv(wTc);

%De donde se obtienen los par�metros extr�nsecos:
cRw = cTw(1:3,1:3);
ctw = cTw(1:3,4);


%De este modo, se obtiene los puntos del tablero de ajedrez referenciados a
%la c�mara (no se puede multiplicar directamente por A porque la distorsi�n
%va despu�s de la proyecci�n):
cM_P = [cRw ctw] * wM_P_;

%A continuaci�n, se proyectar�n los puntos NORMALIZADOS:
for i = 1:Naj*Maj
M_p_norm(:,i) = [cM_P(1,i)/cM_P(3,i);cM_P(2,i)/cM_P(3,i)];     %cX/cZ;cY/cZ
end

%Una vez obtenidos los puntos proyectados normalizados, se aplican las
%distorsiones radial y tangencial a cada punto de la matriz:

%Vector de r^2 (para cada punto):
for i = 1:Naj*Maj
    r2(i) = M_p_norm(1,i)^2 + M_p_norm(2,i)^2;      %r^2=x^2+y^2
end

%Vector de distorsi�n radial:
for i = 1:Naj*Maj
    dist_r(i) = 1 + kr1*r2(i) + kr2*r2(i)^2;
end

%Matriz de distorsi�n tangencial:
for i = 1:Naj*Maj
    dist_t(:,i) =  [ (2*kt1*M_p_norm(1,i)*M_p_norm(2,i)) + kt2*(r2(i)+2*M_p_norm(1,i)^2) ;
                     (2*kt2*M_p_norm(1,i)*M_p_norm(2,i)) + kt1*(r2(i)+2*M_p_norm(2,i)^2)];
end

%Por tanto, la matriz de puntos normalizados y distorsionados quedar�a:
for i = 1:Naj*Maj
    m_p_norm_dist(:,i) = [M_p_norm(1,i);M_p_norm(2,i)] * dist_r(i) + [dist_t(1,i);dist_t(2,i)];
end

%Ahora, para obtener los puntos distorsionados (sin normalizar) y
%proyectados:
for i = 1:Naj*Maj
    m_p_dist(:,i) = [m_p_norm_dist(1,i)*fx + u0 ; m_p_norm_dist(2,i)*fy + v0 ];
end


%Representando:
figure(3);
plot(m_p_dist(1,:),m_p_dist(2,:),'*'); grid; hold on;     %Mostramos el tablero
title('Proyecci�n de la imagen captada por el sensor de la c�mara CON DISTORSI�N');
xlabel('pix'); ylabel('pix');
rectangle('Position', [0 0 N M]); hold off;