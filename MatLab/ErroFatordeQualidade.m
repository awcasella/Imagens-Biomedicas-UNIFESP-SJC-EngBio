function [erro] = ErroFatordeQualidade(f, g)
% ERROFATORDEQUALIDADE é uma função que calcula o erro de qualidade entre
% duas imagens "f" e "g" usando valores de média, desvio padrao e
% covariancia entre as duas matrizes das imagens.

% controle de inputs
if nargin ~= 2 || ~ismatrix(f) || ~ismatrix(g)
    error(['Atenção! Função ', mefilename, ' necessita de dois inputs que sejam matrizes!']);
end
if size(f) ~= size(g)
    error(['Atenção! Inputs passados para a função ', mfilename, ' devem conter as mesmas dimenssoes.']);
end

% calculo
f = f(:);
g = g(:);

desviof = std(f);
desviog = std(g);

mediaf = mean(f);
mediag = mean(g);

cova = sum((f - mediaf).*(g - mediag))/numel(f);

erro = (cova/(desviof*desviog))*((2*mediaf*mediag)/(mediaf^2 + mediag^2))*((2*desviof*desviog)/(desviof^2 + desviog^2));

end