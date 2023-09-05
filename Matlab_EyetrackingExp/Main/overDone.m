function overDone(aud,const,vid)
% ----------------------------------------------------------------------
% overDone(aud,const,vid)
% ----------------------------------------------------------------------
% Goal of the function :
% Close screen and check transfer of eye-link data to eye-link file.
% ----------------------------------------------------------------------
% Input(s) :
% aud : struct containing audio settings
% const : struct containing constant settings
% vid : demo video settings
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........08 | 10 | 2019
% Project.....................CHIB
% Version........................6
% ----------------------------------------------------------------------

% Transfer .edf file
% ------------------
if const.eyeMvt && ~const.TEST 
    statRecFile = Eyelink('ReceiveFile',const.eyelink_temp_file,const.eyelink_temp_file);
    
    if statRecFile ~= 0
        fprintf(1,'\n\tEyelink EDF file correctly transfered');
    else
        fprintf(1,'\n\Error in Eyelink EDF file transfer');
        statRecFile2 = Eyelink('ReceiveFile',const.eyelink_temp_file,const.eyelink_temp_file);
        if statRecFile2 == 0
            fprintf(1,'\n\tEyelink EDF file is now correctly transfered');
        else
            fprintf(1,'\n\n\t!!!!! Error in Eyelink EDF file transfer !!!!!');
            my_sound(9,aud);
        end
    end
end

% Close link with eye tracker
% ---------------------------
if const.eyeMvt && ~const.TEST 
    Eyelink('CloseFile');
    WaitSecs(2.0);
    Eyelink('Shutdown');
    WaitSecs(2.0);
end

% Rename eye tracker file
% -----------------------
if const.eyeMvt && ~const.TEST 
    oldDir = const.eyelink_temp_file;
    newDir = const.eyelink_local_file;
    movefile(oldDir,newDir);
end

% Close Psychtoolbox screen
% -------------------------
ListenChar(1);ShowCursor;
Screen('CloseAll');

% Print block duration
% --------------------
timeDur=toc/60;
fprintf(1,'\n\n\tThis part of the experiment took : %2.0f min.\n\n',timeDur);

% Make video
% ----------
if const.mkVideo
    makeVideo(vid);
end

end