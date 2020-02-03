function [filtro] = FiltroIdeal(passa, tamanho, freq, varargin)
% PASSABAIXA é uma função que tem como objetivo criar um filtro passa baixa
% para ser usado posteriormente. 
% Tem como inputs, o tamanho do sinal original e a frequencia de corte a
% ser usada. Como output, tem uma matriz que representa o filtro, do mesmo
% tamanho do sinal.


% Controle de inputs
if nargin < 3 || nargin > 4
    error(['Atenção! Verifique a quantidade de inputs da função ',mfilename,'!']);
end
if ~isvector(tamanho) || ~isscalar(freq) || ischar(freq) || ~ischar(passa)
    error(['Atenção! Verifique os inputs da função ',mfilename,'!']);
end
if ~isequal(tamanho(1),tamanho(2))
    error('Atenção! Imagem não possui tamanho quadrado, mas nem tudo são rosas. Favor utilizar a função imresize.');
end

% cálculo
filtro2 = zeros(tamanho);
corte = (freq)*((tamanho(1)+tamanho(2))/2);

for l = 1:tamanho(1)
    for c = 1:tamanho(2)
        if  (corte/2) >= sqrt((l - tamanho(1)/2)^2 + (c - tamanho(2)/2)^2)
            filtro2(l, c) = 1;
        end
    end
end

if nargin == 3
    if isequal(lower(passa),'baixa') % passa alta
        filtro = filtro2;
    elseif isequal(lower(passa),'alta') % passa baixa
        filtro = 1 - filtro2;
    end
elseif nargin == 4
    filtro3 = zeros(tamanho);
    freq2 = varargin{1};
    corte = (freq2)*((tamanho(1)+tamanho(2))/2);
    
    for l = 1:tamanho(1)
        for c = 1:tamanho(2)
            if  (corte/2) >= sqrt((l - tamanho(1)/2)^2 + (c - tamanho(2)/2)^2)
                filtro3(l, c) = 1;
            end
        end
    end
    if isequal(lower(passa),'banda') % passa banda
        filtro = abs(filtro3 - filtro2);
    else %notch
        filtro = 1 - abs(filtro3 - filtro2);
    end
end

% figure; image(im2uint8(filtro)); colormap(gray); title(['Filtro passa ', passa]); 
end