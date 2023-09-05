function [scr,const] = constColor(scr,const)
% ----------------------------------------------------------------------
% [scr,const] = constColor(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute color with or without gamma linearisation
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing screen settings
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........17 | 07 | 2019
% Project.....................CHIB
% Version........................4
% ----------------------------------------------------------------------

% Define colors
% -------------
const.bgLum       = 30;
const.lumTar      = 20;

scr.black        =  BlackIndex(scr.scr_num);
scr.white        =  cdpms2gun(scr,const,80,'gray');    scr.white       =  scr.white(1);
const.grayBg     =  cdpms2gun(scr,const,const.bgLum,'gray');
const.gray       =  cdpms2gun(scr,const,10,'gray');
const.red        =  cdpms2gun(scr,const,const.lumTar ,'red');
const.green      =  cdpms2gun(scr,const,const.lumTar ,'green');
const.blue       =  cdpms2gun(scr,const,15,'blue');

const.bright     =  cdpms2gun(scr,const,(const.grayBg*2),'gray');
const.dark       =  scr.black;

% Define stimuli color
% --------------------
const.postFix     = const.gray ;
const.colBG       = const.grayBg ;
const.colCue      = const.bright ;
const.col1Int     = const.bright ;
const.Flash       = const.green ;
% if mod(const.sjct_numId,2) == 1
%     const.col1Int = const.red;
%     const.col3Int = const.green;
% else
%     const.col1Int = const.green;
%     const.col3Int = const.red;
% end
const.colBar                = const.green;
const.colWaitSpace          = const.red;
const.colErrFix             = scr.black;
const.colFix                = scr.white;
const.colTarDot             = scr.black;
const.colTarCtrDot          = scr.white;
const.colTarCtrCtrDot       = scr.black;
const.colFixExp             = const.gray;

end