function MediasPatrones = calculaMediaPatron(MatrizPatrones)

MediasPatrones = zeros (7,1);

for i=1:7
    MediasPatrones(i,1) = mean(MatrizPatrones(i,:));
end

end