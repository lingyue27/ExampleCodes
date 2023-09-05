function drawStats(sub)
% ----------------------------------------------------------------------
% drawStats(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw comparisons and statitistics
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject configuration
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Data saved :
% PDF files containing each results
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 14 / 03 / 2016
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

close all
fprintf(1,'\n\t>> Drawing results [IN PROGRESS]...\n');

% load data
load(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini));
if strcmp(sub.ini,'ALL');
    figSet.showStats        = 1; 
else
    figSet.showStats        = 0; 
end

% Plot settings
% -------------
% figure size
figSet.numRow               = 3;
figSet.numColumn            = 5;
figSize_X                   = 350*figSet.numColumn;
figSize_Y                   = 250*figSet.numRow;
start_X                     = 0;
start_Y                     = 0;
paperSize                   = [figSize_X/30,figSize_Y/30];
paperPos                    = [0 0 paperSize(1) paperSize(2)];

% colors
figSet.beige                = [245,241,237]/255;
figSet.purple               = [104/255 45/255 139/255];
figSet.gray30               = [.3,.3,.3];
figSet.gray50               = [.5,.5,.5];
figSet.gray60               = [.6,.6,.6];
figSet.gray70               = [.7,.7,.7];
figSet.white                = [1 1 1];
figSet.red                  = [239, 15  47]/255;
figSet.blue                 = [ 54, 98,160]/255;
figSet.green                = [  0,150, 64]/255;
figSet.black                = [0,0,0];

% figure settings
figSet.fontName             = 'Myriad Pro';
figSet.legFontSize          = 6;
figSet.tickFontSize         = 8;
figSet.labelFontSize        = 10;
figSet.axisWidth            = 1;
figSet.area_bg              = figSet.beige;
figSet.starSizeVal          = linspace(0,7,5);
figSet.markerSize           = 12;
figSet.ebWidth              = 1.5;

% Drawing loop
% ------------
for tPlot = 1:10
    
    % Define figure type of plot
    switch tPlot
        case 1                                          
            % luminance/gap effects
            dataMat             = configEyeAll{end}.tabResMainAll;
            if figSet.showStats 
                dataMat_Stats   = configEyeAll{end}.tabResMainAll_stats;
            end
            save_end_txt        = '_ResAll';
            figSet.leg          = 1;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {'Gap 0 ms','Gap 200 ms'};                % legend text
            figSet.yTickNameL1  = {'Iso.','Iso.','Non-iso.','Non-iso.'};    % y axis tick name, line 1
            figSet.yTickNameL2  = {'Iso.','Non-iso.','Iso.','Non-iso.'};    % y axis tick name, line 2
            figSet.colPlot1     = figSet.red;                               % color legend value 1
            figSet.colPlot2     = figSet.blue;                              % color legend value 2
            figSet.draw2Values  = 0;                                        % compare two values only (1) = Yes; (0) = No
        case 2                                          
            % overall gap effect
            dataMat             = configEyeAll{end}.tabResGapAll;
            if figSet.showStats
                dataMat_Stats   = configEyeAll{end}.tabResGapAll_stats;
            end
            save_end_txt        = '_ResGap';
            figSet.leg          = 0;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {};                                       % legend text
            figSet.yTickNameL1  = {'Gap 0 ms','Gap 200 ms'};                % y axis tick name, line 1
            figSet.yTickNameL2  = {};                                       % y axis tick name, line 2
            figSet.colPlot1     = figSet.purple;                            % color legend value 1
            figSet.draw2Values  = 1;                                        % compare two values only (1) = Yes; (0) = No
        case 3                                          
            % congurency effect
            dataMat             = configEyeAll{end}.tabResCongAll;
            if figSet.showStats
                dataMat_Stats   = configEyeAll{end}.tabResCongAll_stats;
            end
            save_end_txt        = '_ResCong';
            figSet.leg          = 0;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {};                                       % legend text
            figSet.yTickNameL1  = {'Congruent','Incongruent'};              % y axis tick name, line 1
            figSet.yTickNameL2  = {};                                       % y axis tick name, line 2
            figSet.colPlot1     = figSet.green;                             % color legend value 1
            figSet.draw2Values  = 1;                                        % compare two values only (1) = Yes; (0) = No
        case 4                                          
            % Reference luminance effect
            dataMat             = configEyeAll{end}.tabResLumRefAll;
            if figSet.showStats
                dataMat_Stats   = configEyeAll{end}.tabResLumRefAll_stats;
            end
            save_end_txt        = '_LumRef';
            figSet.leg          = 0;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {};                                       % legend text
            figSet.yTickNameL1  = {'Iso.','Non-iso.'};                      % y axis tick name, line 1
            figSet.yTickNameL2  = {'Iso. + non-iso','Iso. + non-iso.'};     % y axis tick name, line 2
            figSet.colPlot1     = figSet.purple;                             % color legend value 1
            figSet.draw2Values  = 1;                                        % compare two values only (1) = Yes; (0) = No
        case 5                                          
            % Probe luminance effect
            dataMat             = configEyeAll{end}.tabResLumProbeAll; 
            if figSet.showStats
                dataMat_Stats   = configEyeAll{end}.tabResLumProbeAll_stats;
            end
            save_end_txt        = '_LumProbe';
            figSet.leg          = 0;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {};                                       % legend text
            figSet.yTickNameL1  = {'Iso. + non-iso','Iso. + non-iso.'};     % y axis tick name, line 1
            figSet.yTickNameL2  = {'Iso.','Non-iso.'};                      % y axis tick name, line 2
            figSet.colPlot1     = figSet.purple;                             % color legend value 1
            figSet.draw2Values  = 1;                                        % compare two values only (1) = Yes; (0) = No
        case 6                                          
            % Reference gap effect
            dataMat             = configEyeAll{end}.tabResGapRefAll;
            if figSet.showStats
                dataMat_Stats   = configEyeAll{end}.tabResGapRefAll_stats;
            end
            save_end_txt        = '_GapRef';
            figSet.leg          = 1;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {'Gap 0 ms','Gap 200 ms'};                % legend text
            figSet.yTickNameL1  = {'Iso.','Non-iso.'};                      % y axis tick name, line 1
            figSet.yTickNameL2  = {'Iso. + non-iso','Iso. + non-iso.'};     % y axis tick name, line 2
            figSet.colPlot1     = figSet.red;                               % color legend value 1
            figSet.colPlot2     = figSet.blue;                              % color legend value 2
            figSet.draw2Values  = 0;                                        % compare two values only (1) = Yes; (0) = No
        case 7                                          
            % Probe gap effect
            dataMat             = configEyeAll{end}.tabResGapProbeAll;
            if figSet.showStats
                dataMat_Stats   = configEyeAll{end}.tabResGapProbeAll_stats;
            end
            save_end_txt        = '_GapProbe';
            figSet.leg          = 1;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {'Gap 0 ms','Gap 200 ms'};                % legend text
            figSet.yTickNameL1  = {'Iso. + non-iso','Iso. + non-iso.'};     % y axis tick name, line 1
            figSet.yTickNameL2  = {'Iso.','Non-iso.'};                      % y axis tick name, line 2
            figSet.colPlot1     = figSet.red;                               % color legend value 1
            figSet.colPlot2     = figSet.blue;                              % color legend value 2
            figSet.draw2Values  = 0;                                        % compare two values only (1) = Yes; (0) = No
        case 8
            % Condition effect
            dataMat             = configEyeAll{end}.tabResCondAll;
            if figSet.showStats
                dataMat_Stats   = configEyeAll{end}.tabResCondAll_stats;
            end
            save_end_txt        = '_Cond';
            figSet.leg          = 0;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {};                                       % legend text
            figSet.yTickNameL1  = {'Iso.','Iso.','Non-iso.','Non-iso.'};    % y axis tick name, line 1
            figSet.yTickNameL2  = {'Iso.','Non-iso.','Iso.','Non-iso.'};    % y axis tick name, line 2
            figSet.colPlot1     = figSet.purple;                             % color legend value 1
            figSet.draw2Values  = 1;                                        % compare two values only (1) = Yes; (0) = No
        case 9
            % Condition effect / gap 0
            dataMat             = configEyeAll{end}.tabResMainAll;
            if figSet.showStats 
                dataMat_Stats   = configEyeAll{end}.tabResCondGap0All_stats;
            end
            save_end_txt        = '_CondGap0';
            figSet.leg          = 0;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {};                                       % legend text
            figSet.yTickNameL1  = {'Iso.','Iso.','Non-iso.','Non-iso.'};    % y axis tick name, line 1
            figSet.yTickNameL2  = {'Iso.','Non-iso.','Iso.','Non-iso.'};    % y axis tick name, line 2
            figSet.colPlot1     = figSet.red;                               % color legend value 1
            figSet.draw2Values  = 1;                                        % compare two values only (1) = Yes; (0) = No
        case 10
            % Condition effect / gap 0
            dataMat             = configEyeAll{end}.tabResMainAll;
            if figSet.showStats 
                dataMat_Stats   = configEyeAll{end}.tabResCondGap200All_stats;
            end
            save_end_txt        = '_CondGap200';
            figSet.leg          = 0;                                        % use of legend (1) = Yes; (0) = No
            figSet.legTxt       = {};                                       % legend text
            figSet.yTickNameL1  = {'Iso.','Iso.','Non-iso.','Non-iso.'};    % y axis tick name, line 1
            figSet.yTickNameL2  = {'Iso.','Non-iso.','Iso.','Non-iso.'};    % y axis tick name, line 2
            figSet.colPlot1     = figSet.blue;                              % color legend value 1
            figSet.draw2Values  = 1;                                        % compare two values only (1) = Yes; (0) = No
    end
    
    % Create figure
    f(tPlot)                = figure;
    set(f(tPlot),'Name','Statistics','PaperUnits','centimeters','PaperPosition',paperPos,'Color',[1 1 1],'PaperSize',paperSize);
    set(f(tPlot),'Position',[start_X,start_Y,figSize_X,figSize_Y]);
    fileDir                 = sprintf('%s/',sub.all_blockDir);
    fileName                = sprintf('%s%s',sub.ini,save_end_txt);

    % Define columns/rows
    tSubPlot = 0;
    for tCol = 1:figSet.numColumn;
        for tRow = 1:figSet.numRow
            tSubPlot = tSubPlot + 1;
            switch tSubPlot
                case 1
                    figSet.minScale             = 0;
                    figSet.maxScale             = 15;
                    figSet.tickNum              = 4;
                    figSet.unitTxt              = 'Angle change (deg)';
                    figSet.tickType             = 2;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Threshold';
                    figSet.colRes               = [13;11;11;11;11;12;12;12;13;13];
                case 2
                    figSet.minScale             = 0;
                    figSet.maxScale             = 15;
                    figSet.tickNum              = 4;
                    figSet.unitTxt              = 'JND (deg)';
                    figSet.tickType             = 2;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'JND';
                    figSet.colRes               = [14;12;12;12;12;13;13;13;14;14];
                case 3
                    figSet.minScale             = 0;
                    figSet.maxScale             = 1;
                    figSet.tickNum              = 5;
                    figSet.unitTxt              = 'pDev (%)';
                    figSet.tickType             = 2;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Goodness of fit';
                    figSet.colRes               = [15;13;13;13;13;14;14;14;15;15];
                case 4
                    figSet.minScale             = 0.5;
                    figSet.maxScale             = 1;
                    figSet.unitTxt              = 'Perf. (%)';
                    figSet.tickNum              = 6;
                    figSet.tickType             = 2;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Performance';
                    figSet.colRes               = [04;02;02;02;02;03;03;03;04;04];
                case 5
                    if strcmp(sub.ini,'ALL');
                        figSet.minScale             = 0;
                        figSet.maxScale             = 2;
                    else
                        figSet.minScale             = -1;
                        figSet.maxScale             = 4;
                    end
                    figSet.tickNum              = 6;
                    figSet.unitTxt              = 'd''';
                    figSet.tickType             = 1;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Sensitivity';
                    figSet.colRes               = [05;03;03;03;03;04;04;04;05;05];
                case 6
                    figSet.minScale             = 0;
                    if tPlot == 1
                        figSet.maxScale             = 300;
                        figSet.tickNum              = 4;
                    elseif tPlot >= 2 && tPlot <= 5
                        figSet.maxScale             = 800;
                        figSet.tickNum              = 5;
                    elseif tPlot >= 6 && tPlot <= 7
                        figSet.maxScale             = 600;
                        figSet.tickNum              = 4;
                    elseif tPlot == 8
                        figSet.maxScale             = 600;
                        figSet.tickNum              = 4;
                    elseif tPlot >= 9 && tPlot <= 10
                        figSet.maxScale             = 300;
                        figSet.tickNum              = 4;
                    end
                    figSet.unitTxt              = '# Trials';
                    figSet.tickType             = 2;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Trial number';
                    figSet.colRes               = [06;04;04;04;04;05;05;05;06;06];
                case 7
                    if strcmp(sub.ini,'ALL');
                        figSet.minScale             = 125;
                        figSet.maxScale             = 225;
                        figSet.tickNum              = 5;
                    else
                        figSet.minScale             = 100;
                        figSet.maxScale             = 300;
                        figSet.tickNum              = 6;
                    end
                    figSet.unitTxt              = 'Duration (ms)';
                    
                    figSet.tickType             = 1;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Saccade latency';
                    figSet.colRes               = [07;05;05;05;05;06;06;06;07;07];
                case 8
                    figSet.minScale             = 7.5;
                    figSet.maxScale             = 8.5;
                    figSet.unitTxt              = 'Amplitude (deg)';
                    figSet.tickNum              = 5;
                    figSet.tickType             = 1;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Saccade amplitude';
                    figSet.colRes               = [08;06;06;06;06;07;07;07;08;08];
                case 9
                    figSet.minScale             = 30;
                    figSet.maxScale             = 60;
                    figSet.unitTxt              = 'Duration (ms)';
                    figSet.tickNum              = 4;
                    figSet.tickType             = 1;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Saccade duration';
                    figSet.colRes               = [09;07;07;07;07;08;08;08;09;09];
                case 10
                    figSet.minScale             = 100;
                    figSet.maxScale             = 250;
                    figSet.unitTxt              = 'Duration (ms)';
                    figSet.tickNum              = 7;
                    figSet.tickType             = 1;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Reference duration';
                    figSet.colRes               = [10;08;08;08;08;09;09;09;10;10];
                case 11
                    figSet.minScale             = -150;
                    figSet.maxScale             = 250;
                    figSet.unitTxt              = 'Duration (ms)';
                    figSet.tickNum              = 9;
                    figSet.tickType             = 1;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Gap duration';
                    figSet.colRes               = [11;09;09;09;09;10;10;10;11;11];
                case 12
                    figSet.minScale             = -150;
                    figSet.maxScale             = 250;
                    figSet.unitTxt              = 'Duration (ms)';
                    figSet.tickNum              = 9;
                    figSet.tickType             = 1;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Probe rel. to saccade offset';
                    figSet.colRes               = [12;10;10;10;10;11;11;11;12;12];
                case 13
                    figSet.minScale             = -10;
                    figSet.maxScale             = 10;
                    figSet.tickNum              = 5;
                    figSet.unitTxt              = 'Bias (deg)';
                    figSet.tickType             = 2;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Bias';
                    figSet.colRes               = [16;14;14;14;14;15;15;15;16;16];
                case 14
                    figSet.minScale             = 0;
                    figSet.maxScale             = 30;
                    figSet.tickNum              = 7;
                    figSet.unitTxt              = 'JND bias (deg)';
                    figSet.tickType             = 2;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'JND bias';
                    figSet.colRes               = [17;15;15;15;15;16;16;16;17;17];
                case 15
                    figSet.minScale             = 0;
                    figSet.maxScale             = 1;
                    figSet.tickNum              = 5;
                    figSet.unitTxt              = 'pDev bias (%)';
                    figSet.tickType             = 2;
                    figSet.drawResSingle        = 1;
                    figSet.textPlot             = 'Goodness of fit bias';
                    figSet.colRes               = [18;16;16;16;16;17;17;17;18;18];
            end
            
            % suplot
            x_start             = (tCol-1)/figSet.numColumn;
            y_start             = (figSet.numRow-tRow)/figSet.numRow;
            x_size              = 1/figSet.numColumn;
            y_size              = 1/figSet.numRow;
            axes('position',[x_start,y_start,x_size,y_size]);
            hold on
            
            % determine data to plot
            if tPlot == 1
                figSet.yPlot1 = dataMat(dataMat(:,3) == 1,figSet.colRes(tPlot));
                figSet.yPlot2 = dataMat(dataMat(:,3) == 2,figSet.colRes(tPlot));
                
                if figSet.showStats
                    figSet.yPlot1_eb_min = dataMat_Stats{figSet.colRes(tPlot)}(:,4);
                    figSet.yPlot1_eb_max = dataMat_Stats{figSet.colRes(tPlot)}(:,5);
                    figSet.yPlot2_eb_min = dataMat_Stats{figSet.colRes(tPlot)}(:,7);
                    figSet.yPlot2_eb_max = dataMat_Stats{figSet.colRes(tPlot)}(:,8);
                    figSet.starRes = dataMat_Stats{figSet.colRes(tPlot)}(:,10);
                    figSet.starComp = [];
                end
                
            elseif tPlot >= 2 && tPlot <= 5
                figSet.yPlot1 = dataMat(:,figSet.colRes(tPlot));
                figSet.yPlot2 = [];
                
                if figSet.showStats
                    figSet.yPlot1_eb_min = dataMat_Stats{figSet.colRes(tPlot)}(:,[4,7]);
                    figSet.yPlot1_eb_max = dataMat_Stats{figSet.colRes(tPlot)}(:,[5,8]);
                    figSet.yPlot2_eb_min = [];
                    figSet.yPlot2_eb_max = [];
                    figSet.starRes = dataMat_Stats{figSet.colRes(tPlot)}(:,10);
                    figSet.starComp = [];
                end
            elseif tPlot >= 6 && tPlot <= 7
                figSet.yPlot1 = dataMat(dataMat(:,2) == 1,figSet.colRes(tPlot));
                figSet.yPlot2 = dataMat(dataMat(:,2) == 2,figSet.colRes(tPlot));
                if figSet.showStats
                    figSet.yPlot1_eb_min = dataMat_Stats{figSet.colRes(tPlot)}(:,4);
                    figSet.yPlot1_eb_max = dataMat_Stats{figSet.colRes(tPlot)}(:,5);
                    figSet.yPlot2_eb_min = dataMat_Stats{figSet.colRes(tPlot)}(:,7);
                    figSet.yPlot2_eb_max = dataMat_Stats{figSet.colRes(tPlot)}(:,8);
                    figSet.starRes = dataMat_Stats{figSet.colRes(tPlot)}(:,10);
                    figSet.starComp = [];
                end
            elseif tPlot == 8 
                figSet.yPlot1 = dataMat(:,figSet.colRes(tPlot));
                figSet.yPlot2 = [];
                if figSet.showStats
                    figSet.yPlot1_eb_min = [dataMat_Stats{figSet.colRes(tPlot)}(1,4),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(1,7),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(2,7),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(3,7)];
                    figSet.yPlot1_eb_max = [dataMat_Stats{figSet.colRes(tPlot)}(1,5),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(1,8),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(2,8),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(3,8)];
                    figSet.yPlot2_eb_min = [];
                    figSet.yPlot2_eb_max = [];
                    figSet.starRes = dataMat_Stats{figSet.colRes(tPlot)}(:,10);
                    figSet.starComp = dataMat_Stats{figSet.colRes(tPlot)}(:,1:2);
                end
            elseif tPlot == 9
                figSet.yPlot1 = dataMat(dataMat(:,3) == 1,figSet.colRes(tPlot));
                figSet.yPlot2 = [];
                if figSet.showStats
                    figSet.yPlot1_eb_min = [dataMat_Stats{figSet.colRes(tPlot)}(1,4),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(1,7),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(2,7),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(3,7)];
                    figSet.yPlot1_eb_max = [dataMat_Stats{figSet.colRes(tPlot)}(1,5),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(1,8),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(2,8),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(3,8)];
                    figSet.yPlot2_eb_min = [];
                    figSet.yPlot2_eb_max = [];
                    figSet.starRes = dataMat_Stats{figSet.colRes(tPlot)}(:,10);
                    figSet.starComp = dataMat_Stats{figSet.colRes(tPlot)}(:,1:2);
                end
            elseif tPlot == 10
                figSet.yPlot1 = dataMat(dataMat(:,3) == 2,figSet.colRes(tPlot));
                figSet.yPlot2 = [];
                if figSet.showStats
                    figSet.yPlot1_eb_min = [dataMat_Stats{figSet.colRes(tPlot)}(1,4),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(1,7),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(2,7),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(3,7)];
                    figSet.yPlot1_eb_max = [dataMat_Stats{figSet.colRes(tPlot)}(1,5),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(1,8),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(2,8),...
                                            dataMat_Stats{figSet.colRes(tPlot)}(3,8)];
                    figSet.yPlot2_eb_min = [];
                    figSet.yPlot2_eb_max = [];
                    figSet.starRes = dataMat_Stats{figSet.colRes(tPlot)}(:,10);
                    figSet.starComp = dataMat_Stats{figSet.colRes(tPlot)}(:,1:2);
                end
            end
            
            % drawings
            drawCompVal(figSet)
            
            % figure size
            valLim = 1.5;
            set(gca,'YDir','reverse','XLim',[-valLim,valLim]/0.6-0.2 ,'YLim',[-1.8,1.8]+0.4,'Box','off',...
                           'XColor',figSet.white,'YColor',figSet.white,'XTick',[],'YTick',[],'XTickLabel','','YTickLabel','','ZTickLabel','');
            
        end
    end
    
    % Save figure
    if ismac
        makePdf(fileDir,f(tPlot),fileName);
    else
        print('-dpdf',[fileDir,fileName,'.pdf']);
    end
    close(f(tPlot))
 end

end