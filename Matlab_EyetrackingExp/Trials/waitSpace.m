function waitSpace(scr,aud,const,my_key,t,expDes)
% ----------------------------------------------------------------------
% waitSpace(scr,aud,const,my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Wait at the beggining of the experiment and after each break that the
% participant press the space bar while fixating to start the trial.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% aud : struct containing audio settings
% const : struct containing constant settings
% my_key : structure containing keyboard settings
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Original script by Martin SZINTE             
% Updated :         21 | 07 | 2018
% Project :                   IBCH
% Version :                    1.0
% ----------------------------------------------------------------------

while KbCheck(-1); end
FlushEvents('KeyDown');

% Button flag
key_press.space         = 0;
key_press.escape        = 0;
key_press.push_button   = 0;

% Keyboard checking :
if const.eyeMvt && ~const.TEST
    Eyelink('message','EVENT_PRESS_SPACE');
end

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

while ~key_press.push_button
    
    Screen('FillRect',scr.main,const.colBG);

    % Fixation point
    my_circle(scr.main, const.colFixExp, fixPos(1), fixPos(2)    ,const.fixExp );
    Screen('Flip',scr.main);
     
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if ~key_press.push_button
            if (keyCode(my_key.escape)) && ~const.expStart
                overDone(aud,const,[]);
            elseif (keyCode(my_key.space))
                key_press.space = 1;
                key_press.push_button = 1;
            end
        end
    end
end

end