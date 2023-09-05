function [rgb]=cdpms2gun(scr, const, candelaVal, colorAsk)
% ----------------------------------------------------------------------
% [rgb]=cdpms2gun(wPtr,const,candelaVal,colorAsk)
% ----------------------------------------------------------------------
% Goal of the function :
% Give the triplet gun values for the desired gray or RGB in candela/m2
% ----------------------------------------------------------------------
% Input(s) :
% wPtr : window pointer struct
% const : struct containing previous constant configurations.
% candelaVal = desired candela val
% colorAsk = color wanted ('red','green','blue','gray')
% ----------------------------------------------------------------------
% Output(s):
% [rgb] = Gun values in RGB (0->255)
% ----------------------------------------------------------------------
% Created  by Martin SZINTE         (martin.szinte@gmail.com)
% Modified by Lukasz GRZECZKOWSKI   (lukasz.grzeczkowski@gmail.com)
% Last update   : 10 / 01 / 2017
% Project       : FeatureGhost
% Version       : 1.0
% ----------------------------------------------------------------------

if const.expStart == 0
    switch colorAsk
        case 'red'
            maxR = 25/2;
            if candelaVal > maxR
                candelaVal = maxR;
            end
            rgb = [candelaVal/maxR*255 0 0];
        case 'green'
            maxG = 50/2;
            if candelaVal > maxG
                candelaVal = maxG;
            end
            rgb = [0 candelaVal/maxG*255 0];
        case 'blue'
            maxB = 10/2;
            if candelaVal > maxB
                candelaVal = maxB;
            end
            rgb = [0 0 candelaVal/maxB*255];
        case 'gray'
            maxGy = 85/2;
            if candelaVal > maxGy
                candelaVal = maxGy;
            end
            rgb = [candelaVal/maxGy*255 candelaVal/maxGy*255 candelaVal/maxGy*255];
    end
else
    switch colorAsk
        case 'red'
            if candelaVal > scr.tabCalibRed(end,end) 
               candelaVal = scr.tabCalibRed(end,end);
            end
            rgb = [1 0 0]*InvertGammaExtP([scr.RGBparamGamma(1,1),scr.RGBparamGamma(2,1)],255,candelaVal/scr.tabCalibRed(end,end));
        case 'green'
            if candelaVal > scr.tabCalibGreen(end,end)
               candelaVal = scr.tabCalibGreen(end,end);
            end
            rgb = [0 1 0]*InvertGammaExtP([scr.RGBparamGamma(1,2),scr.RGBparamGamma(2,2)],255,candelaVal/scr.tabCalibGreen(end,end));
        case 'blue'
            if candelaVal > scr.tabCalibBlue(end,end)
               candelaVal = scr.tabCalibBlue(end,end);
            end
            rgb = [0 0 1]*InvertGammaExtP([scr.RGBparamGamma(1,3),scr.RGBparamGamma(2,3)],255,candelaVal/scr.tabCalibBlue(end,end));
        case 'gray'
            if candelaVal > scr.tabCalibGray(end,end)
               candelaVal = scr.tabCalibGray(end,end);
            end
            rgb = [1 1 1]*InvertGammaExtP([scr.GRAYparamGamma(1),scr.GRAYparamGamma(2)],255,candelaVal/scr.tabCalibGray(end,end));
    end
end
end