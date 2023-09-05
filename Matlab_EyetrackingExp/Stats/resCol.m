% expResMat
% ---------
% Column #001 block
% Column #002 trial number
% Column #003 rand01 = test condition (1 = color adjustment; 2 = threshold task; 3 = saccade main)
% Column #004 rand02 = saccade/test directon (1 = saccade right; 2 = saccade left)
% Column #005 rand03 = Reference angle from vertical (-64 deg; -54.5 deg; -45 deg; -35.5 deg; -26 deg; 26 deg; 35.5 deg; 45 deg; 54.5 deg; 64 deg)
% Column #006 rand04 = Probe angle change level (1 = angle change 1; ... 6 = angle change level 6) 
% Column #007 rand05 = Luminance of the reference (1 = isoluminant; 2 = non-isoluminant)
% Column #008 rand06 = Luminance of the probe (1 = isoluminant; 2 = non-isoluminant)
% Column #009 rand07 = Post-saccadic gap duration (1 = 0 ms; 2 = 200 ms)
% Column #010 rand08 = Fixation duration jitter (1 = 0 ms; ... 36 = +300 ms)
% Column #011 rand09 = 
% Column #012 rand10 = 
% Column #013 rand11 = 
% Column #014 angle of the direction change (deg)
% Column #015 resMat(1) = Stimulus' presence reported (1 = Present; 2 = Absent; -2 = no report)
% Column #016 resMat(2) = Correctness of answer (1 = correct; 0 = incorrect; -2 = no report)
% Column #017 resMat(3) = Gaze check (1 = saccade or fixation correct; 0 = saccade or fixation incorrect; -1 = fixation break)
% Column #018 eyeCrit(1) = saccade get out fixation boundary
% Column #019 eyeCrit(2) = saccade get in saccade boundary
% Column #020 eyeCrit(3) = saccade Stayed at least 50 msec in saccade boundary
% Column #021 eyeCrit(4) = saccade latency too short
% Column #022 eyeCrit(5) = saccade latency too long

% msg_tab
% -------
% Column #023 (01) Trial ID
% Column #024 (02) tedf TRIAL_START
% Column #025 (03) tedf TRIAL_END
% Column #026 (06) tedf EVENT_PRES2S_SPACE
% Column #027 (07) tedf EVENT_FIX_CHECK
% Column #028 (08) tedf EVENT_TRIAL_START
% Column #029 (09) tedf FIX_BREAK_START
% Column #030 (10) tedf EVENT_ONLINE_SACONSET_BOUND
% Column #031 (11) tedf EVENT_ONLINE_SACOFFSET_BOUND
% Column #032 (13) tedf FT_START
% Column #033 (14) tedf FT_END
% Column #034 (15) tedf REF_START
% Column #035 (16) tedf REF_END
% Column #036 (15) tedf GAP_START
% Column #037 (16) tedf GAP_END
% Column #038 (15) tedf PROBE_START
% Column #039 (16) tedf PROBE_END
% Column #040 (17) tedf EVENT_GET_ANSWER
% Column #041 (18) tedf EVENT_ANSWER

% analysis_val
% ------------
% Column #042 (01) sac onset
% Column #043 (02) sac offset
% Column #044 (03) sac duration
% Column #045 (04) sac latency
% Column #046 (05) offline/online saccade onset detection
% Column #047 (05) sac velocity peak
% Column #048 (06) sac distance
% Column #049 (07) sac angle
% Column #050 (08) sac amplitude get
% Column #051 (09) sac x onset
% Column #052 (10) sac y onset
% Column #053 (11) sac x offset
% Column #054 (12) sac y offset
% Column #055 (13) durFixCheck (duration of fixation check)
% Column #056 (14) durFT (duration of fixation target)
% Column #057 (15) durREF (duration of reference stimulus)
% Column #058 (16) durGAP (duration of the gap)
% Column #059 (17) durPROBE (duration of the probe)
% Column #060 (18) durResp (reaction time)
% Column #061 (19) durTrial (duration of a trial + reaction time)
% Column #062 (20) durSacOnline (duration of saccade detected online)
% Column #063 (21) probeOnSacOff (duration of probe onset relative to saccade offset)

% crit_val
% --------
% Column #064 (01) Good/BAD trial flag           (1 = YES; 0 = NO)
% Column #065 (03) Blink during trial            (1 = YES; 0 = NO)
% Column #066 (04) Miss time stamps              (1 = YES; 0 = NO)
% Column #067 (02) Online incorrect trial        (1 = YES; 0 = NO)
% Column #068 (06) Inaccurate saccade            (1 = YES; 0 = NO)
