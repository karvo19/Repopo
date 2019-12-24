function MediasPatrones = calculaMediaPatron(MatrizPatrones)

%Inicialización de la variable donde se va a almacenar la media de los
%patrones
MediasPatrones = zeros (7,1);

%Se calcula media de los patrones y se almacena en un vector columna
for i=1:7
    MediasPatrones(i,1) = mean(MatrizPatrones(i,:));
end

end