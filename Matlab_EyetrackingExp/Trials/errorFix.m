function errorFix(scr,aud,const,my_key,vid,t,expDes)
% ----------------------------------------------------------------------
% errorFix(scr,const,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Blank stimuli and display three red circle around the fixation
% target to invite subject to refixate.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% aud : struct containing audio settings
% const : struct containing constant settings
% my_key : structure containing keyboard settings
% vid : demo video settings
% ----------------------------------------------------------------------
% Output(s):
% none
%----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........18 | 07 | 2019
% Project.....................CHIB
% Version........................4
% ----------------------------------------------------------------------

if const.eyeMvt && ~const.TEST;Eyelink('message','EVENT_ERROR_FIX');end
key_press.push_button = 0;

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

for nbf = 1:const.errorFixNbFrmMax
    
    Screen('FillRect',scr.main, const.colBG)
    
    if nbf >= const.errFixCircle1frmStart && nbf <= const.errFixCircle1frmEnd
        my_circle(scr.main,const.colErrFix,fixPos(1),fixPos(2),const.errfixOutRad1);
        my_circle(scr.main,const.colBG,fixPos(1),fixPos(2),const.errfixInRad1);
        
    elseif nbf >= const.errFixCircle2frmStart && nbf <= const.errFixCircle2frmEnd        
        my_circle(scr.main,const.colErrFix,fixPos(1),fixPos(2),const.errfixOutRad2);
        my_circle(scr.main,const.colBG,fixPos(1),fixPos(2),const.errfixInRad2);

    elseif nbf >= const.errFixCircle3frmStart && nbf <= const.errFixCircle3frmEnd
        my_circle(scr.main,const.colErrFix,fixPos(1),fixPos(2),const.errfixOutRad3);
        my_circle(scr.main,const.colBG,fixPos(1),fixPos(2),const.errfixInRad3);
    end

    my_circle(scr.main, const.colFixExp, fixPos(1),fixPos(2),const.fixExp);
    Screen('Flip',scr.main);
    
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if ~key_press.push_button
            if (keyCode(my_key.escape)) && ~const.expStart
                overDone(aud,const,vid)
                WaitSecs(const.iti);
            end
        end
    end
end

end
    