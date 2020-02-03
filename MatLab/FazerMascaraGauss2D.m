function [wGauss2d] = FazerMascaraGauss2D(media, desvio)
% FAZERMASCARAGAUSS2D é uma função que recebe 2 inputs, media e desvio, e a
% partir deles constrói um vetor de amostras e faz sua distribuição 
% gaussiana em um novo vetor, usando esse resultado e uma convolução 2d é
% possivel calcular uma distribuição gaussiana em duas dimenssões.

% Controle de inputs
if nargin ~= 2
    error('Número de argumentos de entrada diferente de dois.');
end
if ~isscalar(media) || ~isscalar(desvio) || ischar(media) || ischar(desvio)
    error(['Atenção. Função ', mfilename, ' deve conter apenas 2 inputs escalares.']);
end

x = 1:(2*media - 1);
y = gaussmf(x, [media, desvio]);
wGauss2d = conv2(y, y');
wGauss2d = wGauss2d./sum(sum(wGauss2d));
end

