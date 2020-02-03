function [filtro] = FiltroGaussiano(passa, tamanho, freq, varargin)
% FiltroGaussiano é uma função que produz um filtro de dimensões "tamanho",
% que seja do tipo "passa", a uma frequencia de corte "freq". Caso seja um
% filtro do tipo passa banda ou notch, tem-se um input adicional para a
% segunda frequencia de corte necessária. Como o próprio nome diz, esse
% filtro segue uma distribuição gaussiana.

%controle de inputs
if nargin < 2 || nargin > 4
    error(['Atenção! Verifique a quantidade de inputs da função ',mfilename,'!']);
end
if ~isvector(freq) || ~isvector(tamanho)
    error('Atenção! Verifique os inputs da função.');    
end
if ~isequal(tamanho(1),tamanho(2))
    error('Atenção! Imagem não possui tamanho quadrado, mas nem tudo são rosas. Favor utilizar a função imresize.');
end

%calculo
D0 = freq*(tamanho(1)/2);
filtro2 = zeros(tamanho);
centro = tamanho./2;
for l = 1:size(filtro2, 1)
    for c = 1:size(filtro2, 2)
        D = sqrt((centro(1) - l)^2 + (centro(2) - c)^2);
        filtro2(l, c) = exp(-(D^2)/(2*D0^2));
    end
end

if nargin == 3
    if isequal(lower(passa),'alta') % passa alta
        filtro = 1 - filtro2;
    elseif isequal(lower(passa),'baixa') % passa baixa
        filtro = filtro2;
    end
elseif nargin == 4
    freq2 = varargin{1};
    D1 = freq2*(tamanho(1)/2);
    centro2 = tamanho./2;
    filtro3 = zeros(tamanho);
    for l = 1:size(filtro3,1)
        for c = 1:size(filtro3,2)
            D = sqrt((centro2(1) - l)^2 + (centro2(2) - c)^2);
            filtro3(l, c) = exp(-(D^2)/(2*D1^2));
        end
    end
    
    if freq2 > freq
        filtro4 = filtro3 - filtro2;
    else
        filtro4 = filtro2 - filtro3;
    end
    if isequal(lower(passa),'banda') % passa banda
        filtro = filtro4;
    elseif isequal(lower(passa),'notch') % notch
        filtro = 1 - filtro4;
    end
end
    
% figure; image(im2uint8(filtro)); colormap(gray(256)); title(['Filtro passa ', passa, ' Gaussiano']);
end

