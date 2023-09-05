function process_trial(sub)
% ----------------------------------------------------------------------
% process_trial(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Count different trial and percentage of different exclusion criteria 
% of eye-tracker trials and create a summary in .txt and graphs
% ----------------------------------------------------------------------
% Input(s) :
% sub = subject configuration
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Original script by Martin SZINTE
% Last update : 08 / 12 / 2017
% Project :     WarewolGhost
% Version :     2.0
% ----------------------------------------------------------------------

% Load data
% ---------
load(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini));
fileTypeTrial = configEyeAll{sub.blockNum+1}.resMat;

% Inital configuration
% --------------------
% Criterions
txt_criterions = {  '  Correct Trials     ',...
                    ' Blinks during trial ',...
                    '  Miss Time Stamps   ',...
                    '  Online inc. trial  ',...
                    ' Inaccurate saccade  '};

num_goodTrial           = 57;
num_missDurTrial        = 58;
num_missTimeStamps      = 59;
num_onlineError         = 60;
num_inaccurateSacTrial  = 61;

num_crit  = [num_goodTrial;...
             num_missDurTrial;...
             num_missTimeStamps;...
             num_onlineError;......
             num_inaccurateSacTrial];

% Data spliters
if strcmp(sub.task,'MAIN')
    num_var1 = 4; % arrangement of distractor relative to the FT/ST 
    mod_var1 = 2;  % 3 modalities
    val_var1 = [1;2];
    txt_var1 = {'Saccade right',...
                'Saccade left'};
else
    num_var1 = 4; % arrangement of distractor relative to the FT/ST 
    mod_var1 = 2; % 2 modalities
    val_var1 = [1;2];
    txt_var1 = {'Stimuli right',...
                'Stimuli left'};
end

txt_split = {txt_var1};
%txt_split = {txt_var1,txt_var2};

num_split = [num_var1,mod_var1];
             %num_var2,mod_var2];

% Criterion Index 
for tCrit = 1:size(num_crit,1)
    indexCrit(:,tCrit) = fileTypeTrial(:,num_crit(tCrit,1))==1;
end

% Data spliters index (RWD/LWD)
for tCrit = 1:size(num_crit,1)
    for tSplit = 1:size(num_split,1)
        for tMod = 1:num_split(tSplit,2)
            indexSplit(:,tMod,tCrit,tSplit) = fileTypeTrial(:,num_crit(tCrit,1))==1 & fileTypeTrial(:,num_split(tSplit,1)) == val_var1(tMod);
        end
    end
end

% Number Criterions
for tCrit = 1:size(num_crit,1)
    numbCrit(:,tCrit) = sum(indexCrit(:,tCrit));
end

% Number Split data
for tCrit = 1:size(num_crit,1)
    for tSplit = 1:size(num_split,1)
        for tMod = 1:num_split(tSplit,2)
            numbSplit(:,tMod,tCrit,tSplit) =  sum(indexSplit(:,tMod,tCrit,tSplit));
        end
    end
end

% Percent Criterions
for tCrit = 1:size(num_crit,1)
    percentCrit(:,tCrit) = numbCrit(:,tCrit)/size(fileTypeTrial,1);
end

% Percent Split
for tCrit = 1:size(num_crit,1)
    for tSplit = 1:size(num_split,1)
        for tMod = 1:num_split(tSplit,2)
            percentSplit(:,tMod,tCrit,tSplit) = (numbSplit(:,tMod,tCrit,tSplit)/numbCrit(:,tCrit));
        end
    end
end

% Saving data in text file
confile = sprintf('%s/%s_summary.txt',sub.all_blockDir,sub.ini);
fcon = fopen(confile,'w');

for tCrit = 1:size(num_crit,1)
    fprintf(fcon,'\t%s:\t\t\t%4.0f\t(%0.3f)\n', txt_criterions{tCrit}, numbCrit(:,tCrit),percentCrit(:,tCrit));
    for tSplit = 1:size(num_split,1)
        for tMod = 1:num_split(tSplit,2)
            fprintf(fcon,'\t%s:\t\t\t%4.0f\t(%0.3f)\n',txt_split{tSplit}{tMod}, numbSplit(:,tMod,tCrit,tSplit), percentSplit(:,tMod,tCrit,tSplit));
        end
    end
    fprintf(fcon,'\n');
end

fclose(fcon);

% Figure
% ------
black           =   [0,0,0];
gray            =   [0.7,0.7,0.7];
blue            =   [0,0,0.8];
red             =   [0.8,0,0];
light_red       =   [1,0.5,0.5];
light_blue      =   [0.5,0.5,1];

fontsize = 7;
fontname = 'Helvetica';

xticklabel = txt_criterions;
xlim = [0 size(txt_criterions,2)+1];
maxNum = max(numbCrit)*2;
ylim = [0,maxNum];
xtick = 1:1:xlim(2)-1;
ytick = 0:200:max(numbCrit);

for tSplit = 1:size(num_split,1)
    colorUsed = lines(num_split(tSplit,2));
    f=figure();
    name = sprintf('%s General summary Split(%i)',sub.ini,tSplit);
    set(f, 'Name', name,'PaperOrientation', 'portrait','PaperUnits','normalized','PaperPosition', [-0.05,0.5,1.1,0.5]);
    figSize_X = 700;
    figSize_Y = 500;
    
    res = figSize_X/figSize_Y;
    start_X = 0;start_Y = 0;
    set(f,'Position',[start_X,start_Y,figSize_X+start_X,figSize_Y+start_Y]);

    matStackedAll = [];
    for tCrit = 1:size(num_crit,1)
        matStacked = numbSplit(:,:,tCrit,tSplit);
        matStackedAll = [matStackedAll;matStacked];
    end
    b = bar(matStackedAll,'stacked');
    for tMod = 1:num_split(tSplit,2)
        set(b(tMod),'FaceColor',colorUsed(tMod,:));
        legMat(tMod) = b(tMod); 
    end

    legD = legend(legMat,txt_split{tSplit});
    set(legD,'Position',[0.4 0.6 0.24 0.08], 'FontWeight','bold','FontSize', fontsize ,'FontName', fontname,'Box','off')
    set(gca, 'FontSize', fontsize ,'FontName', fontname, 'XLim', xlim ,'XTick', xtick,'YLim',ylim,'YTick',ytick,'XTickLabel','');
    
    
    % Axes            
    text(xlim(2)/2,ylim(2)+100,'Trials distribution','FontSize', fontsize+4 ,'FontName', fontname, 'FontWeight','bold','Color',black,'HorizontalAlignment','center')
    text(-0.1,0.4,'Trials','Units','normalized','FontSize', fontsize ,'FontName',fontname,'HorizontalAlignment','center','FontWeight','bold','Color',black,'Rotation',90);
    
    
    for tCrit = 1:size(txt_criterions,2)
        
        % Xlabel
        if mod(tCrit,2)
            text(tCrit/(size(txt_criterions,2)+1),-0.03,txt_criterions{tCrit},'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center');
        else
            text(tCrit/(size(txt_criterions,2)+1),-0.06,txt_criterions{tCrit},'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center');
        end
        
        % All trials
        text(tCrit/(size(txt_criterions,2)+1),0.98,sprintf('%i',numbCrit(tCrit)),'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center');
        text(tCrit/(size(txt_criterions,2)+1),0.94,sprintf('( %5.2f %%)',percentCrit(tCrit)*100),'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center');
        
        % Trials splited
        for tMod = 1:num_split(tSplit,2)
            
            text(tCrit/(size(txt_criterions,2)+1),0.90 -(0.08*(tMod-1)),sprintf('%i',numbSplit(1,tMod,tCrit,tSplit)),'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center','Color',colorUsed(tMod,:));
            text(tCrit/(size(txt_criterions,2)+1),0.86 -(0.08*(tMod-1)),sprintf('( %5.2f %%)',percentSplit(1,tMod,tCrit,tSplit)*100),'Units','normalized','FontSize', fontsize ,'FontName', fontname,'HorizontalAlignment','center','Color',colorUsed(tMod,:));
            
        end
    end
    
    print('-dpdf',sprintf('%s/%s_summary.pdf', sub.all_blockDir, sub.ini)); 
    
end
end