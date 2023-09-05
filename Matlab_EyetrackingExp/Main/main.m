function main(const)
% ----------------------------------------------------------------------
% main(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Launch all function of the experiment
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant settings
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........07 | 10 | 2019
% Project.....................CHIB
% Version........................6
% ----------------------------------------------------------------------

% File directory
% --------------
[const] = dirSaveFile(const);

% Network location
% ----------------
if ismac && ~const.TEST && const.eyeMvt
	[~,~] = system('echo eyelab | sudo -S networksetup -switchtolocation "Eyelink"');
    pause(5)
else
    [~,~] = system('echo eyelab | sudo -S networksetup -switchtolocation "Web"');
end

% Screen configuration
% --------------------
[scr] = scrConfig(const);

% Sound configuration
% --------------------
[aud] = audioConfig;

% Keyboard configuration
% ----------------------
[my_key] = keyConfig;
tic;

% Gamma calibration
% -----------------
[textExp, button] = instructionConfig;
if const.expStart;
    [scr]=gammaCalib(scr,const,my_key,textExp,button);
end

% Color config
% ------------
[scr,const]= constColor(scr,const);

% Constant configurations
% -----------------------
[const] = constConfig(scr,const);

% Experimental design
% -------------------
[expDes] = designConfig(const);

% Get demo video settings
[expDes,vid] = getVideoSettings(scr,const,expDes);

% Open screen window
% ------------------
if const.synctest == 1
    Screen('Preference', 'SkipSyncTests', 2);
    fprintf(1,'\n\tMain line 52: Don''t forget to put const.synctest to 0 and restart Matlab before testing !!!\n');
end

if const.debugTransp;PsychDebugWindowConfiguration;end
[scr.main,scr.rect] = Screen('OpenWindow',scr.scr_num,[0 0 0],[], scr.clr_depth,2);
Screen('BlendFunction', scr.main, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
priorityLevel = MaxPriority(scr.main);Priority(priorityLevel);

% Open sound pointer
% ------------------
aud.master_main = PsychPortAudio('Open', [], aud.master_mode, aud.master_reqlatclass, aud.master_rate, aud.master_nChannels); % Open a PortAudio audio device and initialize it
PsychPortAudio('Start', aud.master_main, aud.master_rep, aud.master_when, aud.master_waitforstart); % Start a Port Audio device
PsychPortAudio('Volume', aud.master_main, aud.master_globalVol);% Set audio output volume
aud.stim_handle = PsychPortAudio('OpenSlave', aud.master_main, aud.slaveStim_mode);

% Initialise EyeLink
% ------------------
if const.eyeMvt; [el] = initEyeLink(scr,const);
else el = [];end

% Main part
% ---------
ListenChar(2);GetSecs;
[vid]=runTrials(scr,aud,const,expDes,el,my_key,vid);

% End
% ---
overDone(aud,const,vid);

end