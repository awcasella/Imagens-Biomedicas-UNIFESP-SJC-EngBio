function [filtrada] = FiltroMediana(imagem, tamanho)
%FILTROMEDIANA retorna uma matriz que � a correla��o envolvendo a mediana dos
%valores de pixels da imagem.

imagem = im2double(imagem); % passando tudo pra double
w = ones(tamanho); 
matriz = zeros(size(imagem) + size(w) - [1,1]); % alocando uma matriz auxiliar
dimensao = (size(matriz) - size(imagem))/2; % calculando a dimensao
matriz(1+dimensao(1):end-dimensao(1), 1+dimensao(2):end-dimensao(2)) = imagem(1:end,1:end); % preenchendo com zeros

filtrada = zeros(size(imagem)); % alocando a matriz do output

for linha = 1:size(filtrada,1)
    for coluna = 1:size(filtrada,2)
        % f(linha:linha+size(w,1)-1, coluna:coluna+size(w,2)-1) � a
        % submatriz de f, ou seja s�o os elementos de f onde a mascara est�
        % passando em cima.
        mat = matriz(linha:linha+size(w,1)-1, coluna:coluna+size(w,2)-1).*w;
        vet = sort(mat(1:end));
        filtrada(linha, coluna) = median(vet); 
    end
end
% filtrada = im2uint8(filtrada);
% nova = CeifaPadding(nova, size(w));
% figure; image(im2uint8(filtrada)); colormap(gray(256)); title('Imagem Com M�scara de Mediana');
end