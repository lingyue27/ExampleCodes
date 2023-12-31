function [x,y,t]=getCoord(scr,const)
% ----------------------------------------------------------------------
% [x,y,t]=getCoord(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Get gaze coordinates or mouse's in dummy mode.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% x : X eye/mouse coordinate (horizontal)
% y : Y eye/mouse coordinate (vertical)
% t : time
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 03 / 01 / 2017
% Project :     FeatureGhost
% Version :     1.0
% ----------------------------------------------------------------------

if const.TEST
    [x,y]=GetMouse(scr.main); % gaze position simulate by mouse position
    t = GetSecs;
else
    evt = Eyelink('newestfloatsample');
    x = evt.gx(const.recEye);
    y = evt.gy(const.recEye);
    t = evt.time;
    if evt.gx(const.recEye) == -32768 || evt.gy(const.recEye) == -32768
        x = 0;
        y = 0;
    end
end
end