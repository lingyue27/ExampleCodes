function drawTrialInfoEL(scr,const,expDes,el,t)
% ----------------------------------------------------------------------
% drawTrialInfoEL(scr,const,expDes,el,t)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a box on the eyelink display.
% Modified for the fixation task
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% const : struct containing constant settings
% expDes : struct containing design settings
% el : struct containing eyelink settings
% t : trial meter
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Last update :   08 | 10 | 2019
% Project :                 CHIB
% Version :                    6
% ----------------------------------------------------------------------

% Define colors
% -------------
stimFrmCol      = el.obj_white;
stimCol         = el.obj_dark_red;
boundaryCol     = el.obj_pink;
dotCol          = el.obj_dark_blue;

% Clear screen
% -------------
eyeLinkClearScreen(el.bgCol)

% Define design
% -------------
bloc1 = expDes.expMat(t,3);

% Rand5
rand5  = expDes.expMat(t,7);
if bloc1 == 1 || bloc1 == 2
    fixPos = const.fixPos;
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
            fixPos = const.leftSacCtrUp;
        case 2
            fixPos = const.rightSacCtrUp;
        case 3
            fixPos = const.leftSacCtrDown;
        case 4
            fixPos= const.rightSacCtrDown;
    end
    tarPos = fixPos;
end

% Condition
cond = const.mainCond;
if cond == 1
    condtxt = 'Sac2000';
elseif cond == 2
    condtxt = 'Sac_0';
elseif cond == 3
    condtxt = 'Fix2000';
elseif cond == 4
    condtxt = 'Fix_0';
end

% Saccade boundaries
radAft = const.boundRadAft;
radBef = const.boundRadBef;

% Draw Stimuli
% ------------
if bloc1 == 1 || bloc1 == 2
    % Ref + Probe position left
    eyeLinkDrawBox(tarPosL(1),tarPosL(2), const.stimSizeX_pix,const.stimSizeY_pix,3,stimFrmCol,stimCol);
    eyeLinkDrawBox(tarPosL(1),tarPosL(2),10,10,2,stimFrmCol,dotCol);
    
    % Saccade target & boundary left
    eyeLinkDrawBox(tarPosL(1),tarPosL(2),const.stimSizeX_pix,const.stimSizeY_pix,2,stimFrmCol,dotCol);
    eyeLinkDrawBox(tarPosL(1),tarPosL(2),radAft*2,radAft*2,1,boundaryCol,1);
    
    % Ref + Probe position right
    eyeLinkDrawBox(tarPosR(1),tarPosR(2), const.stimSizeX_pix,const.stimSizeY_pix,3,stimFrmCol,stimCol);
    eyeLinkDrawBox(tarPosR(1),tarPosR(2),10,10,2,stimFrmCol,dotCol);
    
    % Saccade target & boundary right
    eyeLinkDrawBox(tarPosR(1),tarPosR(2),const.stimSizeX_pix,const.stimSizeY_pix,2,stimFrmCol,dotCol);
    eyeLinkDrawBox(tarPosR(1),tarPosR(2),radAft*2,radAft*2,1,boundaryCol,1);

elseif bloc1 == 3 || bloc1 == 4
    % Ref + Probe position
    eyeLinkDrawBox(tarPos(1),tarPos(2), const.stimSizeX_pix,const.stimSizeY_pix,3,stimFrmCol,stimCol);
    eyeLinkDrawBox(tarPos(1),tarPos(2),10,10,2,stimFrmCol,dotCol);
    
    % Saccade target & boundary
    eyeLinkDrawBox(tarPos(1),tarPos(2),const.stimSizeX_pix,const.stimSizeY_pix,2,stimFrmCol,dotCol);
    eyeLinkDrawBox(tarPos(1),tarPos(2),radAft*2,radAft*2,1,boundaryCol,1);    
end

% Fixation target & boundary
eyeLinkDrawBox(fixPos(1),fixPos(2),const.fixRad*2,const.fixRad*2,2,stimFrmCol,dotCol);
eyeLinkDrawBox(fixPos(1),fixPos(2),radBef*2,radBef*2,1,boundaryCol,1);

% Draw trial informations
% -----------------------
corT   = expDes.corTrial;
incorT = expDes.incorTrial;
remT   = expDes.iniEndJ - expDes.corTrial;
 
text0 = sprintf('%s | S# %2.0f | tCor=%3.0f | tInc= %3.0f | tRem=%3.0f ',condtxt, const.sjct_numId ,corT, incorT, remT);
eyeLinkDrawText(scr.x_mid,scr.scr_sizeY - 30,el.txtCol,text0);

WaitSecs(0.1);
end