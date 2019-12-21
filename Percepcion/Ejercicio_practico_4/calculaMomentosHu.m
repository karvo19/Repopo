function MomentosHu = calculaMomentosHu(img)

% Si se llama a calculaMomentos(img), se obtendrán los valores necesarios
% de los momentos centrales clasificados por etiquetas. Notar que mu00,
% mu11, etc son vectores del tamaño de las etiquetas.

[mu00,mu11,mu10,mu01,mu20,mu02,mu21,mu12,mu30,mu03] = calculaMomentos(img);

% Ahora, es necesario normalizar los momentos centrales:

% gamma = (r+s)/2+1;

% etars = murs / (mu00)^gamma ;
r = 0; s = 0;
gamma = (r+s)/2+1;
eta00 =  mu00 ./ (mu00).^gamma;


r = 1; s = 1;
gamma = (r+s)/2+1;
eta11 =  mu11 ./ (mu00).^gamma;


r = 0; s = 1;
gamma = (r+s)/2+1;
eta01 =  mu01 ./ (mu00).^gamma;


r = 1; s = 0;
gamma = (r+s)/2+1;
eta10 =  mu10 ./ (mu00).^gamma;


r = 2; s = 0;
gamma = (r+s)/2+1;
eta20 =  mu20 ./ (mu00).^gamma;


r = 0; s = 2;
gamma = (r+s)/2+1;
eta02 =  mu02 ./ (mu00).^gamma;


r = 2; s = 1;
gamma = (r+s)/2+1;
eta21 =  mu21 ./ (mu00).^gamma;


r = 1; s = 2;
gamma = (r+s)/2+1;
eta12 =  mu12 ./ (mu00).^gamma;


r = 3; s = 0;
gamma = (r+s)/2+1;
eta30 =  mu30 ./ (mu00).^gamma;


r = 0; s = 3;
gamma = (r+s)/2+1;
eta03 =  mu03 ./ (mu00).^gamma;


% Una vez obtenidos los diferentes etas, se calculan los distintos momentos
% de Hu:

Hu1 = eta20 + eta02;
Hu2 = (eta20 + eta02).^2 + 4*eta11.^2;
Hu3 = (eta30-3*eta12).^2 + (3*eta21-eta03).^2;
Hu4 = (eta30+eta12).^2 + (eta21+eta03).^2;
Hu5 = (eta30-3*eta12).*(eta30+eta12).*( (eta30+eta12).^2-3*(eta21+eta03).^2 ) + (3*eta21-eta03).*(eta21+eta03).*( 3*(eta30+eta12).^2 - (eta21+eta03).^2 );
Hu6 = (eta20-eta02).*( (eta30+eta12).^2 - (eta21+eta03).^2 ) + 4*eta11.*(eta30+eta12).*(eta21+eta03);
Hu7 = (3*eta21-eta03).*(eta30+eta12).*( (eta30+eta12).^2 - 3*(eta21+eta03).^2 ) - (eta30-3*eta12).*(eta21+eta03).*( 3*(eta30+eta12).^2 - (eta21+eta03).^2  );

MomentosHu = [Hu1;Hu2;Hu3;Hu4;Hu5;Hu6;Hu7];


end