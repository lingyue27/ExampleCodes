function [key_press,vid] = getAnswer(scr,aud,const,expDes,t,my_key,vid,boundary)
% ----------------------------------------------------------------------
% [key_press,vid] = getAnswer(scr,aud,const,expDes,my_key,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Check keyboard press, and return flags.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% aud : struct containing audio settings
% const : struct containing constant settings
% expDes : struct containing design settings
% my_key : structure containing keyboard settings
% vid : demo video settings
% boundary : saccade boundary
% ----------------------------------------------------------------------
% Output(s):
% key_press : struct containing key answer.
% tRT : reaction time
% vid : video structure if demo mode activated
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Original script by Martin SZINTE             (martin.szinte@gmail.com)
% Updated...........08 | 10 | 2019
% Project.....................CH1B
% Version........................6
% ----------------------------------------------------------------------

% Button flag
% -----------
key_press.upArrow	    = 0;
key_press.downArrow     = 0;
key_press.rightArrow	= 0;
key_press.leftArrow     = 0;
key_press.push_button   = 0;
timeRep                 = 0;


% Rand 1 : Task type
% ------------------
bloc1 = expDes.expMat(t,3);

% Rand 3 : Condition IB, CH
% -------------------------
rand3 = expDes.expMat(t,5);

while ~key_press.push_button
    
    % Choose the right message for the end
%     if mod(const.sjct_numId,2) == 1
%         end_msg = ('Which interval lasted longer?\n\nRED            GREEN\n\n\n\n\n\n(You can blink now...)');
%     else
%         end_msg = ('Which interval lasted longer?\n\nGREEN            RED\n\n\n\n\n\n(You can blink now...)');
%     end
    end_msg = ('Which interval lasted longer?\n\n1st                 2nd\n\n\n\n\n\n(You can blink now...)');
    
    if const.expStart && bloc1 == 1 || bloc1 == 2
        if boundary.saccadeStart == 0
            end_msg = ('Please make an eye movement to the target\n\npress <- or -> to continue...');
        elseif boundary.saccadeEndLong == 0
            end_msg = ('Please make an eye movement to the target\n and continue fixating the target without blinking\n\npress <- or -> to continue...');
        elseif boundary.saccadeStart == 1 && boundary.saccadeEnd == 0
            end_msg = ('Please make an eye movement to the target\n\npress <- or -> to continue...');
        elseif boundary.keepFix == 0 
            end_msg = ('Please continue fixating the target without blinking\n\npress <- or -> to continue...');
        elseif boundary.latencyTooShort == 1
            end_msg = ('Please wait the fixation to turn green to make an eye movement\n\npress <- or -> to continue...');
        end  
    elseif const.expStart && bloc1 == 3 || bloc1 == 4
        if boundary.saccadeStart == 1
            end_msg = ('Please continue fixating the target without blinking\n\npress <- or -> to continue...');
        end
    end
    
    Screen('TextSize', scr.main, const.text_size);
    const.colText = const.gray;
    DrawFormattedText(scr.main, end_msg, 'center', 'center', const.colText);
    Screen('Flip',scr.main);
    
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
        timeRep = timeRep +1;
        if timeRep == expDes.timeRTvid;
            key_press.push_button = 1;
            key_press.leftArrow = 1;
        end
    end
    
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if ~key_press.push_button
            if (keyCode(my_key.escape)) && ~const.expStart
                overDone(aud,const,vid)
            elseif (keyCode(my_key.left))
                key_press.leftArrow = 1;
                key_press.push_button = 1;
            elseif (keyCode(my_key.right))
                key_press.rightArrow = 1;
                key_press.push_button = 1;
            end
        end
    end
end

end