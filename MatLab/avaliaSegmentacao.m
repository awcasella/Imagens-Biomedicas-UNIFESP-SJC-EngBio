function [resultado] = avaliaSegmentacao(objetoSegmentado, GoldStandard)
%AVALIASEGMENTACAO Summary of this function goes here
%   Detailed explanation goes here

% Controle de Inputs
if nargin ~= 2
    error(['Aten��o! Fun��o ',mfilename,' requer dois inputs.']);
end
if ~ismatrix(objetoSegmentado) || ~ismatrix(GoldStandard)
    error(['Aten��o! Verifique os inputs da fun��o ',mfilename,'!']);
end

% Calculo

resultado = zeros(1, 5);

intersecao = objetoSegmentado.*GoldStandard;

areaInter = sum(sum(intersecao));
areaSegmento = sum(sum(objetoSegmentado));
areaGold = sum(sum(GoldStandard));

VP = (areaInter/areaGold)*100;
FP = ((areaSegmento - areaInter)/(numel(objetoSegmentado) - areaGold))*100;
% FP = ((areaSegmento - areaInter)/(areaGold))*100;
FN = ((areaGold - areaInter)/areaGold)*100;
OD = (200*VP)/(2*VP + FP + FN);
OR = (100*VP)/(VP + FP + FN);

resultado(1:5) = [VP, FP, FN, OD, OR];
end

