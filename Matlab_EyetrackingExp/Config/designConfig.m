function [expDes] = designConfig(const)
% ----------------------------------------------------------------------
% [expDes] = designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute an experimental randomised matrix containing all variable data
% used in the experiment.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containing design settings
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........08 | 10 | 2019
% Project.....................CHIB
% Version........................6
% ----------------------------------------------------------------------

% Experimental blocked condition
% ------------------------------
% Rand 1: Test condition 
expDes.oneR = const.mainCond;
% 1 = Saccade
% 2 = Fixation

% Experimental random variables
% -----------------------------
% Rand 2: EMPTY
expDes.twoR = 0;
% 1 = saccade right
% 2 = saccade left

% Rand 3: EMPTY
expDes.threeR = 0;
% 1 = IB condition
% 2 = CH condition

% Rand 4: Temporal Jitter of the stimulus in the either 1st (IB) or 2nd (CH) interval
expDes.fourR = (1:2);
%    0.125
%    0.250
%    0.375
%    0.500
%    0.625
%    0.750
%    0.875

% Rand 5 : Stimulus location configuration
expDes.fiveR = [1,2,3,4];
% 1 = Up both
% 2 = Down both
% 3 = Up left, down right
% 4 = Down left, Up right

% Rand 6 : EMPTY
expDes.sixR = 0;
% 1 = isoluminant
% 2 = non-isoluminant

% Rand 7 : EMPTY
expDes.sevenR = 0;
% 1  =   0 ms
% 2  = 200 ms

% Rand 8 : Fixation duration jitter [36 modalities]
expDes.eightR = 0;
%  1  = 400 ms + 0 screen frame (400 ms)
%  2  = 400 ms + 1 screen frame (408 ms)
% ...
% 36  = 400 ms + 36 screen frame (700 ms)

% Rand 9 : EMPTY
expDes.nineR = 0;
% 1 = change cw
% 2 = change ccw

% Rand 10 : EMPTY
expDes.tenR = 0;
% 1 = gaze in periphery
% 2 = gaze in center

% Experimental settings
% ---------------------
expDes.nb_cond    = 0;
expDes.nb_var     = 0;
expDes.nb_rand    = 10;
expDes.nb_list    = 0;

expDes.nb_trials = 20; % Total number of trials per block
nb_trDatPt = 5;        % Total number of data points per each individual observation in each block
%       Task
% ========================
%      2 time conditions (2000 ms, 0 ms)
%   x  4 saccade directions / fixation positions
%   x  7 probe durations
%   x  2 eye conditions (saccade, fixation)
%   x 20 trials
% =========================
%  = 280 trials
%  = 4 blocks of 140 trials (~15 min each)

% Experimental loop
% -----------------
rng('default');rng('shuffle');

blockT = const.fromBlock;
for t_trial = 1:expDes.nb_trials

    randVal1   = randperm(numel(expDes.oneR));    rand_rand1  = expDes.oneR(randVal1(1));
    randVal2   = randperm(numel(expDes.twoR));    rand_rand2  = expDes.twoR(randVal2(1));
    randVal3   = randperm(numel(expDes.threeR));  rand_rand3  = expDes.threeR(randVal3(1));
    randVal4   = randperm(numel(expDes.fourR));   rand_rand4  = expDes.fourR(randVal4(1));
    randVal5   = randperm(numel(expDes.fiveR));   rand_rand5  = expDes.fiveR(randVal5(1));
    randVal6   = randperm(numel(expDes.sixR));    rand_rand6  = expDes.sixR(randVal6(1));
    randVal7   = randperm(numel(expDes.sevenR));  rand_rand7  = expDes.sevenR(randVal7(1));
    randVal8   = randperm(numel(expDes.eightR));  rand_rand8  = expDes.eightR(randVal8(1));
    randVal9   = randperm(numel(expDes.nineR));   rand_rand9  = expDes.nineR(randVal9(1));
    randVal10  = randperm(numel(expDes.tenR));    rand_rand10 = expDes.tenR(randVal10(1));
    
    expDes.expMat(t_trial,:) = [ blockT,        t_trial,        rand_rand1,    rand_rand2,     rand_rand3...
                                 rand_rand4,    rand_rand5,     rand_rand6,    rand_rand7,     rand_rand8,...
                                 rand_rand9,    rand_rand10,    ];
end

% Replace expMat to have same amount of trials in each condition
% --------------------------------------------------------------
mat = [];
for a = expDes.twoR
    for b = expDes.fourR    
        mat = [mat ; a b];
    end
end
% lookCond = repelem(mat, nb_trDatPt,1);
lookCond = repmat(mat,nb_trDatPt,1);
lookCond = lookCond(randperm(end),:);
sz_block = size(lookCond);
if ~isequal(sz_block(1),  expDes.nb_trials )
    disp('WARNING; THE NUMBER OF TRIALS IS NOT EQUAL!')
    return
end
expDes.expMat(:,4) = lookCond(:,1);
expDes.expMat(:,6) = lookCond(:,2);

end
