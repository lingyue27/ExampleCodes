function [const] = constConfig(scr,const)
% ----------------------------------------------------------------------
% [const] = constConfig(scr,const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute all constant data of this experiment.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........08 | 10 | 2019
% Project.....................CHIB
% Version........................6
% ----------------------------------------------------------------------

% Text configuration
% ------------------
const.my_font = 'Arial';
const.text_size = 30;
const.cue_size  = 50;

% Time
% ----
% clock
const.my_clock_ini  = clock;

% Fixation Stark und Stabile + Jitter
const.durIniFix = 1.000;             const.numIniFix = (round(const.durIniFix/scr.frame_duration));  % 300 + 200 (check fix)
const.FT_greenDely = 1.000;          const.num_FT_greenDely = (round(const.FT_greenDely/scr.frame_duration));

% Timing of fixation duration in seconds and converted into number of frames (nbf)
if const.mainCond == 3 || const.mainCond == 4
    const.cueDurMs      = 1.500;    
elseif const.mainCond == 1 || const.mainCond == 2
    const.cueDurMs      = 1.500;    
end
const.cueDurNbf   = (round(const.cueDurMs  / scr.frame_duration));

% Timing of the interval durations
const.OneIntDurMs   = [0.100 1.000];             const.OneIntNbf   = (round(const.OneIntDurMs   / scr.frame_duration));
const.EndIntDurMs = 0.500;                       const.EndIntNbf = (round(const.EndIntDurMs / scr.frame_duration));
const.FlashIntDurMs = 0.025;                     const.FlashIntNbf = (round(const.FlashIntDurMs / scr.frame_duration)); 

if const.mainCond == 1 || const.mainCond == 2
    const.StartIntDurMs = 0.040;
elseif const.mainCond == 3 || const.mainCond == 4
    const.StartIntDurMs = 0.500;       
end
const.StartIntNbf = (round(const.StartIntDurMs / scr.frame_duration));

if const.mainCond == 1 || const.mainCond == 3
    const.TwoIntDurMs = 2.000;
elseif const.mainCond == 2 || const.mainCond == 4
    const.TwoIntDurMs = 0.500;       
end
const.TwoIntNbf   = (round(const.TwoIntDurMs   / scr.frame_duration));

if const.mainCond == 1 || const.mainCond == 3
    const.ThreeIntDurMs = 0.500;
    const.LastFlashIntDurMs = 0.025;
elseif const.mainCond == 2 || const.mainCond == 4
    const.ThreeIntDurMs = 0.000;     
    const.LastFlashIntDurMs = 0.025;
end
const.ThreeIntNbf = (round(const.ThreeIntDurMs / scr.frame_duration));
const.LastFlashIntNbf = (round(const.LastFlashIntDurMs / scr.frame_duration));

% Flash duration in the Updown task
% const.flashDurMs = 0.025;           const.flashDurNbf = (round(const.flashDurMs/scr.frame_duration)); 

% Saccade in circle
const.durInBound = 0.050;           const.numInBound = (round(const.durInBound/scr.frame_duration));

% Saccade latency max
const.dur_maxLatency = 4.500;       const.num_maxLatency = (round(const.dur_maxLatency/scr.frame_duration));
const.dur_minLatency = 0.100;       const.num_minLatency = (round(const.dur_minLatency/scr.frame_duration));

% Inter stimulus interval duration (in seconds) 
const.iti = 0.500; 

% FP for Calibration:
const.fixPos            = [scr.x_mid, scr.y_mid];
const.fixRadVal         = 0.4;                          [const.fixRad,~]              = vaDeg2pix(const.fixRadVal,scr);
const.fixCtrRadVal      = const.fixRadVal*3/4;          [const.fixCtrRad,~]           = vaDeg2pix(const.fixCtrRadVal,scr);
const.fixCtrCtrRadVal   = const.fixCtrRadVal*1/2;       [const.fixCtrCtrRad,~]        = vaDeg2pix(const.fixCtrCtrRadVal,scr);

% FP For the Experiment
const.fixExpVal         = 0.1 ;                         [const.fixExp ,~]             = vaDeg2pix(const.fixExpVal ,scr);

% Saccade configuration
const.sacAmpVal         = 10;                           [const.sacAmp,~]              = vaDeg2pix(const.sacAmpVal,scr);

const.cardinalDistDVA   = sqrt((const.sacAmpVal^2)/2);  [const.cardinalDist,~]        = vaDeg2pix(const.cardinalDistDVA,scr);                       

const.leftSacCtrUp      = [scr.x_mid - const.cardinalDist, scr.y_mid - const.cardinalDist];
const.leftSacCtrDown    = [scr.x_mid - const.cardinalDist, scr.y_mid + const.cardinalDist];

const.rightSacCtrUp     = [scr.x_mid + const.cardinalDist, scr.y_mid - const.cardinalDist];
const.rightSacCtrDown   = [scr.x_mid + const.cardinalDist, scr.y_mid + const.cardinalDist];

% Stimuli settings
% ------------------------

const.stimSizeX_deg  = 2;    [const.stimSizeX_pix,~] = vaDeg2pix(const.stimSizeX_deg ,scr);
const.stimSizeY_deg  = 2;    [const.stimSizeY_pix,~] = vaDeg2pix(const.stimSizeY_deg ,scr);
const.stimRad_pix    = const.stimSizeX_pix/2;

% Rect Left Up
const.rectLeftUp(:,1)  = const.leftSacCtrUp(:,1) - const.stimSizeX_pix/2;      % left
const.rectLeftUp(:,2)  = const.leftSacCtrUp(:,2) - const.stimSizeY_pix/2;      % top
const.rectLeftUp(:,3)  = const.leftSacCtrUp(:,1) + const.stimSizeX_pix/2;      % right
const.rectLeftUp(:,4)  = const.leftSacCtrUp(:,2) + const.stimSizeY_pix/2;      % bottom

% Rect Left Down
const.rectLeftDown(:,1)  = const.leftSacCtrDown(:,1) - const.stimSizeX_pix/2;   % left
const.rectLeftDown(:,2)  = const.leftSacCtrDown(:,2) - const.stimSizeY_pix/2;   % top
const.rectLeftDown(:,3)  = const.leftSacCtrDown(:,1) + const.stimSizeX_pix/2;   % right
const.rectLeftDown(:,4)  = const.leftSacCtrDown(:,2) + const.stimSizeY_pix/2;   % bottom

% Rect Right Up
const.rectrightUp(:,1)  = const.rightSacCtrUp(:,1) - const.stimSizeX_pix/2;     % left
const.rectrightUp(:,2)  = const.rightSacCtrUp(:,2) - const.stimSizeY_pix/2;     % top
const.rectrightUp(:,3)  = const.rightSacCtrUp(:,1) + const.stimSizeX_pix/2;     % right
const.rectrightUp(:,4)  = const.rightSacCtrUp(:,2) + const.stimSizeY_pix/2;     % bottom

% Rect right Down
const.rectrightDown(:,1)  = const.rightSacCtrDown(:,1) - const.stimSizeX_pix/2; % left
const.rectrightDown(:,2)  = const.rightSacCtrDown(:,2) - const.stimSizeY_pix/2; % top
const.rectrightDown(:,3)  = const.rightSacCtrDown(:,1) + const.stimSizeX_pix/2; % right
const.rectrightDown(:,4)  = const.rightSacCtrDown(:,2) + const.stimSizeY_pix/2; % bottom


% Error fixation
% --------------
const.durErrorFixGap1   = 0.150;       const.errorFixGap1NbFrm   = (round(const.durErrorFixGap1/scr.frame_duration));
const.durErrorFixGap2   = 0.100;       const.errorFixGap2NbFrm   = (round(const.durErrorFixGap2/scr.frame_duration));
const.durErrorFixCircle = 0.050;       const.errorFixCircleNbFrm = (round(const.durErrorFixCircle/scr.frame_duration));

const.durErrorFix   = const.durErrorFixGap1 + 3* const.durErrorFixCircle + 2*const.durErrorFixGap2;             
const.errorFixNbFrm = (round(const.durErrorFix/scr.frame_duration));

const.errorFixNbFrmMax = const.errorFixNbFrm;

const.errFixCircle1frmStart = 1 + const.errorFixGap1NbFrm;                              
const.errFixCircle1frmEnd = const.errFixCircle1frmStart + const.errorFixCircleNbFrm -1;
const.errFixCircle2frmStart = const.errFixCircle1frmEnd + const.errorFixGap2NbFrm + 1;
const.errFixCircle2frmEnd = const.errFixCircle2frmStart + const.errorFixCircleNbFrm -1;
const.errFixCircle3frmStart = const.errFixCircle2frmEnd + const.errorFixGap2NbFrm + 1;
const.errFixCircle3frmEnd = const.errFixCircle3frmStart + const.errorFixCircleNbFrm -1;

const.errfixWidth   = 0.1;
const.errfixRadCtr1 = 2;
const.errfixRadCtr2 = 1.5;
const.errfixRadCtr3 = 1;

const.errfixOutRad1Val = const.errfixRadCtr1 + (const.errfixWidth/2); [const.errfixOutRad1,~] = vaDeg2pix(const.errfixOutRad1Val,scr); 
const.errfixInRad1Val  = const.errfixRadCtr1 - (const.errfixWidth/2); [const.errfixInRad1,~]  = vaDeg2pix(const.errfixInRad1Val,scr); 

const.errfixOutRad2Val = const.errfixRadCtr2 + (const.errfixWidth/2); [const.errfixOutRad2,~] = vaDeg2pix(const.errfixOutRad2Val,scr); 
const.errfixInRad2Val  = const.errfixRadCtr2 - (const.errfixWidth/2); [const.errfixInRad2,~]  = vaDeg2pix(const.errfixInRad2Val,scr); 

const.errfixOutRad3Val = const.errfixRadCtr3 + (const.errfixWidth/2); [const.errfixOutRad3,~] = vaDeg2pix(const.errfixOutRad3Val,scr); 
const.errfixInRad3Val  = const.errfixRadCtr3 - (const.errfixWidth/2); [const.errfixInRad3,~]  = vaDeg2pix(const.errfixInRad3Val,scr); 

% Eyelink settings
% ----------------
const.boundRadBefVal                = 2;
const.boundRadBef                   = vaDeg2pix(const.boundRadBefVal,scr);
const.boundRadAftVal                = 2;
const.boundRadAft                   = vaDeg2pix(const.boundRadAftVal,scr);
const.timeOut                       = 1.5;
const.tCorMin                       = 0.2;
const.fixation_outer_rim_rad        = const.fixRad;
const.fixation_rim_rad              = const.fixCtrRad;
const.fixation_rad                  = const.fixCtrCtrRad;
const.fixation_outer_rim_color      = [0,0,0];
const.fixation_rim_color            = [255,255,255];
const.fixation_color                = [0,0,0];

end