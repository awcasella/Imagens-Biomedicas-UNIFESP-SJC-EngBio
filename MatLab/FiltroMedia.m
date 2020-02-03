function [filtrada] = FiltroMedia(imagem, tamanho)
% FILTROMEDIA � uma fun��o que suavisa as bordas de uma "imagem" usando a
% correla��o com um kernel que tem um certo "tamanho". Essa correla��o faz
% uso da m�dia aritm�tica de todos os valores mascarados pelo kernel.

% controle de inputs
if nargin ~= 2
    error(['Aten��o! Fun��o ', mfilename, ' necessita de dois inputs.']);
end
if ~ismatrix(imagem) || ~isvector(tamanho) || ischar(tamanho)
    error(['Aten��o! Verifique os inputs passados para a fun��o ', mfilename,'.']);
end

% calculo
fator = 1/(tamanho(1)*tamanho(2));
w1 = fator*ones(tamanho);

filtrada = xcorr2(imagem, w1);
filtrada = CeifaPadding(filtrada, size(w1));
% figure; image(im2uint8(filtrada)); colormap(gray(256)); title('Imagem filtrada ',num2str(tamanho(1),'x',num2str(tamanho(2))));
end

