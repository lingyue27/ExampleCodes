function [ci,meanCond,ciVal] = within_subjects_CI(matRes,type,numBoot)
% ----------------------------------------------------------------------
% [ci,meanCond,ciVal] = within_subjects_CI(matRes,type,numBoot)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute within subjects confidence interval
% ----------------------------------------------------------------------
% Input(s) :
% matRes: matrix of results
%         => M column (M conditions) by N rows (N subjects)
% type => (1) confidence interval based on SEM
%         (2) confidence interval based on STD of bootstrapped data
%         (3) confidence interval based on percentile of bootstrapped data
%         (4) classical SEM
% numBoot: if type (2) or (3) number of bootstrap iteration
% ----------------------------------------------------------------------
% Output(s):
% ci : confidence interval (row 1 = lower value i.e.  2.5%
%                           row 2 = upper value i.e. 97.5%)
% meanCond: nanmean of each conditions
% ciVal:  confidence interval to add and subtract to he mean
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 27 / 02 / 2016
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

% get data set information
numCond = size(matRes,2);               % determine number of conditions to compare
numSub  = size(matRes,1);               % determine number of subjects
meanAcrossSub = nanmean(matRes,1);      % mean across subjects
meanAcrossCond = nanmean(matRes,2);     % mean across conditions
grandMean = nanmean(meanAcrossCond);    % grand mean (across subjects and conditions)

% Normalize data as Cousineau (2005), subtract subject mean perf. from each
% condition and then add the grand mean, such that the variance and CI do
% not depend on subject effects
matCous = (matRes - repmat(meanAcrossCond,1,size(matRes,2)))+ grandMean;

if type == 1
    studentCumDist = tinv(0.975,numSub-1);  % student's t inverse cumulative distribution function
    
    % from normalized data sem (see Cousineau(2005))
    varCous = var(matCous,0,1);                         % corrected variance of normalized data
    
    % from normalized data sem corrected for the number
    % of within-subject conditions (see Morey(2008))
    varMorey = varCous*(numCond/(numCond-1));           % corrected variance of normalized data corrected for Cousineau bias
    stdMorey = sqrt(varMorey);                          % corrected std of normalized data corrected for Cousineau bias
    semMorey = stdMorey/sqrt(numSub);                   % sem of normalized data corrected for Cousineau bias
    ciSemMorey = semMorey*studentCumDist;               % confidence interval from sem of normalized data corrected for Cousineau bias

    ci = [meanAcrossSub-ciSemMorey;...                  % lower ci values
          meanAcrossSub+ciSemMorey];                    % upper ci values
    
    ciVal = ciSemMorey;                                % ci value to add to mean

elseif type == 2
    studentCumDistBoot = tinv(0.975,numBoot-1);         % student's t inverse cumulative distribution function
    
    % Compute Bootstraped data
    matBootCous  = bootstrap(matCous,numBoot);          % boostrapped matrix from normalized data
    
    varBootCous = var(matBootCous,1,1);                 % uncorrected variance of bootstrapped normalized data (equivalent of above)
    
    varBootMorey = varBootCous*(numCond/(numCond-1));   % uncorrected variance of normalized bootstrapped data corrected for Cousineau bias
    stdBootMorey = sqrt(varBootMorey);                  % corrected std of normalized data corrected for Cousineau bias
    ciBootMorey = stdBootMorey*studentCumDistBoot;      % confidence interval from std of bootstrapped normalized data corrected for Cousineau bias
    
    ci = [meanAcrossSub-ciBootMorey;...                 % lower ci values
          meanAcrossSub+ciBootMorey];                   % upper ci values
    
    ciVal = ciBootMorey;                                % ci value to add to mean
    
elseif type == 3
    matBootCous = bootstrap(matCous,numBoot);                   % boostrapped matrix from normalized data
    
    ciBootCous = [  meanAcrossSub-prctile(matBootCous,2.5);...
                   -meanAcrossSub+prctile(matBootCous,97.5)];   % confidence interval of bootstrapped normalized data
    
    ciBootMorey = ciBootCous*(numCond/(numCond-1))...
                        /sqrt(numCond/(numCond-1));             % confidence interval of bootstrapped normalized data corrected for Cousineau bias
    
	ci = [meanAcrossSub-ciBootCous(1,:);...
          meanAcrossSub+ciBootCous(2,:)];                        % ci value to add to mean
    
    ciVal = mean(ciBootMorey,1);                                 % ci mean values to add to mean

elseif type == 4
    
    ciVal = [nanstd(matRes,0)/sqrt(numSub)];
    ci = [mean(matRes)-ciVal(1,:);...
             mean(matRes)+ciVal(1,:)];
    
elseif type == 5
	
    matBootRes = bootstrap(matRes,numBoot);

    ci = [prctile(matBootRes,2.5);prctile(matBootRes,97.5)];
    ciVal = [abs(ci(1,:)-mean(matRes));...
             ci(2,:)-mean(matRes)];
    
end
meanCond = meanAcrossSub;                           % mean across subjects of each conditions

    function bsData = bootstrap(data,ni)
        
        if nargin<2
            ni = 100;
        end
        
        nc = size(data,1);    % number of cases
        
        for i = 1:ni
            bsSample = randsample(1:nc,nc,1);
            bsData(i,:) = mean(data(bsSample,:));
        end
        
    end


end