function plantillaDilatada = dilataImagen(plantilla,mascara)

% Función que hace la erosión de una plantilla dado la máscara que se desee

% Dimensiones de la plantilla
[M,N] = size(plantilla);
radioMask = floor(size(mascara.Neighborhood)/2);

% Tamaño de la máscara
radioMask = size(mascara);
plantillaDilatada = plantilla;
for y = 1+radioMask:M-radioMask
    for x = 1+radioMask:N-radioMask
            for ym = -radioMask:radioMask
                for xm = -radioMask:radioMask
                    if((mascara.Neighborhood(ym+radioMask+1,xm+radioMask+1)))
                        if((plantilla(y+ym,x+xm)) == 1)
                            plantillaDilatada(y,x) = 1;
%                             xm = radioMask;
%                             ym = radioMask;
                        end
                    end
                end
            end
%         end
        
    end
end