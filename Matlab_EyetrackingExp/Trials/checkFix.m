function [cor,vid] = checkFix(scr,aud,const,my_key,vid,t,expDes)
% ----------------------------------------------------------------------
% [cor,vid] = checkFix(scr,aud,const,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a the fixation target (Green dot with bull-eye), and wait gaze 
% fixation. If gaze fixated then fixation target change his bull-eye
% color and wait 200ms until return a signal (cor) to start the trial.
% Modified for fixation experiment.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% aud : struct containing audio settings
% const : struct containing constant settings
% my_key : structure containing keyboard settings
% vid : demo video settings
% ----------------------------------------------------------------------
% Output(s):
% cor = flag or signal of a right fixation of FP.
% vid : stucture for the demo video mode
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Original script by Martin SZINTE
% Last update : 05 / 12 / 2017
% Project :     WarewolGhost
% Version :     2.0
% ----------------------------------------------------------------------

% Initial configurations
% ----------------------
if const.eyeMvt && ~const.TEST;Eyelink('message', 'EVENT_FIX_CHECK');end
while KbCheck(-1); end
radBef = const.boundRadBef;
timeout = const.timeOut;     % maximum fixation check time
tCorMin = const.tCorMin;     % minimum correct fixation time

rand5  = expDes.expMat(t,7);
if const.mainCond == 1 || const.mainCond == 2
    fixPos = const.fixPos;
elseif const.mainCond == 3 || const.mainCond == 4
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
end

% Check fixation
% --------------

tstart = GetSecs;
cor = 0;
corStart=0;
tCor = 0;
t=tstart;

while ((t-tstart)<timeout && tCor<= tCorMin)
    
    if const.eyeMvt;
        [x,y]=getCoord(scr,const);
    
        if sqrt((x-fixPos(1))^2+(y-fixPos(2))^2) < radBef
            cor = 1;
        else
            cor = 0;
        end
    else
        cor = 1;
    end
    
    Screen('FillRect',scr.main,const.colBG)
    
    % Fixation point and saccade target
    my_circle(scr.main, const.colFixExp,fixPos(1),fixPos(2)    ,const.fixExp);
    Screen(scr.main,'Flip');
    
    if const.mkVideo
        vid.j = vid.j + 1;
        if vid.j <= vid.sparseFile*1
            vid.j1 = vid.j1 + 1;
            vid.imageArray1(:,:,:,vid.j1)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*1 && vid.j <= vid.sparseFile*2
            vid.j2 = vid.j2 + 1;
            vid.imageArray2(:,:,:,vid.j2)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*2 && vid.j <= vid.sparseFile*3
            vid.j3 = vid.j3 + 1;
            vid.imageArray3(:,:,:,vid.j3)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*3 && vid.j <= vid.sparseFile*4
            vid.j4 = vid.j4 + 1;
            vid.imageArray4(:,:,:,vid.j4)=Screen('GetImage', scr.main);
        elseif vid.j > vid.sparseFile*4 && vid.j <= vid.sparseFile*5
            vid.j5 = vid.j5 + 1;
            vid.imageArray5(:,:,:,vid.j5)=Screen('GetImage', scr.main);
        end
    end
    
    if cor == 1 && corStart == 0
        tCorStart = GetSecs;
        corStart = 1;
    elseif cor == 1 && corStart == 1
        tCor = GetSecs-tCorStart;
    else
        corStart = 0;
    end
    t = GetSecs;
    
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if keyCode(my_key.escape)  && ~const.expStart
            overDone(aud,const,vid);
        end
    end
end


end