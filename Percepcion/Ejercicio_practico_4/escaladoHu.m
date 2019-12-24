function MomentosHuEscalados = escaladoHu(MomentosHu)

% Función que hace el escalado entre 0 y 1 de los momentos de Hu.
% Notar que la matriz de MomentosHu que entra como parámetro agrupa los
% momentos de Hu por filas.

[alto,ancho] = size(MomentosHu);

% Es necesario para su escalado saber el máximo y el mínimo de cada uno de
% los momentos de Hu de TODOS LOS PATRONES. Luego, momento a momento se
% escala cada uno de los momentos pertenecientes a cada patrón:
for i=1:7
   Max_i = max(MomentosHu(i,:));
   Min_i = min(MomentosHu(i,:));
   for j=1:ancho
       MomentosHuEscalados(i,j) = ( MomentosHu(i,j) - Min_i ) / ( Max_i - Min_i );
   end
    
end

end