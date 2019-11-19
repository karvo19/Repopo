function separaObjetos(plantilla,etiqueta,tamanoMask)
% Función que separa los objetos que están juntos a la hora de hacer el BB

    mask=strel('disk',tamanoMask);
    
    % Plantilla con el objeto de interés
    plantillaObjeto = (plantilla==etiqueta);
    plantillaErosionada = erosionaImagen (plantillaObjeto, mask);
    
    %--------------- Para pruebas comentar y descomentar ---------------%
%     imshow (plantillaErosionada);
%     pause();
%     
%     return;
    %-------------------------------------------------------------------%
    
    % Una vez separados los objetos, se etiqueta de nuevo
    etiquetado2 = bwlabel(plantillaErosionada);
    
    % Se declara una matriz de matrices para separar en plantillas
    % distintas cada uno de los objetos
    [M,N] = size (plantillaErosionada);
    etiqSeparada = max(max(etiquetado2));
    plantillaDilatada = zeros(M,N,etiqSeparada);
    
    % Ahora, se estudia cada objeto por separado según cada plantilla y se
    % le devuelve el tamaño original
    for i=1:etiqSeparada
        plantillaObjetoSeparado = (etiquetado2==i);
        plantillaDilatada(:, :, i) = dilataImagen (plantillaObjetoSeparado, mask);
%         imshow(plantillaDilatada(:,:,i));
%         pause();
    end
    
    
    % Una vez obtenidas las plantillas, se hace el Bounding Box de los
    % objetos por separado. Para ello, es necesario obtener la masa y el
    % centro de masas de cada uno de ellos. Se va a recurrir a la función
    % calculaMomentos
    
    % Se inicializa la matrices de los momentos
    masaSeparada = zeros(1,etiqSeparada);
    cdmSeparada = zeros(2,etiqSeparada);
    inerciaSeparada = zeros(2,2,etiqSeparada);
    
    % Se calculan los momentos y se hace el Bounding Box de cada objeto
    for i = 1: etiqSeparada
        BoundingBox(plantillaDilatada(:,:,i),'c');
        [masaSeparada,cdmSeparada,inerciaSeparada] = calculaMomentos(plantillaDilatada(:,:,i));
        viscircles(cdmSeparada',2,'LineWidth',1.5,'EdgeColor','c');
    end
    