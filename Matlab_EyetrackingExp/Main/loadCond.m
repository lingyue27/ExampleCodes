function [ cond, condtxt ] = loadCond( subjIdNum, currrentBlock )
%% loadCond - Function loads the necessary condition from the lookup table. 
%  We counterbalance the order of all conditions in our experiment. 
% ----------------------------------------------------------------------
%
% ----------------------------------------------------------------------
% Input(s) :
% subjIdNum = Subject number that is asked at the beginning of the
% experiment (cf. const.sjct_NumId in sbjConfig.m)
%
% currrentBlock = Block to run, const.FromBlock
% ----------------------------------------------------------------------
% Output(s):
% my_key : structure containing keyboard settings
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........15 | 07 | 2019
% Project.....................CHIB
% Version........................4
% ----------------------------------------------------------------------

% Load lookup table and put in variable
lookuptable = cell2mat(struct2cell(load('lookuptab2.mat')));

% Define the condition to run
cond = lookuptable(subjIdNum, currrentBlock);

if cond == 1
    condtxt = 'Sacccade 2000';
elseif cond == 2
    condtxt = 'Sacaccade 0';
elseif cond == 3
    condtxt = 'Fixation 2000';
elseif cond == 4
    condtxt = 'Fixation 0';
end