function [filtrada] = FiltroMediaHarmonica(imagem, tamanho)
%FILTROMEDIAHARMONICA é uma função que suavisa as bordas de uma "imagem" usando a
% correlação com um kernel que tem um certo "tamanho". Essa correlação faz
% uso da média aritmética de todos os valores mascarados pelo kernel.

% controle de inputs
if nargin ~= 2
    error(['Atenção! Função ', mfilename, ' necessita de dois inputs.']);
end
if ~ismatrix(imagem) || ~isvector(tamanho) || ischar(tamanho)
    error(['Atenção! Verifique os inputs passados para a função ', mfilename,'.']);
end

% calculo
fator = tamanho(1)*tamanho(2);
w = ones(tamanho);
filtrada = zeros(size(imagem));
for m = 2+(tamanho(1)-1)/2:size(imagem,1)-(tamanho(1)-1)/2
    for n = 2+(tamanho(2)-1)/2:size(imagem,2)-(tamanho(2)-1)/2
        mat = imagem(m-1:m+size(w,1)-2, n-1:n+size(w,2)-2);
        mat = 1./mat;
        debaixo = sum(sum(mat));
        filtrada(m,n) = fator*(1./debaixo);
    end
end

% filtrada = xcorr2(imagem, w1);
% filtrada = fator./filtrada;
% filtrada = CeifaPadding(filtrada, size(w));
figure; image(im2uint8(filtrada)); colormap(gray(256)); title(['Imagem filtrada ',num2str(tamanho(1)),'x',num2str(tamanho(2))]);
end

