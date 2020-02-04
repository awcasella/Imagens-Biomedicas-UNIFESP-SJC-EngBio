function [Histograma, X] = FazerHistograma(imagem)
%FAZERHISTOGRAMA � uma fun��o que calcula o n�mero de vezes que cada valor
%de intensidade (que pode variar de 0 a 255) se repete na imagem e armazena
%isso no vetor histograma.

% Controle de inputs
if nargin~=1
    error(['Function ', mfilename, ' needs one input.']);
end
if ~ismatrix(imagem)
    error(['Atention! Verifify the input of function ', mfilename, ', it should be a matrix.']);
end

% Calculo, 
[M,N] = size(imagem);
Histograma = zeros(1,256);
imagem = im2uint8(imagem);
for l = 1:M
    for c = 1:N
        Histograma(imagem(l,c)+1) = Histograma(imagem(l,c)+1) + 1;
    end
end
X = 1:256;
figure; stem(X,Histograma); title('Histograma');
end