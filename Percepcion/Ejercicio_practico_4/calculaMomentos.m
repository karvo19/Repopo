function [mu00,mu11,mu10,mu01,mu20,mu02,mu21,mu12,mu30,mu03] = calculaMomentos(plantilla)

% Funci�n que calcula los momentos de orden 0, 1 y 2 a partir de una
% plantilla
[M,N] = size(plantilla);
% Suponiendo que est� etiquetada, vamos a calcular el m�ximo de etiquetas:
etiqs = max(max(plantilla));

% Inicializaci�n de los momentos
masa = zeros(1,etiqs);
cdmasa = zeros(2,etiqs);
inercia = zeros(2,2,etiqs);
m10 = zeros(1,etiqs);
m01 = zeros(1,etiqs);
mu00 = zeros(1,etiqs);
mu11 = zeros(1,etiqs);
mu10 = zeros(1,etiqs);
mu01 = zeros(1,etiqs);
mu20 = zeros(1,etiqs);
mu02 = zeros(1,etiqs);
mu21 = zeros(1,etiqs);
mu12 = zeros(1,etiqs);
mu30 = zeros(1,etiqs);
mu03 = zeros(1,etiqs);

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



r = 1; s = 2;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu12(i) = mu12(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end



r = 2; s = 1;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu21(i) = mu21(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end



r = 3; s = 0;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu30(i) = mu30(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end


r = 0; s = 3;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu03(i) = mu03(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end


r = 0; s = 0;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu00(i) = mu00(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end


r = 0; s = 1;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu01(i) = mu01(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end





r = 1; s = 0;
for i = 1:etiqs
    for x = 1:N
        for y = 1:M
            if (plantilla(y,x)==i)
                mu10(i) = mu10(i) + (x-xcm(i))^r*(y-ycm(i))^s;
            end
        end
    end
end



% Momentos = [mu00;mu11;mu10;mu01;mu20;mu02;mu21;mu12;mu30;mu03];

% Por tanto, el centro de inercias resulta:
for i = 1:etiqs
    inercia(:,:,i) = [mu02(i) -mu11(i); -mu11(i) mu20(i)];
end