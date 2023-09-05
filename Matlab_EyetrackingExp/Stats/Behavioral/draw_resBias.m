function draw_resBias(sub)
% ----------------------------------------------------------------------
% draw_resBias(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw resutls of bias
% ----------------------------------------------------------------------
% Input(s):
% sub : subject settings
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Data saved:
% PDF files
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 08 / 03 / 2016
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

fprintf(1,'\n\t>> Drawing fit data for bias [IN PROGRESS]...\n');

figSet.numRow = 7;
figSet.numCol = 4;

figSize_X = 350*figSet.numCol;
figSize_Y = 350*figSet.numRow;
start_X = 0;start_Y = 0;

paperSize = [figSize_X/30,figSize_Y/30];
paperPos = [0 0 paperSize(1) paperSize(2)];

load(sprintf('%s/expRes_%s_AllB.mat',sub.all_blockDir,sub.ini));
load(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini));
fileRes  = configEyeAll{end}.tabResBias;
const    = configAll{1}.const;

f=figure;
name = sprintf('%s bias',sub.ini);
set(f,'Name',name,'PaperUnits','centimeters','PaperPosition',paperPos,'Color',[1 1 1],'PaperSize',paperSize);
set(f,'Position',[start_X,start_Y,figSize_X,figSize_Y]);
fileDir = sprintf('%s/',sub.all_blockDir);
fileName = sprintf('%s_SacBias',sub.ini);

%% figure settings
markerMaxSize   = 12;                   % maximum size of the dots
ratioTick       = 0.025;                % range ratio of tick lines
ratioScale      = 0.05;                 % range ratio of scale addition
ratioTickText   = 0.15;                 % range ratio of tick text position
ratioTitleText  = 0.2;                  % range ratio of tick label
ratioGraph      = [0.5,0.5,0.2,0.4];    % range ratio of figure (left up righ down)
red             = [239, 15  47]/255;
blue            = [ 54, 98,160]/255;
green           = [  0,150, 64]/255;
beige           = [245,241,237]/255;
purple          = [104/255 45/255 139/255];

axisWidth = 1;                          % width of the axes
minX = -16;                             % minimum x value
maxX = 16;                              % maximum x value
rangeX = maxX - minX;                   % x values range
axisXTitle = 'Angle change (deg)';      % x axis title

minY = 0;                               % minimum y value
maxY = 1;                               % maximum y value
rangeY = maxY - minY;                   % y values rnage
tickY = [0,.25,.5,.75,1];               % y values ticks
axisYTitle = '% Clockwise';             % y axis title

widthTH = 2.5;                          % line widht of threshold fit

%% curve fitting parameters
opt.Functionname      = 'PAL_CumulativeNormal';                 % @PAL_Logistic;  %Alternatives: PAL_Gumbel, PAL_Weibull, %PAL_CumulativeNormal, PAL_HyperbolicSecant
opt.nruns             = sub.fitBootNum;                         % Number of bootstraps
opt.cutparam          = .5;                                     % Threshold cut
opt.confI             = .95;                                    % Confidence interval
opt.ParOrNonPar       = 1;                                      % Parametric or non-parametric bootstrap
opt.GOF               = 1;                                      % Goodness of fit computation (0: no)
opt.GridGrain         = sub.fitGrainNum;                        % Number of search values
opt.ciopt             = 'percent';                              % Computation of confidence interval
opt.searchGrid.alpha  = linspace(1,89,opt.GridGrain);           % Range of cut
opt.searchGrid.beta   = linspace(0,4,opt.GridGrain);            % slope
opt.searchGrid.gamma  = 0;                                      % Guess-rate
guess_rate = 0;

if sub.fitLapseRate
    opt.searchGrid.lambda = linspace(0,0.2,opt.GridGrain);      % Lapse-rate
    lapse_rate = 1;
else
    opt.searchGrid.lambda = 0;                                  % Lapse-rate
    lapse_rate = 0;
end
opt.whichfitparams    = [1 1 guess_rate lapse_rate];            % [threshold slope guess-rate lapse-rate]

thSaveBias          = [];
thSaveGapBias       = [];
thSaveCongBias      = [];
thSaveLumRefBias    = [];
thSaveLumProbeBias  = [];
thSaveGapRefBias    = [];
thSaveGapProbeBias  = [];
thSaveCondBias      = [];

for tRow = 1:figSet.numRow
    
    for tCol = 1:figSet.numCol
        
        if (tRow == 1 || tRow == 2)
            resCol      = 5;    % performance
            angCol      = 6;    % played test angle
            numCol      = 7;    % number of trials
            switch tRow
                case 1; rand7Val = 1; titleRow = 'Gap = 0 ms';      fileRes  = configEyeAll{end}.tabResBias; colPlot = red;
                case 2; rand7Val = 2; titleRow = 'Gap = 200 ms';    fileRes  = configEyeAll{end}.tabResBias; colPlot = blue;
            end
            switch tCol
                case 1; rand5Val = 1;  rand6Val = 1;    titleCol = sprintf('ref = iso / probe = iso / %s',titleRow);           desiredSample   = 30/2;% desired amount of trial per dot
                case 2; rand5Val = 1;  rand6Val = 2;    titleCol = sprintf('ref = iso / probe = non-iso / %s',titleRow);       desiredSample   = 30/2;% desired amount of trial per dot
                case 3; rand5Val = 2;  rand6Val = 1;    titleCol = sprintf('ref = non-iso / probe = iso / %s',titleRow);       desiredSample   = 30/2;% desired amount of trial per dot
                case 4; rand5Val = 2;  rand6Val = 2;    titleCol = sprintf('ref = non-iso / probe = non-iso / %s',titleRow);   desiredSample   = 30/2;% desired amount of trial per dot
            end
            matRes  = fileRes(fileRes(:,1) == rand5Val & fileRes(:,2) == rand6Val & fileRes(:,3) == rand7Val,:);
        elseif tRow == 3
            resCol      = 3;    % performance
            angCol      = 4;    % played test angle
            numCol      = 5;    % number of trials
            switch tCol
                case 1; fileRes  = configEyeAll{end}.tabResGapBias;
                    gapVal  = 1;
                    matRes  = fileRes(fileRes(:,1) == gapVal,:);
                    titleCol = 'gap 0 ms';                      desiredSample   = 120/2;
                    colPlot = red;
                case 2; fileRes  = configEyeAll{end}.tabResGapBias;
                    gapVal  = 2;
                    matRes  = fileRes(fileRes(:,1) == gapVal,:);
                    titleCol = 'gap 200 ms';                    desiredSample   = 120/2;
                    colPlot = blue;
                case 3; fileRes  = configEyeAll{end}.tabResCongBias;
                    congVal = 1;
                    matRes  = fileRes(fileRes(:,1) == congVal,:);
                    titleCol = 'Ref-Probe congruent';           desiredSample   = 120/2;
                    colPlot = green;
                case 4; fileRes  = configEyeAll{end}.tabResCongBias;
                    congVal = 2;
                    matRes  = fileRes(fileRes(:,1) == congVal,:);
                    titleCol = 'Ref-Probe incongruent';         desiredSample   = 120/2;
                    colPlot = green;
            end
        elseif tRow == 4
            resCol      = 3;    % performance
            angCol      = 4;    % played test angle
            numCol      = 5;    % number of trials
            colPlot     = purple;
            switch tCol
                case 1; fileRes  = configEyeAll{end}.tabResLumRefBias;
                    lumRefVal = 1;
                    matRes  = fileRes(fileRes(:,1) == lumRefVal,:); % ref iso
                    titleCol = 'Ref lumimance = iso';           desiredSample   = 120/2;
                case 2; fileRes  = configEyeAll{end}.tabResLumRefBias;
                    lumRefVal = 2;
                    matRes  = fileRes(fileRes(:,1) == lumRefVal,:);
                    titleCol = 'Ref lumimance = non-iso';       desiredSample   = 120/2;
                case 3; fileRes  = configEyeAll{end}.tabResLumProbeBias;
                    lumProbeVal = 1;
                    matRes  = fileRes(fileRes(:,1) == lumProbeVal,:);
                    titleCol = 'Probe lumimance = iso';         desiredSample   = 120/2;
                case 4; fileRes  = configEyeAll{end}.tabResLumProbeBias;
                    lumProbeVal = 2;
                    matRes  = fileRes(fileRes(:,1) == lumProbeVal,:);
                    titleCol = 'Probe lumimance = non-iso';     desiredSample   = 120/2;
            end
            
        elseif tRow == 5
            resCol      = 4;    % performance
            angCol      = 5;    % played test angle
            numCol      = 6;    % number of trials
            fileRes  = configEyeAll{end}.tabResGapRefBias;
            switch tCol
                case 1;
                    lumRefVal = 1;
                    gapval    = 1;
                    titleCol  = 'Ref lumimance = iso / gap 0';       desiredSample   = 60/2;
                    colPlot   = red;
                case 2;
                    lumRefVal = 1;
                    gapval    = 2;
                    titleCol  = 'Ref lumimance = iso / gap 200';     desiredSample   = 60/2;
                    colPlot   = blue;
                case 3;
                    lumRefVal = 2;
                    gapval    = 1;
                    titleCol = 'Ref lumimance = non-iso / gap 0';   desiredSample   = 60/2;
                    colPlot   = red;
                case 4;
                    lumRefVal = 2;
                    gapval    = 2;
                    titleCol = 'Ref lumimance = non-iso / gap 200'; desiredSample   = 60/2;
                    colPlot   = blue;
            end
            matRes    = fileRes(fileRes(:,1) == lumRefVal & fileRes(:,2) == gapval, :); % ref iso\
        elseif tRow == 6
            resCol      = 4;    % performance
            angCol      = 5;    % played test angle
            numCol      = 6;    % number of trials
            fileRes  = configEyeAll{end}.tabResGapProbeBias;
            switch tCol
                case 1; 
                    lumProbeVal = 1;
                    gapval    = 1;
                    titleCol  = 'Probe lumimance = iso / gap 0';       desiredSample   = 60/2;
                    colPlot   = red;
                case 2;
                    lumProbeVal = 1;
                    gapval    = 2;
                    titleCol  = 'Probe lumimance = iso / gap 200';     desiredSample   = 60/2;
                    colPlot   = blue;
                case 3;
                    lumProbeVal = 2;
                    gapval    = 1;
                    titleCol = 'Probe lumimance = non-iso / gap 0';   desiredSample   = 60/2;
                    colPlot   = red;
                case 4;
                    lumProbeVal = 2;
                    gapval    = 2;
                    titleCol = 'Probe lumimance = non-iso / gap 200'; desiredSample   = 60/2;
                    colPlot   = blue;
            end
            matRes    = fileRes(fileRes(:,1) == lumProbeVal & fileRes(:,2) == gapval, :); % ref iso
        elseif tRow == 7
            resCol      = 4;    % performance
            angCol      = 5;    % played test angle
            numCol      = 6;    % number of trials
            colPlot     = purple;
            fileRes  = configEyeAll{end}.tabResCondBias;
            switch tCol
                case 1; rand5Val = 1;  rand6Val = 1;    titleCol = 'ref = iso / probe = iso';           desiredSample   = 60/2;% desired amount of trial per dot
                case 2; rand5Val = 1;  rand6Val = 2;    titleCol = 'ref = iso / probe = non-iso';       desiredSample   = 60/2;% desired amount of trial per dot
                case 3; rand5Val = 2;  rand6Val = 1;    titleCol = 'ref = non-iso / probe = iso';       desiredSample   = 60/2;% desired amount of trial per dot
                case 4; rand5Val = 2;  rand6Val = 2;    titleCol = 'ref = non-iso / probe = non-iso';   desiredSample   = 60/2;% desired amount of trial per dot
            end
            matRes    = fileRes(fileRes(:,1) == rand5Val & fileRes(:,2) == rand6Val, :);
        end
        
        % determine data
        xVal    = matRes(:,angCol);
        yVal    = round(matRes(:,resCol).*matRes(:,numCol));
        xSample = matRes(:,numCol);
        
        % add minX and maxX of the plot
        xVal    = [minX-rangeX*ratioScale,xVal',maxX+rangeX*ratioScale];
        yVal    = [NaN, yVal',NaN];
        xSample = [0, xSample', 0];
        [resFit, xFit, ~, yFit]= runPalFit(xVal,yVal,xSample,opt.searchGrid,opt.whichfitparams,opt.nruns,opt.ParOrNonPar,opt.GOF,opt.cutparam,opt.confI,opt.Functionname,opt.ciopt);
        
        % compute JND
        jnd_val = 1/resFit.paramsValues(2);

        %% create figure
        x_start = (tCol-1)/figSet.numCol;
        y_start = (figSet.numRow-tRow)/figSet.numRow;
        x_size = 1/figSet.numCol;
        y_size = 1/figSet.numRow;
        
        axes('position',[x_start,y_start,x_size,y_size]);
        hold on
        
        %% draw x/y axes of performance graph
        tickX = matRes(:,angCol);               % x value ticks
        
        % draw x-axis
        xaxisX = linspace(minX-rangeX*ratioScale,maxX+rangeX*ratioScale,100);
        yaxisX = minY - rangeY*ratioScale*2;
        plot(xaxisX,0*xaxisX+yaxisX,'k','LineWidth',axisWidth)
        
        ytextAxisX = minY - 1.2*rangeY*ratioTickText;
        ytickX = yaxisX:-0.01:yaxisX-rangeY*ratioTick;
        for tTick = 1:numel(tickX)
            plot(tickX(tTick)+ytickX*0,ytickX,'LineWidth',axisWidth,'Color',[0,0,0])
            text(tickX(tTick),ytextAxisX,sprintf('%2.0f',tickX(tTick)),'HorizontalAlignment','center');
        end
        text(0,ytextAxisX-rangeY*ratioTitleText/2,axisXTitle,'HorizontalAlignment','center');
        
        % draw y-axis
        yaxisY = linspace(minY-rangeY*ratioScale,maxY+rangeY*ratioScale,100);
        xaxisY = minX - rangeX*ratioScale*2;
        plot(0*yaxisY+xaxisY,yaxisY,'LineWidth',axisWidth,'Color',[0,0,0])
        
        xtextAxisX = minX - rangeX*ratioTickText;
        xtickY = xaxisY:-0.01:xaxisY-rangeX*ratioTick;
        for tTick = 1:numel(tickY)
            plot(xtickY,xtickY*0+tickY(tTick),'LineWidth',axisWidth,'Color',[0,0,0])
            text(xtextAxisX,tickY(tTick),sprintf('%1.2g',tickY(tTick)),'HorizontalAlignment','right');
        end
        text(xtextAxisX-rangeX*ratioTitleText,rangeY/2,axisYTitle,'HorizontalAlignment','center','Rotation',90);
        
        % draw figure title
        figTitle = sprintf('%s',titleCol);
        text(minX-rangeX*ratioScale,maxY+rangeY*ratioTitleText*1.5,figTitle,'HorizontalAlignment','left','FontWeight','bold');
        
        % draw background frame
        fill([minX-rangeX*ratioScale,maxX+rangeX*ratioScale,maxX+rangeX*ratioScale,minX-rangeX*ratioScale],...
            [minY-rangeY*ratioScale,minY-rangeY*ratioScale,maxY+rangeY*ratioScale,maxY+rangeY*ratioScale],...
            beige,'Linestyle','none');
        
        % define axes limits
        set(gca,'XLim',[minX-rangeX*ratioGraph(1),maxX+rangeX*ratioGraph(3)],...
            'YLim',[minY-rangeY*ratioGraph(4),maxY+rangeY*ratioGraph(2)],...
            'XTicklabel','','YTicklabel','','XColor',[1,1,1],'YColor',[1,1,1])
        
        %% draw threshold arrow/range + text + save threshodl value
        % plot Bias level line
        xTHX = linspace(minX-rangeX*ratioScale,maxX+rangeX*ratioScale,100);
        yTHX = opt.cutparam(1);
        plot(xTHX,0*xTHX+yTHX,'Color',[1,1,1],'LineWidth',widthTH)
        
        % plot zero bias level line
        yZero = linspace(minY-rangeY*ratioScale,maxY+rangeY*ratioScale,100);
        xZero = yZero * 0;
        plot(xZero,yZero,'Color',[1,1,1],'LineWidth',widthTH)
        
        % threhold arrow
        yTH_arrow = linspace(minY-rangeY*ratioScale,opt.cutparam(1),100);
        xTH_arrow = yTH_arrow*0+resFit.cuts(1);
        plot(xTH_arrow,yTH_arrow,'-','Color',colPlot,'LineWidth',widthTH);
        plot(xTH_arrow(1),0,'v','MarkerSize',7,'MarkerEdgeColor',colPlot,'MarkerFaceColor',colPlot,'LineWidth',widthTH);
        
        % threshold text + save
        textTH      = sprintf('Bias(%1.2f) = %2.1f deg',opt.cutparam(1),resFit.cuts(1));
        textJND     = sprintf('JND = %2.1f',jnd_val);
        textGOF     = sprintf('GOF Dev = %1.2f, GOF pDev = %1.2f',resFit.GOF.Dev,resFit.GOF.pDev);
        text(minX-rangeX*ratioScale,maxY+rangeY*ratioTitleText*1.0,textTH,'HorizontalAlignment','left');
        text(minX-rangeX*ratioScale,maxY+rangeY*ratioTitleText*0.7,textJND,'HorizontalAlignment','left');
        text(minX-rangeX*ratioScale,maxY+rangeY*ratioTitleText*0.4,textGOF,'HorizontalAlignment','left');

        if isinf(resFit.cuts(1))
            resFit.cuts(1) = NaN;
        end
        fprintf(1,'\n\t   %s: Bias(%1.2f) = %2.1f deg; JND = %1.2f',titleCol,opt.cutparam(1),resFit.cuts(1),jnd_val);
        
        if (tRow == 1 || tRow == 2)
            thSaveBias = [thSaveBias;rand5Val,rand6Val,rand7Val,resFit.cuts(1),resFit.SEcuts,jnd_val,resFit.SEslop,resFit.GOF.Dev,resFit.GOF.pDev];
        elseif tRow == 3
            if tCol == 1 || tCol == 2
                thSaveGapBias = [thSaveGapBias;gapVal,resFit.cuts(1),resFit.SEcuts,jnd_val,resFit.SEslop,resFit.GOF.Dev,resFit.GOF.pDev];
            elseif tCol == 3 || tCol == 4
                thSaveCongBias = [thSaveCongBias;congVal,resFit.cuts(1),resFit.SEcuts,jnd_val,resFit.SEslop,resFit.GOF.Dev,resFit.GOF.pDev];
            end
        elseif tRow == 4
            if tCol == 1 || tCol == 2
                thSaveLumRefBias = [thSaveLumRefBias;lumRefVal,resFit.cuts(1),resFit.SEcuts,jnd_val,resFit.SEslop,resFit.GOF.Dev,resFit.GOF.pDev];
            elseif tCol == 3 || tCol == 4
                thSaveLumProbeBias = [thSaveLumProbeBias;lumProbeVal,resFit.cuts(1),resFit.SEcuts,jnd_val,resFit.SEslop,resFit.GOF.Dev,resFit.GOF.pDev];
            end
        elseif tRow == 5
            thSaveGapRefBias = [thSaveGapRefBias; lumRefVal, gapval, resFit.cuts(1),resFit.SEcuts,jnd_val,resFit.SEslop,resFit.GOF.Dev,resFit.GOF.pDev];
        elseif tRow == 6
            thSaveGapProbeBias = [thSaveGapProbeBias; lumProbeVal, gapval, resFit.cuts(1),resFit.SEcuts,jnd_val,resFit.SEslop,resFit.GOF.Dev,resFit.GOF.pDev];
        elseif tRow == 7
            thSaveCondBias = [thSaveCondBias; rand5Val, rand6Val, resFit.cuts(1),resFit.SEcuts,jnd_val,resFit.SEslop,resFit.GOF.Dev,resFit.GOF.pDev];
        end
        
        %% draw performance and fit
        plot(xFit,yFit,'-','Color',colPlot,'LineWidth',widthTH);
        
        for tPlot = 1:size(matRes,1)
            p(tPlot) = plot(matRes(tPlot,angCol),matRes(tPlot,resCol),'o');
            markerSize = markerMaxSize*(matRes(tPlot,numCol)/desiredSample);
            set(p(tPlot),'MarkerSize',markerSize,'MarkerEdgeColor',colPlot,'MarkerFaceColor',[1,1,1],'LineWidth',widthTH)
        end
        clear('resFit','xFit','yFit');
        
        %% draw legend
        plot(minX+rangeX*0.7,minY+rangeY*0.1,'o','MarkerSize',markerMaxSize,'MarkerEdgeColor',colPlot,'MarkerFaceColor',[1,1,1],'LineWidth',widthTH)
        plot(minX+rangeX*0.7,minY+rangeY*0,'o','MarkerSize',markerMaxSize/2,'MarkerEdgeColor',colPlot,'MarkerFaceColor',[1,1,1],'LineWidth',widthTH)
        text(minX+rangeX*0.78,minY+rangeY*0.1,sprintf('%3.0f trials',desiredSample),'HorizontalAlignment','left','VerticalAlignment','middle');
        text(minX+rangeX*0.78,minY+rangeY*0,sprintf('%3.0f trials',desiredSample/2),'HorizontalAlignment','left','VerticalAlignment','middle');
 
    end
end

%% Saving procedure
if ismac
    makePdf(fileDir,f,fileName);
else
    print('-dpdf',[fileDir,fileName,'.pdf']);
end
configEyeAll{end}.thSaveBias            = thSaveBias;
configEyeAll{end}.thSaveGapBias         = thSaveGapBias;
configEyeAll{end}.thSaveCongBias        = thSaveCongBias;
configEyeAll{end}.thSaveLumRefBias      = thSaveLumRefBias;
configEyeAll{end}.thSaveLumProbeBias    = thSaveLumProbeBias;
configEyeAll{end}.thSaveGapRefBias      = thSaveGapRefBias;
configEyeAll{end}.thSaveGapProbeBias    = thSaveGapProbeBias;
configEyeAll{end}.thSaveCondBias        = thSaveCondBias;

save(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini),'configEyeAll');

fprintf(1,'\n\n\t>> Fitting/Drawing data [DONE]\n');
end