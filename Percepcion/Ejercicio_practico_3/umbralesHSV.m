% Script donde se guardan los umbrales para identificar cada figura
function [uR,uG,uB,uY,uO,uK] = umbralesHSV(gMediana)
% colorThresholder(gMediana);
uR = [0.949 0.020; 0.317 1; 0.295 1];
uG = [0.205 0.372; 0.361 1; 0.251 1];
uB = [0.511 0.630; 0.235 1; 0 1];
uY = [0.136 0.203; 0.612 1; 0.612 1];
uO = [0.964 0.122; 0.639 1; 0.781 1];
uK = [0 1; 0 0.536; 0 0.464];


% Aspecto del vector de umbrales:
% [Hmin Hmax; Smin Smax; Vmin Vmax]