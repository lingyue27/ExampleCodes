function [const] = sbjConfig(const)
% ----------------------------------------------------------------------
% [const] = sbjConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Take subject and block configuration.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........15 | 07 | 2019
% Project.....................CHIB
% Version........................4
% ----------------------------------------------------------------------

if const.expStart
    const.sjct =  upper(strtrim(input(sprintf('\n\tInitials: '),'s')));
    
    if ~const.TEST && const.eyeMvt && ~strcmp(const.sjct,'DEMO');
        const.sjct_DomEye = upper(strtrim(input(sprintf('\n\tRecorded Eye (R or L): '),'s')));
        if strcmp(const.sjct_DomEye,'L')
            const.recEye = 1;
        elseif strcmp(const.sjct_DomEye,'R')
            const.recEye = 2;
        else
            error('Restart and please enter a correct value (L or R).');
        end
    else
        const.sjct_DomEye='DM';
        const.recEye = 2;
    end
    
    
    firstRes = 0;
    for tB = 1:const.numBlockMainTot
        resExist = exist(sprintf('Data/%s/ExpData/B%i/%s_B%i.edf',const.sjct, tB, const.sjct,tB));
        if resExist == 0 && ~firstRes
            firstRes =1;
            const.fromBlock = tB;
        end
    end
    
    
    if const.fromBlock == 1 && ~strcmp(const.sjct,'DEMO'); % if it is the first block, assign a subject number, get age and sex.
        sum_fold = dir('Data/');
        const.sjct_numId = sum([sum_fold(~ismember({sum_fold.name},{'.','..'})).isdir]);
        if const.sjct_numId == 0; const.sjct_numId = 1;end
        const.sjct_age = input(sprintf('\n\tAge: '));
        const.sjct_gender = upper(strtrim(input(sprintf('\n\tSex (M or F): '),'s')));
        
    elseif const.fromBlock ~= 1
        b1 = 1;
        firstBlock = load(sprintf('Data/%s/ExpData/B%i/expRes_%s_B%i.mat',const.sjct, b1, const.sjct,b1));
        const.sjct_numId = firstBlock.config.const.sjct_numId;
        clear firstBlock;
    else
        const.sjct_age = 'XX';
        const.sjct_gender = 'X';
    end
    
    [const.mainCond, condtxt ] = loadCond(const.sjct_numId, const.fromBlock);  % Load the block type to run
    fprintf(1, '\n\tFrom Block Nb : %i\n', const.fromBlock);
    fprintf(1, '\n\tCondition  ID : %i\n', const.mainCond);
    fprintf(1,['\n\tCondition type: ' condtxt '\n']);
    
else
    const.sjct = 'Anon';
    const.sjct_age = 'XX';
    const.sjct_gender = 'X';
    const.sjct_DomEye = 'TM';
    const.recEye  = 2;
    
    const.fromBlock  = 1;
    fprintf(1,'\n\tFrom Block nb: 1\n\n');
end

end