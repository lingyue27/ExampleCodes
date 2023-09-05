function [candelaVal]=gun2cdpms(scr, const, color,colorAsk)
% ----------------------------------------------------------------------
% [candelaVal]=gun2cdpms(scr,color,colorAsk)
% ----------------------------------------------------------------------
% Goal of the function :
% Give the triplet gun values for the desired gray or RGB in candela/m2
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer struct
% const : struct containing previous constant configurations.
% color = color in RGB
% colorAsk = color wanted ('red','green','blue','gray')
% ----------------------------------------------------------------------
% Output(s):
% candelaVal = candela val
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Last update : 12 / 01 / 2017
% Project :     none
% Version :     1.0
% ----------------------------------------------------------------------

if const.expStart == 0
    switch colorAsk
        case 'red'
            maxR = 25/2;
            candelaVal = (color(1)/255)*maxR;
        case 'green'
            maxG = 50/2;
            candelaVal = (color(2)/255)*maxG;
        case 'blue'
            maxB = 10/2;
            candelaVal = (color(3)/255)*maxB;
        case 'gray'
            maxGy = 85/2;
            candelaVal = (color(1)/255)*maxGy;
    end
else
    switch colorAsk
        case 'red'
            candelaVal = (color(1)/255)*scr.tabCalibRed(end,end);
        case 'green'
            candelaVal = (color(2)/255)*scr.tabCalibGreen(end,end);
        case 'blue'
            candelaVal = (color(3)/255)*scr.tabCalibBlue(end,end);
        case 'gray'
            candelaVal = (color(1)/255)*scr.tabCalibGray(end,end);
    end
end
end