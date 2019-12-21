function Mpatrones = CargaPatronesConjuntoValidacion (Mprototipos, nClases, rangoCaract)
%
% Funci�n que cargar�a el conjunto de patrones de validaci�n para el test del clasificador.
% Aqu� simularemos que se dispone de esos patrones, generando un cierto n�mero de ellos para cada
% clase, siguiente una distribuci�n normal cuya media coincide con el prototipo de la clase
% correspondiente y una desviaci�n t�pica fijada por igual para todas las clases.
%

dibujarSN = 0;

% Asumimos una determinada desviaci�n t�pica, igual para todas las clases:
sigma = 0.1;

% Rango admitido de cada una de las dos caracter�sticas:
x1Min = rangoCaract(1,1);
x1Max = rangoCaract(1,2);
x2Min = rangoCaract(2,1);
x2Max = rangoCaract(2,2);

% Generaremos el mismo n�mero de patrones por cada clase:
nPatronesPorClase = 100;

Mpatrones = [];

if dibujarSN
   figure;  hold on;
end

% Queremos forzar a que siempre que se ejecute se cargue el mismo conjunto de patrones de
% validaci�n. Para ello, establecemos siempre la misma semilla del generador de n�meros aleatorios:
rng(1);

for k = 1 : nClases
   z = Mprototipos(:,k);
   x1PatronesCk = randn(1,nPatronesPorClase) * sigma + z(1);
   x2PatronesCk = randn(1,nPatronesPorClase) * sigma + z(2);
   % Restringimos cada una de las caracter�sticas al rango admisible:
   x1PatronesCk = min(max(x1PatronesCk,x1Min),x1Max);
   x2PatronesCk = min(max(x2PatronesCk,x2Min),x2Max);
   Mpatrones = [Mpatrones, [x1PatronesCk; x2PatronesCk; k*ones(1,nPatronesPorClase)]];

   if dibujarSN
      plot(x1PatronesCk,x2PatronesCk, 'b.');
   end
end

if dibujarSN
   for clase = 1:nClases
       z = Mprototipos(:,clase);
       plot (z(1), z(2), 'kx', 'MarkerSize', 18);
       text (z(1), z(2)+0.05, sprintf('%d', clase), 'FontSize', 24 ); 
   end
   hold off;
end
