function saccades_analysis(sub)
% ----------------------------------------------------------------------
% saccades_analysis(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Analysis of saccade distribution in function of different caracteristic
% of saccades in that particular task such as saccade lenght,
% saccade duration, saccade latency, saccade velocity.
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject and analysis settings
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Data saved :
% PDF files containing each histogram files
% ----------------------------------------------------------------------
% Original script by Martin SZINTE
% Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 28 / 21 / 2017
% Project :     WarewolfGhost
% Version :     2.0
% ----------------------------------------------------------------------

close all

% Initial configuration
% ---------------------
black =         [0,0,0];
gray =          [0.4,0.4,0.4];
light_gray =    [0.8,0.8,0.8];
blue =          [0,0,0.8];
red  =          [0.8,0,0];
light_red =     [1,0.5,0.5];
light_blue =    [0.5,0.5,1];
orange =        [1 150/255 0];
light_orange =  [1, 200/255 150/255];

fontsize = 8;
fontname = 'Helvetica';

figSize_Yi = 200;
figSize_X = 1000;
start_X = 0;
start_Y = 0;

% Load data
% ---------
load(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini));
fileRes = configEyeAll{sub.blockNum+1}.resMatCor;

% Treat data
% ----------
% Data spliters

num_var1 = 9;  % arrangement of distractor relative to the FT/ST
mod_var1 = 2;  % 3 modalities
val_var1 = [1;2];
txt_var1 = {'All trials ','Gap 0','Gap 200'};
numMax = 100;
numStep = 25;
numCond = 2;
    

% txt_split = {txt_var1;txt_var2};
txt_split = {txt_var1};

% num_split = [num_var1,mod_var1;...
%              num_var2,mod_var2];

num_split = [num_var1,mod_var1];

% val_var = {val_var1;val_var2};
val_var = {val_var1};

%% DATA

txtRes1 = 'Sac latencies (msec)';                  rawRes1 = 39;   nBins_res1 =  0:25:+500;
txtRes2 = 'Sac amplitude (deg)';                   rawRes2 = 44;   nBins_res2 =  4:0.25:12;
txtRes3 = 'Duration of the REF stim (ms)';         rawRes3 = 51;   nBins_res3 =  0:25:+500;
txtRes4 = 'Probe onset rel. to sac. offset (ms)';  rawRes4 = 37;   nBins_res4 =  -100:10:+200;

num_crit        = [rawRes1;     rawRes2;    rawRes3;    rawRes4;];
txt_criterions  = {txtRes1,     txtRes2,    txtRes3,    txtRes4};
nBins_res       = {nBins_res1;  nBins_res2; nBins_res3;	nBins_res4};

%% Criterion indices
for tSplit = 1:size(num_split,1) % from 1 to 1
    for tMod = 1:num_split(tSplit,2) % from 1 to 2
        indexSplit{tMod,tSplit} = fileRes(:,num_split(tSplit,1)) == val_var{tSplit}(tMod);
    end
end

%% Resuls
% All

for tSplit = 1:size(num_split,1)
    for tMod = 1:num_split(tSplit,2)
        for tCrit = 1:size(num_crit,1)
            resCrit{tMod,tSplit,tCrit} = fileRes(indexSplit{tMod,tSplit},num_crit(tCrit,1));
        end
    end
end


for tSplit = 1:size(num_split,1)
    colorUsed = lines(num_split(tSplit,2));
    numSub = (num_split(tSplit,2)+1)*size(num_crit,1);
    tRow    = 1;    add     = 0;    addCol  = 0;
    numRawPlot = (num_split(tSplit,2)+1);
    
    for subP = 1:numSub
        if subP == 9;
        end
        if subP == 1
            f=figure(tSplit);
            figSize_Y = figSize_Yi*numRawPlot;
            name = (sprintf('%s_SacDist',sub.ini));
            set(f, 'Name', name,'PaperOrientation', 'landscape','PaperUnits','normalized','PaperPosition', [-0.05,0,1.1,1]);
            set(f,'Position',[start_X,start_Y,figSize_X+start_X,figSize_Y+start_Y]);
            hold on;
        end
        
        if subP < size(num_crit,1) + 1 % all results
            for tCol = 1:size(num_crit,1)
                if ~mod(subP-tCol,tCol)
                    [n] = histc(fileRes(:,num_crit(tCol)),nBins_res{tCol});
                    xout = nBins_res{tCol};
                    plot_mean = nanmean(fileRes(:,num_crit(tCol)));
                    plot_median = nanmedian(fileRes(:,num_crit(tCol)));
                end
            end
        else
            
            [n] = histc(resCrit{tRow-1,tSplit,addCol+1},nBins_res{addCol+1});
            xout = nBins_res{addCol+1};
            plot_mean = nanmean(resCrit{tRow-1,tSplit,addCol+1});
            plot_median = nanmedian(resCrit{tRow-1,tSplit,addCol+1});
            addCol = addCol +1;
            if addCol == size(num_crit,1)
                addCol = 0;
            end
            
        end
        
        
        % Axes
        xlim = [xout(1) xout(end)];
        if subP == 1 || subP == 2 || subP == 3 || subP == 4
            ylim = [0 numMax*sub.blockNum]; ytick = ylim(1):numStep*sub.blockNum:ylim(2);color = orange;
        else
            ylim = [0 (numMax/numCond)*sub.blockNum]; ytick = ylim(1):(numStep*sub.blockNum/numCond):ylim(2);color = colorUsed(tRow-1,:);
        end
        
        if ~mod(subP,size(num_crit,1))
            tRow = tRow +1;
        end
        subplot(numRawPlot,size(num_crit,1),subP)
        
        x_mean_med = 0.6;
        y_plot = ylim(1):1:ylim(2);
        p_mean = plot(0*y_plot+plot_mean,y_plot);
        set(p_mean,'LineWidth',1.2,'Color',color,'LineStyle','-')
        hold on
        p_median = plot(0*y_plot+plot_median,y_plot);
        set(p_median,'LineWidth',1.2,'Color',color,'LineStyle','--')
        hold on
        text(x_mean_med,0.8 ,sprintf('mean = %3.2f',plot_mean),'Units','normalized','FontSize',fontsize,'FontName',fontname,'HorizontalAlignment','left','Color',color);
        text(x_mean_med,0.7,sprintf('median = %3.2f',plot_median),'Units','normalized','FontSize',fontsize,'FontName',fontname,'HorizontalAlignment','left','Color',color);
        
        bplot = bar(xout,n);
        set(bplot,'EdgeColor',black,'FaceColor',color,'BarWidth',1);
        set(gca,'XLim',xlim,'YLim',ylim,'YTick',ytick,'Box','on','FontSize',fontsize,'FontName',fontname);
        
        numLeg1 = 1:size(num_crit,1):numSub;
        if sum(numLeg1 == subP)
            add = add +1;
            text(-0.2,0.5,txt_split{tSplit}(add),'Units','normalized','FontSize',fontsize+2,'HorizontalAlignment','center','Color',black,'Rotation',90);
        end
        
        ydist = -0.3;
        for tColT = 1:size(num_crit,1)
            if subP == numLeg1(end) + (tColT -1);
                text(0.5,ydist,txt_criterions{tColT},'Units','normalized','FontSize',fontsize+2,'HorizontalAlignment','center','Color',black);
            end
        end
    end
    
    plot_file = sprintf('%s/%s.pdf',sub.all_blockDir,name);
    print('-dpdf',plot_file)
end
end