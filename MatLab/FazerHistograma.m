function [Histograma] = FazerHistograma(imagem)
%FAZERHISTOGRAMA � uma fun��o que calcula o n�mero de vezes que cada valor
%de intensidade (que pode variar de 0 a 255) se repete na imagem e armazena
%isso no vetor histograma.

% Controle de inputs
if nargin~=1
    error(['Fun��o ', mfilename, ' necessita somente um input.']);
end
if ~ismatrix(imagem)
    error(['Aten��o! Verifique o input da fun��o ', mfilename, '. Imagem deve ser uma matriz.']);
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