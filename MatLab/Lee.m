function [filtrada] = Lee(vrh, I, tamanho)
%LEE é uma função que recebe a matriz de uma imagem "I" junto com o valor
%da variancia de uma regiao homogenea "vrh" e filtra essa imagem de forma
%que a borra um pouco exceto as bordas e retorna a imagem filtrada.

%controle de inputs
if nargin~=3
    error(['Atenção! Função ', mfilename, ' necessita de três inputs!']);
end
if ~isscalar(vrh) || ischar(vrh) || ~ismatrix(I)
    error('Verifique os valores passados como inputs!');
end

%calculo
filtrada = zeros(size(I));
x = (tamanho(1) - 1)/2;
y = (tamanho(2) - 1)/2;

w = zeros(tamanho);

for M = 1+x:size(I,1)-x
    for N = 1+x:size(I,2)-x
        mascara = I(M-x:M+size(w,1)-(x+1), N-y:N+size(w,2)-(y+1));
        mask = mascara(1:end);
        vl = var(mask);
        k = 1 - (vrh/vl);
        if k > 1
            k = 1;
        elseif k < 0
            k = 0;
        end
        media = sum(sum(I(M-x:M+size(w,1)-(x+1), N-y:N+size(w,2)-(y+1))))/numel(w);
        filtrada(M, N) = media + k*(I(M,N) - media);
    end
end

figure; image(im2uint8(filtrada)); colormap(gray(256)); title('Lee');

end

