function extractorMain(sub)
% ----------------------------------------------------------------------
% extractorMain(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Extract results, mean, number of the different combination of variable
% used in this experiment.
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configuration
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

fprintf(1,'\n\n\t>> Data extraction [IN PROGRESS]\n');
load(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini));

%% Extract data from resMatCor and make means for each condition
fileRes             = configEyeAll{end}.resMatCor;                  % all trials
thSave              = configEyeAll{end}.thSave;                     % fit data in main conditions
thSaveGap           = configEyeAll{end}.thSaveGap;                  % fit data for main gap effect
thSaveCong          = configEyeAll{end}.thSaveCong;                 % fit data for congruency effect
thSaveLumRef        = configEyeAll{end}.thSaveLumRef;               % fit data for reference luminance effect
thSaveLumProbe      = configEyeAll{end}.thSaveLumProbe;             % fit data for probe luminance effect
thSaveGapRef        = configEyeAll{end}.thSaveGapRef;               % fit data for reference/probe gap effect
thSaveGapProbe      = configEyeAll{end}.thSaveGapProbe;             % fit data for reference/probe gap effect
thSaveCond          = configEyeAll{end}.thSaveCond;                 % fit data for conditions

thSaveBias          = configEyeAll{end}.thSaveBias;                 % fit data in main conditions
thSaveGapBias       = configEyeAll{end}.thSaveGapBias;              % fit data for main gap effect
thSaveCongBias      = configEyeAll{end}.thSaveCongBias;             % fit data for congruency effect
thSaveLumRefBias    = configEyeAll{end}.thSaveLumRefBias;           % fit data for reference luminance effect
thSaveLumProbeBias  = configEyeAll{end}.thSaveLumProbeBias;         % fit data for probe luminance effect
thSaveGapRefBias    = configEyeAll{end}.thSaveGapRefBias;           % fit data for reference/probe gap effect
thSaveGapProbeBias  = configEyeAll{end}.thSaveGapProbeBias;         % fit data for reference/probe gap effect
thSaveCondBias      = configEyeAll{end}.thSaveCondBias;             % fit data for conditions

rand5Col            = 7;    % Luminance of the reference
nb.rand5            = 2;
rand6Col            = 8;    % Luminance of the probe
nb.rand6            = 2;
rand7Col            = 9;    % Post-saccadic gap duration
nb.rand7            = 2;
corResCol           = 16;   % Correctness of the answer
sacLatCol           = 45;   % Saccade latency
sacAmpCol           = 50;   % Saccade amplitude
refDurCol           = 57;   % Duration of the ref
gapDurCol           = 58;   % Duration of the gap
probeOnSacOffCol    = 63;   % Probe onset relative to saccade offset
sacDurCol           = 44;   % Saccade duration

%% Extractor of main effect
thCol               = 4;    % fitted data threshold
jndCol              = 6;    % fitted data jnd
pDevCol             = 9;    % fitted data pDev

all.varTab  = []; all.val01   = [];
all.val02   = []; all.val03   = [];
all.val04   = []; all.val05   = [];
all.val06   = []; all.val07   = [];
all.val08   = []; all.val09   = [];
all.val10   = []; all.val11   = [];
all.val12   = []; all.val13   = [];
all.val14   = []; all.val15   = [];

for rand5 = 1:nb.rand5
    index.rand5 = fileRes(:,rand5Col) == rand5;
    
    for rand6 = 1:nb.rand6
        index.rand6 = fileRes(:,rand6Col) == rand6;
        
        for rand7 = 1:nb.rand7
            index.rand7 = fileRes(:,rand7Col) == rand7;
    
            allData         = fileRes(index.rand5 & index.rand6 & index.rand7,:);
            allDataFit      = thSave(thSave(:,1) == rand5 & thSave(:,2) == rand6 & thSave(:,3) == rand7,:);
            allDataFitBias  = thSaveBias(thSaveBias(:,1) == rand5 & thSaveBias(:,2) == rand6 & thSaveBias(:,3) == rand7,:);
            
            val01_data = allData(:,corResCol);          % mean performance
            val02_data = allData(:,corResCol);          % sensitivity
            val03_data = allData(:,corResCol);          % number of trials
            val04_data = allData(:,sacLatCol);          % saccade latency
            val05_data = allData(:,sacAmpCol);          % saccade amplitude
            val06_data = allData(:,sacDurCol);          % saccade duration
            val07_data = allData(:,refDurCol);          % ref duration
            val08_data = allData(:,gapDurCol);          % gap duration
            val09_data = allData(:,probeOnSacOffCol);   % probe onset relative to sac offset
            val10_data = allDataFit(:,thCol);           % threshold
            val11_data = allDataFit(:,jndCol);          % jnd
            val12_data = allDataFit(:,pDevCol);         % pDev
            val13_data = allDataFitBias(:,thCol);       % threshold
            val14_data = allDataFitBias(:,jndCol);      % jnd
            val15_data = allDataFitBias(:,pDevCol);     % pDev
            
            if isempty(val01_data)
                varTab  =   [rand5,rand6,rand7];
                val01   =   NaN;    val02   =   NaN;
                val03   =   NaN;    val04   =   NaN;
                val05   =   NaN;    val06   =   NaN;
                val07   =   NaN;	val08   =   NaN;
                val09   =   NaN;	val10   =   NaN;
                val11   =   NaN;    val12   =   NaN;
                val13   =   NaN;    val14   =   NaN;
                val15   =   NaN;
            else
                varTab  =   nanmean([allData(:,rand5Col),allData(:,rand6Col),allData(:,rand7Col)],1);
                val01   =   nanmean(val01_data);
                val02   =   d2afcSDT(nanmean(val02_data));
                val03   =   numel(val03_data);
                val04   =   nanmean(val04_data);
                val05   =   nanmean(val05_data);
                val06   =   nanmean(val06_data);
                val07   =   nanmean(val07_data);
                val08   =   nanmean(val08_data);
                val09   =   nanmean(val09_data);
                val10   =   val10_data;
                val11   =   val11_data;
                val12   =   val12_data;
                val13   =   val13_data;
                val14   =   val14_data;
                val15   =   val15_data;
            end
            all.varTab      =   [all.varTab;    varTab  ];
            all.val01       =   [all.val01;     val01  	];
            all.val02       =   [all.val02;     val02	];
            all.val03       =   [all.val03;     val03	];
            all.val04       =   [all.val04;     val04	];
            all.val05       =   [all.val05;     val05	];
            all.val06       =   [all.val06;     val06	];
            all.val07       =   [all.val07;     val07	];
            all.val08       =   [all.val08;     val08	];
            all.val09       =   [all.val09;     val09	];
            all.val10       =   [all.val10;     val10	];
            all.val11       =   [all.val11;     val11	];
            all.val12       =   [all.val12;     val12	];
            all.val13       =   [all.val13;     val13	];
            all.val14       =   [all.val14;     val14	];
            all.val15       =   [all.val15;     val15	];
        end
    end
end

% Save data
configEyeAll{end}.tabResMainAll = [all.varTab, all.val01, all.val02, all.val03, all.val04, all.val05,...
                                               all.val06, all.val07, all.val08, all.val09, all.val10,...
                                               all.val11, all.val12, all.val13, all.val14, all.val15];
% col01 = rand5: Luminance of the reference (1 = isoluminant; 2 = non-isoluminant)
% col02 = rand6: Luminance of the probe (1 = isoluminant; 2 = non-isoluminant)
% col03 = rand7: Post-saccadic gap duration (1 = 0 ms; 2 = 200 ms)
% col04 = mean performance
% col05 = sensitivity
% col06 = number of trials
% col07 = saccade latency
% col08 = saccade amplitude
% col09 = saccade duration
% col10 = ref duration
% col11 = gap duration
% col12 = probe onset relative to sac offset
% col13 = threshold
% col14 = jnd
% col15 = pDev
% col16 = threshold
% col17 = jnd
% col18 = pDev

%% Extractor of main gap effects
thCol               = 2;    % fitted data threshold
jndCol              = 4;    % fitted data jnd
pDevCol             = 7;    % fitted data pDev

all.varTab  = []; all.val01   = [];
all.val02   = []; all.val03   = [];
all.val04   = []; all.val05   = [];
all.val06   = []; all.val07   = [];
all.val08   = []; all.val09   = [];
all.val10   = []; all.val11   = [];
all.val12   = []; all.val13   = [];
all.val14   = []; all.val15   = [];

for rand7 = 1:nb.rand7
    index.rand7     = fileRes(:,rand7Col) == rand7;
    allData         = fileRes(index.rand7,:);
    allDataFit      = thSaveGap(thSaveGap(:,1) == rand7,:);
    allDataFitBias  = thSaveGapBias(thSaveGapBias(:,1) == rand7,:);
    
    val01_data = allData(:,corResCol);          % mean performance
    val02_data = allData(:,corResCol);          % sensitivity
    val03_data = allData(:,corResCol);          % number of trials
    val04_data = allData(:,sacLatCol);          % saccade latency
    val05_data = allData(:,sacAmpCol);          % saccade amplitude
    val06_data = allData(:,sacDurCol);          % saccade duration
    val07_data = allData(:,refDurCol);          % ref duration
    val08_data = allData(:,gapDurCol);          % gap duration
    val09_data = allData(:,probeOnSacOffCol);   % probe onset relative to sac offset
    val10_data = allDataFit(:,thCol);           % threshold
    val11_data = allDataFit(:,jndCol);          % jnd
    val12_data = allDataFit(:,pDevCol);         % pDev
    val13_data = allDataFitBias(:,thCol);       % threshold
    val14_data = allDataFitBias(:,jndCol);      % jnd
    val15_data = allDataFitBias(:,pDevCol);     % pDev
    
    if isempty(val01_data)
        varTab  =   rand7;
        val01   =   NaN;    val02   =   NaN;
        val03   =   NaN;    val04   =   NaN;
        val05   =   NaN;    val06   =   NaN;
        val07   =   NaN;	val08   =   NaN;
        val09   =   NaN;	val10   =   NaN;
        val11   =   NaN;    val12   =   NaN;
        val13   =   NaN;    val14   =   NaN;
        val15   =   NaN;
    else
        varTab  =   nanmean(allData(:,rand7Col),1);
        val01   =   nanmean(val01_data);
        val02   =   d2afcSDT(nanmean(val02_data));
        val03   =   numel(val03_data);
        val04   =   nanmean(val04_data);
        val05   =   nanmean(val05_data);
        val06   =   nanmean(val06_data);
        val07   =   nanmean(val07_data);
        val08   =   nanmean(val08_data);
        val09   =   nanmean(val09_data);
        val10   =   val10_data;
        val11   =   val11_data;
        val12   =   val12_data;
        val13   =   val13_data;
        val14   =   val14_data;
        val15   =   val15_data;
    end
    all.varTab      =   [all.varTab;    varTab  ];
    all.val01       =   [all.val01;     val01  	];
    all.val02       =   [all.val02;     val02	];
    all.val03       =   [all.val03;     val03	];
    all.val04       =   [all.val04;     val04	];
    all.val05       =   [all.val05;     val05	];
    all.val06       =   [all.val06;     val06	];
    all.val07       =   [all.val07;     val07	];
    all.val08       =   [all.val08;     val08	];
    all.val09       =   [all.val09;     val09	];
    all.val10       =   [all.val10;     val10	];
    all.val11       =   [all.val11;     val11	];
    all.val12       =   [all.val12;     val12	];
    all.val13       =   [all.val13;     val13	];
    all.val14       =   [all.val14;     val14	];
    all.val15       =   [all.val15;     val15	];
end
configEyeAll{end}.tabResGapAll = [all.varTab, all.val01, all.val02, all.val03, all.val04, all.val05,...
                                              all.val06, all.val07, all.val08, all.val09, all.val10,...
                                              all.val11, all.val12, all.val13, all.val14, all.val15];
                                        
% col01 = rand7: Post-saccadic gap duration (1 = 0 ms; 2 = 200 ms)
% col02 = mean performance
% col03 = sensitivity
% col04 = number of trials
% col05 = saccade latency
% col06 = saccade amplitude
% col07 = saccade duration
% col08 = ref duration
% col09 = gap duration
% col10 = probe onset relative to sac offset
% col11 = threshold
% col12 = jnd
% col13 = pDev
% col14 = bias
% col15 = jnd bias
% col16 = pDev bias

%% Extractor of congruency effects
thCol               = 2;    % fitted data threshold
jndCol            = 4;    % fitted data jnd
pDevCol             = 7;    % fitted data pDev

all.varTab  = []; all.val01   = [];
all.val02   = []; all.val03   = [];
all.val04   = []; all.val05   = [];
all.val06   = []; all.val07   = [];
all.val08   = []; all.val09   = [];
all.val10   = []; all.val11   = [];
all.val12   = []; all.val13   = [];
all.val14   = []; all.val15   = [];

nb.cong = 2;
congCol = size(fileRes,2)+1;
for tTrial = 1:size(fileRes,1);
    if fileRes(tTrial,rand5Col) == fileRes(tTrial,rand6Col)
        fileRes(tTrial,congCol) = 1; % congruent
    else
        fileRes(tTrial,congCol) = 2; % incongruent
    end
end

for cong = 1:nb.cong
    index.cong = fileRes(:,congCol) == cong;
    
        
    allData         = fileRes(index.cong,:);
    allDataFit      = thSaveCong(thSaveCong(:,1) == cong,:);
    allDataFitBias  = thSaveCongBias(thSaveCongBias(:,1) == cong,:);
    
    val01_data = allData(:,corResCol);          % mean performance
    val02_data = allData(:,corResCol);          % sensitivity
    val03_data = allData(:,corResCol);          % number of trials
    val04_data = allData(:,sacLatCol);          % saccade latency
    val05_data = allData(:,sacAmpCol);          % saccade amplitude
    val06_data = allData(:,sacDurCol);          % saccade duration
    val07_data = allData(:,refDurCol);          % ref duration
    val08_data = allData(:,gapDurCol);          % gap duration
    val09_data = allData(:,probeOnSacOffCol);   % probe onset relative to sac offset
    val10_data = allDataFit(:,thCol);           % threshold
    val11_data = allDataFit(:,jndCol);          % jnd
    val12_data = allDataFit(:,pDevCol);         % pDev
    val13_data = allDataFitBias(:,thCol);       % threshold
    val14_data = allDataFitBias(:,jndCol);      % jnd
    val15_data = allDataFitBias(:,pDevCol);     % pDev
    
    
    if isempty(val01_data)
        varTab  =   cong;
        val01   =   NaN;    val02   =   NaN;
        val03   =   NaN;    val04   =   NaN;
        val05   =   NaN;    val06   =   NaN;
        val07   =   NaN;	val08   =   NaN;
        val09   =   NaN;	val10   =   NaN;
        val11   =   NaN;    val12   =   NaN;
        val13   =   NaN;    val14   =   NaN;
        val15   =   NaN;
    else
        varTab  =   nanmean(allData(:,congCol),1);
        val01   =   nanmean(val01_data);
        val02   =   d2afcSDT(nanmean(val02_data));
        val03   =   numel(val03_data);
        val04   =   nanmean(val04_data);
        val05   =   nanmean(val05_data);
        val06   =   nanmean(val06_data);
        val07   =   nanmean(val07_data);
        val08   =   nanmean(val08_data);
        val09   =   nanmean(val09_data);
        val10   =   val10_data;
        val11   =   val11_data;
        val12   =   val12_data;
        val13   =   val13_data;
        val14   =   val14_data;
        val15   =   val15_data;
    end
    all.varTab      =   [all.varTab;    varTab  ];
    all.val01       =   [all.val01;     val01  	];
    all.val02       =   [all.val02;     val02	];
    all.val03       =   [all.val03;     val03	];
    all.val04       =   [all.val04;     val04	];
    all.val05       =   [all.val05;     val05	];
    all.val06       =   [all.val06;     val06	];
    all.val07       =   [all.val07;     val07	];
    all.val08       =   [all.val08;     val08	];
    all.val09       =   [all.val09;     val09	];
    all.val10       =   [all.val10;     val10	];
    all.val11       =   [all.val11;     val11	];
    all.val12       =   [all.val12;     val12	];
    all.val13       =   [all.val13;     val13	];
    all.val14       =   [all.val14;     val14	];
    all.val15       =   [all.val15;     val15	];
end
configEyeAll{end}.tabResCongAll = [all.varTab, all.val01, all.val02, all.val03, all.val04, all.val05,...
                                               all.val06, all.val07, all.val08, all.val09, all.val10,...
                                               all.val11, all.val12, all.val13, all.val14, all.val15];
% col01 = cong: congruency between reference and probe (1 = congruent, 2 = incongruent)
% col02 = mean performance
% col03 = sensitivity
% col04 = number of trials
% col05 = saccade latency
% col06 = saccade amplitude
% col07 = saccade duration
% col08 = ref duration
% col09 = gap duration
% col10 = probe onset relative to sac offset
% col11 = threshold
% col12 = jnd
% col13 = pDev
% col14 = bias
% col15 = jnd bias
% col16 = pDev bias

%% Extractor of luminance of reference effects
thCol               = 2;    % fitted data threshold
jndCol            = 4;    % fitted data jnd
pDevCol             = 7;    % fitted data pDev

all.varTab  = []; all.val01   = [];
all.val02   = []; all.val03   = [];
all.val04   = []; all.val05   = [];
all.val06   = []; all.val07   = [];
all.val08   = []; all.val09   = [];
all.val10   = []; all.val11   = [];
all.val12   = []; all.val13   = [];
all.val14   = []; all.val15   = [];

for rand5 = 1:nb.rand5
    index.rand5     = fileRes(:,rand5Col) == rand5;
    allData         = fileRes(index.rand5,:);
    allDataFit      = thSaveLumRef(thSaveLumRef(:,1) == rand5,:);
    allDataFitBias  = thSaveLumRefBias(thSaveLumRefBias(:,1) == rand5,:);
    
    val01_data = allData(:,corResCol);          % mean performance
    val02_data = allData(:,corResCol);          % sensitivity
    val03_data = allData(:,corResCol);          % number of trials
    val04_data = allData(:,sacLatCol);          % saccade latency
    val05_data = allData(:,sacAmpCol);          % saccade amplitude
    val06_data = allData(:,sacDurCol);          % saccade duration
    val07_data = allData(:,refDurCol);          % ref duration
    val08_data = allData(:,gapDurCol);          % gap duration
    val09_data = allData(:,probeOnSacOffCol);   % probe onset relative to sac offset
    val10_data = allDataFit(:,thCol);           % threshold
    val11_data = allDataFit(:,jndCol);        % jnd
    val12_data = allDataFit(:,pDevCol);         % pDev
    val13_data = allDataFitBias(:,thCol);       % threshold
    val14_data = allDataFitBias(:,jndCol);      % jnd
    val15_data = allDataFitBias(:,pDevCol);     % pDev
    
    if isempty(val01_data)
        varTab  =   rand5;
        val01   =   NaN;    val02   =   NaN;
        val03   =   NaN;    val04   =   NaN;
        val05   =   NaN;    val06   =   NaN;
        val07   =   NaN;	val08   =   NaN;
        val09   =   NaN;	val10   =   NaN;
        val11   =   NaN;    val12   =   NaN;
        val13   =   NaN;    val14   =   NaN;
        val15   =   NaN;
    else
        varTab  =   nanmean(allData(:,rand5Col),1);
        val01   =   nanmean(val01_data);
        val02   =   d2afcSDT(nanmean(val02_data));
        val03   =   numel(val03_data);
        val04   =   nanmean(val04_data);
        val05   =   nanmean(val05_data);
        val06   =   nanmean(val06_data);
        val07   =   nanmean(val07_data);
        val08   =   nanmean(val08_data);
        val09   =   nanmean(val09_data);
        val10   =   val10_data;
        val11   =   val11_data;
        val12   =   val12_data;
        val13   =   val13_data;
        val14   =   val14_data;
        val15   =   val15_data;
    end
    all.varTab      =   [all.varTab;    varTab  ];
    all.val01       =   [all.val01;     val01  	];
    all.val02       =   [all.val02;     val02	];
    all.val03       =   [all.val03;     val03	];
    all.val04       =   [all.val04;     val04	];
    all.val05       =   [all.val05;     val05	];
    all.val06       =   [all.val06;     val06	];
    all.val07       =   [all.val07;     val07	];
    all.val08       =   [all.val08;     val08	];
    all.val09       =   [all.val09;     val09	];
    all.val10       =   [all.val10;     val10	];
    all.val11       =   [all.val11;     val11	];
    all.val12       =   [all.val12;     val12	];
    all.val13       =   [all.val13;     val13	];
    all.val14       =   [all.val14;     val14	];
    all.val15       =   [all.val15;     val15	];
end
configEyeAll{end}.tabResLumRefAll = [all.varTab, all.val01, all.val02, all.val03, all.val04, all.val05,...
                                                 all.val06, all.val07, all.val08, all.val09, all.val10,...
                                                 all.val11, all.val12, all.val13, all.val14, all.val15];
% col01 = rand5: Luminance of the reference (1 = isoluminant; 2 = non-isoluminant)
% col02 = mean performance
% col03 = sensitivity
% col04 = number of trials
% col05 = saccade latency
% col06 = saccade amplitude
% col07 = saccade duration
% col08 = ref duration
% col09 = gap duration
% col10 = probe onset relative to sac offset
% col11 = threshold
% col12 = jnd
% col13 = pDev
% col14 = bias
% col15 = jnd bias
% col16 = pDev bias


%% Extractor of luminance of probe effects
thCol               = 2;    % fitted data threshold
jndCol            = 4;    % fitted data jnd
pDevCol             = 7;    % fitted data pDev

all.varTab  = []; all.val01   = [];
all.val02   = []; all.val03   = [];
all.val04   = []; all.val05   = [];
all.val06   = []; all.val07   = [];
all.val08   = []; all.val09   = [];
all.val10   = []; all.val11   = [];
all.val12   = []; all.val13   = [];
all.val14   = []; all.val15   = [];

for rand6 = 1:nb.rand6
    index.rand6     = fileRes(:,rand6Col) == rand6;
    allData         = fileRes(index.rand6,:);
    allDataFit      = thSaveLumProbe(thSaveLumProbe(:,1) == rand6,:);
    allDataFitBias  = thSaveLumProbeBias(thSaveLumProbeBias(:,1) == rand6,:);
    
    val01_data = allData(:,corResCol);          % mean performance
    val02_data = allData(:,corResCol);          % sensitivity
    val03_data = allData(:,corResCol);          % number of trials
    val04_data = allData(:,sacLatCol);          % saccade latency
    val05_data = allData(:,sacAmpCol);          % saccade amplitude
    val06_data = allData(:,sacDurCol);          % saccade duration
    val07_data = allData(:,refDurCol);          % ref duration
    val08_data = allData(:,gapDurCol);          % gap duration
    val09_data = allData(:,probeOnSacOffCol);   % probe onset relative to sac offset
    val10_data = allDataFit(:,thCol);           % threshold
    val11_data = allDataFit(:,jndCol);          % jnd
    val12_data = allDataFit(:,pDevCol);         % pDev
    val13_data = allDataFitBias(:,thCol);       % threshold
    val14_data = allDataFitBias(:,jndCol);      % jnd
    val15_data = allDataFitBias(:,pDevCol);     % pDev
    
    if isempty(val01_data)
        varTab  =   rand6;
        val01   =   NaN;    val02   =   NaN;
        val03   =   NaN;    val04   =   NaN;
        val05   =   NaN;    val06   =   NaN;
        val07   =   NaN;	val08   =   NaN;
        val09   =   NaN;	val10   =   NaN;
        val11   =   NaN;    val12   =   NaN;
        val13   =   NaN;    val14   =   NaN;
        val15   =   NaN;
    else
        varTab  =   nanmean(allData(:,rand6Col),1);
        val01   =   nanmean(val01_data);
        val02   =   d2afcSDT(nanmean(val02_data));
        val03   =   numel(val03_data);
        val04   =   nanmean(val04_data);
        val05   =   nanmean(val05_data);
        val06   =   nanmean(val06_data);
        val07   =   nanmean(val07_data);
        val08   =   nanmean(val08_data);
        val09   =   nanmean(val09_data);
        val10   =   val10_data;
        val11   =   val11_data;
        val12   =   val12_data;
        val13   =   val13_data;
        val14   =   val14_data;
        val15   =   val15_data;
    end
    all.varTab      =   [all.varTab;    varTab  ];
    all.val01       =   [all.val01;     val01  	];
    all.val02       =   [all.val02;     val02	];
    all.val03       =   [all.val03;     val03	];
    all.val04       =   [all.val04;     val04	];
    all.val05       =   [all.val05;     val05	];
    all.val06       =   [all.val06;     val06	];
    all.val07       =   [all.val07;     val07	];
    all.val08       =   [all.val08;     val08	];
    all.val09       =   [all.val09;     val09	];
    all.val10       =   [all.val10;     val10	];
    all.val11       =   [all.val11;     val11	];
    all.val12       =   [all.val12;     val12	];
    all.val13       =   [all.val13;     val13	];
    all.val14       =   [all.val14;     val14	];
    all.val15       =   [all.val15;     val15	];
end
configEyeAll{end}.tabResLumProbeAll = [all.varTab, all.val01, all.val02, all.val03, all.val04, all.val05,...
                                                   all.val06, all.val07, all.val08, all.val09, all.val10,...
                                                   all.val11, all.val12, all.val13, all.val14, all.val15];
% col01 = rand6: Luminance of the probe (1 = isoluminant; 2 = non-isoluminant)
% col02 = mean performance
% col03 = sensitivity
% col04 = number of trials
% col05 = saccade latency
% col06 = saccade amplitude
% col07 = saccade duration
% col08 = ref duration
% col09 = gap duration
% col10 = probe onset relative to sac offset
% col11 = threshold
% col12 = jnd
% col13 = pDev
% col14 = bias
% col15 = jnd bias
% col16 = pDev bias


%% Extractor of gap effect depending on luminance of the reference
thCol               = 3;    % fitted data threshold
jndCol              = 5;    % fitted data jnd
pDevCol             = 8;    % fitted data pDev

all.varTab  = []; all.val01   = [];
all.val02   = []; all.val03   = [];
all.val04   = []; all.val05   = [];
all.val06   = []; all.val07   = [];
all.val08   = []; all.val09   = [];
all.val10   = []; all.val11   = [];
all.val12   = []; all.val13   = [];
all.val14   = []; all.val15   = [];

for rand5 = 1:nb.rand5                              % Luminance of the reference
    index.rand5 = fileRes(:,rand5Col) == rand5;
    
    for rand7 = 1:nb.rand7                          % Post-Saccadic Gap duration
        index.rand7 = fileRes(:,rand7Col) == rand7;
        
        allData         = fileRes(index.rand5 & index.rand7,:);
        allDataFit      = thSaveGapRef(thSaveGapRef(:,1) == rand5 & thSaveGapRef(:,2) == rand7,:);
        allDataFitBias  = thSaveGapRefBias(thSaveGapRefBias(:,1) == rand5 & thSaveGapRefBias(:,2) == rand7,:);
        
        val01_data = allData(:,corResCol);          % mean performance
        val02_data = allData(:,corResCol);          % sensitivity
        val03_data = allData(:,corResCol);          % number of trials
        val04_data = allData(:,sacLatCol);          % saccade latency
        val05_data = allData(:,sacAmpCol);          % saccade amplitude
        val06_data = allData(:,sacDurCol);          % saccade duration
        val07_data = allData(:,refDurCol);          % ref duration
        val08_data = allData(:,gapDurCol);          % gap duration
        val09_data = allData(:,probeOnSacOffCol);   % probe onset relative to sac offset
        val10_data = allDataFit(:,thCol);           % threshold
        val11_data = allDataFit(:,jndCol);          % jnd
        val12_data = allDataFit(:,pDevCol);         % pDev
        val13_data = allDataFitBias(:,thCol);       % threshold
        val14_data = allDataFitBias(:,jndCol);      % jnd
        val15_data = allDataFitBias(:,pDevCol);     % pDev
        
        
        if isempty(val01_data)
            varTab  =   [rand5,rand7];
            val01   =   NaN;    val02   =   NaN;
            val03   =   NaN;    val04   =   NaN;
            val05   =   NaN;    val06   =   NaN;
            val07   =   NaN;	val08   =   NaN;
            val09   =   NaN;	val10   =   NaN;
            val11   =   NaN;    val12   =   NaN;
            val13   =   NaN;    val14   =   NaN;
            val15   =   NaN;
        else
            varTab  =   nanmean([allData(:,rand5Col),allData(:,rand7Col)],1);
            val01   =   nanmean(val01_data);
            val02   =   d2afcSDT(nanmean(val02_data));
            val03   =   numel(val03_data);
            val04   =   nanmean(val04_data);
            val05   =   nanmean(val05_data);
            val06   =   nanmean(val06_data);
            val07   =   nanmean(val07_data);
            val08   =   nanmean(val08_data);
            val09   =   nanmean(val09_data);
            val10   =   val10_data;
            val11   =   val11_data;
            val12   =   val12_data;
            val13   =   val13_data;
            val14   =   val14_data;
            val15   =   val15_data;
        end
        all.varTab      =   [all.varTab;    varTab  ];
        all.val01       =   [all.val01;     val01  	];
        all.val02       =   [all.val02;     val02	];
        all.val03       =   [all.val03;     val03	];
        all.val04       =   [all.val04;     val04	];
        all.val05       =   [all.val05;     val05	];
        all.val06       =   [all.val06;     val06	];
        all.val07       =   [all.val07;     val07	];
        all.val08       =   [all.val08;     val08	];
        all.val09       =   [all.val09;     val09	];
        all.val10       =   [all.val10;     val10	];
        all.val11       =   [all.val11;     val11	];
        all.val12       =   [all.val12;     val12	];
        all.val13       =   [all.val13;     val13	];
        all.val14       =   [all.val14;     val14	];
        all.val15       =   [all.val15;     val15	];
    end
end
configEyeAll{end}.tabResGapRefAll = [all.varTab, all.val01, all.val02, all.val03, all.val04, all.val05,...
                                                 all.val06, all.val07, all.val08, all.val09, all.val10,...
                                                 all.val11, all.val12, all.val13, all.val14, all.val15];
% col01 = rand5: Luminance of the reference (1 = isoluminant; 2 = non-isoluminant)
% col02 = rand7: Post-saccadic gap duration (1 = 0 ms; 2 = 200 ms)
% col03 = mean performance
% col04 = sensitivity
% col05 = number of trials
% col06 = saccade latency
% col07 = saccade amplitude
% col08 = saccade duration
% col09 = ref duration
% col10 = gap duration
% col11 = probe onset relative to sac offset
% col12 = threshold
% col13 = jnd
% col14 = pDev
% col15 = bias
% col16 = jnd bias
% col17 = pDev bias

%% Extractor of gap effect depending on luminance of the probe
thCol               = 3;    % fitted data threshold
jndCol              = 5;    % fitted data jnd
pDevCol             = 8;    % fitted data pDev

all.varTab  = []; all.val01   = [];
all.val02   = []; all.val03   = [];
all.val04   = []; all.val05   = [];
all.val06   = []; all.val07   = [];
all.val08   = []; all.val09   = [];
all.val10   = []; all.val11   = [];
all.val12   = []; all.val13   = [];
all.val14   = []; all.val15   = [];

for rand6 = 1:nb.rand6                              % Luminance of the reference
    index.rand6 = fileRes(:,rand6Col) == rand6;
    
    for rand7 = 1:nb.rand7                          % Post-Saccadic Gap duration
        index.rand7 = fileRes(:,rand7Col) == rand7;
        
        allData         = fileRes(index.rand6 & index.rand7,:);
        allDataFit      = thSaveGapProbe(thSaveGapProbe(:,1) == rand6 & thSaveGapProbe(:,2) == rand7,:);
        allDataFitBias  = thSaveGapProbeBias(thSaveGapProbeBias(:,1) == rand6 & thSaveGapProbeBias(:,2) == rand7,:);
        
        val01_data = allData(:,corResCol);          % mean performance
        val02_data = allData(:,corResCol);          % sensitivity
        val03_data = allData(:,corResCol);          % number of trials
        val04_data = allData(:,sacLatCol);          % saccade latency
        val05_data = allData(:,sacAmpCol);          % saccade amplitude
        val06_data = allData(:,sacDurCol);          % saccade duration
        val07_data = allData(:,refDurCol);          % ref duration
        val08_data = allData(:,gapDurCol);          % gap duration
        val09_data = allData(:,probeOnSacOffCol);   % probe onset relative to sac offset
        val10_data = allDataFit(:,thCol);           % threshold
        val11_data = allDataFit(:,jndCol);          % jnd
        val12_data = allDataFit(:,pDevCol);         % pDev
        val13_data = allDataFitBias(:,thCol);       % threshold
        val14_data = allDataFitBias(:,jndCol);      % jnd
        val15_data = allDataFitBias(:,pDevCol);     % pDev
        
        if isempty(val01_data)
            varTab  =   [rand6,rand7];
            val01   =   NaN;    val02   =   NaN;
            val03   =   NaN;    val04   =   NaN;
            val05   =   NaN;    val06   =   NaN;
            val07   =   NaN;	val08   =   NaN;
            val09   =   NaN;	val10   =   NaN;
            val11   =   NaN;    val12   =   NaN;
            val13   =   NaN;    val14   =   NaN;
            val15   =   NaN;
        else
            varTab  =   nanmean([allData(:,rand6Col),allData(:,rand7Col)],1);
            val01   =   nanmean(val01_data);
            val02   =   d2afcSDT(nanmean(val02_data));
            val03   =   numel(val03_data);
            val04   =   nanmean(val04_data);
            val05   =   nanmean(val05_data);
            val06   =   nanmean(val06_data);
            val07   =   nanmean(val07_data);
            val08   =   nanmean(val08_data);
            val09   =   nanmean(val09_data);
            val10   =   val10_data;
            val11   =   val11_data;
            val12   =   val12_data;
            val13   =   val13_data;
            val14   =   val14_data;
            val15   =   val15_data;
        end
        all.varTab      =   [all.varTab;    varTab  ];
        all.val01       =   [all.val01;     val01  	];
        all.val02       =   [all.val02;     val02	];
        all.val03       =   [all.val03;     val03	];
        all.val04       =   [all.val04;     val04	];
        all.val05       =   [all.val05;     val05	];
        all.val06       =   [all.val06;     val06	];
        all.val07       =   [all.val07;     val07	];
        all.val08       =   [all.val08;     val08	];
        all.val09       =   [all.val09;     val09	];
        all.val10       =   [all.val10;     val10	];
        all.val11       =   [all.val11;     val11	];
        all.val12       =   [all.val12;     val12	];
        all.val13       =   [all.val13;     val13	];
        all.val14       =   [all.val14;     val14	];
        all.val15       =   [all.val15;     val15	];
    end
end
configEyeAll{end}.tabResGapProbeAll = [all.varTab, all.val01, all.val02, all.val03, all.val04, all.val05,...
                                                   all.val06, all.val07, all.val08, all.val09, all.val10,...
                                                   all.val11, all.val12, all.val13, all.val14, all.val15];
% col01 = rand5: Luminance of the reference (1 = isoluminant; 2 = non-isoluminant)
% col02 = rand7: Post-saccadic gap duration (1 = 0 ms; 2 = 200 ms)
% col03 = mean performance
% col04 = sensitivity
% col05 = number of trials
% col06 = saccade latency
% col07 = saccade amplitude
% col08 = saccade duration
% col09 = ref duration
% col10 = gap duration
% col11 = probe onset relative to sac offset
% col12 = threshold
% col13 = jnd
% col14 = pDev
% col15 = bias
% col16 = jnd bias
% col17 = pDev bias

%% Extractor of condition effect
thCol               = 3;    % fitted data threshold
jndCol              = 5;    % fitted data jnd
pDevCol             = 8;    % fitted data pDev

all.varTab  = []; all.val01   = [];
all.val02   = []; all.val03   = [];
all.val04   = []; all.val05   = [];
all.val06   = []; all.val07   = [];
all.val08   = []; all.val09   = [];
all.val10   = []; all.val11   = [];
all.val12   = []; all.val13   = [];
all.val14   = []; all.val15   = [];

for rand5 = 1:nb.rand5
    index.rand5 = fileRes(:,rand5Col) == rand5;
    
    for rand6 = 1:nb.rand6
        index.rand6 = fileRes(:,rand6Col) == rand6;
        
        allData         = fileRes(index.rand5 & index.rand6,:);
        allDataFit      = thSaveCond(thSaveCond(:,1) == rand5 & thSaveCond(:,2) == rand6,:);
        allDataFitBias  = thSaveCondBias(thSaveCondBias(:,1) == rand5 & thSaveCondBias(:,2) == rand6,:);
        
        val01_data = allData(:,corResCol);          % mean performance
        val02_data = allData(:,corResCol);          % sensitivity
        val03_data = allData(:,corResCol);          % number of trials
        val04_data = allData(:,sacLatCol);          % saccade latency
        val05_data = allData(:,sacAmpCol);          % saccade amplitude
        val06_data = allData(:,sacDurCol);          % saccade duration
        val07_data = allData(:,refDurCol);          % ref duration
        val08_data = allData(:,gapDurCol);          % gap duration
        val09_data = allData(:,probeOnSacOffCol);   % probe onset relative to sac offset
        val10_data = allDataFit(:,thCol);           % threshold
        val11_data = allDataFit(:,jndCol);          % jnd
        val12_data = allDataFit(:,pDevCol);         % pDev
        val13_data = allDataFitBias(:,thCol);       % threshold
        val14_data = allDataFitBias(:,jndCol);      % jnd
        val15_data = allDataFitBias(:,pDevCol);     % pDev
        
        if isempty(val01_data)
            varTab  =   [rand5,rand6];
            val01   =   NaN;    val02   =   NaN;
            val03   =   NaN;    val04   =   NaN;
            val05   =   NaN;    val06   =   NaN;
            val07   =   NaN;	val08   =   NaN;
            val09   =   NaN;	val10   =   NaN;
            val11   =   NaN;    val12   =   NaN;
            val13   =   NaN;    val14   =   NaN;
            val15   =   NaN;
        else
            varTab  =   nanmean([allData(:,rand5Col),allData(:,rand6Col)],1);
            val01   =   nanmean(val01_data);
            val02   =   d2afcSDT(nanmean(val02_data));
            val03   =   numel(val03_data);
            val04   =   nanmean(val04_data);
            val05   =   nanmean(val05_data);
            val06   =   nanmean(val06_data);
            val07   =   nanmean(val07_data);
            val08   =   nanmean(val08_data);
            val09   =   nanmean(val09_data);
            val10   =   val10_data;
            val11   =   val11_data;
            val12   =   val12_data;
            val13   =   val13_data;
            val14   =   val14_data;
            val15   =   val15_data;
        end
        all.varTab      =   [all.varTab;    varTab  ];
        all.val01       =   [all.val01;     val01  	];
        all.val02       =   [all.val02;     val02	];
        all.val03       =   [all.val03;     val03	];
        all.val04       =   [all.val04;     val04	];
        all.val05       =   [all.val05;     val05	];
        all.val06       =   [all.val06;     val06	];
        all.val07       =   [all.val07;     val07	];
        all.val08       =   [all.val08;     val08	];
        all.val09       =   [all.val09;     val09	];
        all.val10       =   [all.val10;     val10	];
        all.val11       =   [all.val11;     val11	];
        all.val12       =   [all.val12;     val12	];
        all.val13       =   [all.val13;     val13	];
        all.val14       =   [all.val14;     val14	];
        all.val15       =   [all.val15;     val15	];
    end
end
configEyeAll{end}.tabResCondAll = [all.varTab, all.val01, all.val02, all.val03, all.val04, all.val05,...
                                               all.val06, all.val07, all.val08, all.val09, all.val10,...
                                               all.val11, all.val12, all.val13, all.val14, all.val15];
% col01 = rand5: Luminance of the reference (1 = isoluminant; 2 = non-isoluminant)
% col02 = rand6: Luminance of the probe (1 = isoluminant; 2 = non-isoluminant)
% col03 = mean performance
% col04 = sensitivity
% col05 = number of trials
% col06 = saccade latency
% col07 = saccade amplitude
% col08 = saccade duration
% col09 = ref duration
% col10 = gap duration
% col11 = probe onset relative to sac offset
% col12 = threshold
% col13 = jnd
% col14 = pDev
% col15 = bias
% col16 = jnd bias
% col17 = pDev bias

% Save all matrix
% ---------------
save(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini),'configEyeAll');

end