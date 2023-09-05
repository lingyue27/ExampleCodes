function all_analysis(initials,taskType,blockNum,eyeAnalysis)
% -------------------------------------------------------------------------
% all_analysis(initials,taskType,blockNum,eyeAnalysis)
% -------------------------------------------------------------------------
% Goal of the function :
% Run all eye and behavioral analysis for an individual subject
% -------------------------------------------------------------------------
% Input(s) :
% initials    : subject initials
% taskType    : type of task and/or number of session (e.g: 'TH1','MAIN')
% blockNum    : number of blocks
% eyeAnalysis : eye + behavior analysis (1) or behavior analysis  only (0)
% 
% e.g.  all_analysis('MS','MAIN',2,1)
% -------------------------------------------------------------------------
% Generated Results:
% 1. Return in AllB/expResEye_XX_AllB.mat, see Stats/ResCol for details
% 2. Return main task results
% -------------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........04 | 10 | 2019
% Project.....................CHIB
% Version........................5
% -------------------------------------------------------------------------

% Initial settings
% ----------------
close all;warning ('off','all');
sub.dir                                     = (which('all_analysis'));
sub.dir                                     = sub.dir(1:end-21);
sub.ini                                     = initials;
sub.task                                    = taskType;
sub.blockNum                                = blockNum;
sub.fitBootNum                              = 100;
sub.fitGrainNum                             = 100;
sub.fitLapseRate                            = 0; % 0 0 1 1
sub.all_blockDir                            = sprintf('%s/Data/%s/ExpData%s/AllB',sub.dir,sub.ini,sub.task);

configAll                                   = [];
configEyeAll{sub.blockNum+1}.resMat         = [];
configEyeAll{sub.blockNum+1}.resMatCor      = [];
configEyeAll{sub.blockNum+1}.resMatIncor    = [];


% Change directory and path
% -------------------------
cd(sub.dir);
addpath(genpath('../V5/'));

% Gaze analysis
% -------------
if eyeAnalysis
    for rep = 1:sub.blockNum
        
        % Determine block number and directory
        sub.fromB       = rep;
        sub.blockDir    = sprintf('%s/Data/%s/ExpData%s/B%i',sub.dir,sub.ini,sub.task,sub.fromB);
        fprintf(1,'\n\t------------------------ BLOCK %i ------------------------\n',sub.fromB);
        
        % EDF data conversion in dat and msg temporary file
        fprintf(1,'\n\tConverting %s_B%i.edf to %s_B%i.msg and %s_B%i.msg /.dat  files\n\n',sub.ini,sub.fromB,sub.ini,sub.fromB,sub.ini,sub.fromB);
        if ismac;    edf2asc = '/Applications/Eyelink/EDF_Access_API/Example/edf2asc';
        elseif ispc; edf2asc = sprintf('%s/Stats/EyeTracking/edf2asc.exe',sub.dir);end
        [~,~] = system([edf2asc, ' ', sprintf('%s/%s_B%i',sub.blockDir,sub.ini,sub.fromB),'.edf -e -y']);
        movefile(sprintf('%s/%s_B%i.asc',sub.blockDir,sub.ini,sub.fromB), sprintf('%s/%s_B%i.msg',sub.blockDir,sub.ini,sub.fromB));
        [~,~] = system([edf2asc, ' ', sprintf('%s/%s_B%i',sub.blockDir,sub.ini,sub.fromB),'.edf -s -miss -1.0 -y']);
        movefile(sprintf('%s/%s_B%i.asc',sub.blockDir,sub.ini,sub.fromB), sprintf('%s/%s_B%i.dat',sub.blockDir,sub.ini,sub.fromB));
        
        % Gaze analysis
        [configAll,configEyeAll] = eyeDataAnalysis(sub,configAll,configEyeAll);
        
        % delete .dat and .msg temporary file
        delete(sprintf('%s/%s_B%i.msg',sub.blockDir,sub.ini,sub.fromB));
        delete(sprintf('%s/%s_B%i.dat',sub.blockDir,sub.ini,sub.fromB));
    end
    
    % Create all block folder and save data
    if ~isdir(sub.all_blockDir);mkdir(sub.all_blockDir);end
    save(sprintf('%s/expRes_%s_AllB.mat',sub.all_blockDir,sub.ini),'configAll');
    save(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini),'configEyeAll');
    save(sprintf('%s/sub_%s_AllB.mat',sub.all_blockDir,sub.ini),'sub');

    % Compute trial summary
    process_trial(sub);
    
    % Run saccade metrics analysis
    saccades_analysis(sub);
    
end

% Behavior analysis
% -----------------
% % All thresholds and slope
  indiv_data_anal(sub)
% draw_resTh(sub)
% 
% % All bias and jnd
% extractorBias(sub)
% draw_resBias(sub)
% 
% % Draw all results
% extractorMain(sub)
% drawStats(sub)

end