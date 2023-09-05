function instructionsIm(scr,aud,const,my_key,nameImage,exitFlag)
% ----------------------------------------------------------------------
% instructionsIm(scr,aud,const,my_key,text,button,exitFlag)
% ----------------------------------------------------------------------
% Goal of the function :
% Display instructions draw in .png file.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen settings
% aud : struct containing audio settings
% const : struct containing constant settings
% nameImage : name of the file image to display
% exitFlag : if = 1 (quit after 3 sec)
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 26 / 12 / 2016
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

while KbCheck(-1); end
KbName('UnifyKeyNames');

dirImageFile = 'Instructions/Image/';
dirImage = [dirImageFile,nameImage,'.png'];
[imageToDraw,~,alpha] =  imread(dirImage);
imageToDraw(:,:,4) = alpha;

t_handle = Screen('MakeTexture',scr.main,imageToDraw);
texrect = Screen('Rect', t_handle);
push_button = 0;

t0 = GetSecs;
tEnd = 3;
while ~push_button;
    
    FlushEvents ;
    Screen('FillRect',scr.main,const.colBG);
    Screen('DrawTexture',scr.main,t_handle,texrect,[0,0,scr.scr_sizeX,scr.scr_sizeY]);
    t1 = Screen('Flip',scr.main);
    
    if exitFlag
        if t1 - t0 > tEnd;
            push_button=1;
        end
    end
    
    [keyIsDown, ~, keyCode] = KbCheck(-1);
    if keyIsDown
        if (keyCode(my_key.escape)) && ~const.expStart
            overDone(aud,const,[]);
        elseif keyCode(my_key.space)
            push_button=1;
        end
    end
end

Screen('Close',t_handle);
end