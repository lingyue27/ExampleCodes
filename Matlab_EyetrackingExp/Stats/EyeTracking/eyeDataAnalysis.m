function [configAll,configEyeAll] = eyeDataAnalysis(sub,configAll,configEyeAll)
% ----------------------------------------------------------------------
% [configAll,configEyeAll] = eyeDataAnalysis(sub,configAll,configEyeAll)
% ----------------------------------------------------------------------
% Goal of the function :
% Gaze analysis across different sub-functions
% ----------------------------------------------------------------------
% Input(s) :
% sub = subject and analysis settings
% configAll = stuct containing block structs of experimental settings 
% configEyeAll = stuct containing block structs of eye analysis
% ----------------------------------------------------------------------
% Output(s):
% configAll = stuct containing block structs of experimental settings 
% configEyeAll = stuct containing block structs of eye analysis
% ----------------------------------------------------------------------
% Created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 26 / 01 / 2017
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

% Load configurations
% -------------------
load(sprintf('%s/expRes_%s_B%i.mat',sub.blockDir,sub.ini,sub.fromB));

% Define analysis settings
% ------------------------
[configEye] = xanaEyeMovements(config);

% Create a tab file with timestamps
% ---------------------------------
[configEye] = xmsg2tab(sub,config,configEye);

% Gaze analysis
% -------------
[configEye] = anaEyeMovements(sub,config,configEye);

% Put blocks together
% -------------------
configAll{sub.fromB} = config;
configEyeAll{sub.fromB} = configEye;
configEyeAll{sub.blockNum+1}.resMat = [configEyeAll{sub.blockNum+1}.resMat;configEyeAll{sub.fromB}.resMat];
configEyeAll{sub.blockNum+1}.resMatCor = [configEyeAll{sub.blockNum+1}.resMatCor;configEyeAll{sub.fromB}.resMatCor];
configEyeAll{sub.blockNum+1}.resMatIncor = [configEyeAll{sub.blockNum+1}.resMatIncor;configEyeAll{sub.fromB}.resMatIncor];


end