function [resMat,vid,expDes,eyeCrit]=runSingleTrial(scr,aud,const,expDes,my_key,t,vid)
% ----------------------------------------------------------------------
% [resMat,vid,expDes,eyeCrit]=runSingleTrial(scr,aud,const,expDes,my_key,t,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Main file of the experiment, interaction between eye-tracker and
% display. Draw each sequence and return results.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% aud : struct containing audio settings
% const : struct containing constant settings
% expDes : struct containing design settings
% my_key : structure containing keyboard settings
% t : trial meter
% vid : demo video settings
% ----------------------------------------------------------------------
% Output(s):
% resMat     : experimental results
% resMat(1)  : presence reported (1 = Present;   2 = Absent;   -2 = NONE)
% resMat(2)  : correctness of answer  (1 = COR;  0 = INCOR; -2 = NONE)
% resMat(3)  : gaze check (1 = SAC/FIX COR; 0 = SAC/FIX INCO -1 = FIX BREAK)
% vid        : structure of the video if demo mode activated
% expDes     : struct containing design settings
% eyeCrit(1) : saccade get out fixation boundary
% eyeCrit(2) : saccade get in saccade boundary
% eyeCrit(3) : saccade stayed at least 50 msec in saccade boundary
% eyeCrit(4) : saccade latency too short
% eyeCrit(5) : saccade latency too long
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated :         07 | 10 | 2019
% Project :                   CHIB
% Version :                      6
% ----------------------------------------------------------------------
% Keyboard settings
% -----------------
while KbCheck(-1); end
FlushEvents('KeyDown');

% Gaze settings
% -------------
radBef = const.boundRadBef;
radAft = const.boundRadAft;
fixPos = const.fixPos;

% Compute and simplify var and rand
% ---------------------------------
if const.checkTrial && ~const.expStart
    fprintf(1,'\n\n\t========================  TRIAL %3.0f ========================\n',t);
end

% Rand 1 : Task type
bloc1 = expDes.expMat(t,3);
bloc1Txt = {'Sac2000','Sac0','Fix2000','Fix0'};
if const.checkTrial && ~const.expStart
    fprintf(1,'\n\tTest condition = \t\t%s',bloc1Txt{bloc1});
end

% Rand 4 : Change in the duration of the target
rand4 = expDes.expMat(t,6);

% Rand 5 : Positions of the targets
rand5  = expDes.expMat(t,7);
if bloc1 == 1 || bloc1 == 2
    switch rand5
        case 1
            tarPosL = const.leftSacCtrUp;
            tarPosR = const.rightSacCtrDown;
        case 2
            tarPosL = const.leftSacCtrUp;
            tarPosR = const.rightSacCtrDown;
        case 3
            tarPosL = const.leftSacCtrDown;
            tarPosR = const.rightSacCtrUp;
        case 4
            tarPosL = const.leftSacCtrDown;
            tarPosR = const.rightSacCtrUp;
    end
elseif bloc1 == 3 || bloc1 == 4
    switch rand5
        case 1
            postTarPos = const.leftSacCtrUp;
        case 2
            postTarPos = const.rightSacCtrUp;
        case 3
            postTarPos = const.leftSacCtrDown;
        case 4
            postTarPos= const.rightSacCtrDown;
    end
    
    fixPos = postTarPos;
    
    if rand5 == 1 || rand5 == 3
        stimDir = 1;
    elseif rand5 == 2 || rand5 == 4
        stimDir = 2;
    end
end

% Testing for the saccade condition dummy
if ~const.expStart
    switch rand5
        case 1
            postTarPos = const.leftSacCtrUp;
        case 2
            postTarPos = const.rightSacCtrDown;
        case 3
            postTarPos = const.leftSacCtrUp;
        case 4
            postTarPos= const.rightSacCtrUp;
    end
    
    if rand5 == 1 || rand5 == 3
        stimDir = 1;
    elseif rand5 == 2 || rand5 == 4
        stimDir = 2;
    end
end

% Define time
% -----------
% Define durations for each event
num_FT      = const.numIniFix + const.cueDurNbf;
num_iStart  = const.StartIntNbf;
num_iOne    = const.OneIntNbf(rand4);
num_iTwo    = const.TwoIntNbf;
num_iThree  = const.ThreeIntNbf;
num_iEnd    = const.EndIntNbf; % let the disk stay a bit longer than the last flash disapear
num_iFlash  = const.FlashIntNbf;
num_iLastFlash = const.LastFlashIntNbf;

% FT
num_FT_start     = 1;
num_FT_end       = num_FT_start + num_FT - 1;
num_FT_greenDely = const.num_FT_greenDely;

if const.eyeMvt && bloc1 == 1 || bloc1 == 2

    % 1st Interval
    num_iStart_start   = -10; 
    num_iStart_end     = -10;
    num_framesMax    = num_FT_end; % this way the stim is not played except if a saccade is made

    % 1st Flash
    num_iOneFlash_start = -10;
    num_iOneFlash_end = -10;
    % 1st Interval
    num_iOne_start   = -10; 
    num_iOne_end     = -10;
    % 2nd Flash
    num_iTwoFlash_start = -10;
    num_iTwoFlash_end = -10;    
    % 2nd Interval
    num_iTwo_start = -10;
    num_iTwo_end   = -10;
    % 3rd Flash
    num_iThreeFlash_start = -10;
    num_iThreeFlash_end = -10;
    % 3rd Interval
    num_iThree_start = -10;
    num_iThree_end   = -10;
    % 4th Flash
    num_iFourFlash_start = -10;
    num_iFourFlash_end = -10;
    % End Interval
    num_iEnd_start = -10;
    num_iEnd_end   = -10;
else
    % Start Interval
    num_iStart_start   = num_FT_end + 1;
    num_iStart_end     = num_iStart_start + num_iStart - 1;    
    % 1st Flash
    num_iOneFlash_start = num_iStart_end +1;
    num_iOneFlash_end = num_iOneFlash_start + num_iFlash - 1;
    % 1st Interval
    num_iOne_start   = num_iOneFlash_end + 1;
    num_iOne_end     = num_iOne_start + num_iOne - 1;
    % 2nd Flash
    num_iTwoFlash_start = num_iOne_end +1;
    num_iTwoFlash_end = num_iTwoFlash_start + num_iFlash - 1;    
    % 2nd Interval
    num_iTwo_start = num_iTwoFlash_end + 1;
    num_iTwo_end   = num_iTwo_start + num_iTwo - 1;
    % 3rd Flash
    num_iThreeFlash_start = num_iTwo_end +1;
    num_iThreeFlash_end = num_iThreeFlash_start + num_iFlash - 1;  
    % 3rd Interval
    num_iThree_start = num_iThreeFlash_end + 1;
    num_iThree_end   = num_iThree_start + num_iThree -1;
    % 4th Flash
    num_iFourFlash_start = num_iThree_end +1;
    num_iFourFlash_end = num_iFourFlash_start + num_iLastFlash - 1;     
    % End Interval
    num_iEnd_start = num_iFourFlash_end + 1;
    num_iEnd_end   = num_iEnd_start + num_iEnd -1;
    
    num_framesMax   =  num_iEnd_end;
end

if const.checkTimeFrm && ~const.expStart
    fprintf(1,'\n\tFT:    \t\t\t\t%i to %i',num_FT_start,num_FT_end);
    fprintf(1,'\n\tREF:   \t\t\t\t%i to %i',num_iOne_start,num_iOne_end);
    fprintf(1,'\n\tPROBE: \t\t\t\t%i to %i\n',num_iTwo_start,num_iTwo_end);
end

% Prepare stimuli
% ---------------
stim_rad = const.stimRad_pix;

% MAIN LOOP
% ---------
boundary.saccadeStart     = 0;
boundary.saccadeEnd       = 0;
boundary.saccadeEndLong   = 0;
boundary.sac_1            = 0;
boundary.sac_2            = 0;
boundary.latencyTooLong   = 0;
boundary.latencyTooShort  = 0;
boundary.keepFix          = 0;
num_SacOff                = 0;
num_sacOn                 = 0;
eyeCrit                   = [-2,-2,-2,-2,-2];

if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_TRIAL_START');
end

nbf = 0;GetSecs;
timeInCirle = 0;
num_fix_start = 0;

while nbf < num_framesMax
    
    nbf = nbf + 1;
    Screen('FillRect', scr.main, const.colBG)
    
    % Eye data coordinates
    % --------------------
    if const.eyeMvt
        [x,y] = getCoord(scr,const);
    end
    
    % Saccade/Fixation check
    % ----------------------
    if const.eyeMvt
        % Main task with a saccade:
        % Before REF onset
        % Gaze is in circle boundary around FP
        if nbf >= 1 && nbf < num_FT_start
            disp('FixCheckDone')
            if sqrt((x-fixPos(1))^2+(y-fixPos(2))^2)>radBef
                if ~const.TEST
                    Eyelink('message','FIX_BREAK_START');
                end
                resMat = [-2,-2,-1];
                return
            end
            
            % After REF onset
        elseif nbf >= num_FT_start && nbf <= num_framesMax
            % Gaze quits boundary arround FP
            if bloc1 == 1 || bloc1 == 2    % if saccade condition
                if sqrt((x-fixPos(1))^2+(y-fixPos(2))^2)>radBef
                    boundary.saccadeStart = 1;
                    
                    if ~boundary.sac_1
                        if ~const.TEST
                            Eyelink('message','EVENT_ONLINE_SACONSET_BOUND');
                        end
                        boundary.sac_1 = 1;
                        % Compute time for the saccade latency
                        num_sacOn = nbf;
                        % FT
                        num_FT_end = nbf-1;
                    end
                end
                
                % Gaze arrives in boundary arround REF
                if sqrt((x-tarPosL(1))^2+(y-tarPosL(2))^2)<radAft || sqrt((x-tarPosR(1))^2+(y-tarPosR(2))^2)<radAft
                    boundary.saccadeEnd = 1;
                    timeInCirle = timeInCirle + 1;
                    
                    if timeInCirle == const.numInBound
                        boundary.saccadeEndLong = 1;
                        num_fix_start = timeInCirle;
                    end
                    if ~boundary.sac_2
                        if ~const.TEST
                            Eyelink('message','EVENT_ONLINE_SACOFFSET_BOUND');
                        end
                        boundary.sac_2 = 1;
                        num_SacOff = nbf;
                        % re-compute time for the saccade condition                                          
                        
                        % Start Interval
                        num_iStart_start = num_SacOff +1;
                        num_iStart_end = num_iStart_start + num_iStart - 1;
                        
                        % 1st Flash
                        num_iOneFlash_start = num_iStart_end +1;
                        num_iOneFlash_end = num_iOneFlash_start + num_iFlash - 1;
                       
                        % 1st Interval
                        num_iOne_start   = num_iOneFlash_end + 1;
                        num_iOne_end     = num_iOne_start + num_iOne - 1;
                      
                        % 2nd Flash
                        num_iTwoFlash_start = num_iOne_end +1;
                        num_iTwoFlash_end = num_iTwoFlash_start + num_iFlash - 1;    
                       
                        % 2nd Interval
                        num_iTwo_start = num_iTwoFlash_end + 1;
                        num_iTwo_end   = num_iTwo_start + num_iTwo - 1;
                       
                        % 3rd Flash
                        num_iThreeFlash_start = num_iTwo_end +1;
                        num_iThreeFlash_end = num_iThreeFlash_start + num_iFlash - 1;  
                       
                        % 3rd Interval
                        num_iThree_start = num_iThreeFlash_end + 1;
                        num_iThree_end   = num_iThree_start + num_iThree -1;
                       
                        % 4th Flash
                        num_iFourFlash_start = num_iThree_end +1;
                        num_iFourFlash_end = num_iFourFlash_start + num_iLastFlash - 1;     
                        
                        % End Interval
                        num_iEnd_start = num_iFourFlash_end + 1;
                        num_iEnd_end   = num_iEnd_start + num_iEnd -1;
                        
                        num_framesMax   = num_iEnd_end + 1 ;
                    end
                end
                % Wybierz ktory bodziec wyswietlic
                if x < fixPos(1)
                    postTarPos = tarPosL;
                    stimDir = 1;
                elseif x > fixPos(1)
                    postTarPos = tarPosR;
                    stimDir = 2;
                end
            elseif bloc1 == 3 || bloc1 == 4      % if fixation condition
                if sqrt((x-fixPos(1))^2+(y-fixPos(2))^2)>radBef % In case there is an eye movement (unwanted)
                    my_sound(13,aud);
                    resMat = [-2,-2,-1,stimDir];
                    boundary.saccadeStart = 1;
                    WaitSecs(0.5) % wait 500ms before restarting next trial
                    disp('I waited for 0.5 seconds')
                    return
                else
                    boundary.saccadeStart = 0;
                end
            end
            
        end
        
    end
    
    % Stimulus Presentation:
    % ----------------------
    Screen('TextSize', scr.main, const.cue_size);
    % Fixation point ------------------------------------------------------
    if nbf >= num_FT_start && nbf <= num_FT_end;
        % FP Saccade Cue
        if bloc1 == 1 || bloc1 == 2
            my_circle(scr.main, const.colFixExp, fixPos(1), fixPos(2), const.fixExp);
            my_circle(scr.main, const.colFixExp, tarPosR(1), tarPosR(2), const.fixExp);
            my_circle(scr.main, const.colFixExp, tarPosL(1), tarPosL(2), const.fixExp);
            
            my_circle(scr.main, const.colCue, tarPosL(1), tarPosL(2), stim_rad);
            my_circle(scr.main, const.colCue, tarPosR(1), tarPosR(2), stim_rad);
            
            % Add fixation dots inside the targets
            my_circle(scr.main, const.postFix , tarPosR(1), tarPosR(2), const.fixExp);
            my_circle(scr.main, const.postFix , tarPosL(1), tarPosL(2), const.fixExp);
            
        elseif bloc1 == 3 || bloc1 == 4
            my_circle(scr.main, const.postFix, postTarPos(1), postTarPos(2), const.fixExp);
            my_circle(scr.main, const.green,   postTarPos(1), postTarPos(2), const.fixExp);
        end
        
        if nbf >= num_FT_start + num_FT_greenDely && nbf <= num_FT_end;     % make the FP green after a delay of 1sec, this is the go signal for saccade exacution.
            my_circle(scr.main, const.green, fixPos(1), fixPos(2), const.fixExp);
            % FP
            my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad); % add white circle earlier
            my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);       
        end
        
    end
    
    % Check the timing DELEATE / COMMENT AFTER!!!
%      if nbf == num_iOne_start
%          tic
%      elseif nbf == num_iOne_end
%          toc
%          One_dur = (num_iOne_end - num_iOne_start)*scr.frame_duration
%      end
%      
%      if nbf == num_iThree_start
%          tic
%      elseif nbf == num_iThree_end
%          toc
%          Three_dur = (num_iThree_end - num_iThree_start)*scr.frame_duration
%      end
     

    % Start Interval --------------------------------------------------------
    if nbf >= num_iStart_start && nbf <= num_iStart_end
        % FP
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        % Add fixation dots inside the targets
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
    end
    % 1st Flash --------------------------------------------------------
    if nbf >= num_iOneFlash_start && nbf <= num_iOneFlash_end
        my_circle(scr.main, const.Flash, postTarPos(1), postTarPos(2), stim_rad*1.6); % Ring
        my_circle(scr.main, const.colBG , postTarPos(1), postTarPos(2), stim_rad*1.4);        
        % FP
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        % Add fixation dots inside the targets
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
    end 

    % 1st Interval --------------------------------------------------------
    if nbf >= num_iOne_start && nbf <= num_iOne_end
        % FP
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        % Add fixation dots inside the targets
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
    end
    
    % 2nd Flash --------------------------------------------------------
    if nbf >= num_iTwoFlash_start && nbf <= num_iTwoFlash_end
        my_circle(scr.main, const.Flash, postTarPos(1), postTarPos(2), stim_rad*1.6); % Ring
        my_circle(scr.main, const.colBG , postTarPos(1), postTarPos(2), stim_rad*1.4);        
        % FP
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        % Add fixation dots inside the targets
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
    end     
    
    % 2nd Interval --------------------------------------------------------
    if nbf >= num_iTwo_start && nbf <= num_iTwo_end
        % FP
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        %my_circle(scr.main, const.red, postTarPos(1), postTarPos(2), stim_rad);        
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
    end
    
    % 3rd Flash --------------------------------------------------------
    if nbf >= num_iThreeFlash_start && nbf <= num_iThreeFlash_end
        my_circle(scr.main, const.Flash, postTarPos(1), postTarPos(2), stim_rad*1.6); % Ring
        my_circle(scr.main, const.colBG , postTarPos(1), postTarPos(2), stim_rad*1.4);        
        % FP
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        % Add fixation dots inside the targets
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
    end  
    
    % 3rd Interval --------------------------------------------------------
   if nbf >= num_iThree_start && nbf <= num_iThree_end
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        % Add fixation dots inside the targets
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
   end
    
    % 4th Flash --------------------------------------------------------
    if nbf >= num_iFourFlash_start && nbf <= num_iFourFlash_end
        my_circle(scr.main, const.Flash, postTarPos(1), postTarPos(2), stim_rad*1.6); % Ring
        my_circle(scr.main, const.colBG , postTarPos(1), postTarPos(2), stim_rad*1.4);        
        % FP
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        % Add fixation dots inside the targets
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
    end 
    
    % End Interval --------------------------------------------------------
    if nbf >= num_iEnd_start && nbf <= num_iEnd_end
        my_circle(scr.main, const.col1Int, postTarPos(1), postTarPos(2), stim_rad);
        %my_circle(scr.main, const.green, postTarPos(1), postTarPos(2), stim_rad);        
        % Add fixation dots inside the targets
        my_circle(scr.main, const.postFix , postTarPos(1), postTarPos(2), const.fixExp);
    end
    
    % Eyelink messages
    if const.eyeMvt
        if nbf == num_FT_start;      Eyelink('message','FT_START');                 end
        if nbf == num_FT_start+num_FT_greenDely; Eyelink('message','FT_GREEN');     end
        if nbf == num_FT_end+1;      Eyelink('message','FT_END');                   end
        if nbf == num_iOne_start;    Eyelink('message','IONE_START');               end
        if nbf == num_iOne_end+1;    Eyelink('message','IONE_END');                 end
        if nbf == num_iTwo_start;    Eyelink('message','ITWO_START');               end
        if nbf == num_iTwo_end+1;    Eyelink('message','ITWO_END');                 end
        if nbf == num_iThree_start;  Eyelink('message','ITHREE_START');             end
        if nbf == num_iThree_end;    Eyelink('message','ITHREE_END');               end
        if nbf == num_iEnd_start;    Eyelink('message','IEND_START');               end
        if nbf == num_iEnd_end;      Eyelink('message','IEND_END');                 end
        if nbf == num_iOneFlash_start;    Eyelink('message','INT_ONEFlash_START');     disp('1_SF');    end
        if nbf == num_iOneFlash_end+1;    Eyelink('message','INT_ONEFlash_END');       disp('1_EF');    end
        if nbf == num_iTwoFlash_start;    Eyelink('message','INT_TWOFlash_START');     disp('2_SF');    end
        if nbf == num_iTwoFlash_end+1;    Eyelink('message','INT_TWOFlash_END');       disp('2_EF');    end
        if nbf == num_iThreeFlash_start;  Eyelink('message','INT_THREEFlash_START');   disp('3_SF');    end
        if nbf == num_iThreeFlash_end+1;  Eyelink('message','INT_THREEFlash_END');     disp('3_EF');    end
        if nbf == num_iFourFlash_start;  Eyelink('message','INT_FOURFlash_START');     disp('4_SF');    end
        if nbf == num_iFourFlash_end+1;  Eyelink('message','INT_FOURFlash_END');       disp('4_EF');    end
        % Because the last stimulus is presented for one more loop/frame,
        % the last trigger is after the next flip (outside of the loop)
    end
    % Flip
    Screen('Flip',scr.main);  
end

% Flip To Blank the screen as soon as outside of the loop and wait before
% the response.
Screen('Flip',scr.main); 
% WaitSecs(0.5); have end interval instead of it

% Results and Output
% ------------------
if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_GET_ANSWER');
end

% Check saccade latency
% ---------------------
if bloc1 == 1
    sacLat_online =  num_SacOff - num_FT_start + num_FT_greenDely;
    if (sacLat_online >= const.num_maxLatency)
        boundary.latencyTooLong = 1;
    end
    if (sacLat_online <= const.num_minLatency)
        boundary.latencyTooShort = 1;
    end
end

% Online check Ss waited for the FP to turn green
% -----------------------------------------------
if const.expStart && bloc1 == 1 || bloc1 == 2
    if num_sacOn +1 < num_FT_start + num_FT_greenDely
        boundary.latencyTooShort = 1;
        my_sound(13,aud);
        stimDir = 0;
        resMat = [-2,-2,-1, stimDir];
    else
        boundary.latencyTooShort  = 0;
    end
end

% Check fixation duration in saccade conditions
% ---------------------------------------------
if const.expStart && bloc1 == 1 || bloc1 == 2
    num_keepFix = num_iThree_end - (num_iOne_start+num_fix_start);
    if num_keepFix > timeInCirle
        boundary.keepFix = 0;
    else
        boundary.keepFix = 1;
    end
end

% getAnswer
% ---------------------------------------------
[key_press,vid] = getAnswer(scr,aud,const,expDes,t, my_key,vid,boundary);
if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_ANSWER');
end

%  Define if eyeOK
% ---------------------------------------------
if const.eyeMvt && bloc1 == 1 || bloc1 == 2
    if boundary.saccadeStart && boundary.saccadeEnd && boundary.saccadeEndLong && ~boundary.latencyTooShort && ~boundary.latencyTooLong && boundary.keepFix;
        eyeOK = 1;
    else
        eyeOK = 0;
    end
elseif const.eyeMvt && bloc1 == 3 || bloc1 == 4
    if boundary.saccadeStart == 1
        eyeOK = 0;
    else
        eyeOK = 1;
    end
else
    eyeOK = 1;
end

eyeCrit = [ boundary.saccadeStart,...
    boundary.saccadeEnd,...
    boundary.latencyTooShort,...
    boundary.saccadeEndLong,...
    boundary.latencyTooLong    ];

% Code the response
% -----------------
if rand4 == 1                           % if second longer
    if key_press.leftArrow;
        resMat = [1,0,eyeOK, stimDir];  % Response:Left = First was longer
    elseif key_press.rightArrow
        resMat = [2,1,eyeOK, stimDir];  % Response:Right = Second was longer
    elseif key_press.escape == 1
        resMat = [-2,-2,eyeOK, stimDir];
        overDone(aud,const,vid);
    end
elseif rand4 == 2                       % if first longer
    if key_press.leftArrow;
        resMat = [1,1,eyeOK, stimDir];  % Response:Left = First was longer
    elseif key_press.rightArrow
        resMat = [2,0,eyeOK, stimDir];  % Response:Right = Second was longer
    elseif key_press.escape == 1
        resMat = [-2,-2,eyeOK, stimDir];
        overDone(aud,const,vid);
    end
end

% Provide Feedback
% ----------------
if const.feedbackTr == 1 && resMat(2) == 0
    my_sound(12,aud);
end

% ITI
% Insert an ITI at the end of each trial
Screen('Flip',scr.main);
WaitSecs(const.iti);
end