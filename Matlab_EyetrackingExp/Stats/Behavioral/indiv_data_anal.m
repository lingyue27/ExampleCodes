function indiv_data_anal(sub)
% ----------------------------------------------------------------------
% extractorTh(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Extract results, mean, number of the different combination of variable
% used in the threshold trials
% ----------------------------------------------------------------------
% Input(s) :
% sub = subject configuration
% configEyeAll = stuct containing block structs of eye analysis
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------          
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Original script by Martin SZINTE
% Update............07 | 03 | 2018
% Project.............Checkerboard
% Version........................1
% ----------------------------------------------------------------------

fprintf(1,'\n\n\t>> Data extraction [IN PROGRESS]\n');
load(sprintf('%s/expResEye_%s_AllB.mat', sub.all_blockDir, sub.ini));

resMatCor = configEyeAll{end}.resMatCor;

% Pre-Saccadic Constrast Modulation Levels : 1 = 0.00; 2 = 0.20; 3 = -0.20 (=phase shift)
preContrastCol  = 6;    % column
nb_pre_csts     = 3;    % modalities 

% Rand 5 : Contrast modulation of the post-saccadic, foveal test pattern
% [0.00   0.005   0.010   0.015   0.020]
postContrastCol = 7;    % column
nb_post_csts    = 5;    % modalities

seenCol = 9;    % Perception Present/Absent : 1/2 
corrCol = 10;   % Correctness of answer 

% Create empty vectors for individual data:
conds_seen_indiv = [];
conds_pcor_indiv = [];

for i_cst = 1:nb_pre_csts
    
    % Create empty vectors for data per condition:
    cond_pseen = [];
    cond_pcorr = [];
    
    for i_post_ctrst = 1:nb_post_csts
        
        % Number of trials in the condition (because of offline eyetracking
        % error, those might not be equal in each condition
        requested_cond = resMatCor(:,preContrastCol) == i_cst & resMatCor(:,postContrastCol) == i_post_ctrst;
        filter_cond = logical(requested_cond); 
        nb_trials_cond = sum(requested_cond);
        
        % Chances of perception
        resp_seen     = sum(resMatCor(filter_cond, seenCol) == 1);
        percent_seen  = round((resp_seen/nb_trials_cond)*100, 2);
        
        % Percent Correct
        resp_corr     = sum(resMatCor(filter_cond, corrCol) == 1);
        percent_corr  = round((resp_corr/nb_trials_cond)*100, 2);
        
        % Blow the vectors with new data at each look (yes matlab dislikes
        % that but who cares)
        cond_pseen = [cond_pseen percent_seen];         %#ok<AGROW>
        cond_pcorr = [cond_pcorr percent_corr];         %#ok<AGROW>
        
    end
    % Range conditions in different rows
    conds_seen_indiv = [conds_seen_indiv; cond_pseen];  %#ok<AGROW>
    conds_pcor_indiv = [conds_pcor_indiv; cond_pcorr];  %#ok<AGROW>
    
end

% Plot Individual Data % -------------------------------------------------------------
fig1 = figure;
mrk_size = 15;
ft_sz    = 8;
subplot(1,2,1)
plot(1:nb_post_csts, conds_seen_indiv(1,:), 'k.-', 'MarkerSize',mrk_size); hold on
plot(1:nb_post_csts, conds_seen_indiv(2,:), 'b.-', 'MarkerSize',mrk_size); hold on
plot(1:nb_post_csts, conds_seen_indiv(3,:), 'r.-', 'MarkerSize',mrk_size); hold on
set(gca,'XTick', [0 1 2 3 4 5 6 7], 'XTickLabel',{'','0.0','0.05','0.1','0.15','0.20',''}, 'FontSize', ft_sz)
xlabel('Post-Saccadic Contrast Modulation');
ylabel('% Seen Post-Saccadic Grating');
ylim([0 100]); axis square

l1 = legend('0.0', '0.20', '-0.20');
title(l1, 'Pre-Sacc Modulation')
legend('Location','southeast')
legend('boxoff')

subplot(1,2,2)
plot(1:nb_post_csts, conds_pcor_indiv(1,:), 'k.-', 'MarkerSize', mrk_size); hold on
plot(1:nb_post_csts, conds_pcor_indiv(2,:), 'b.-', 'MarkerSize', mrk_size); hold on
plot(1:nb_post_csts, conds_pcor_indiv(3,:), 'r.-', 'MarkerSize', mrk_size); hold on
set(gca,'XTick', [0 1 2 3 4 5 6 7], 'XTickLabel',{'','0.0','0.05','0.1','0.15','0.20',''}, 'FontSize', ft_sz)
xlabel('Post-Saccadic Contrast Modulation');
ylabel('% Correct');
ylim([0 100]); axis square

l2 = legend('0.0', '0.20', '-0.20');
title(l2, 'Pre-Sacc Modulation')
legend('Location','southeast')
legend('boxoff')
% ----------------------------------------------------------------------------------

% Save the data
h = gcf; % Current figure handle
set(h,'Resize','off');
configEyeAll{end}.tabResSeen = conds_seen_indiv;
configEyeAll{end}.tabResPcor = conds_pcor_indiv;
save(sprintf('%s/expResEye_%s_AllB.mat',sub.all_blockDir,sub.ini), 'configEyeAll');

% Save the Figure
print('-bestfit','-dpdf',sprintf('%s/%s_Res.pdf', sub.all_blockDir, sub.ini));
close(fig1);

end

% Add 

% PLot Average Data

