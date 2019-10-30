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
h = 4.96e-3;
w = 3.52e-3;

% K de distorsión radial:
% Lente 1:
kr1 = -0.4320;

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
f1 = imread('chessBoardDistorted1.jpg');
ff1 = zeros([N,M]);

% Imagen 2
f2 = imread('chessBoardDistorted2.jpg');
ff2 = zeros([N,M]);


% Criterio de interpolación al vecino más cercano
for u = 0:N-1
    for v = 0:M-1
        % Cálculo de coordenadas normalizadas
        xn = (u-u0)/fx;
        yn = (v-v0)/fy;

        % u = xn*fx + u0;
        % v = yn*fy + v0;

        % Cálculo de la r2
        r2 = xn^2 + yn^2;

        % Coordenadas distorsionadas:
        xn_d = xn*(1+kr1*r2);
        yn_d = yn*(1+kr1*r2);

        % Coordenadas del píxel distorsionadas:
        u_d = xn_d*fx + u0;
        v_d = yn_d*fy + v0;
        
        ff1(u+1,v+1) = uint8( f1(round(u_d),round(v_d)) );
    end
end

figure(1);
imshow([f1,ff1]);

% 