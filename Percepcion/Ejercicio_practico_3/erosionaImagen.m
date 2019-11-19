function plantillaErosionada = erosionaImagen(plantilla,mascara)

% Funci�n que hace la erosi�n de una plantilla dado la m�scara que se desee

% Dimensiones de la plantilla
[M,N] = size(plantilla);
radioMask = floor(size(mascara.Neighborhood)/2);

% Tama�o de la m�scara
radioMask = size(mascara);
plantillaErosionada = plantilla;
for y = 1+radioMask:M-radioMask
    for x = 1+radioMask:N-radioMask
%         if(plantilla(y,x) ~= 0)
            for ym = -radioMask:radioMask
                for xm = -radioMask:radioMask
                    if((mascara.Neighborhood(ym+radioMask+1,xm+radioMask+1)))
                        if((plantilla(y+ym,x+xm)) == 0)
                            plantillaErosionada(y,x) = 0;
%                             xm = radioMask;
%                             ym = radioMask;
                        end
                    end
                end
            end
%         end
        
    end
end
