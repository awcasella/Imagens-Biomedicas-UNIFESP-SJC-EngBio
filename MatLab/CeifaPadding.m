function [imagem] = CeifaPadding(imagem, tamkernel)
% CeifaPadding � uma fun��o que visa ceifar as linhas e colunas de uma
% matriz preenchidas com zeros para que pudesse ser feita a correla��o
% entre o sinal e o kernel. 
% Essa fun��o tem como inputs, uma matriz chamada "imagem" de dimens�o MxN
% que est� preenchida com zeros, e um vetor "tamkernel" que cont�m os
% valores relacionados a dimens�o do kernel. O output dessa fun��o � a
% pr�pria matriz "imagem" j� com suas respectivas linhas e colunas
% devidamente ceifados. Recomenda-se que a "imagem" seja o output da fun��o
% "xcorr2".

% Controle de inputs
if nargin ~= 2
    error(['Aten��o! Fun��o ',mfilename,' necessita de dois inputs!']);
end
if tamkernel > size(imagem)
    error(['Aten��o! Verifique a ordem dos valores passados nos inputs da fun��o ', mfilename,'.']);
end

l = tamkernel(1);
c = tamkernel(2);

if mod(l,2)==0
    dimlinha = l/2;
    imagem(1:dimlinha-1,:) = []; % ceifa por cima
else
    dimlinha = (l-1)/2;
    imagem(1:dimlinha,:) = []; % ceifa por cima
end

if mod(c,2)==0
    dimcoluna = c/2;
    imagem(:,1:dimcoluna-1) = []; % ceifa pela esquerda
else
    dimcoluna = (c-1)/2;
    imagem(:,1:dimcoluna) = []; % ceifa pela esquerda
end


imagem(end - dimlinha + 1:end,:) = []; % ceifa por baixo

imagem(:,end - dimcoluna + 1:end) = []; % ceifa pela direita
end