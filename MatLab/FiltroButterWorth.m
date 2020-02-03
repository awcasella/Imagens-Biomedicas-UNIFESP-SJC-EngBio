function [filtro] = FiltroButterWorth(passa, tamanho, nPolos, freq, varargin)
% PASSABAIXABUTTERWORTH é uma função que constrói um filtro ButterWorth de
% dimenssões "tamanho", que seja do tipo "passa" e que contenha uma
% quantidade de polos igual a "nPolos". Caso seja um filtro do tipo passa 
% banda ou notch, tem-se um input adicional para a segunda frequencia de 
% corte necessária.


% controle de inputs
if nargin < 4 || nargin > 5
    error(['Atenção! Função ',mfilename,' necessita de pelo menos quatro inputs!']);
end
if ~isscalar(freq) || ~isvector(tamanho) || ~isscalar(nPolos)
    error('Atenção! Verifique os inputs da função.');    
end
if ~isequal(tamanho(1),tamanho(2))
    error('Atenção! Imagem não possui tamanho quadrado, mas nem tudo são rosas. Favor utilizar a função imresize.');
end

%calculo
filtro2 = zeros(tamanho);
centro = tamanho./2;
D0 = freq*(tamanho(1)/2);
for l = 1:size(filtro2,1)
    for c = 1:size(filtro2,2)
        D = sqrt((centro(1) - l)^2 + (centro(2) - c)^2);
        filtro2(l, c) = 1/(1 + (D/D0)^(2*nPolos));
    end
end

if nargin == 4
    if isequal(lower(passa),'baixa')
        filtro = filtro2;
    elseif isequal(lower(passa),'alta')
        filtro = 1 - filtro2;
    end
elseif nargin == 5
    filtro3 = zeros(tamanho);
    centro = tamanho./2;
    freq2 = varargin{1};
    D0 = freq2*(tamanho(1)/2);
    for l = 1:size(filtro3,1)
        for c = 1:size(filtro3,2)
            D = sqrt((centro(1) - l)^2 + (centro(2) - c)^2);
            filtro3(l, c) = 1/(1 + (D/D0)^(2*nPolos));
        end
    end
    if isequal(lower(passa),'banda')
        filtro = abs(filtro3 - filtro2);
    elseif isequal(lower(passa),'notch')
        filtro = 1 - abs(filtro3 - filtro2);
    end
end
% figure; image(im2uint8(filtro)); colormap(gray(256)); title(['Filtro passa ', passa]);
end

