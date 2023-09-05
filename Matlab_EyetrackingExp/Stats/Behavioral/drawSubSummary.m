function drawSubSummary(sub)
% ----------------------------------------------------------------------
% drawSubSummary(sub)
% ----------------------------------------------------------------------
% Goal of the function :
% Extract and calculate mean isoluminance values and sample demographics
% ----------------------------------------------------------------------
% Input(s):
% sub : subject settings
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------
% Data saved:
% TXT file
% ----------------------------------------------------------------------
% Created by Martin SZINTE & Lukasz GRZECZKOWSKI
% (martin.szinte@gmail.com & lukasz.grzeczkowski@gmail.com)
% Last update : 13 / 03 / 2016                    
% Project :     FeatureGhost               
% Version :     3.0
% ----------------------------------------------------------------------

%% Load the subject data for isoluminant green and demographics
ss = sub.iniAll;

% Create empty arrays for future data
isoval_mean_centre_all = [];
isoval_mean_periph_all = [];
sbj_age_all = [];
sbj_sex_all = [];
sbj_eye_all = [];
incor_tot_all    = [];
incor_online_all = [];
incor_blink_all  = [];
incor_missTimeStamps_all = [];
incor_inaccSaccade_all   = [];
isoval_mean_centre_RGB_all = [];
isoval_mean_periph_RGB_all = [];

for subj = ss(1:numel(ss))
    
    % define the files and load
    lumFile = sprintf('Data/%s/ExpDataFF1/B1/expRes_%s_B1.mat',char(subj), char(subj)); load(lumFile);
    resFile = sprintf('Data/%s/ExpDataMAIN/AllB/expResEye_%s_AllB.mat', char(subj), char(subj)); load(resFile);
    
    % load mean individual isoluminace in periphery and center in cd/m2 and RGB
    isoval_mean_centre = config.const.greenIsoCenterCdpms;
    isoval_std_centre  = config.const.greenIsoCenterCdpmsSTD;
    isoval_mean_centre_RGB = config.const.greenIsoCenter(2);
    isoval_mean_periph = config.const.greenIsoPeriphCdpms;
    isoval_std_periph  = config.const.greenIsoPeriphCdpmsSTD;
    isoval_mean_periph_RGB = config.const.greenIsoPeriph(2);
    
    % load individual demographics
    sbj_age = config.const.sjct_age;
    sbj_sex = config.const.sjct_gender;
    sbj_eye = config.const.sjct_DomEye;
    
    % individual incorrect trial count
    cor_tot = sum(configEyeAll{end}.resMat(:,64));                      % Column #064 (01) Good/BAD trial flag           (1 = YES; 0 = NO)
    incor_blink  = sum(configEyeAll{end}.resMat(:,65));                 % Column #065 (03) Blink during trial            (1 = YES; 0 = NO)
    incor_missTimeStamps = sum(configEyeAll{end}.resMat(:,66));         % Column #066 (04) Miss time stamps              (1 = YES; 0 = NO)
    incor_online = sum(configEyeAll{end}.resMat(:,67));                 % Column #067 (02) Online incorrect trial        (1 = YES; 0 = NO)
    incor_inaccSaccade   = sum(configEyeAll{end}.resMat(:,68));         % Column #068 (06) Inaccurate saccade            (1 = YES; 0 = NO)

    % here save the individual data in a .txt file
    fid_name = sprintf('%s_SubjInfo.txt', char(subj));
    fid_dir  = sprintf('Data/%s/ExpDataMAIN/AllB/', char(subj));
    fid = fopen(fid_name, 'w');
    fprintf(fid, 'Initials......................: %s\n'    , char(subj));
    fprintf(fid, 'Age...........................: %0.2f\n' , char(sbj_age));
    fprintf(fid, 'Sex...........................: %s\n'    , sbj_sex);
    fprintf(fid, 'Dominant Eye..................: %s\n'    , sbj_eye);
    fprintf(fid, 'Isolum Periph (%2.1f)..........: %0.2f cd/m2 +|- %0.2f(SD)\n' ,config.const.BGlum, isoval_mean_periph , isoval_std_periph);
    fprintf(fid, 'Isolum Center (%2.1f)..........: %0.2f cd/m2 +|- %0.2f(SD)\n' , config.const.BGlum,isoval_mean_centre , isoval_std_centre);  
    fprintf(fid, 'Isolum Periph (%3.0f)...........: %0.3f (RGB)\n' ,config.const.greenPhys(2), isoval_mean_periph_RGB );
    fprintf(fid, 'Isolum Centre (%3.0f)...........: %0.3f (RGB)\n'  ,config.const.greenPhys(2), isoval_mean_centre_RGB );
    fprintf(fid, 'Correct Trials................: %0.2f\n'  , cor_tot);
    fprintf(fid, 'Incor > Online Reject.........: %0.2f\n'  , incor_online);
    fprintf(fid, 'Incor > Blink Trials..........: %0.2f\n'  , incor_blink);
    fprintf(fid, 'Incor > Miss Time Stamps......: %0.2f\n'  , incor_missTimeStamps);
    fprintf(fid, 'Incor > Inaccurate saccade....: %0.2f\n'  , incor_inaccSaccade);
    fclose(fid); movefile(fid_name, fid_dir);
    
    % fill empty arrays with data for all subjects
    isoval_mean_centre_all = [isoval_mean_centre_all ; isoval_mean_centre];
    isoval_mean_periph_all = [isoval_mean_periph_all ; isoval_mean_periph];
    isoval_mean_centre_RGB_all = [isoval_mean_centre_RGB_all ; isoval_mean_centre_RGB];
    isoval_mean_periph_RGB_all = [isoval_mean_periph_RGB_all ; isoval_mean_periph_RGB];
    
    
    sbj_age_all = [sbj_age_all ; sbj_age];
    sbj_sex_all = [sbj_sex_all ; sbj_sex];
    sbj_eye_all = [sbj_eye_all ; sbj_eye];
    
    cor_tot_all              = [incor_tot_all            ; cor_tot];
    incor_online_all         = [incor_online_all         ; incor_online];
    incor_blink_all          = [incor_blink_all          ; incor_blink];
    incor_missTimeStamps_all = [incor_missTimeStamps_all ; incor_missTimeStamps];
    incor_inaccSaccade_all   = [incor_inaccSaccade_all   ; incor_inaccSaccade];
    
end


%% Calculate means from loaded data
% luminance
iso_mean_periph_all = mean(isoval_mean_centre_all);
iso_std_periph_all  = std(isoval_mean_centre_all);
iso_mean_center_all = mean(isoval_mean_periph_all);
iso_std_center_all  = std(isoval_mean_periph_all);

mean_iso_mean_periph_RGB = mean(isoval_mean_periph_RGB_all);
mean_iso_mean_centre_RGB = mean(isoval_mean_centre_RGB_all);
std_iso_mean_periph_RGB = std(isoval_mean_periph_RGB_all);
std_iso_mean_centre_RGB = std(isoval_mean_centre_RGB_all);

% demographics
mean_sbj_age       = mean(sbj_age_all);
min_age = min(sbj_age_all);
max_age = max(sbj_age_all);   
num_females  = sum((sbj_sex_all) == 'F');
num_tot_subj = numel(sbj_sex_all);
num_right_dominant  = sum((sbj_eye_all) == 'R');

% bad trials count
mean_cor_trials   = mean(cor_tot_all);
mean_incor_online = mean(incor_online_all);
mean_incor_blink  = mean(incor_blink_all);
mean_incor_missTimeStamps = mean(incor_missTimeStamps_all);
mean_incor_inaccSaccade   = mean(incor_inaccSaccade_all);

% open file write and close 
fid_name = sprintf('ALL_SubjInfo.txt');
fid_dir = sprintf('Data/ALL/ExpDataMAIN/AllB/');
fid = fopen(fid_name, 'w');
fprintf(fid, 'Initials......................: ALL\n');
fprintf(fid, 'Age...........................: %0.2f, Range (%1.0f %1.0f)\n' , mean_sbj_age, min_age, max_age);
fprintf(fid, 'Female Count..................: %1.0f / %1.0f\n'    , char(num_females), char(num_tot_subj));
fprintf(fid, 'Right Dominant Eye Count......: %1.0f / %1.0f\n'    , num_right_dominant, num_tot_subj);
fprintf(fid, 'Isolum Periph (%2.1f)..........: %0.2f +|- %0.2f(SD)\n' , config.const.BGlum,iso_mean_periph_all , iso_std_periph_all);
fprintf(fid, 'Isolum Center (%2.1f)..........: %0.2f +|- %0.2f(SD)\n' , config.const.BGlum,iso_mean_center_all , iso_std_center_all);
fprintf(fid, 'Isolum Periph (%3.0f)...........: %0.3f (RGB) +|- %0.2f(SD)\n' ,config.const.greenPhys(2), mean_iso_mean_periph_RGB , std_iso_mean_periph_RGB);
fprintf(fid, 'Isolum Centre (%3.0f)...........: %0.3f (RGB) +|- %0.2f(SD)\n' ,config.const.greenPhys(2), mean_iso_mean_centre_RGB ,std_iso_mean_centre_RGB);
fprintf(fid, 'Correct Trials (Mean).........: %0.2f\n'  , mean_cor_trials);
fprintf(fid, 'Incor > Online Reject.........: %0.2f\n'  , mean_incor_online);
fprintf(fid, 'Incor > Blink Trials..........: %0.2f\n'  , mean_incor_blink);
fprintf(fid, 'Incor > Miss Time Stamps......: %0.2f\n'  , mean_incor_missTimeStamps);
fprintf(fid, 'Incor > Inaccurate saccade....: %0.2f\n'  , mean_incor_inaccSaccade);
fclose(fid); movefile(fid_name, fid_dir);

end