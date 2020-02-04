function [filtrada] = Gradiente(Imagem, tipo)
% GRADIENTE � uma fun��o que filtra uma "imagem" usando a correla��o com
% dois diferentes filtros, "sobel" ou "prewitt" que s�o passados no
% parametro "tipo".

% controle de inputs
if nargin ~= 2
    error(['Aten��o! Fun��o ', mfilename,' necessita de dois inputs.']);
end
if ~ischar(tipo) || ~isvector(tipo) || ~ismatrix(Imagem)
    error(['Aten��o! Verifique os inputs passados na fun��o ', mfilename,'.']);
end

Imagem = im2double(Imagem);
if isequal(lower(tipo),'sobel')
    xsobel = [-1, 0, 1; -2, 0, 2; -1, 0, 1]; % kernel em x com Sobel
    ysobel = xsobel'; % kernel em y com Sobel
    
    delFdelX = xcorr2(Imagem, xsobel); % Derivada parcial em X com correla��o em Sobel
    ImagemSobelEmX = CeifaPadding(delFdelX, size(xsobel)); % Ceifando
    
    delFdelY = xcorr2(Imagem, ysobel); % Derivada parcial em Y com correla��o em Sobel
    ImagemSobelEmY = CeifaPadding(delFdelY, size(ysobel)); % Ceifando
    
    moduloSobel = sqrt(ImagemSobelEmX.^2 + ImagemSobelEmY.^2); % Computando o modulo em Sobel
    filtrada = moduloSobel;
    
    figure;
    celulasobel = {'Imagem','ImagemSobelEmX','ImagemSobelEmY','moduloSobel'};
    for n = 1:4
        subplot(2,2,n);
        image(im2uint8(eval(celulasobel{n})));
        colormap(gray(256));
        title(celulasobel{n});
    end
    
elseif isequal(lower(tipo),'prewitt')
    xprewitt = [-1,0, 1; -1,0, 1; -1,0, 1]; % kernel em x com Prewitt
    yprewitt = xprewitt'; % kernel em y com Prewitt
    
    delFdelX = xcorr2(Imagem, xprewitt); % Derivada parcial em X com correla��o em Prewitt
    ImagemPrewittEmX = CeifaPadding(delFdelX, size(xprewitt)); % Ceifando
    
    delFdelY = xcorr2(Imagem, yprewitt); % Derivada parcial em Y com correla��o em Prewitt
    ImagemPrewittEmY = CeifaPadding(delFdelY, size(yprewitt)); % Ceifando
    
    moduloPrewitt = sqrt(ImagemPrewittEmX.^2 + ImagemPrewittEmY.^2); % Computando o modulo em Prewitt
    filtrada = moduloPrewitt;
    
    figure;
    celulaPrewitt = {'Imagem','ImagemPrewittEmX','ImagemPrewittEmY','moduloPrewitt'};
    for n = 1:4
        subplot(2,2,n);
        image(im2uint8(eval(celulaPrewitt{n})));
        colormap(gray(256));
        title(celulaPrewitt{n});
    end
end

end

