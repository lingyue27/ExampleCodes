function [el] = initEyeLink(scr,const)
% ----------------------------------------------------------------------
% [el] = initEyeLink(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Initializes eyeLink-connection, creates edf-file
% and writes experimental parameters to edf-file
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% el : struct containing eyelink settings
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 26 / 01 / 2017
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

% Get intial default settings
% ---------------------------
el=EyelinkInitDefaults(scr.main);

% Color definition in EL display
% ------------------------------
el.obj_black            = 0;        el.bg_black             = 0;
el.obj_dark_blue        = 1;        el.bg_dark_dark_blue    = 1;
el.obj_dark_green       = 2;        el.bg_dark_blue         = 2;
el.obj_dark_turquoise   = 3;        el.bg_blue              = 3;
el.obj_dark_red         = 4;        el.bg_light_blue        = 4;
el.obj_dark_purple      = 5;        el.bg_light_light_blue	= 5;
el.obj_dark_yellow      = 6;        el.bg_turquoise         = 6;
el.obj_light_gray       = 7;        el.bg_light_turquoise   = 7;
el.obj_dark_gray        = 8;        el.bg_flashy_blue   	= 8;
el.obj_light_purple     = 9;        el.bg_green             = 9;
el.obj_light_green      = 10;       el.bg_dark_dark_green   = 10;
el.obj_light_turquoise  = 11;       el.bg_dark_green        = 11;
el.obj_light_red        = 12;       el.bg_green2            = 12;
el.obj_pink             = 13;       el.bg_light_green       = 13;
el.obj_light_yellow     = 14;       el.bg_light_green2      = 14;
el.obj_white            = 15;       el.bg_flashy_green      = 15;

% Modify different defaults settings
% ----------------------------------
el.timeCalibMin                 = 15;
el.timeCalib                    = el.timeCalibMin*60;
el.msgfontcolour                = WhiteIndex(el.window);
el.imgtitlecolour               = WhiteIndex(el.window);
el.targetbeep                   = 0;
el.feedbackbeep                 = 0;
el.eyeimgsize                   = 50;
el.displayCalResults            = 1;
el.backgroundcolour             = const.colBG;
el.fixation_outer_rim_rad       = const.fixation_outer_rim_rad;
el.fixation_rim_rad             = const.fixation_rim_rad;
el.fixation_rad                 = const.fixation_rad;
el.fixation_outer_rim_color     = const.fixation_outer_rim_color;
el.fixation_rim_color           = const.fixation_rim_color;
el.fixation_color               = const.fixation_color;
el.txtCol                       = 15;
el.bgCol                        = 0;
el.sample_rate                  = 1000;
EyelinkUpdateDefaults(el);

% Connection initialization 
% --------------------------
if ~const.TEST;dummymode = 0;else dummymode = 1;end
if ~EyelinkInit(dummymode)
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% Open record file
% ----------------
res = Eyelink('Openfile', const.eyelink_temp_file);
if res~=0
    fprintf('Cannot create EDF file ''%s'' ', const.eyelink_temp_file);
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% Connection verification
% -----------------------
if Eyelink('IsConnected')~=1 && ~dummymode
    fprintf('Not connected. exiting');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% Set up tracker personal configuration
% -------------------------------------
% Set parser
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,HTARGET');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,FIXUPDATE,SACCADE,BLINK');
Eyelink('command', 'link_sample_data  = GAZE,GAZERES,AREA,HREF,VELOCITY,FIXAVG,STATUS');

% Scree settings
Eyelink('command','screen_pixel_coords = %d %d %d %d', 0, 0, scr.scr_sizeX-1, scr.scr_sizeY-1);
Eyelink('command','screen_phys_coords = %d %d %d %d',scr.disp_sizeLeft,scr.disp_sizeTop,scr.disp_sizeRight,scr.disp_sizeBot);
Eyelink('command','screen_distance = %d %d', scr.distTop, scr.distBot);
Eyelink('command','simulation_screen_distance = %d', scr.dist);

% Tracking mode and settings
Eyelink('command','enable_automatic_calibration = YES');
Eyelink('command','pupil_size_diameter = YES');
Eyelink('command','heuristic_filter = 1 1');
Eyelink('command','saccade_velocity_threshold = 30');
Eyelink('command','saccade_acceleration_threshold = 9500');
Eyelink('command','saccade_motion_threshold = 0.15');
Eyelink('command','use_ellipse_fitter =  NO');
Eyelink('command','sample_rate = %d',el.sample_rate);

% Personal calibrations
rng('default');rng('shuffle');
angle = 0:pi/3:5/3*pi;
if const.typeCalib == 1
    % compute calibration target locations
    [cx1,cy1] = pol2cart(angle,0.6);
    [cx2,cy2] = pol2cart(angle+(pi/6),0.45);
    cx = round(scr.x_mid + scr.x_mid*[0 cx1 cx2]);
    cy = round(scr.y_mid + scr.x_mid*[0 cy1 cy2]);
    
    % order for eyelink
    c = [cx(1), cy(1),...   % 1.  center center
        cx(9), cy(9),...   % 2.  center up
        cx(13),cy(13),...  % 3.  center down
        cx(5), cy(5),...   % 4.  left center
        cx(2), cy(2),...   % 5.  right center
        cx(4), cy(4),...   % 6.  left up
        cx(3), cy(3),...   % 7.  right up
        cx(6), cy(6),...   % 8.  left down
        cx(7), cy(7),...   % 9.  right down
        cx(10),cy(10),...  % 10. left up
        cx(8), cy(8),...   % 11. right up
        cx(11),cy(11),...  % 12. left down
        cx(12),cy(12)];    % 13. right down
    
    % compute validation target locations (calibration targets smaller radius)
    [vx1,vy1] = pol2cart(angle,0.50);
    [vx2,vy2] = pol2cart(angle+pi/6,0.35);
    
    vx = round(scr.x_mid + scr.x_mid*[0 vx1 vx2]);
    vy = round(scr.y_mid + scr.x_mid*[0 vy1 vy2]);
    
    % order for eyelink
    % order for eyelink
    v = [vx(1), vy(1),...   % 1.  center center
        vx(9), vy(9),...   % 2.  center up
        vx(13),vy(13),...  % 3.  center down
        vx(5), vy(5),...   % 4.  left center
        vx(2), vy(2),...   % 5.  right center
        vx(4), vy(4),...   % 6.  left up
        vx(3), vy(3),...   % 7.  right up
        vx(6), vy(6),...   % 8.  left down
        vx(7), vy(7),...   % 9.  right down
        vx(10),vy(10),...  % 10. left up
        vx(8), vy(8),...   % 11. right up
        vx(11),vy(11),...  % 12. left down
        vx(12),vy(12)];    % 13. right down
elseif const.typeCalib == 2
    
    bigRect = [scr.scr_sizeX*0.8,scr.scr_sizeY*0.8];
    smallRect = [scr.scr_sizeX*0.4,scr.scr_sizeY*0.4];
    
    % order for eyelink
    c = [   scr.x_mid                   , scr.y_mid,                    ... %  1.  center
            scr.x_mid                   , scr.y_mid - bigRect(2)/2,     ... %  2.  big center up
            scr.x_mid                   , scr.y_mid + bigRect(2)/2,     ... %  3.  big center down
            scr.x_mid - bigRect(1)/2    , scr.y_mid,                    ... %  4.  big left center
            scr.x_mid + bigRect(1)/2    , scr.y_mid,                    ... %  5.  big right center
            scr.x_mid - bigRect(1)/2    , scr.y_mid - bigRect(2)/2,     ... %  6.  big left up
            scr.x_mid + bigRect(1)/2    , scr.y_mid - bigRect(2)/2,     ... %  7.  big right up
            scr.x_mid - bigRect(1)/2    , scr.y_mid + bigRect(2)/2,     ... %  8.  big left down
            scr.x_mid + bigRect(1)/2    , scr.y_mid + bigRect(2)/2,     ... %  9.  big right down
            scr.x_mid - smallRect(1)/2  , scr.y_mid - smallRect(2)/2,   ... % 10.  small left up
            scr.x_mid + smallRect(1)/2  , scr.y_mid - smallRect(2)/2,   ... % 11.  small right up
            scr.x_mid - smallRect(1)/2  , scr.y_mid + smallRect(2)/2,   ... % 12.  small left down
            scr.x_mid + smallRect(1)/2  , scr.y_mid + smallRect(2)/2];  ... % 13.  small right down
	
	c = round(c);    
        
	bigRect = [scr.scr_sizeX*0.7,scr.scr_sizeY*0.7];
    smallRect = [scr.scr_sizeX*0.35,scr.scr_sizeY*0.35];
    
    % order for eyelink
    v = [   scr.x_mid                   , scr.y_mid,                    ... %  1.  center
            scr.x_mid                   , scr.y_mid - bigRect(2)/2,     ... %  2.  big center up
            scr.x_mid                   , scr.y_mid + bigRect(2)/2,     ... %  3.  big center down
            scr.x_mid - bigRect(1)/2    , scr.y_mid,                    ... %  4.  big left center
            scr.x_mid + bigRect(1)/2    , scr.y_mid,                    ... %  5.  big right center
            scr.x_mid - bigRect(1)/2    , scr.y_mid - bigRect(2)/2,     ... %  6.  big left up
            scr.x_mid + bigRect(1)/2    , scr.y_mid - bigRect(2)/2,     ... %  7.  big right up
            scr.x_mid - bigRect(1)/2    , scr.y_mid + bigRect(2)/2,     ... %  8.  big left down
            scr.x_mid + bigRect(1)/2    , scr.y_mid + bigRect(2)/2,     ... %  9.  big right down
            scr.x_mid - smallRect(1)/2  , scr.y_mid - smallRect(2)/2,   ... % 10.  small left up
            scr.x_mid + smallRect(1)/2  , scr.y_mid - smallRect(2)/2,   ... % 11.  small right up
            scr.x_mid - smallRect(1)/2  , scr.y_mid + smallRect(2)/2,   ... % 12.  small left down
            scr.x_mid + smallRect(1)/2  , scr.y_mid + smallRect(2)/2];  ... % 13.  small right down
    
	v = round(v);
end

Eyelink('command', 'calibration_type = HV13');
Eyelink('command', 'generate_default_targets = NO');

Eyelink('command', 'randomize_calibration_order 1');
Eyelink('command', 'randomize_validation_order 1');
Eyelink('command', 'cal_repeat_first_target 1');
Eyelink('command', 'val_repeat_first_target 1');

Eyelink('command', 'calibration_samples=14');
Eyelink('command', 'calibration_sequence=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');
Eyelink('command', sprintf('calibration_targets = %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i',c));

Eyelink('command', 'validation_samples=14');
Eyelink('command', 'validation_sequence=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');
Eyelink('command', sprintf('validation_targets = %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i',v));

% Connection verification
% -----------------------
if Eyelink('IsConnected')~=1 && ~dummymode
    fprintf('Not connected. exiting');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

end