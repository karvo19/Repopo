%% Validación

% % Ahora, es necesario ver qué características son las que mejor se
% % diferencian entre un dígito y otro. Para ello, se va a recurrir al
% % cálculo del momento de Fisher para cada clase.

% % Validacion;

% % Es necesario calcular la media de todas las clases:
% nClases = 10;
% Medias = zeros(size(MediasPatrones)); %Inicialización

% % Sumatorio
% for i=1:nClases
%     Medias = Medias + MediasPatrones(i,:);
% end
% % return;
% % Dividido entre el número de clases
% Medias = (1/nClases) * Medias;
% 
% Vk = zeros(10,10,10); %Covarianza de 24x24 (patrones) y 10 dígitos

% % La covarianza de cada clase resulta:
% for i=1:10
%     Vk(:,:,i) = cov(MatrizPatrones(:,1:10,i));
% end

% % Por tanto, ya se tienen todos los datos necesarios para calcular el
% % coeficiente de Fisher generalizado:
% fisher = calculaFisher(nClases,Medias,MediasPatrones,Vk);

% return;

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