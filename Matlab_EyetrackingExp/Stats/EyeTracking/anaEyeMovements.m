function [configEye] = anaEyeMovements(sub,config,configEye)
% ----------------------------------------------------------------------
% [configEye] = anaEyeMovements(sub,config,configEye)
% ----------------------------------------------------------------------
% Goal of the function :
% Data analysis of eye tracker data for Saccade experiment
% ----------------------------------------------------------------------
% Input(s) :
% sub = subject configuration
% config : struct containing experimental settings
% configEye = struct containing eye data analysis
% ----------------------------------------------------------------------
% Output(s):
% configEye = struct containing eye data analysis
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 28 / 11 / 2017
% Project :     WarewolfGhost
% Version :     1.0
% ----------------------------------------------------------------------

fprintf(1,'\n\tProcessing %s_B%i.dat file...\n ',sub.ini, sub.fromB);

% Get files
% ---------
% Msg data
msg_tab         = configEye.msg_tab;

% Eye coordinates data
eye_data_file   = sprintf('%s/%s_B%i.dat',sub.blockDir,sub.ini,sub.fromB);
eye_data_fid    = fopen(eye_data_file);
eye_data        = textscan(eye_data_fid,'%f%f%f%f%s');
eye_data        = [eye_data{1},eye_data{2},eye_data{3}];

% Design and behavioral data
expRes_data     = config.expDes.expResMat;

% Loop over trials
% ----------------
tIncor          = 0;
tCor            = 0;
rand1Col        = 3;
rand2Col        = 4;
onlineCorCol    = 11;

for t = 1:(size(msg_tab,1))
    % design values
    rand1               = expRes_data(t,rand1Col);          % Test condition (1 = flicker fusion, 2 = main)
    rand2               = expRes_data(t,rand2Col);          % Saccade direction (1 = right, 2 = left)
    onlineCheck         = expRes_data(t,onlineCorCol);      % gaze check (1 = SAC/FIX COR; 0 = SAC/FIX INCO -1 = FIX BREAK)
    
    % fixation and saccade target rect
    fixPos              = config.const.fixPos;
    fixRad              = configEye.anaEye.sacRadBfr;
    fixRect             = [fixPos fixPos] + [-fixRad -fixRad fixRad fixRad];
    if rand2 == 1
        sacPos = config.const.rightSacCtr;
    elseif rand2 == 2
        sacPos = config.const.leftSacCtr;
    end
    sacRad              = configEye.anaEye.sacRadAft;
    sacRect             = [sacPos sacPos] + [-sacRad -sacRad sacRad sacRad];
    
    % Stimuli time and duration
    tTrial_start        = msg_tab(t,2);
    tTrial_end          = msg_tab(t,3);
    tFixCheck_start     = msg_tab(t,5);
    tRunTrial_start     = msg_tab(t,6);
    tSacOnline_start    = msg_tab(t,8);
    tSacOnline_end      = msg_tab(t,9);
    tFT_start           = msg_tab(t,10);
    tFT_end             = msg_tab(t,11);
    tREF_start          = msg_tab(t,12);
    tREF_end            = msg_tab(t,13);
    tGAP_start          = msg_tab(t,14);
    tGAP_end            = msg_tab(t,15);
    tPROBE_start        = msg_tab(t,16);
    tPROBE_end          = msg_tab(t,17);
    tGetAnswer          = msg_tab(t,18);
    tAnswer             = msg_tab(t,19);
    
    durFixCheck         = tRunTrial_start - tFixCheck_start;
    durFT               = tFT_end - tFT_start;
    durREF              = tGAP_start - tREF_start;
    durPROBE            = tPROBE_end - tPROBE_start;
    durResp             = tAnswer - tGetAnswer;
    durTrial            = tTrial_end - tTrial_start;
    durSacOnline        = tSacOnline_end - tSacOnline_start;
    
    % Exclusion indicator
    trialCriterion      = 0; %    Trial criterion (1 = all ok, 0 = not all ok)
    onlineError         = 0; % #1 Online error (error fixation, too slow saccade, too slow responses)
    missDurTrial        = 0; % #2 Blinks during all trials
    missTimeStamps      = 0; % #3 Missing times stamps trials during all trials
    inaccurateSac       = 0; % #4 Inaccurate saccade
    
    % Collected values
    sacOnset        = -8;	sacOffset       = -8;       % saccade onset time                            | saccade offset time
    sacDur          = -8;   sacLatency      = -8;       % saccade duration                              | saccade latency
    sacVPeak        = -8;   sacDist         = -8;       % saccade velocity peak                         | saccade distance
    sacAngle        = -8;   sacAmpGet       = -8;       % saccade angle                                 | saccade amplitude
    sacxOnset       = -8;   sacyOnset       = -8;       % saccade onset x coordinate                    | saccade onset y coordinate
    sacxOffset      = -8;   sacyOffset      = -8;       % saccade offset x coordinate                   | saccade offset y coordinate
    sacOffOnLatency = -8;   probeOnSacOff   = -8;       % saccade online/offline latency difference     | probe onset relative saccade offset 
    
    % Criterion #1
    if onlineCheck ~= 1
        onlineError = 1;
    end
    
    % Criterion #2
    idx = find(eye_data(:,1) >= tRunTrial_start & eye_data(:,1) <= tGetAnswer);
    if ~onlineError
        idxmbdi = find(eye_data(idx,configEye.anaEye.crit_cols)==-1, 1);
        if ~isempty(idxmbdi);
            missDurTrial = 1;
        end
    end
    
    % Criterion #3
    if ~onlineError
        time = eye_data(idx,1);
        if sum(diff(time)>(1000/configEye.anaEye.SAMPRATE)) || isempty(time);
            missTimeStamps  = 1;
        end
    end
    
    % Criteria #4
    if rand1 == 2
        if ~missTimeStamps && ~missDurTrial && ~onlineError
            sAcc = [];
            x = configEye.anaEye.DPP*([eye_data(idx,2), (eye_data(idx,3))]);
            v = vecvel(x, configEye.anaEye.SAMPRATE, configEye.anaEye.VELTYPE);
            ms = microsaccMerge(x,v,configEye.anaEye.velSD,configEye.anaEye.minDur,configEye.anaEye.mergeInt);
            ms = saccpar(ms);
            if size(ms,1) > 0
                amp  = ms(:,7);
                ms   = ms(amp>configEye.anaEye.maxMSAmp,:);
            end
            
            if size(ms,1) > 0 && ~isempty(ms)
                nSac   = size(ms,1);
                if nSac > 0
                    s1 = 0;
                    while s1 < nSac
                        s1 = s1+1;
                        xBeg  = configEye.anaEye.PPD*x(ms(s1,1),1);
                        yBeg  = configEye.anaEye.PPD*x(ms(s1,1),2);
                        xEnd  = configEye.anaEye.PPD*x(ms(s1,2),1);
                        yEnd  = configEye.anaEye.PPD*x(ms(s1,2),2);
                        fixedFix = isincircle(xBeg,yBeg,fixRect);
                        fixedTar = isincircle(xEnd,yEnd,sacRect);
                        if fixedTar && fixedFix;sAcc = s1;end
                    end
                end
                
                if ~isempty(sAcc)
                    sacOnset         = time(ms(sAcc,1));
                    sacOffset        = time(ms(sAcc,2));
                    sacDur           = ms(sAcc,3);
                    sacLatency       = sacOnset - tREF_start;
                    sacOffOnLatency  = tSacOnline_start - sacOnset;
                    sacVPeak         = ms(sAcc,4);
                    sacDist          = ms(sAcc,5);
                    sacAngle         = ms(sAcc,6);
                    sacAmpGet        = ms(sAcc,7);
                    sacxOnset        = configEye.anaEye.PPD*x(ms(sAcc,1),1);
                    sacyOnset        = configEye.anaEye.PPD*x(ms(sAcc,1),2);
                    sacxOffset       = configEye.anaEye.PPD*x(ms(sAcc,2),1);
                    sacyOffset       = configEye.anaEye.PPD*x(ms(sAcc,2),2);
                    probeOnSacOff    = tPROBE_start - sacOffset;
                else
                    inaccurateSac       = 1;
                end
            else
                % no saccade detected
                inaccurateSac       = 1;
            end
        end
    end
    
    % Data save
    % ---------
    % Eye gaze trace values
    idx2    = find(eye_data(:,1) >= tTrial_start & eye_data(:,1) <= tTrial_end);
    time2   = eye_data(idx2,1);
    matGaze_val = [time2, eye_data(idx2,2), eye_data(idx2,3)];
    
    % Analysis values
    analysis_val = [ sacOnset,       sacOffset,      sacDur,             sacLatency,         sacOffOnLatency,    ...
                     sacVPeak,       sacDist,        sacAngle,           sacAmpGet,          sacxOnset,          ...
                     sacyOnset,      sacxOffset,     sacyOffset,         durFixCheck,        durFT,              ...
                     durREF,         durPROBE,       durResp,            durTrial,           durSacOnline        probeOnSacOff];
    
	% Criterion values
    if rand1 == 2
        if ~onlineError && ~missDurTrial && ~missTimeStamps && ~inaccurateSac
            trialCriterion = 1;
        end
    end
    crit_val = [trialCriterion, missDurTrial, missTimeStamps, onlineError, inaccurateSac];
    
    % Saving matrix
    configEye.resMat(t,:) = [expRes_data(t,:),msg_tab(t,:),analysis_val,crit_val];
	configEye.gazeMat{t}  = {configEye.resMat(t,:);matGaze_val};
    if trialCriterion
        tCor = tCor+1;
        configEye.resMatCor(tCor,:) = [expRes_data(t,:),msg_tab(t,:),analysis_val,crit_val];
        configEye.gazeMatCor{tCor}  = {configEye.resMat(t,:);matGaze_val};
    else
        tIncor = tIncor + 1;
        configEye.resMatIncor(tIncor,:) = [expRes_data(t,:),msg_tab(t,:),analysis_val,crit_val];
        configEye.gazeMatIncor{tIncor}  = {configEye.resMat(t,:);matGaze_val};
    end
    
end

% Saving procedure
% ----------------
if tIncor == 0;
    configEye.resMatIncor(1,:) = zeros(1,size(configEye.resMatCor,2));
    configEye.gazeMatIncor{1} = [];
end
save(sprintf('%s/expResEye_%s_B%i.mat',sub.blockDir,sub.ini,sub.fromB),'configEye');

goodTrial_Sum           =   sum(configEye.resMat(:,end-4)==1);
badTrial_Sum            =   sum(configEye.resMat(:,end-4)==0);
missDurTrial_Sum        =   sum(configEye.resMat(:,end-3));
missTimeStamps_Sum      =   sum(configEye.resMat(:,end-2));
onlineError_Sum         =   sum(configEye.resMat(:,end-1));
inaccurateSac_Sum       =   sum(configEye.resMat(:,end));

% Print summary
% -------------
fprintf(1,'\n\tTrials :\t\t\t\t%i\n\n',t);
fprintf(1,'\tGood Trials :\t\t\t\t%i\n',goodTrial_Sum);
fprintf(1,'\tBad Trials :\t\t\t\t%i\n\n',badTrial_Sum);
fprintf(1,'\tBlink during trial :\t\t\t%i\n',missDurTrial_Sum);
fprintf(1,'\tMissing time stamps :\t\t\t%i\n\n',missTimeStamps_Sum);
fprintf(1,'\tOnline detected error trial:\t\t%i\n',onlineError_Sum);
fprintf(1,'\tInaccurate saccade  :\t\t\t%i\n',inaccurateSac_Sum);
    
end