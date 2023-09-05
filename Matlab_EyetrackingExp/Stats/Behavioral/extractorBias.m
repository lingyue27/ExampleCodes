function extractorBias(sub)
% ----------------------------------------------------------------------
% extractorBias(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Extract results, mean, number of the different combination of variable
% used to get the bias and the jnds
% ----------------------------------------------------------------------
% Input(s) :
% sub = subject configuration
% configEyeAll = stuct containing block structs of eye analysis
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Created by Martin SZINTE          (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI    (lukasz.grzeczkowski@gmail.com)
% Last update : 08 / 03 / 2017
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

fprintf(1,'\n\n\t>> Data extraction for fit bias [IN PROGRESS]\n');
load(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini));

fileRes = configEyeAll{end}.resMatCor;

%Probe angle change level
rand4Col  = 6;    % column
nb.rand4  = 6;    % modalities 
% 1 = level 1
% 2 = level 2
% 3 = level 3
% 4 = level 4
% 5 = level 5
% 6 = level 6

% Luminance of the reference
rand5Col = 7;    % column
nb.rand5 = 2;    % modalities
% 1 = isoluminant
% 2 = non-isoluminant

% Luminance of the probe
rand6Col = 8;    % column
nb.rand6 = 2;    % modalities
% 1 = isoluminant
% 2 = non-isoluminant

% Post-Saccadic Gap duration
rand7Col = 9;    % column
nb.rand7 = 2;    % modalities
% 1 = gap 0
% 2 = gap 200

% Direction of the change
rand9Col = 11;    % column
nb.rand9 = 2;    % modalities
% 1 = clockwise
% 2 = counter-clockwise

% Angle of the direction change
angCol = 14;

% response (button press)
respCol = 15;

% recode in % cw
for tTrial = 1:size(fileRes,1)
    if fileRes(tTrial,respCol) == 1
        fileRes(tTrial,respCol) = 1;
    elseif fileRes(tTrial,respCol) == 2
        fileRes(tTrial,respCol) = 0;
    else
        fileRes(tTrial,respCol) = NaN;
    end
end

% recode change level in change angle (negative and positive)
% recode alos angle change with direction
for tTrial = 1:size(fileRes,1)
    switch fileRes(tTrial,rand4Col)
        case 1
            if     fileRes(tTrial,rand9Col) == 1; fileRes(tTrial,rand4Col) = 7;  
            elseif fileRes(tTrial,rand9Col) == 2; fileRes(tTrial,rand4Col) = 6; fileRes(tTrial,angCol) = fileRes(tTrial,angCol)*-1;
            end
        case 2
            if     fileRes(tTrial,rand9Col) == 1; fileRes(tTrial,rand4Col) = 8;
            elseif fileRes(tTrial,rand9Col) == 2; fileRes(tTrial,rand4Col) = 5; fileRes(tTrial,angCol) = fileRes(tTrial,angCol)*-1;
            end
        case 3
            if     fileRes(tTrial,rand9Col) == 1; fileRes(tTrial,rand4Col) = 9;
            elseif fileRes(tTrial,rand9Col) == 2; fileRes(tTrial,rand4Col) = 4; fileRes(tTrial,angCol) = fileRes(tTrial,angCol)*-1;
            end
        case 4
            if     fileRes(tTrial,rand9Col) == 1; fileRes(tTrial,rand4Col) = 10;
            elseif fileRes(tTrial,rand9Col) == 2; fileRes(tTrial,rand4Col) = 3; fileRes(tTrial,angCol) = fileRes(tTrial,angCol)*-1;
            end
        case 5
            if     fileRes(tTrial,rand9Col) == 1; fileRes(tTrial,rand4Col) = 11;
            elseif fileRes(tTrial,rand9Col) == 2; fileRes(tTrial,rand4Col) = 2; fileRes(tTrial,angCol) = fileRes(tTrial,angCol)*-1;
            end
        case 6
            if     fileRes(tTrial,rand9Col) == 1; fileRes(tTrial,rand4Col) = 12;
            elseif fileRes(tTrial,rand9Col) == 2; fileRes(tTrial,rand4Col) = 1; fileRes(tTrial,angCol) = fileRes(tTrial,angCol)*-1;
            end
    end
end
nb.rand4  = 12;    % modalities 
% 01 = -6 level (ccw)
% 02 = -5 level (ccw)
% 03 = -4 level (ccw)
% 04 = -3 level (ccw)
% 05 = -2 level (ccw)
% 06 = -1 level (ccw)
% 07 = +1 level (cw)
% 08 = +2 level (cw)
% 09 = +3 level (cw)
% 10 = +4 level (cw)
% 11 = +5 level (cw)
% 12 = +6 level (cw)

% Extractor across eccentricities and all conditions
all.allData   =  [];
all.values    =  [];
all.meanVal   =  [];
all.realVal   =  [];
all.num       =  [];
all.varTabR   =  [];

% extract between condition
for rand5 = 1:nb.rand5                                  % Luminance of the reference
    index.rand5 = fileRes(:,rand5Col) == rand5;
    
    for rand6 = 1:nb.rand6                              % Luminance of the probe
        index.rand6 = fileRes(:,rand6Col) == rand6;
        
        for rand7 = 1:nb.rand7                          % Post-Saccadic Gap duration
            index.rand7 = fileRes(:,rand7Col) == rand7;
            
            for rand4 = 1:nb.rand4                      % Probe angle change level
                index.rand4 = fileRes(:,rand4Col) == rand4;
        
                allData     =   fileRes(index.rand5 & index.rand6 & index.rand4 & index.rand7,:);
                values      =   allData(:,respCol);
                values2     =   allData(:,angCol);
                
                if isempty(values)
                    meanVal     =   NaN;
                    realVal     =   NaN;
                    num         =   0;
                    varTab      =   [rand5,rand6,rand7,rand4];
                    varTabR     =   varTab;
                else
                    meanVal     =   nanmean(values);
                    realVal     =   nanmean(values2);
                    num         =   numel(values);
                    varTab      =   [allData(:,rand5Col),allData(:,rand6Col),allData(:,rand7Col),allData(:,rand4Col)];
                    varTabR     =   mean(varTab,1);
                end
            
                all.allData =   [all.allData;   allData   ];
                all.values  =   [all.values;    values    ];
                all.meanVal =   [all.meanVal;   meanVal   ];
                all.realVal =   [all.realVal;   realVal   ];
                all.num     =   [all.num;       num       ];
                all.varTabR =   [all.varTabR;   varTabR   ];
            end
        end
    end
end
configEyeAll{end}.tabResBias = [all.varTabR, all.meanVal, all.realVal, all.num];

% Extractor across eccentricities for gap effect
all.allData   =  [];
all.values    =  [];
all.meanVal   =  [];
all.realVal   =  [];
all.num       =  [];
all.varTabR   =  [];

for rand7 = 1:nb.rand7
    index.rand7 = fileRes(:,rand7Col) == rand7;
    
    for rand4 = 1:nb.rand4
        index.rand4 = fileRes(:,rand4Col) == rand4;
        
        allData     =   fileRes(index.rand4 & index.rand7,:);
        values      =   allData(:,respCol);
        values2     =   allData(:,angCol);
        
        if isempty(values)
            meanVal     =   NaN;
            realVal     =   NaN;
            num         =   0;
            varTab      =   [rand7,rand4];
            varTabR     =   varTab;
        else
            meanVal     =   nanmean(values);
            realVal     =   nanmean(values2);
            num         =   numel(values);
            varTab      =   [allData(:,rand7Col),allData(:,rand4Col)];
            varTabR     =   mean(varTab,1);
        end
        
        all.allData =   [all.allData;   allData   ];
        all.values  =   [all.values;    values    ];
        all.meanVal =   [all.meanVal;   meanVal   ];
        all.realVal =   [all.realVal;   realVal   ];
        all.num     =   [all.num;       num       ];
        all.varTabR =   [all.varTabR;   varTabR   ];
    end
end
configEyeAll{end}.tabResGapBias = [all.varTabR, all.meanVal, all.realVal, all.num];



% Extractor across eccentricities for congruency effect
nb.cong = 2;
congCol = size(fileRes,2)+1;
for tTrial = 1:size(fileRes,1);
    if fileRes(tTrial,rand5Col) == fileRes(tTrial,rand6Col)
        fileRes(tTrial,congCol) = 1; % congruent
    else
        fileRes(tTrial,congCol) = 2; % incongruent
    end
end

all.allData   =  [];
all.values    =  [];
all.meanVal   =  [];
all.realVal   =  [];
all.num       =  [];
all.varTabR   =  [];

for cong = 1:nb.cong
    index.cong = fileRes(:,congCol) == cong;
    
    for rand4 = 1:nb.rand4
        index.rand4 = fileRes(:,rand4Col) == rand4;
        
        allData     =   fileRes(index.rand4 & index.cong,:);
        values      =   allData(:,respCol);
        values2     =   allData(:,angCol);
        
        if isempty(values)
            meanVal     =   NaN;
            realVal     =   NaN;
            num         =   0;
            varTab      =   [cong,rand4];
            varTabR     =   varTab;
        else
            meanVal     =   nanmean(values);
            realVal     =   nanmean(values2);
            num         =   numel(values);
            varTab      =   [allData(:,congCol),allData(:,rand4Col)];
            varTabR     =   mean(varTab,1);
        end
        
        all.allData =   [all.allData;   allData   ];
        all.values  =   [all.values;    values    ];
        all.meanVal =   [all.meanVal;   meanVal   ];
        all.realVal =   [all.realVal;   realVal   ];
        all.num     =   [all.num;       num       ];
        all.varTabR =   [all.varTabR;   varTabR   ];
    end
end
configEyeAll{end}.tabResCongBias = [all.varTabR, all.meanVal, all.realVal, all.num];

% Extractor across eccentricities for ref luminance effect
all.allData   =  [];
all.values    =  [];
all.meanVal   =  [];
all.realVal   =  [];
all.num       =  [];
all.varTabR   =  [];

for rand5 = 1:nb.rand5
    index.rand5 = fileRes(:,rand5Col) == rand5;
    
    for rand4 = 1:nb.rand4
        index.rand4 = fileRes(:,rand4Col) == rand4;
        
        allData     =   fileRes(index.rand4 & index.rand5, :);
        values      =   allData(:, respCol);
        values2     =   allData(:, angCol);
        
        if isempty(values)
            meanVal     =   NaN;
            realVal     =   NaN;
            num         =   0;
            varTab      =   [rand5,rand4];
            varTabR     =   varTab;
        else
            meanVal     =   nanmean(values);
            realVal     =   nanmean(values2);
            num         =   numel(values);
            varTab      =   [allData(:,rand5Col),allData(:,rand4Col)];
            varTabR     =   mean(varTab,1);
        end
        
        all.allData =   [all.allData;   allData   ];
        all.values  =   [all.values;    values    ];
        all.meanVal =   [all.meanVal;   meanVal   ];
        all.realVal =   [all.realVal;   realVal   ];
        all.num     =   [all.num;       num       ];
        all.varTabR =   [all.varTabR;   varTabR   ];
    end
end
configEyeAll{end}.tabResLumRefBias = [all.varTabR,all.meanVal,all.realVal,all.num];

% Extractor across eccentricities for probe luminance effect
all.allData   =  [];
all.values    =  [];
all.meanVal   =  [];
all.realVal   =  [];
all.num       =  [];
all.varTabR   =  [];

for rand6 = 1:nb.rand6
    index.rand6 = fileRes(:,rand6Col) == rand6;
    
    for rand4 = 1:nb.rand4
        index.rand4 = fileRes(:,rand4Col) == rand4;
        
        allData     =   fileRes(index.rand4 & index.rand6,:);
        values      =   allData(:,respCol);
        values2     =   allData(:,angCol);
        
        if isempty(values)
            meanVal     =   NaN;
            realVal     =   NaN;
            num         =   0;
            varTab      =   [rand6,rand4];
            varTabR     =   varTab;
        else
            meanVal     =   nanmean(values);
            realVal     =   nanmean(values2);
            num         =   numel(values);
            varTab      =   [allData(:,rand6Col),allData(:,rand4Col)];
            varTabR     =   mean(varTab,1);
        end
        
        all.allData =   [all.allData;   allData   ];
        all.values  =   [all.values;    values    ];
        all.meanVal =   [all.meanVal;   meanVal   ];
        all.realVal =   [all.realVal;   realVal   ];
        all.num     =   [all.num;       num       ];
        all.varTabR =   [all.varTabR;   varTabR   ];
    end
end
configEyeAll{end}.tabResLumProbeBias = [all.varTabR,all.meanVal,all.realVal,all.num];

% Extract data for depending on luminance of the reference
all.allData   =  [];
all.values    =  [];
all.meanVal   =  [];
all.realVal   =  [];
all.num       =  [];
all.varTabR   =  [];
for rand5 = 1:nb.rand5                              % Luminance of the reference
    index.rand5 = fileRes(:,rand5Col) == rand5;
    
    for rand7 = 1:nb.rand7                          % Post-Saccadic Gap duration
        index.rand7 = fileRes(:,rand7Col) == rand7;
        
        for rand4 = 1:nb.rand4                      % Probe angle change level
            index.rand4 = fileRes(:,rand4Col) == rand4;
            
            allData     =   fileRes(index.rand5 & index.rand7 & index.rand4,:);
            values      =   allData(:,respCol);
            values2     =   allData(:,angCol);
            
            if isempty(values)
                meanVal     =   NaN;
                realVal     =   NaN;
                num         =   0;
                varTab      =   [rand5,rand7,rand4];
                varTabR     =   varTab;
            else
                meanVal     =   nanmean(values);
                realVal     =   nanmean(values2);
                num         =   numel(values);
                varTab      =   [allData(:,rand5Col), allData(:,rand7Col), allData(:,rand4Col)];
                varTabR     =   mean(varTab,1);
            end
            
            all.allData =   [all.allData;   allData   ];
            all.values  =   [all.values;    values    ];
            all.meanVal =   [all.meanVal;   meanVal   ];
            all.realVal =   [all.realVal;   realVal   ];
            all.num     =   [all.num;       num       ];
            all.varTabR =   [all.varTabR;   varTabR   ];
        end
        
    end
end
configEyeAll{end}.tabResGapRefBias = [all.varTabR, all.meanVal, all.realVal, all.num];

% Extract data for depending on luminance of the probe
all.allData   =  [];
all.values    =  [];
all.meanVal   =  [];
all.realVal   =  [];
all.num       =  [];
all.varTabR   =  [];
for rand6 = 1:nb.rand6                              % Luminance of the probe
    index.rand6 = fileRes(:,rand6Col) == rand6;
    
    for rand7 = 1:nb.rand7                          % Post-Saccadic Gap duration
        index.rand7 = fileRes(:,rand7Col) == rand7;
        
        for rand4 = 1:nb.rand4                      % Probe angle change level
            index.rand4 = fileRes(:,rand4Col) == rand4;
            
            allData     =   fileRes(index.rand6 & index.rand7 & index.rand4,:);
            values      =   allData(:,respCol);
            values2     =   allData(:,angCol);
            
            if isempty(values)
                meanVal     =   NaN;
                realVal     =   NaN;
                num         =   0;
                varTab      =   [rand6,rand7,rand4];
                varTabR     =   varTab;
            else
                meanVal     =   nanmean(values);
                realVal     =   nanmean(values2);
                num         =   numel(values);
                varTab      =   [allData(:,rand6Col), allData(:,rand7Col), allData(:,rand4Col)];
                varTabR     =   mean(varTab,1);
            end
            
            all.allData =   [all.allData;   allData   ];
            all.values  =   [all.values;    values    ];
            all.meanVal =   [all.meanVal;   meanVal   ];
            all.realVal =   [all.realVal;   realVal   ];
            all.num     =   [all.num;       num       ];
            all.varTabR =   [all.varTabR;   varTabR   ];
        end
        
    end
end
configEyeAll{end}.tabResGapProbeBias = [all.varTabR, all.meanVal, all.realVal, all.num];
save(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini),'configEyeAll');

% Extract data depending on conditions
all.allData   =  [];
all.values    =  [];
all.meanVal   =  [];
all.realVal   =  [];
all.num       =  [];
all.varTabR   =  [];
for rand5 = 1:nb.rand5                              % Luminance of the reference
    index.rand5 = fileRes(:,rand5Col) == rand5;
    
    for rand6 = 1:nb.rand6                              % Luminance of the reference
        index.rand6 = fileRes(:,rand6Col) == rand6;
        
        for rand4 = 1:nb.rand4                      % Probe angle change level
            index.rand4 = fileRes(:,rand4Col) == rand4;
            
            allData     =   fileRes(index.rand5 & index.rand6 & index.rand4,:);
            values      =   allData(:,respCol);
            values2     =   allData(:,angCol);
            
            if isempty(values)
                meanVal     =   NaN;
                realVal     =   NaN;
                num         =   0;
                varTab      =   [rand5,rand6,rand4];
                varTabR     =   varTab;
            else
                meanVal     =   nanmean(values);
                realVal     =   nanmean(values2);
                num         =   numel(values);
                varTab      =   [allData(:,rand5Col), allData(:,rand6Col), allData(:,rand4Col)];
                varTabR     =   mean(varTab,1);
            end
            
            all.allData =   [all.allData;   allData   ];
            all.values  =   [all.values;    values    ];
            all.meanVal =   [all.meanVal;   meanVal   ];
            all.realVal =   [all.realVal;   realVal   ];
            all.num     =   [all.num;       num       ];
            all.varTabR =   [all.varTabR;   varTabR   ];
        end
    end
end
configEyeAll{end}.tabResCondBias = [all.varTabR, all.meanVal, all.realVal, all.num];
save(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini),'configEyeAll');

end