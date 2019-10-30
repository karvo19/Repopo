% function [vecino, bilineal] = corrige(imagen_distorsionada)
% Transformacion de coordenadas sin a con distorsion pixel a pixel
    for u = 0:N-1
        for v = 0:M-1
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
            
            if(u_d >= 0 && u_d <= N-1 && v_d >= 0 && v_d <= M-1)
                % Criterio de interpolación al vecino más cercano
                vecino(u+1,v+1) = imagen_distorsionada(round(u_d)+1,round(v_d)+1);

                % Criterio de interpolacion bilineal:

                % Identificamos los dos pixeles mas proximos a u_d. Estos seran el
                % pixel que se obtenga de la transformacion y el que indique el 
                % redondeo (izquierda o derecha)

                % Direccion u
                u_d_i = floor(u_d);
                if(floor(u_d) == round(u_d))
                    u_d_j = u_d_i - 1;
                else
                    u_d_j = u_d_i + 1;
                end
                if(u_d_i > u_d_j)
                    u_d_1 = u_d_j;
                    u_d_2 = u_d_i;
                else
                    u_d_1 = u_d_i;
                    u_d_2 = u_d_j;
                end
                if(u_d_j < 0 || u_d_j >= N)
                    u_d_1 = u_d_i;
                    u_d_2 = u_d_i;
                end

                % Direccion v
                v_d_i = floor(v_d);
                if(floor(v_d) == round(v_d))
                    v_d_j = v_d_i - 1;
                else
                    v_d_j = v_d_i + 1;
                end
                if(v_d_i > v_d_j)
                    v_d_1 = v_d_j;
                    v_d_2 = v_d_i;
                else
                    v_d_1 = v_d_i;
                    v_d_2 = v_d_j;
                end
                if(v_d_j < 0 || v_d_j >= M)
                    v_d_1 = v_d_i;
                    v_d_2 = v_d_i;
                end

                % Ponderamos los valores de intensidad segun proximidad en u.
                I_ud_v1 = (u_d_2 - u_d) * imagen_distorsionada(u_d_1 + 1, v_d_1 + 1) + ...
                    (u_d - u_d_1) * imagen_distorsionada(u_d_2 + 1, v_d_1 + 1);

                I_ud_v2 = (u_d_2 - u_d) * imagen_distorsionada(u_d_1 + 1, v_d_2 + 1) + ...
                    (u_d - u_d_1) * imagen_distorsionada(u_d_2 + 1, v_d_2 + 1);

                % Si nos encontramos en un borde vertical
                if(u_d_j < 0 || u_d_j >= N)
                    I_ud_v1 = imagen_distorsionada(u_d_i + 1, v_d_1 + 1);
                    I_ud_v2 = imagen_distorsionada(u_d_i + 1, v_d_2 + 1);
                end

                % Ponderamos los valores de intensidad segun proximidad en v.
                bilineal(u+1,v+1) = (v_d_2 - v_d) * I_ud_v1 + ...
                    (v_d - v_d_1) * I_ud_v2;

                % Si nos encontramos en un borde horizontal
                if(v_d_j < 0 || v_d_j >= M)
                    bilineal(u+1,v+1) = imagen_distorsionada(u+1,v_d_i+1);
                end
            end
        end
    end
% end