function [vid] = runTrials(scr,aud,const,expDes,el,my_key,vid)
% ----------------------------------------------------------------------
% [vid] = runTrials(scr,aud,const,expDes,el,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Main trial function, prepare eye-link, and display the trial function.
% Save the experimental data in different files.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% aud : struct containing audio settings
% const : struct containing constant settings
% expDes : struct containing design settings
% el : struct containing eyelink settings
% my_key : structure containing keyboard settings
% vid : video structure if demo mode activated
% ----------------------------------------------------------------------
% Output(s):
% vid : video structure if demo mode activated
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated :         18 | 07 | 2019
% Project :                   CHIB
% Version :                      4
% ----------------------------------------------------------------------

% Save all config at start of the block
% -------------------------------------
config.scr = scr; config.aud = aud; config.const = const; config.expDes = expDes; config.el = el; config.my_key = my_key; 
save(const.exp_fileMat,'config');

% First mouse config
% ------------------
HideCursor;
if const.eyeMvt && const.TEST;ShowCursor;end
SetMouse(0,0);

% Instructions
% ------------
if const.eyeMvt && ~const.TEST
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'General intructions');
end

% if mod(const.sjct_numId,2) == 1
%     if const.mainCond == 1 || const.mainCond == 2
%         instructionsIm(scr,aud,const,my_key,'Sac2000red',0);
%     elseif const.mainCond == 3 || const.mainCond == 4
%         instructionsIm(scr,aud,const,my_key,'Fix2000red',0);
%     end
% else
%     if const.mainCond == 1 || const.mainCond == 2
%         instructionsIm(scr,aud,const,my_key,'Sac2000green',0);
%     elseif const.mainCond == 3 || const.mainCond == 4
%         instructionsIm(scr,aud,const,my_key,'Fix2000green',0);
%     end
% end

if const.mainCond == 1
    instructionsIm(scr,aud,const,my_key,'Sac2000',0);
elseif const.mainCond == 2
    instructionsIm(scr,aud,const,my_key,'Sac0',0);
elseif const.mainCond == 3
    instructionsIm(scr,aud,const,my_key,'Fix2000',0);
elseif const.mainCond == 4
    instructionsIm(scr,aud,const,my_key,'Fix0',0);
end

% First calibration
% -----------------
if const.eyeMvt && ~const.TEST
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'1st Calibration instruction');
    instructionsIm(scr,aud,const,my_key,'Calibration',0);
    calibresult = EyelinkDoTrackerSetup(el);
    if calibresult==el.TERMINATE_KEY
        return
    end
end

% Main Loop
% ---------
expDone             = 0;
newJ                = 0;
iniClockCalib       = GetSecs;
startJ              = 1;
endJ                = size(expDes.expMat,1);
expDes.iniEndJ      = endJ;
expDes.expResMat    = [];
if const.mkVideo;endJ = 1;end
calibReq            = 0;
calibBreak          = 0;
expDes.corTrial     = 0;
expDes.incorTrial   = 0;

if ~const.eyeMvt
    timeCalib = 3600; % 1h
else 
    timeCalib = el.timeCalib;
end

while ~expDone
    for t = startJ:endJ
        trialDone = 0;
        while ~trialDone
            
            % Calib problems
            nowClockCalib = GetSecs;
            if (nowClockCalib - iniClockCalib)> timeCalib
                calibReq = 1;
            end
            
            if calibReq==1
                if const.eyeMvt && ~const.TEST
                    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Pause');
                    textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
                    eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
                    instructionsIm(scr,aud,const,my_key,'Pause',0);
                    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Calibration Pause');
                    textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
                    eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
                    instructionsIm(scr,aud,const,my_key,'Calibration',0);
                    EyelinkDoTrackerSetup(el);
                    iniClockCalib = GetSecs;
                    calibBreak = 1;
                end
                calibReq=0;
            end

            if const.eyeMvt && ~const.TEST
                Eyelink('command', 'record_status_message ''TRIAL %d''', t);
                Eyelink('message', 'TRIALID %d', t);
            end

            fix    = 0;
            record = 0;
            while fix ~= 1 || ~record
                if const.eyeMvt && ~const.TEST
                    if ~record
                        
                        Eyelink('startrecording');
                        key=1;
                        while key ~=  0
                            key = EyelinkGetKey(el);		% dump any pending local keys
                        end
                        error=Eyelink('checkrecording'); 	% check recording status
                        
                        if error==0
                            record = 1;
                            Eyelink('message', 'RECORD_START');
                        else
                            record = 0;
                            Eyelink('message', 'RECORD_FAILURE');
                        end
                    end
                else
                    record = 1;
                end
                
                if fix~=1 && record
                    if const.eyeMvt && ~const.TEST;
                        drawTrialInfoEL(scr,const,expDes,el,t)
                    end
                    if t ==1 || calibBreak == 1;
                        calibBreak = 0;
                        waitSpace(scr,aud,const,my_key,t,expDes)
                    end
                    [fix,vid] = checkFix(scr,aud,const,my_key,vid,t,expDes);
                end
                
                if fix~=1 && record
                    if ~const.TEST
                        eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'Error calibration instruction');
                        textP = sprintf(' tCor=%3.0f | tIncor = %3.0f | tRem=%3.0f',expDes.corTrial,expDes.incorTrial,expDes.iniEndJ - expDes.corTrial);
                        eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 40,el.txtCol,textP);
                        instructionsIm(scr,aud,const,my_key,'Calibration',0);
                        EyelinkDoTrackerSetup(el);
                        calibBreak = 1;
                    end
                    record = 0;
                end
            end
            
            % Trial
            if const.eyeMvt && ~const.TEST
                Eyelink('message', 'TRIAL_START %d', t);
                Eyelink('message', 'SYNCTIME');
            end
            [resMat,vid,expDes,eyeCrit] = runSingleTrial(scr,aud,const,expDes,my_key,t,vid);
            if const.eyeMvt && ~const.TEST && resMat(3) ~= -1
                Eyelink('message', 'TRIAL_END %d',  t);
                Eyelink('stoprecording');
            end
            
            % Trial meter
            if resMat(3) == 1 && resMat(1) ~= -2
                expDes.corTrial = expDes.corTrial+1;
            else
                expDes.incorTrial = expDes.incorTrial+1;
            end
            
            if resMat(3) == -1
                % Break Fixation => send a new trial + save trial configuration for later presentation
                trialDone = 1;
                errorFix(scr,aud,const,my_key,vid,t,expDes)
                if const.eyeMvt && ~const.TEST
                    Eyelink('message', 'TRIAL_END %d',  t);
                    Eyelink('stoprecording');
                end
                expDes.expResMat(t,:)= [expDes.expMat(t,:),resMat,eyeCrit];
                if ~const.mkVideo
                    newJ = newJ+1;
                    expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
                end
            elseif resMat(3) == 0
                % incorrect saccade
                trialDone = 1;
                expDes.expResMat(t,:)= [expDes.expMat(t,:),resMat,eyeCrit];
                if ~const.mkVideo
                    newJ = newJ+1;
                    expDes.expMatAdd(newJ,:) = expDes.expMat(t,:);
                end
            else
                trialDone = 1;
                expDes.expResMat(t,:)= [expDes.expMat(t,:),resMat,eyeCrit];           
            end
        end        
    end
    
    % If error of fixation of volontary missed trial
    if ~newJ
        expDone = 1;
    else
        startJ = endJ+1;
        endJ = endJ+newJ;
        expDes.expMat=[expDes.expMat;expDes.expMatAdd];
        expDes.expMatAdd = [];
        newJ = 0;
    end
end

if const.eyeMvt && ~const.TEST
    Eyelink('command','clear_screen');
    Eyelink('command', 'record_status_message ''END''');
end
WaitSecs(1);

% Save all config at end of the block
% -----------------------------------
config.scr = scr;  config.const = const; config.expDes = expDes; config.el = el; config.my_key = my_key; config.aud = aud;
save(const.exp_fileMat,'config');

% End
% ---
if const.eyeMvt && ~const.TEST
    eyeLinkClearScreen(el.bgCol);eyeLinkDrawText(scr.x_mid,scr.y_mid,el.txtCol,'The end');
end

arr_end = [1 2 3];
pos = randi(length(arr_end));
card = arr_end(pos);

if const.fromBlock == const.numBlockMainTot
    instructionsIm(scr,aud,const,my_key,'End',1);
else
    if card == 1
        instructionsIm(scr,aud,const,my_key,'End_block1',1);
    elseif card == 2
        instructionsIm(scr,aud,const,my_key,'End_block2',1);
    elseif card ==3
        instructionsIm(scr,aud,const,my_key,'End_block3',1);
    end
end


% Online gaze statistics
% ----------------------
fprintf(1,' \n\n\tTrials correct             = %3.0f (%1.2f)',expDes.corTrial,expDes.corTrial/(expDes.corTrial+expDes.incorTrial));
fprintf(1,   '\n\tTrials incorrect           = %3.0f (%1.2f)',expDes.incorTrial,expDes.incorTrial/(expDes.corTrial+expDes.incorTrial));

matIncor = expDes.expResMat(expDes.expResMat(:,end-5)~=1,:);

incorFix = sum(expDes.expResMat(:,end-5)==-1);
sacStay = sum((matIncor(:,end-4)==0));
sacInac = sum((matIncor(:,end-3)==0));
sacDurIn = sum((matIncor(:,end-2)==0));
latTooShort = sum((matIncor(:,end-1)==1));
latTooLong = sum((matIncor(:,end)==1));

fprintf(1,'\n\n\tIncorrect fixation trials  = %3.0f (%1.2f)',incorFix,incorFix/expDes.incorTrial);
fprintf(1,'  \n\tSaccade stayed in fixation = %3.0f (%1.2f)',sacStay,sacStay/expDes.incorTrial);
fprintf(1,'  \n\tInaccurate end of saccade  = %3.0f (%1.2f)',sacInac,sacInac/expDes.incorTrial);
fprintf(1,'  \n\tSaccade do not stay 50 ms  = %3.0f (%1.2f)',sacDurIn,sacDurIn/expDes.incorTrial);
fprintf(1,'  \n\tSac latency too short      = %3.0f (%1.2f)',latTooShort,latTooShort/expDes.incorTrial);
fprintf(1,'  \n\tSac latency too long       = %3.0f (%1.2f)',latTooLong,latTooLong/expDes.incorTrial);


end