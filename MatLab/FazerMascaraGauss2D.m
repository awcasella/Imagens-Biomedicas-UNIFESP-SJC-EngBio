function [wGauss2d] = FazerMascaraGauss2D(media, desvio)
% FAZERMASCARAGAUSS2D � uma fun��o que recebe 2 inputs, media e desvio, e a
% partir deles constr�i um vetor de amostras e faz sua distribui��o 
% gaussiana em um novo vetor, usando esse resultado e uma convolu��o 2d �
% possivel calcular uma distribui��o gaussiana em duas dimenss�es.

% Controle de inputs
if nargin ~= 2
    error('N�mero de argumentos de entrada diferente de dois.');
end
if ~isscalar(media) || ~isscalar(desvio) || ischar(media) || ischar(desvio)
    error(['Aten��o. Fun��o ', mfilename, ' deve conter apenas 2 inputs escalares.']);
end

x = 1:(2*media - 1);
y = gaussmf(x, [media, desvio]);
wGauss2d = conv2(y, y');
wGauss2d = wGauss2d./sum(sum(wGauss2d));
end

