function [filtrada] = Laplaciano(tipo, Imagem)
% LAPLACIANO é uma função que filtra uma "Imagem" usando uma correlação
% com kernels do tipo torre(usando só verticais ou horizontais) ou
% dama(também usando as diagonais). 

% controle de inputs
if nargin ~= 2
    error(['Atenção! Função ', mfilename,' necessita de dois inputs.']);
end
if ~ischar(tipo) || ~isvector(tipo) || ~ismatrix(Imagem)
    error(['Atenção! Verifique os inputs passados na função ', mfilename,'.']);
end

Imagem = im2double(Imagem);

% calculo
torre = [0,1,0; 1, -4, 1; 0, 1, 0];
dama = [1, 1, 1; 1, -8, 1; 1, 1, 1];

STorre = xcorr2(Imagem,torre);
SDama = xcorr2(Imagem,dama);

ITorre = CeifaPadding(STorre, size(torre));
IDama = CeifaPadding(SDama, size(dama));

if isequal(lower(tipo), 'torre') 
    filtrada = ITorre;
elseif isequal(lower(tipo), 'dama')
    filtrada = IDama;
else
    error(['Tipo de kernel rejeitado! Função ', mfilename, ' aceita apenas kernel "Torre" ou "Dama".']);
end

% figure;
% subplot(1,3,1); image(im2uint8(Imagem)); colormap(gray(256)); title('Imagem Original');
% subplot(1,3,2); image(im2uint8(ITorre)); colormap(gray(256)); title('Imagem Laplacianada com Torre');
% subplot(1,3,3); image(im2uint8(IDama)); colormap(gray(256)); title('Imagem Laplacianada com Dama');

end

