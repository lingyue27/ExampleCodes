function all_obs_analysis(indiv,eyeAna)
% ----------------------------------------------------------------------
% all_obs_analysis(indiv,eyeAna)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute automaticaly results for all participants
% ----------------------------------------------------------------------
% Input(s) :
% indiv: do individual analysis     0 = NO,     1 = YES
% eyeAna = if individual analysis neeeded, do eye analysis (1) or not (0)
%
% e.g. all_obs_analysis(1,1)
%      all_obs_analysis(0,0)
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Original script by Martin SZINTE
% Update............05 | 04 | 2018
% Project.............Checkerboard
% Version........................5
% ----------------------------------------------------------------------

% Participant list
% ----------------
sub.iniAll          = { 'AS' 'BB' 'BZ' 'CB' 'CF' 'CS' 'EB' 'ET' 'FD' 'FS' 'JK' 'LLM' 'MAK' 'MH' 'PF' };
sub.block           = [  4    4    4    4    4    4    4    4     4    4    4    4    4     4    4   ];

% Initial settings
% ----------------
warning('off','all');
sub.ini             = 'ALL';
sub.task        	= 'MAIN';
sub.num             = size(sub.iniAll,2);
sub.expName         = 'CHIB';
sub.dir             = (which('all_obs_analysis'));
sub.dir             = sub.dir(1:end-25);
sub.all_blockDir    = sprintf('%s/Data/%s/ExpData/AllB',sub.dir,sub.ini);    if ~isdir(sub.all_blockDir);mkdir(sub.all_blockDir);end
sub.all_indivDir    = sprintf('%s/Data/%s/ExpData/Indiv',sub.dir,sub.ini);   if ~isdir(sub.all_indivDir);mkdir(sub.all_indivDir);end


% Change directory and path
% -------------------------
cd(sub.dir);
addpath(genpath('../V5/')); 

% Individual analysis
% -------------------
if indiv
    for numSjct = 1:size(sub.iniAll,2)
        fprintf('\n\n\t%s analysis IN PROGRESS...\n',sub.iniAll{numSjct});
        all_analysis(sub.iniAll{numSjct},'MAIN',sub.block(numSjct),eyeAna)
    end
end