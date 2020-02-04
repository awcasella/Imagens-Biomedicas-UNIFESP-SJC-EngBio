function [filtrada] = Lee(vrh, I, tamanho, goWithLaplacian)
%LEE � uma fun��o que recebe a matriz de uma imagem "I" junto com o valor
%da variancia de uma regiao homogenea "vrh" e filtra essa imagem de forma
%que a borra um pouco exceto as bordas e retorna a imagem filtrada.

%controle de inputs
if nargin<4
    goWithLaplacian = false;
end
if nargin < 3
    error(['Aten��o! Fun��o ', mfilename, ' necessita de 4 inputs!']);
end
if ~isscalar(vrh) || ischar(vrh) || ~ismatrix(I) || ~islogical(goWithLaplacian)
    error('Verifique os valores passados como inputs!');
end

%calculo
filtrada = zeros(size(I));
x = (tamanho(1) - 1)/2;
y = (tamanho(2) - 1)/2;

if goWithLaplacian
    L = laplaciano(I, "torre");
end

for M = 1+x:size(I,1)-x
    for N = 1+x:size(I,2)-x
        mascara = I(M-x:M+tamanho(1)-(x+1), N-y:N+tamanho(2)-(y+1));
        if ~goWithLaplacian
            mask = mascara(1:end);
            vl = var(mask);
            k = 1 - (vrh/vl);
            if k > 1
                k = 1;
            elseif k < 0
                k = 0;
            end
        else
            k = L(M, N);
        end
        media = sum(sum(mascara))/numel(mascara);
        filtrada(M, N) = media + k*(I(M,N) - media);
    end
end

% figure; image(im2uint8(filtrada)); colormap(gray(256)); title('Lee');

end

