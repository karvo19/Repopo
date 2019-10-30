% ------------------------------------------------------------------------
% Ejercicio pr�ctico 2 - Eliminaci�n de distorsi�n en imagen
% ------------------------------------------------------------------------


%------------------------ Par�metros de la c�mara -----------------------
f = 4.2e-3; %Distancia focal

N = 1000;
M = 1000;

u0 = N/2 + 1;
v0 = M/2 - 2;

% Sensor de la c�mara
h = 4.96e-3;
w = 3.52e-3;

% K de distorsi�n radial:
% Lente 1:
kr1 = -0.4320;

% Lente 2
% kr1 = 0.4320;

% Dimensiones efectivas del p�xel:
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


% Criterio de interpolaci�n al vecino m�s cercano
for u = 0:N-1
    for v = 0:M-1
        % C�lculo de coordenadas normalizadas
        xn = (u-u0)/fx;
        yn = (v-v0)/fy;

        % u = xn*fx + u0;
        % v = yn*fy + v0;

        % C�lculo de la r2
        r2 = xn^2 + yn^2;

        % Coordenadas distorsionadas:
        xn_d = xn*(1+kr1*r2);
        yn_d = yn*(1+kr1*r2);

        % Coordenadas del p�xel distorsionadas:
        u_d = xn_d*fx + u0;
        v_d = yn_d*fy + v0;
        
        ff1(u+1,v+1) = uint8( f1(round(u_d),round(v_d)) );
    end
end

figure(1);
imshow([f1,ff1]);

% 