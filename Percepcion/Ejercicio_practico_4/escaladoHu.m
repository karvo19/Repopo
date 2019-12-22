function MomentosHuEscalados = escaladoHu(MomentosHu)

% Función que hace el escalado entre 0 y 1 de los momentos de Hu.
% Notar que la matriz de MomentosHu que entra como parámetro agrupa los
% momentos de Hu por filas.

[alto,ancho] = size(MomentosHu);

for i=1:7
   Max_i = max(max(MomentosHu(:,:)));
   Min_i = min(min(MomentosHu(:,:)));
   for j=1:ancho
       MomentosHuEscalados(i,j) = ( MomentosHu(i,j) - Min_i ) / ( Max_i - Min_i );
   end
    
end

end