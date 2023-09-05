# Header
# -------------------------------------------------------------------------
# By          : Lingyue CHEN, supervised by Zhuanghua SHI
# Start date  : 26 June | 2021
# Projet      : Implicit Intentional Binding (Onset delay) -- Exp 4
# Coded by    : Lingyue CHEN
# Notes       : Tactile temporal reproduction task
#               General structure: same as Exp 1 & 2 (same testing as Exp 4)
#               Change: visual -> tactile
#
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------

import numpy as np
import psychopy as py

from psychopy.hardware import keyboard
from pyglet.window import key


# Config
# -------------------------------------------------------------------------
# Design config (
#   2 conditions (Synchronous / Fixed-onset-delay)
# x 2 phases (Adaptation / Testing)
#
# -- Adaptation phase --
# x 50 trials
# x fixed onset delay (150ms) in Fixed-onset-delay condition
#   or synchronous onset in Synchronous condition
# + n*10 trials (n >= 0, always test the last 10 trials for reproduction accuracy, and add 10 more trials when failed)
# = 50 + n10 trials
#
# -- Testing phase --
# x 13 blocks
# x 21 trials (
#      5 top-up trials (same as in the adaptation phase)
#   + (4 testing trials
#   (new design) x 4 onset delay levels (0:50:150ms)))
# = 260 trials
#
# = 2 x (50 + 13 x (5 + 4 x 4)) + 10(n1 + n2) trials
# = 646 + 10(n1 + n2) trials
# = 2 conditions of (1 block of (50 + 10n) trials  + 13 blocks of 21 trials)


# Ns ----------------------------------------
nCond = 2                                      # condition number
nBlock_test = 13                               # block number of testing phase in each condition
nTotal_block = nBlock_test * nCond             # total block number
nTrial_adap = 50                               # trial number in each adaptation phase
nTrial_top = 5                                 # trial number of top-up trial in each testing block
nDur = 4                                       # level number of probe duration
nTrial_test = 4                                # trial number of testing trial of each level in each block
nTotal_test = nDur * nTrial_test               # total testing trial number of each block
nTrial_rep = 10                                # trial number of each repeated round by the end of adaptation phase


# Ns for testing codes ----------------------
# fake numbers for quick debugging
# nCond = 2                                      # condition number
# nBlock_test = 2                                # block number of testing phase in each condition
# nTotal_block = nBlock_test * nCond             # total block number
# nTrial_adap = 2                                # trial number in each adaptation phase
# nTrial_top = 2                                 # trial number in each adaptation phase
# nDur = 4                                       # level number of probe duration
# nTrial_test = 1                                # trial number of testing trial of each level in each block
# nTotal_test = nDur * nTrial_test               # total testing trial number of each block
# nTrial_rep = 2                                 # trial number of each repeated round by the end of adaptation phase
# -------------------------------------------


Cond = [1, 2]                                  # condition type, 1: synchronous, 2: fixed-onset-delay


# Timing settings ---------------------------
Dur_fix = 0.4                                  # fixation duration for each trial(s)
Dur_st = 0.8                                   # standard duration(s): the first stimuli display
Dur_delay = 0.15                               # fixed onset delay duration(s) for the fixed-onset delay adaptation

Dur_test_ms = list(np.arange(0, 200, 50))      # onset delay duration level(ms) for testing trials
                                               # (can't use when the step is non-integer)
                                               # would not include the stop number, so need to count to 200 in order to include 150
Dur_test = [i/1000 for i in Dur_test_ms]       # duration level(s), transfer to "s" (can't divide list directly, need to divide each element in the list)
l_Dur_test = Dur_test * nTrial_test            # list of duration level for each block (shuffle before each block)

Dur_acc_dis = 0.08                             # accuracy distance range for reproduction (s)
Dur_acc_l = Dur_st - Dur_acc_dis               # lower accuracy range for reproduction
Dur_acc_u = Dur_st + Dur_acc_dis               # upper accuracy range for reproduction

# Dur_rand_l = 0.2                             # lower random delay range for random-onset adaptation
# Dur_rand_u = 1.2                             # upper random delay range for random-onset adaptation

# Dur_rand_l = 0.4             # for testing   # lower random delay range for random-onset adaptation
# Dur_rand_u = 0.8             # for testing   # upper random delay range for random-onset adaptation

Dur_TRand_l = 1                                 # lower random delay range for between trail gap
Dur_TRand_u = 2                                 # upper random delay range for between trial gap

Dur_fb = 0.4                                   # feedback display duration
Dur_mask = 0.4                                 # mask duration between trials (s), insert by the end of each trial
Dur_trial_end = 1                            # waiting duration between trials (s), insert by the end of each trial


# Stimuli setting ----------------------------
# (
# -- Center disks --
# white
# 1st time: present for the standard duration
# 2nd time: present for reproduction or random-onset durations)
#
# -- Reproduction cue --
# Please press space to reproduce the time
#
# -- Feedback --
# adaptation phase and top-up trials
# "too long", "accurate", "too short")


r_disk = 30                                    # disk r


# -- Position --
PosX_disk = 0                                  # x position of the disk
PosY_disk = 0                                  # y position of the disk
# PosX_fix = 0.98                              # x position of the disk (setting in mac)
PosX_fix = 0                                   # x position of the disk
PosY_fix = 0                                   # y position of the disk
PosX_fb = 1                                    # x position of the feedback note
PosY_fb = 0                                    # y position of the feedback note

# -- color --
Col_white = [1, 1, 1]                          # color: white


# Setup the window
# -------------------------------------------------------------------------
win = py.visual.Window(
    size=[1366, 768], fullscr=False, screen=0,
    winType='pyglet', allowGUI=True, allowStencil=False,
    monitor='testMonitor', color=[0, 0, 0], colorSpace='rgb',
    blendMode='avg', useFBO=True)              # window from previous experiment
# -------------------------------------------------------------------------


# Setup hardware
# -------------------------------------------------------------------------
# Create a default keyboard (e.g. to check for escape)
defaultKeyboard = keyboard.Keyboard()

# Check key status
# Simple handler that tracks the state of keys on the keyboard.
# If a key is pressed then this handler holds a True value for it.
keyState = key.KeyStateHandler()
# -------------------------------------------------------------------------


# Instructions
# -------------------------------------------------------------------------
# set image path
path = "figures/"


# General instruction --------------------------------
# image
image_intro = py.visual.ImageStim(
    win=win,
    image=path + "image_intro.png",
    units="pix"
)
image_intro.size = [1050, 700]


# Phase instruction --------------------------------
# -- Adaptation（training） --
# image
image_adapt_intro = py.visual.ImageStim(
    win=win,
    image=path + "image_adapt_intro.png",
    units="pix"
)
image_adapt_intro.size = [1265, 700]

# # -- Testing --
# # image
image_test_intro = py.visual.ImageStim(
    win=win,
    image=path + "image_test_intro.png",
    units="pix"
)
image_test_intro.size = [1060, 700]

# image
image_test_intro2 = py.visual.ImageStim(
    win=win,
    image=path + "image_test_intro2.png",
    units="pix"
)
image_test_intro2.size = [1265, 700]


# Break instruction --------------------------------
# -- Between Conditions --
# image
image_break_cond = py.visual.ImageStim(
    win=win,
    image=path + "image_break_cond.png",
    units="pix"
)
image_break_cond.size = [1277, 700]

# -- After adaptation phase --
# # image
image_break_adapt = py.visual.ImageStim(
    win=win,
    image=path + "image_break_adapt.png",
    units="pix"
)
image_break_adapt.size = [1214, 700]

# -- Between blocks --
# # image
image_break_block = py.visual.ImageStim(
    win=win,
    image=path + "image_break_block.png",
    units="pix"
)
image_break_block.size = [835, 700]


# End words --------------------------------
# image
image_end = py.visual.ImageStim(
    win=win,
    image=path + "image_end.png",
    units="pix"
)
image_end.size = [1162, 700]


# Stimuli
# -------------------------------------------------------------------------
# Fixation --------------------------------
fixation = py.visual.TextStim(
    win=win,
    text="+",
    color=[-1, -1, -1]
)
fixation.pos = [PosX_fix, PosY_fix]


# Sound --------------------------------
# for vibration
sound = py.sound.Sound(
    # value=500,
    value=path + 'tone_1000.wav',
    # secs=0.5,
    stereo=True, hamming=True
)
sound.setVolume(1)


# Feedback
# -------------------------------------------------------------------------
# Too short --------------------------------
# -- Text --
fb_short = py.visual.TextStim(
    win=win,
    text="too short",
    color=[-1, -1, -1]
)
fb_short.pos = [PosX_fb, PosY_fb]


# Accurate --------------------------------
# -- Text --
fb_acc = py.visual.TextStim(
    win=win,
    text="good",
    color=[-1, -1, -1]
)
fb_acc.pos = [PosX_fb, PosY_fb]


# Too long --------------------------------
# -- Text --
fb_long = py.visual.TextStim(
    win=win,
    text="too long",
    color=[-1, -1, -1]
)
fb_long.pos = [PosX_fb, PosY_fb]
