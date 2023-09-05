function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........07 | 10 | 2019
% Project.....................CHIB
% Version........................6
% ----------------------------------------------------------------------

% Define directory
% ----------------
if ~isdir(sprintf('Data/%s',const.sjct));
    mkdir(sprintf('Data/%s',const.sjct));
end

if const.expStart
    const.expDir = sprintf('Data/%s/ExpData/B%i',const.sjct,const.fromBlock);
    if ~isdir(const.expDir) || strcmp(const.sjct,'DEMO');
        mkdir(const.expDir);
    else
        aswErase = input('\n This file allready exist, do you want to erase it ? (Y or N)    ','s');
        if upper(aswErase) == 'N'
            error('Please restart the program with correct input.')
        elseif upper(aswErase) == 'Y'
        else
            error('Incorrect input => Please restart the program with correct input.')
        end
    end
else
    const.c = clock;
    const.expDir = sprintf('Data/%s/DebugData/%i-%i_trials/',const.sjct,const.c(2),const.c(3));
    if ~isdir(const.expDir);
        mkdir(const.expDir);
    end
end

% Define saving files
% -------------------
const.exp_fileMat =         sprintf('%s/expRes_%s_B%i.mat',const.expDir,const.sjct,const.fromBlock);
const.eyelink_temp_file =   'XX.edf';
const.eyelink_local_file =  sprintf('%s/%s_B%i.edf',const.expDir,const.sjct,const.fromBlock);

end