function fisher = calculaFisher(nClases,Medias,MediasPatrones,Vk)

% Para calcular el coeficiente de Fisher, es necesario calcular la varianza
% de dispersión externa e interna:

% Inicialización
Ve = 0;
Vi = 0;


% Cálculo de Ve
for i=1:nClases
    Ve = Ve + (MediasPatrones(i,:)-Medias)*(MediasPatrones(i,:)-Medias)';
end

Ve = (1/nClases) * Ve;

% Cálculo de Vi
for i=1:nClases
    Vi = Vi + Vk(:,:,i);
end

Vi = (1/nClases) * Vi;

% Por tanto, el cociente de Fisher resulta:

fisher = Vi^(-1/2) * Ve * (Vi^(-1/2))';

end