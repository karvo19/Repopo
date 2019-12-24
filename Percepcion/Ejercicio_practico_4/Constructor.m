% Constructor

% N�mero de clases:
nClases = 10;

% Tama�o de la matriz de entrenamiento
%   Patr�n 1    Patr�n 2            ...        Patr�n nPatrones
% [    x1_1            x1_2         ...         x1_nPatrones      ]
% [    x2_1            x2_2         ...         x2_nPatrones      ]
% [     ...             ...         ...             ...           ]
% [    xn_nPatrones    xn_nPatrones ...         xn_nPatrones      ]
% [    clase_1          clase_2     ...         clase_nPatrones   ]   
[nfilas, nPatrones] = size(MatrizEntrenamiento);

% C�lculo de los prototipos como valores medios (centroides) de cada clase:
sumaPorClase = zeros (7, nClases);
nPatronesPorClase = zeros (1, nClases);

% Bucle for para ir calculando los sumatorios de cada caracter�stica, clase
% por clase, y tambi�n los patrones que tiene cada clase para,
% posteriormente, poder hacer la media (centroide)
for nPatron = 1:nPatrones
   % Patr�n y clase a la que pertenece:
   x = MatrizEntrenamiento(1:7,nPatron);
   clase = MatrizEntrenamiento(8,nPatron);
   % Se incrementa la suma con los valores x1, x2 del patr�n actual:
   sumaPorClase(:,clase) = sumaPorClase(:,clase) + x;
   % Se incrementa el contador de la clase en 1:
   nPatronesPorClase(clase) = nPatronesPorClase(clase) + 1;
end

% El resultado de la media es una matriz de vectores prototipo:
Mprototipos = zeros (3,nClases);
i = 1;

% Notar que se usan las caracter�sticas 1, 3, 4 y 6
Mprototipos(i,:) = sumaPorClase(1,:)./nPatronesPorClase; i = i + 1;
% Mprototipos(i,:) = sumaPorClase(2,:)./nPatronesPorClase; i = i + 1;
Mprototipos(i,:) = sumaPorClase(3,:)./nPatronesPorClase; i = i + 1;
Mprototipos(i,:) = sumaPorClase(4,:)./nPatronesPorClase; i = i + 1;
% Mprototipos(i,:) = sumaPorClase(5,:)./nPatronesPorClase; i = i + 1;
Mprototipos(i,:) = sumaPorClase(6,:)./nPatronesPorClase; i = i + 1;
% Mprototipos(i,:) = sumaPorClase(7,:)./nPatronesPorClase; i = i + 1;