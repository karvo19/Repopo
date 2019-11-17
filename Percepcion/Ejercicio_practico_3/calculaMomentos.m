function [masa, cdmasa, inercia] = calculaMomentos(plantilla)

% Función que calcula los momentos de orden 0, 1 y 2 a partir de una
% plantilla
[M,N] = size(plantilla);
% Suponiendo que está etiquetada, vamos a calcular el máximo de etiquetas:
etiqs = max(max(plantilla));

% Inicialización de los momentos
masa = zeros(1,etiqs);
cdmasa = zeros(2,etiqs);
inercia = zeros(2,2,etiqs);
m10 = zeros(1,etiqs);
m01 = zeros(1,etiqs);
mu11 = zeros(1,etiqs);
mu20 = zeros(1,etiqs);
mu02 = zeros(1,etiqs);

% Para calcular la masa, r y s deben ser 0
r = 0; s = 0;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                masa(i) = masa(i) + (x^r)*(y^s);
            end
        end
    end
end


% Para calcular el centro de masas, es necesario conocer el momento de
% orden r=1;s=0; y viceversa
r = 1; s = 0;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                m10(i) = m10(i) + (x^r)*(y^s);
            end
        end
    end
end


r = 0; s = 1;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                m01(i) = m01(i) + (x^r)*(y^s);
            end
        end
    end
end

% Por tanto, el centro de masas se encuentra en:
xcm = m10./masa;
ycm = m01./masa;
cdmasa = [xcm; ycm];

% Se calcula ahora el momento central
r = 1; s = 1;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu11(i) = mu11(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end

% Para calcular el centro de inercias, es necesario calcular el momento
% central de orden 2, 0 y el de 0, 2:
% Se calcula ahora el momento central
r = 2; s = 0;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu20(i) = mu20(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end


r = 0; s = 2;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu02(i) = mu02(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end

% Por tanto, el centro de inercias resulta:
for i = 1:etiqs
    inercia(:,:,i) = [mu02(i) -mu11(i); -mu11(i) mu20(i)];
end