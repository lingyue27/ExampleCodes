function [configEye] = xanaEyeMovements(config)
% ----------------------------------------------------------------------
% [configEye] = xanaEyeMovements(config)
% ----------------------------------------------------------------------
% Goal of the function :
% Define all settings of the gaze analysis
% ----------------------------------------------------------------------
% Input(s) :
% config : struct containing all settings
% ----------------------------------------------------------------------
% Output(s):
% configEye = struct containing eye data analysis
% ----------------------------------------------------------------------
% Created by Martin SZINTE (martin.szinte@gmail.com)
% edited by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 26 / 01 / 2017
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------

configEye.anaEye.MO_PHYS    = config.scr.disp_sizeX;            % X size of the monitor in cm.
configEye.anaEye.SAMPRATE   = config.el.sample_rate;            % Sampling rate of Eye Tracker.
configEye.anaEye.velSD      = 3;                                % Lambda threshold for microsaccade detection.
configEye.anaEye.minDur     = 20;                               % Duration threshold for microsaccade detection.
configEye.anaEye.VELTYPE    = 2;                                % Velocity type for saccade detection.
configEye.anaEye.maxMSAmp   = 1;                                % Maximum microsaccade amplitude.
configEye.anaEye.crit_cols  = [2 3];                            % Collumn in dat file containing critical information (x and y of the eye)
configEye.anaEye.mergeInt   = 20;                               % Merge interval for subsequent saccadic events.
configEye.anaEye.sacRadBfr  = config.const.boundRadBef*1;       % size of saccade fixation tolerance before saccade (pixels)
configEye.anaEye.sacRadAft  = config.const.boundRadAft*1;       % size of saccade fixation tolerance before saccade (pixels)
configEye.anaEye.DPP        = pix2vaDeg(1,config.scr);          % degrees per pixel
configEye.anaEye.DPP        = configEye.anaEye.DPP(1);
[configEye.anaEye.PPD,~]    = vaDeg2pix(1,config.scr);          % pixels per degree

end