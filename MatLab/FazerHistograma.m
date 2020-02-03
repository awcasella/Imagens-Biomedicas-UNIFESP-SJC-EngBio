function [Histograma] = FazerHistograma(imagem)
%FAZERHISTOGRAMA é uma função que calcula o número de vezes que cada valor
%de intensidade (que pode variar de 0 a 255) se repete na imagem e armazena
%isso no vetor histograma.

% Controle de inputs
if nargin~=1
    error(['Função ', mfilename, ' necessita somente um input.']);
end
if ~ismatrix(imagem)
    error(['Atenção! Verifique o input da função ', mfilename, '. Imagem deve ser uma matriz.']);
end

% Calculo
[M,N] = size(imagem);
Histograma = zeros(1,256);
imagem = im2uint8(imagem);
for l = 1:M
    for c = 1:N
        Histograma(imagem(l,c)+1) = Histograma(imagem(l,c)+1) + 1;
    end
end
figure; stem(0:255,Histograma); title('Histograma');
end