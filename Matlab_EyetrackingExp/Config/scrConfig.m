function [scr] = scrConfig(const)
% ----------------------------------------------------------------------
% [scr] = scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Give all information about the screen and the monitor.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing screen settings
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........15 | 07 | 2019
% Project.....................CHIB
% Version........................4
% ----------------------------------------------------------------------

% Number of the screens
% ---------------------
scr.all = Screen('Screens');
scr.scr_num = max(scr.all);

% Screen resolution (pixel)
% -------------------------
[scr.scr_sizeX, scr.scr_sizeY]=Screen('WindowSize', scr.scr_num);
if (scr.scr_sizeX ~= const.desiredRes(1) || scr.scr_sizeY ~= const.desiredRes(2)) && const.expStart
    error('Incorrect screen resolution => Please restart the program after changing the resolution to [%i,%i]',const.desiredRes(1),const.desiredRes(2));
end

% Size of the display (mm)
% ------------------------
scr.disp_sizeX = 525;  scr.disp_sizeY = 295;         % setting for VPixx 3D lite

% Screen settings for EL
% ----------------------
scr.disp_sizeLeft  = round(-scr.disp_sizeX/2);     % physical size of the screen from center to left edge (mm)
scr.disp_sizeRight = round(scr.disp_sizeX/2);      % physical size of the screen from center to top edge (mm)
scr.disp_sizeTop   = round(scr.disp_sizeY/2);      % physical size of the screen from center to right edge (mm)
scr.disp_sizeBot   = round(-scr.disp_sizeY/2);     % physical size of the screen from center to bottom edge (mm)

% Pixels size
% -----------
scr.clr_depth = Screen('PixelSize', scr.scr_num);

% Frame rate (fps)
% ----------------
scr.frame_duration =1/(Screen('FrameRate',scr.scr_num));
if scr.frame_duration == inf;
    scr.frame_duration = 1/60;
elseif scr.frame_duration ==0;
    scr.frame_duration = 1/60;
end
scr.fd = scr.frame_duration;

% scr.frame_duration = 1/120;
% fprintf(1,'\n\tscrConfig line 55: Don''t forget to put it out before testing !!!\n');

% Frame rate (hertz)
% ------------------
scr.hz = 1/(scr.frame_duration);
if (scr.hz >= 1.1*const.desiredFD || scr.hz <= 0.9*const.desiredFD) && const.expStart && ~strcmp(const.sjct,'DEMO');
    error('Incorrect refresh rate => Please restart the program after changing the refresh rate to %i Hz',const.desiredFD);
end

if strcmp(const.sjct,'Anon');
    warning off;Screen('Preference', 'SkipSyncTests', 1);
end

% Subject dist (mm)
% -----------------
scr.dist = 600;

% Screen distance (top and bottom from line of sight in mm)
% ---------------------------------------------------------
scr.distTop = 610;
scr.distBot = 610;

% Center of the screen
% --------------------
scr.x_mid = (scr.scr_sizeX/2.0);
scr.y_mid = (scr.scr_sizeY/2.0);
scr.mid   = [scr.x_mid,scr.y_mid];

% Gamma calibration desired test values
% -------------------------------------
scr.desiredValue = 16;
scr.room = 'VPix3D_1U44';
scr.dirCalib = 'GammaCalib';
end