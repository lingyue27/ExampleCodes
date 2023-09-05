function matStats = computeBootstrap(matRes,compMat,numBoot,valStars,typeCI)
% ----------------------------------------------------------------------
% computeBootstrap
% ----------------------------------------------------------------------
% Goal of the function :
% Compute bootstrap for set of comparisons
% ----------------------------------------------------------------------
% Input(s) :
% matRes : matrix of conditions (col) in function of subjects (row)
% numBoot : bootstrap iteration
% valStars : limit for significance star value
% compMat : comparison matrix (e.g. [1,2] => column 1 vs. column 2)
% typeCI = see within_subject_CI.m
% ----------------------------------------------------------------------
% Output(s):
% matStats = matrix of statisticis for each comparisons
%            col1  = condCol1
%            col2  = condCol2
%            col3  = mean cond1
%            col4  = ci val min cond1
%            col5  = ci val max cond1
%            col6  = mean cond2
%            col7  = ci val min cond2
%            col8  = ci val max cond2
%            col9  = p value
%            col10 = number of stars
%            col11 = sign of effect
% ----------------------------------------------------------------------
% Created by Martin SZINTE          (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI    (lukasz.grzeczkowski@gmail.com)
% Last update : 27 / 02 / 2017
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

bootMat     = bootstrap(matRes,numBoot);
matStats    = [];
compNum = size(compMat,1);
[ci,meanCond] = within_subjects_CI(matRes,typeCI,numBoot);

for tCompNum = 1:compNum
    diff_bt   = [];diff_bt      = bootMat(:,compMat(tCompNum,1)) - bootMat(:,compMat(tCompNum,2));
    diff_mean = [];diff_mean    = meanCond(compMat(tCompNum,1)) - meanCond(compMat(tCompNum,2));
    
    
    matStats(tCompNum,1:8)      = [ compMat(tCompNum,1),...
                                    compMat(tCompNum,2),...
                                    meanCond(compMat(tCompNum,1)),...
                                    ci(:,compMat(tCompNum,1))',...
                                    meanCond(compMat(tCompNum,2)),...
                                    ci(:,compMat(tCompNum,2))'];

    pVal_comp = [];
    if ~isnan(diff_mean);
        if diff_mean < 0;
            signVal = -1;
            pVal_comp = sum(diff_bt>0)/numBoot;
        elseif diff_mean > 0;
            signVal = 1;
            pVal_comp = 1-sum(diff_bt>0)/numBoot;
        elseif diff_mean == 0;
            signVal = 1;
            pVal_comp = 1;
        end
        
        pVal_comp = pVal_comp*2;
        
        if pVal_comp == 0;pVal_comp = 1/numBoot;
        elseif pVal_comp> 1; pVal_comp = 1;end
        
        matStats(tCompNum,9) = pVal_comp;
        if pVal_comp > valStars(1)
            matStats(tCompNum,10) = 0;
        elseif pVal_comp <= valStars(1) && pVal_comp > valStars(2)
            matStats(tCompNum,10) = 1;
        elseif pVal_comp <= valStars(2) && pVal_comp > valStars(3)
            matStats(tCompNum,10) = 2;
        elseif pVal_comp <= valStars(3) && pVal_comp > valStars(4)
            matStats(tCompNum,10) = 3;
        elseif pVal_comp <= valStars(4)
            matStats(tCompNum,10) = 4;
        end
        matStats(tCompNum,11) = signVal;
    else
        matStats(tCompNum,9) = NaN;
        matStats(tCompNum,10) = NaN;
        matStats(tCompNum,12) = NaN;
    end
end
end