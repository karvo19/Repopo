% Transformacion de coordenadas sin a con distorsion pixel a pixel
    for u = 1:N
        for v = 1:M
            % Cálculo de coordenadas normalizadas
            xn = (u-u0)/fx;
            yn = (v-v0)/fy;

            % u = xn*fx + u0;
            % v = yn*fy + v0;

            % Cálculo de la r2
            r2 = xn^2 + yn^2;

            % Coordenadas distorsionadas:
            xn_d = xn*(1+kr1*r2);
            yn_d = yn*(1+kr1*r2);

            % Coordenadas del píxel distorsionadas:
            u_d = xn_d*fx + u0;
            v_d = yn_d*fy + v0;
            
            %Si estamos dentro de la imagen, calculamos intensidades de los
            %píxeles. Si no, se mantiene en gris
            if(u_d >= 1 && u_d <= N && v_d >= 1 && v_d <= M)
                % Criterio de interpolación al vecino más cercano
                vecino(v,u) = imagen_distorsionada(round(v_d),round(u_d));

                % Criterio de interpolacion bilineal:

                % Identificamos los dos pixeles mas proximos a u_d. Estos seran el
                % pixel que se obtenga de la transformacion y el que indique el 
                % redondeo (izquierda o derecha)

                % Direccion u
                u_d_i = floor(u_d);    %u_d_i --> pixel actual
                if(floor(u_d) == round(u_d))
                    u_d_j = u_d_i - 1; %u_d_j --> si está por debajo de 0.5
                else
                    u_d_j = u_d_i + 1; %u_d_j --> si está por encima de 0.5
                end
                
                % u_d_1 --> píxel situado a la izquierda
                % u_d_2 --> píxel situado a la derecha
                if(u_d_i > u_d_j)
                    u_d_1 = u_d_j;
                    u_d_2 = u_d_i;
                else
                    u_d_1 = u_d_i;
                    u_d_2 = u_d_j;
                end
                
                % Si alguno de los píxeles están en el borde, se considera
                % el mismo
                if(u_d_j < 1 || u_d_j > N)
                    u_d_1 = u_d_i;
                    u_d_2 = u_d_i;
                end

                % Direccion v
                v_d_i = floor(v_d); %v_d_i --> pixel actual
                if(floor(v_d) == round(v_d))
                    v_d_j = v_d_i - 1; %v_d_j --> si está por debajo de 0.5
                else
                    v_d_j = v_d_i + 1; %v_d_j --> si está por encima de 0.5
                end
                
                % v_d_1 --> píxel situado encima
                % v_d_2 --> píxel situado debajo
                if(v_d_i > v_d_j)
                    v_d_1 = v_d_j;
                    v_d_2 = v_d_i;
                else
                    v_d_1 = v_d_i;
                    v_d_2 = v_d_j;
                end
                
                % Si alguno de los píxeles están en el borde, se considera
                % el mismo
                if(v_d_j < 1 || v_d_j > M)
                    v_d_1 = v_d_i;
                    v_d_2 = v_d_i;
                end

                % Ponderamos los valores de intensidad segun proximidad en u.
                I_v1_ud = (u_d_2 - u_d) * imagen_distorsionada(v_d_1, u_d_1) + ...
                    (u_d - u_d_1) * imagen_distorsionada(v_d_1, u_d_2);

                I_v2_ud = (u_d_2 - u_d) * imagen_distorsionada(v_d_2, u_d_1) + ...
                    (u_d - u_d_1) * imagen_distorsionada(v_d_2, u_d_2);

                % Si nos encontramos en un borde vertical
                if(u_d_j < 1 || u_d_j > N)
                    I_v1_ud = imagen_distorsionada(v_d_1, u_d_i);
                    I_v2_ud = imagen_distorsionada(v_d_2, u_d_i);
                end

                % Ponderamos los valores de intensidad segun proximidad en v.
                bilineal(v, u) = (v_d_2 - v_d) * I_v1_ud + ...
                    (v_d - v_d_1) * I_v2_ud;

                % Si nos encontramos en un borde horizontal
                if(v_d_j < 1 || v_d_j > M)
                    bilineal(v, u) = imagen_distorsionada(v_d_i, u);
                end
            end
        end
    end