function extractorMainGroup(sub)
% ----------------------------------------------------------------------
% extractorMainGroup(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Extract results, mean, number of the different combination of variable
% used in this experiment.
% do statitistic using bootstrap
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configuration
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 08 / 03 / 2016
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

fprintf(1,'\n\n\t>> Data extraction [IN PROGRESS]\n');

% Mean all effects
% ----------------
tabResMainAll       = [];
tabResGapAll        = [];
tabResCongAll       = [];
tabResLumRefAll     = [];
tabResLumProbeAll   = [];
tabResGapRefAll     = [];
tabResGapProbeAll   = [];
for numSjct = 1:size(sub.iniAll,2)
    load(sprintf('%s/Data/%s/ExpDataMAIN/AllB/expResEye_%s_AllB.mat',sub.dir,sub.iniAll{numSjct},sub.iniAll{numSjct}));
    tabResMainAll(:,:,numSjct)      = configEyeAll{end}.tabResMainAll;
    tabResGapAll(:,:,numSjct)       = configEyeAll{end}.tabResGapAll;
    tabResCongAll(:,:,numSjct)      = configEyeAll{end}.tabResCongAll;
    tabResLumRefAll(:,:,numSjct)    = configEyeAll{end}.tabResLumRefAll;
    tabResLumProbeAll(:,:,numSjct)  = configEyeAll{end}.tabResLumProbeAll;
    tabResGapRefAll(:,:,numSjct)    = configEyeAll{end}.tabResGapRefAll;
    tabResGapProbeAll(:,:,numSjct)  = configEyeAll{end}.tabResGapProbeAll;
    tabResCondAll(:,:,numSjct)      = configEyeAll{end}.tabResCondAll;
end

% Compute mean
% ------------
configEyeAll = [];
configEyeAll{1}.tabResMainAll               = nanmean(tabResMainAll,3);
configEyeAll{1}.tabResGapAll                = nanmean(tabResGapAll,3);
configEyeAll{1}.tabResCongAll               = nanmean(tabResCongAll,3);
configEyeAll{1}.tabResLumRefAll             = nanmean(tabResLumRefAll,3);
configEyeAll{1}.tabResLumProbeAll           = nanmean(tabResLumProbeAll,3);
configEyeAll{1}.tabResGapRefAll             = nanmean(tabResGapRefAll,3);
configEyeAll{1}.tabResGapProbeAll           = nanmean(tabResGapProbeAll,3);
configEyeAll{1}.tabResCondAll               = nanmean(tabResCondAll,3);

% Compute statistics
% ------------------
% main effects
matRes      = [];
rand7Col    = 3;
compMat     = [1,5;2,6;3,7;4,8];
for tRes = 4:18
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResMainAll(tabResMainAll(:,rand7Col) == 1,tRes,numSjct)',tabResMainAll(tabResMainAll(:,rand7Col) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResMainAll_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% gap effects
matRes      = [];
rand7Col    = 1;
compMat     = [1,2];
for tRes = 2:16
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResGapAll(tabResGapAll(:,rand7Col) == 1,tRes,numSjct)',tabResGapAll(tabResGapAll(:,rand7Col) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResGapAll_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% congruency effects
matRes      = [];
congCol     = 1;
compMat     = [1,2];
for tRes = 2:16
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResCongAll(tabResCongAll(:,congCol) == 1,tRes,numSjct)',tabResCongAll(tabResCongAll(:,congCol) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResCongAll_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% luminance of reference effects
matRes      = [];
rand5Col    = 1;
compMat     = [1,2];
for tRes = 2:16
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResLumRefAll(tabResLumRefAll(:,rand5Col) == 1,tRes,numSjct)',tabResLumRefAll(tabResLumRefAll(:,rand5Col) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResLumRefAll_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% luminance of probe effects
matRes      = [];
rand6Col    = 1;
compMat     = [1,2];
for tRes = 2:16
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResLumProbeAll(tabResLumProbeAll(:,rand6Col) == 1,tRes,numSjct)',tabResLumProbeAll(tabResLumProbeAll(:,rand6Col) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResLumProbeAll_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% gap effect depending on luminance of the reference
matRes      = [];
rand7Col    = 2;
compMat     = [1,3;2,4];
for tRes = 3:17
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResGapRefAll(tabResGapRefAll(:,rand7Col) == 1,tRes,numSjct)',tabResGapRefAll(tabResGapRefAll(:,rand7Col) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResGapRefAll_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% gap effect depending on luminance of the probe
matRes      = [];
rand7Col    = 2;
compMat     = [1,3;2,4];
for tRes = 3:17
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResGapProbeAll(tabResGapProbeAll(:,rand7Col) == 1,tRes,numSjct)',tabResGapProbeAll(tabResGapProbeAll(:,rand7Col) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResGapProbeAll_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% Cond effect irrespective of gap
matRes      = [];
rand5Col    = 1;
rand6Col    = 2;
compMat     = [1,2;1,3;1,4;2,3;2,4;3,4];
for tRes = 3:17
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResCondAll(tabResCondAll(:,rand5Col) == 1 & tabResCondAll(:,rand6Col) == 1,tRes,numSjct)',...
                             tabResCondAll(tabResCondAll(:,rand5Col) == 1 & tabResCondAll(:,rand6Col) == 2,tRes,numSjct)',...
                             tabResCondAll(tabResCondAll(:,rand5Col) == 2 & tabResCondAll(:,rand6Col) == 1,tRes,numSjct)',...
                             tabResCondAll(tabResCondAll(:,rand5Col) == 2 & tabResCondAll(:,rand6Col) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResCondAll_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% Cond effect irrespective for Gap 0ms
matRes      = [];
rand5Col    = 1;
rand6Col    = 2;
rand7Col    = 3;
compMat     = [1,2;1,3;1,4;2,3;2,4;3,4];
for tRes = 4:18
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResMainAll(tabResMainAll(:,rand5Col) == 1 & tabResMainAll(:,rand6Col) == 1 & tabResMainAll(:,rand7Col) == 1,tRes,numSjct)',...
                             tabResMainAll(tabResMainAll(:,rand5Col) == 1 & tabResMainAll(:,rand6Col) == 2 & tabResMainAll(:,rand7Col) == 1,tRes,numSjct)',...
                             tabResMainAll(tabResMainAll(:,rand5Col) == 2 & tabResMainAll(:,rand6Col) == 1 & tabResMainAll(:,rand7Col) == 1,tRes,numSjct)',...
                             tabResMainAll(tabResMainAll(:,rand5Col) == 2 & tabResMainAll(:,rand6Col) == 2 & tabResMainAll(:,rand7Col) == 1,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResCondGap0All_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% Cond effect irrespective for Gap 200ms
matRes      = [];
rand5Col    = 1;
rand6Col    = 2;
rand7Col    = 3;
compMat     = [1,2;1,3;1,4;2,3;2,4;3,4];
for tRes = 4:18
    % extract individual matrices
    for numSjct = 1:size(sub.iniAll,2)
        matRes(numSjct,:) = [tabResMainAll(tabResMainAll(:,rand5Col) == 1 & tabResMainAll(:,rand6Col) == 1 & tabResMainAll(:,rand7Col) == 2,tRes,numSjct)',...
                             tabResMainAll(tabResMainAll(:,rand5Col) == 1 & tabResMainAll(:,rand6Col) == 2 & tabResMainAll(:,rand7Col) == 2,tRes,numSjct)',...
                             tabResMainAll(tabResMainAll(:,rand5Col) == 2 & tabResMainAll(:,rand6Col) == 1 & tabResMainAll(:,rand7Col) == 2,tRes,numSjct)',...
                             tabResMainAll(tabResMainAll(:,rand5Col) == 2 & tabResMainAll(:,rand6Col) == 2 & tabResMainAll(:,rand7Col) == 2,tRes,numSjct)'];
    end
    configEyeAll{1}.tabResCondGap200All_stats{tRes} = computeBootstrap(matRes,compMat,sub.numBoot,sub.valStars,sub.typeCI);
end

% Save all matrix
% ---------------
save(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini),'configEyeAll');

end