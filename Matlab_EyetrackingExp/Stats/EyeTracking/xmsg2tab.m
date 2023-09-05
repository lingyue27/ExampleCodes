function [configEye] = xmsg2tab(sub,config,configEye)
% ----------------------------------------------------------------------
% [configEye] = xmsg2tab(sub,config,configEye)
% ----------------------------------------------------------------------
% Goal of the function :
% Creates tab-File containing time stamps of trial events
% ----------------------------------------------------------------------
% Input(s) :
% sub : subject and analysis settings
% config : struct containing experimental settings
% configEye = struct containing eye data analysis
% ----------------------------------------------------------------------
% Output(s):
% configEye = struct containing eye data analysis
% ----------------------------------------------------------------------
% Created by Martin SZINTE       (martin.szinte@gmail.com)
% edited by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 26 / 01 / 2017
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

msg_file = sprintf('%s/%s_B%i.msg',sub.blockDir,sub.ini,sub.fromB);
msg_data = fopen(msg_file,'r');
fprintf(1,'\n\tProcessing %s_B%i.msg file...\n',sub.ini,sub.fromB);

msgNumCol = 19;
configEye.msg_tab = ones(size(config.expDes.expResMat,1),msgNumCol)*-8;
t = 0;

stillTheSameData = 1;
while stillTheSameData
    stillTheSameTrial = 1;
    while stillTheSameTrial
        line = fgetl(msg_data);
        if ~ischar(line)                            % end of file
            stillTheSameData = 0;
            break;
        end
        if ~isempty(line)                           % skip empty lines
            la = strread(line,'%s');                % matrix of strings in line
            if length(la) >= 3
                switch char(la(3))

                    % Trial
                    case 'TRIALID';                         t = t+1;
                                                            configEye.msg_tab(t,1)  = str2double(char(la(4)));
                    case 'TRIAL_START';                     configEye.msg_tab(t,2)  = str2double(char(la(2)));
                    case 'TRIAL_END';                       configEye.msg_tab(t,3)  = str2double(char(la(2)));
                                                            stillTheSameTrial = 0;

                    % trial beginning
                    case 'EVENT_PRESS_SPACE';               configEye.msg_tab(t,4)  = str2double(char(la(2)));
                    case 'EVENT_FIX_CHECK';                 configEye.msg_tab(t,5)  = str2double(char(la(2)));
                    case 'EVENT_TRIAL_START';               configEye.msg_tab(t,6)  = str2double(char(la(2)));
                    
                    % Saccade/fixation check
                    case 'FIX_BREAK_START';                 configEye.msg_tab(t,7)  = str2double(char(la(2)));
                    case 'EVENT_ONLINE_SACONSET_BOUND';     configEye.msg_tab(t,8)  = str2double(char(la(2)));
                    case 'EVENT_ONLINE_SACOFFSET_BOUND';    configEye.msg_tab(t,9)  = str2double(char(la(2)));

                    % Stimulus
                    case 'FT_START';                        configEye.msg_tab(t,10) = str2double(char(la(2)));
                    case 'FT_END';                          configEye.msg_tab(t,11) = str2double(char(la(2)));
                    case 'REF_START';                       configEye.msg_tab(t,12) = str2double(char(la(2)));
                    case 'REF_END';                         configEye.msg_tab(t,13) = str2double(char(la(2)));
                    case 'GAP_START';                       configEye.msg_tab(t,14) = str2double(char(la(2)));
                    case 'GAP_END';                         configEye.msg_tab(t,15) = str2double(char(la(2)));
                    case 'PROBE_START';                     configEye.msg_tab(t,16) = str2double(char(la(2)));
                    case 'PROBE_END';                       configEye.msg_tab(t,17) = str2double(char(la(2)));
                    
                    % Answer
                    case 'EVENT_GET_ANSWER';                configEye.msg_tab(t,18) = str2double(char(la(2)));
                    case 'EVENT_ANSWER';                    configEye.msg_tab(t,19) = str2double(char(la(2)));

                end
            end
        end
    end
end


end