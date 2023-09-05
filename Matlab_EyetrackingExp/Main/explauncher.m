

%%  expLauncher
%   ===========
% By          : Lingyue CHEN, Lukasz GRZECZKOWSKI & Zhuanghua SHI
% Coded by    : Lukasz GRZECZKOWSKI, Lingyue CHEN
% Start date  : November | 2019
% Projet      : CHIB
%             : Aim of the project is to investigate the interaction of two
%               time perception effects, namly the intentional binding (IB)
%               and the chronostasis (CH). The idea is that they do not
%               occur simultanouesly but result depending on different
%               situations.
% Version     : 7
%             : In this version, we changed based on V6 paradigm.
%             There is a blank (2nd interval, 0 or 2000ms), ss compare the 1st interval
%             (that varies between 125 - 875 ms) to the 3rd interval of 500
%             ms. Each interval was started and ended by a flash ring.
%
% First setup
% -----------
clear all; clear mex; clear functions; close all; home; ListenChar(1);

% General settings
% ----------------
const.expName           = 'CHIB';               % Experiment name
const.expStart          = 1;                    % Start of a recording exp                          0 = NO   , 1 = YES
const.eyeMvt            = 1;                    % Control eye/mouse movement,                       0 = NO   , 1 = YES

const.TEST              = 0;                    % Dummy mode or not,                                0 = NO(eye), 1 = YES (mouse)
const.mkVideo           = 0;                    % Make a video of one trial                         0 = NO   , 1 = YES
const.typeCalib         = 1;                    % Type of calibration to play                       1 = star , 2 = rectangle
const.checkLat          = 0;                    % Saccade latency feedback                          0 = NO   , 1 = YES
const.checkTrial        = 0;                    % Print trial conditions                            0 = NO   , 1 = YES
const.checkTimeFrm      = 0;                    % Print time frames                                 0 = NO   , 1 = YES
const.debugTransp       = 0;                    % Debug on single screen with transparency          0 = NO   , 1 = YES
const.photometerTest    = 0;                    % Draw Gabor transition values                      0 = NO   , 1 = YES
const.synctest          = 0;                    % Skip or not PTB synch tests                       0 = NO   , 1 = YES
const.feedbackTr        = 1;                    % Provide Error Feedback During Training?           0 = NO   , 1 = YES
const.feedbackExp       = 0;                    % Provide Error Feedback During Experiment?         0 = NO   , 1 = YES

% Screen
% ------
const.calibFlag         = 0;                    % Luminance gamma linearisation calibration         0 = NO   , 1 = YES
const.calibType         = 2;                    % There is 2 types of gamma calibration             1 = Gray linearized, 2 = RGB linearized
const.desiredFD         = 120;                  % Desired refresh rate
% fprintf(1,'\n\texpLauncher line 68: Don''t forget to put it back to 120 !!!\n');
const.desiredRes        = [1920,1080];           % Desired resolution

% Paths
% -----
dir = (which('expLauncher'));cd(dir(1:end-18));
addpath('Config','Main','Conversion','EyeTracking','Gammacalib','Instructions','Trials','Stim','Stats','Video');

% Block Definition
% ----------------
if ~const.expStart || const.mkVideo
    nbBlockTraining            = 1;
    nbBlockMain                = 1;
    const.numBlockTrainingTot  = 1;
    const.numBlockMainTot      = 2;
    
else
    nbBlockTraining            = 1;
    nbBlockMain                = 1;
    const.numBlockTrainingTot  = 1;
    const.numBlockMainTot      = 2;
end

% If not ExpStart, which condition?
% ---------------------------------
if ~const.expStart
    const.sjct_numId = 1;
    const.mainCond = input(sprintf('\n\tSAC (1), FIX (2)?: '));
end

% Subject configuration
% ---------------------
[const] = sbjConfig(const);

% COLOR EXPERIMENT
% ----------------
toBlockTraining = (const.fromBlock+nbBlockTraining-1);
if toBlockTraining > const.numBlockTrainingTot;toBlockTh = const.numBlockTrainingTot;end
for block = const.fromBlock:toBlockTraining
    const.fromBlock = block;
    main(const); clear expDes; clear mex;
end