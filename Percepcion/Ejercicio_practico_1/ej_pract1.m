%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% El presente script está dividido en cuatro partes: 
%       - En la primera se dimensiona y construye el tablero. 
%
%       - En la segunda se hacen los calculos para representar lo captado 
%         por el sensor de la camara sin distorsion.
%
%       - En la tercera parte se realizan los calculos con distorsion.
%
%       - En la cuarta y ultima se realiza una animacion, utilizando la 
%         funcion "pause(1)". Se recomienda poner la figura 4 a pantalla
%         completa para ver mejor la animacion.
%
%
% Los comentarios que explican el proceso y lo que hace cada linea de
% código estan principalmente en las tres primeras partes, ya que la
% ultima no es mas que una copia de los dos primeros con algunas 
% modificaciones para poder representar la animacion.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Ejercicio práctico 1 Sistemas de percepción

% En primer lugar, se va a hacer una matriz que simule el tablero de
% ajedrez que se desea proyectar en el sensor de la cámara.

% Se va a considerar que hay una separación entre puntos de 10cm
% equidistantes tanto en el eje horizontal como en vertical:
clear all
close all
clc
%i --> fila; j --> columna

Naj = 8;             % Número de columnas de tablero de ajedrez
Maj = 5;             % Número de filas de tablero de ajedrez
M_P = zeros(3,Naj*Maj);   % Matriz de puntos inicialmente relleno de ceros
separacion = 0.1;      % [m]

% Ángulos de giro de los ejes de la camara
alpha = 180*(pi/180);  %x
beta = 0*(pi/180);    %y
gamma = 0*(pi/180);   %z

% Posición inicial de la cámara:
x = 0;
y = 0;
z = 2;

% Generamos las coordenadas respecto al mundo de los puntos del tablero
for j = 1:Maj          % Por filas del tablero
    for i = 1:Naj      % Por columnas del tablero
        wM_P(:,(i+(j-1)*Naj)) = [separacion*(i-1) separacion*(j-1) 0];
        wM_P_(:,(i+(j-1)*Naj)) = [wM_P(:,(i+(j-1)*Naj));1];        %Matriz en homogéneas
    end
end

figure(1);
plot(wM_P(1,:),wM_P(2,:),'*'); grid; hold on;     %Mostramos el tablero
title('Representación del tablero');
xlabel('Horizontal (m)'); ylabel('Horizontal (m)');
rectangle('Position', [0 0 separacion*(Naj-1) separacion*(Maj-1)]);


% Parámetros de la cámara
f = 4.2e-3;             %Distancia focal (m)               

N = 4128;               %Número de píxeles horizontales
M = 3096;               %Número de píxeles verticales

w = 4.96e-3;            %Anchura de sensor de la cámara
h = 3.52e-3;             %Altura de sensor de la cámara

u0 = round(N/2) + 1;    %Offset de u (proyección en lente)
v0 = round(M/2) -2;     %Offset de v (proyección en lente)

rho_x = w/N;            %Anchura efectiva del píxel
rho_y = h/M;            %Altura efectiva del píxel

fx = f/rho_x;           %Distancia efectiva horizontal (m)
fy = f/rho_y;           %Distancia efectiva vertical (m)
s = 0;                  %Skew=0

% Matriz de parámetros intrinsecos
A = [fx s*fx u0
      0   fy v0
      0    0  1];

% Matrices de rotación
Rx = [1             0           0
      0    cos(alpha) -sin(alpha)
      0    sin(alpha)  cos(alpha)];
  
Ry = [ cos(beta)    0   sin(beta)
               0    1           0
      -sin(beta)    0   cos(beta)];
  
Rz = [cos(gamma) -sin(gamma)   0
      sin(gamma)  cos(gamma)   0
            0           0      1];

  
%Coeficientes de distorsión
%Radial
kr1 = 0.144; kr2 = -0.307;

%Tangencial
kt1 = -0.0032; kt2 = 0.0017;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Procedimiento del ejercicio sin distorsión en la lente

% Matriz de rotación de la cámara respecto al mundo (rotación x de 180º):
wRc = Rx*Ry*Rz;

% Matriz de traslación de la cámara respecto al mundo:
wtc = [x y z]';

% Por tanto, la matriz de transformación homogénea quedaría (PRIMERO
% TRASLADAR, LUEGO ROTAR): 
wTc = [eye(3) [wtc]; [0 0 0 1]]*[wRc [0;0;0]; [0 0 0 1]];

%Para poner la matriz de transformación homogénea respecto a la cámara:
cTw = inv(wTc);

%De donde se obtienen los parámetros extrínsecos:
cRw = cTw(1:3,1:3);
ctw = cTw(1:3,4);

%Ahora, se calculan los puntos proyectados homogéneos respecto a la
%cámara:

mp_ = A*[cRw ctw]*wM_P_;

%La matriz de puntos proyectados queda, por tanto:
for i=1:Naj*Maj
    mp(:,i) = mp_(1:2,i)/mp_(3,i);
end

figure(2);
plot(mp(1,:),mp(2,:),'*'); grid; hold on;     %Mostramos el tablero
axis([-1 N+1 -1 M+1]);
set(gca, 'YDir', 'reverse');
title('Proyección de la imagen captada por el sensor de la cámara SIN DISTORSIÓN');
xlabel('pix'); ylabel('pix');
rectangle('Position', [0 0 N M]); hold off;

hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Procedimiento del ejercicio con distorsión en la lente

% En primer lugar, es necesario poner los puntos del tablero de ajedrez
% (wM_P) referenciados al sistema de referencia de la cámara (cM_P):

% Matriz de rotación de la cámara respecto al mundo (rotación x 180º):
wRc = Rx*Ry*Rz;

% Matriz de traslación de la cámara respecto al mundo:
wtc = [x y z]';

% Por tanto, la matriz de transformación homogénea quedaría (PRIMERO
% TRASLADAR, LUEGO ROTAR): 
wTc = [eye(3) [wtc]; [0 0 0 1]]*[wRc [0;0;0]; [0 0 0 1]];

% Para poner la matriz de transformación homogénea respecto a la cámara:
cTw = inv(wTc);

% De donde se obtienen los parámetros extrínsecos:
cRw = cTw(1:3,1:3);
ctw = cTw(1:3,4);


%De este modo, se obtiene los puntos del tablero de ajedrez referenciados a
%la cámara (no se puede multiplicar directamente por A porque la distorsión
%va después de la proyección):
cM_P = [cRw ctw] * wM_P_;

% A continuación, se proyectarán los puntos NORMALIZADOS:
for i = 1:Naj*Maj
    M_p_norm(:,i) = [cM_P(1,i)/cM_P(3,i);cM_P(2,i)/cM_P(3,i)];     %cX/cZ;cY/cZ
end

% Una vez obtenidos los puntos proyectados normalizados, se aplican las
% distorsiones radial y tangencial a cada punto de la matriz:

% Vector de r^2 (para cada punto):
for i = 1:Naj*Maj
    r2(i) = M_p_norm(1,i)^2 + M_p_norm(2,i)^2;    %ri^2 = Xni^2 + Yni^2
end

% Vector de distorsión radial:
for i = 1:Naj*Maj
    dist_r(i) = 1 + kr1*r2(i) + kr2*r2(i)^2;
end

% Matriz de distorsión tangencial:
for i = 1:Naj*Maj
    dist_t(:,i) =  [ (2*kt1*M_p_norm(1,i)*M_p_norm(2,i)) + kt2*(r2(i)+2*M_p_norm(1,i)^2) ;
                     (2*kt2*M_p_norm(1,i)*M_p_norm(2,i)) + kt1*(r2(i)+2*M_p_norm(2,i)^2)];
end

% Por tanto, la matriz de puntos normalizados y distorsionados quedaría:
for i = 1:Naj*Maj
    m_p_norm_dist(:,i) = [M_p_norm(1,i);M_p_norm(2,i)] * dist_r(i) + [dist_t(1,i);dist_t(2,i)];
end

% Ahora, para obtener los puntos distorsionados (sin normalizar) y
% proyectados:
for i = 1:Naj*Maj
    m_p_dist(:,i) = [m_p_norm_dist(1,i)*fx + u0 ; m_p_norm_dist(2,i)*fy + v0 ];
end


% Representando:
figure(3);
plot(m_p_dist(1,:),m_p_dist(2,:),'m*'); grid; hold on;     %Mostramos el tablero
axis([-1 N+1 -1 M+1]);
set(gca, 'YDir', 'reverse');
title('Proyección de la imagen captada por el sensor de la cámara CON DISTORSIÓN');
xlabel('pix'); ylabel('pix');
rectangle('Position', [0 0 N M]); hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Animaciones
% Vamos a representar tanto lo captado por la camara como la vista externa
% del conjunto Camara-Tablero respecto al mundo.

% Se iran cambiando las posiciones relativas Camara-Tablero de forma
% progresiva y ordenada para crear una "animación"

% Se hará simultaneamente con y sin distorsión para comparar resultados.
clear all

% Los calculos son exactamente los mismos que antes pero todo juntos
Naj = 8;             % Número de columnas de tablero de ajedrez
Maj = 5;             % Número de filas de tablero de ajedrez
M_P = zeros(3,Naj*Maj);   % Matriz de puntos inicialmente relleno de ceros
separacion = 0.1;      % [m]

% Generamos las coordenadas respecto al mundo de los puntos del tablero
    for j = 1:Maj          % Por filas del tablero
        for i = 1:Naj      % Por columnas del tablero
            wM_P(:,(i+(j-1)*Naj)) = [separacion*(i-1) separacion*(j-1) 0];
            wM_P_(:,(i+(j-1)*Naj)) = [wM_P(:,(i+(j-1)*Naj));1];        %Matriz en homogéneas
        end
    end
    
% Parámetros de la cámara
f = 4.2e-3;             %Distancia focal (m)               

N = 4128;               %Número de píxeles horizontales
M = 3096;               %Número de píxeles verticales

w = 4.96e-3;            %Anchura de sensor de la cámara
h = 3.52e-3;             %Altura de sensor de la cámara

u0 = round(N/2) + 1;    %Offset de u (proyección en lente)
v0 = round(M/2) -2;     %Offset de v (proyección en lente)

rho_x = w/N;            %Anchura efectiva del píxel
rho_y = h/M;            %Altura efectiva del píxel

fx = f/rho_x;           %Distancia efectiva horizontal (m)
fy = f/rho_y;           %Distancia efectiva vertical (m)
s = 0;                  %Skew=0

% Matriz de parámetros intrinsecos
A = [fx s*fx u0
      0   fy v0
      0    0  1];
  
%Coeficientes de distorsión
    %Radial
    kr1 = 0.144; kr2 = -0.307;

    %Tangencial
    kt1 = -0.0032; kt2 = 0.0017;

for i = 0:0.1:9
    % Ángulos de giro de los ejes de la camara
    alpha = (-90/9*i+180)*(pi/180);  %x
    beta =  (-20/9*i)*(pi/180);    %y
    gamma = (-110/9*i)*(pi/180);      %z

    % Posición inicial de la cámara:
    x =  0.05/9*i+0.7;
    y =  0.7/9*i+0.5;
    z = -1.7/9*i+2;

    % Matrices de rotación
    Rx = [1             0           0
          0    cos(alpha) -sin(alpha)
          0    sin(alpha)  cos(alpha)];

    Ry = [ cos(beta)    0   sin(beta)
                   0    1           0
          -sin(beta)    0   cos(beta)];

    Rz = [cos(gamma) -sin(gamma)   0
          sin(gamma)  cos(gamma)   0
                0           0      1];

    % Procedimiento del ejercicio sin distorsión en la lente
    wRc = Rx*Ry*Rz;
    wtc = [x y z]';
    wTc = [eye(3) [wtc]; [0 0 0 1]]*[wRc [0;0;0]; [0 0 0 1]];
    
    cTw = inv(wTc);
    cRw = cTw(1:3,1:3);
    ctw = cTw(1:3,4);
    
    mp_ = A*[cRw ctw]*wM_P_;

    for i=1:Naj*Maj
        mp(:,i) = mp_(1:2,i)/mp_(3,i);
    end
    
    figure(4);
    subplot(2,1,1);
    plot3(wM_P(1,:), wM_P(2,:), wM_P(3,:), 'm*');grid;hold on;
    plot3([0 (Naj-1)*separacion],[0 0],[0 0], 'r'); % eje x del tablero
    plot3([0 0],[0 (Maj-1)*separacion],[0 0], 'g'); % eje y del tablero
    plot3([0 0],[0 0],[0 1], 'b'); % eje z del tablero
    % Camara
    plot3(x, y, z, 'm*'); % Origen de la camara
    ejex_c = wTc*[0.1 0 0 1]';
    ejey_c = wTc*[0 0.1 0 1]';
    ejez_c = wTc*[0 0 0.1 1]';
    plot3([x ejex_c(1)],[y ejex_c(2)],[z ejex_c(3)], 'r'); % eje x de la camara
    plot3([x ejey_c(1)],[y ejey_c(2)],[z ejey_c(3)], 'g'); % eje y de la camara
    plot3([x ejez_c(1)],[y ejez_c(2)],[z ejez_c(3)], 'b'); % eje z de la camara
    title('Vista externa de la posicion relativa Camara-Tablero');
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');hold off;
    axis([0 1 0 1.5 0 2]);
    
%     subplot(2,2,2);
%     plot3(wM_P(1,:), wM_P(2,:), wM_P(3,:), 'm*');grid;hold on;
%     plot3([0 (Naj-1)*separacion],[0 0],[0 0], 'r'); % eje x del tablero
%     plot3([0 0],[0 (Maj-1)*separacion],[0 0], 'g'); % eje y del tablero
%     plot3([0 0],[0 0],[0 1], 'b'); % eje z del tablero
%     % Camara
%     plot3(x, y, z, 'm*'); % Origen de la camara
%     ejex_c = wTc*[0.1 0 0 1]';
%     ejey_c = wTc*[0 0.1 0 1]';
%     ejez_c = wTc*[0 0 0.1 1]';
%     plot3([x ejex_c(1)],[y ejex_c(2)],[z ejex_c(3)], 'r'); % eje x de la camara
%     plot3([x ejey_c(1)],[y ejey_c(2)],[z ejey_c(3)], 'g'); % eje y de la camara
%     plot3([x ejez_c(1)],[y ejez_c(2)],[z ejez_c(3)], 'b'); % eje z de la camara
%     title('Vista externa de la posicion relativa Camara-Tablero');
%     xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');hold off;
%     axis([0 1 0 1.5 0 2]);
    
    % Vista desde la cámara sin distorsionar
    subplot(2,1,2);
    plot(mp(1,:),mp(2,:),'k*'); grid; hold on;
    axis([-1 N+1 -1 M+1]);
    set(gca, 'YDir', 'reverse');
    title('Proyección de la imagen captada por el sensor de la cámara');
    xlabel('pix'); ylabel('pix');
    rectangle('Position', [0 0 N M]); % hold off;


    % Procedimiento del ejercicio con distorsión en la lente
    cM_P = [cRw ctw] * wM_P_;
    
    for i = 1:Naj*Maj
        M_p_norm(:,i) = [cM_P(1,i)/cM_P(3,i);cM_P(2,i)/cM_P(3,i)];
    end

    for i = 1:Naj*Maj
        r2(i) = M_p_norm(1,i)^2 + M_p_norm(2,i)^2;    %ri^2 = Xni^2 + Yni^2
    end

    for i = 1:Naj*Maj
        dist_r(i) = 1 + kr1*r2(i) + kr2*r2(i)^2;
    end

    for i = 1:Naj*Maj
        dist_t(:,i) =  [ (2*kt1*M_p_norm(1,i)*M_p_norm(2,i)) + kt2*(r2(i)+2*M_p_norm(1,i)^2) ;
                         (2*kt2*M_p_norm(1,i)*M_p_norm(2,i)) + kt1*(r2(i)+2*M_p_norm(2,i)^2)];
    end

    for i = 1:Naj*Maj
        m_p_norm_dist(:,i) = [M_p_norm(1,i);M_p_norm(2,i)] * dist_r(i) + [dist_t(1,i);dist_t(2,i)];
    end

    for i = 1:Naj*Maj
        m_p_dist(:,i) = [m_p_norm_dist(1,i)*fx + u0 ; m_p_norm_dist(2,i)*fy + v0 ];
    end

    % Vista desde la cámara con distorsion
    %figure(3);
    subplot(2,1,2);
    plot(m_p_dist(1,:),m_p_dist(2,:),'m*');  %grid; hold on;     %Mostramos el tablero
    axis([-1 N+1 -1 M+1]);
    set(gca, 'YDir', 'reverse');
    
    %Ajuste del tamaño de ventana
    size_window = get(0,'Screensize');
    size_window(3) = size_window(3)/2;
    set(gcf, 'Position', size_window);
    
    title('Proyección de la imagen captada por el sensor de la cámara');
    xlabel('pix'); ylabel('pix');
    rectangle('Position', [0 0 N M]); 
    legend('Sin distorsión','Con distorsión','Location','NorthWest');
    hold off;
    
    pause(0.1);
end