import random

from psychopy import core

import Header
import Trial_SynchOnset
import Trial_FixOnsetDelay
import Trial_Testing


def phase_test(exp_data, subid, condno, cond, blockno):
    # Top-up trials --------------------------------
    # 5 trials with feedback
    # according to the condition type (synchronous /random onset)
    i = 0
    while i < Header.nTrial_top:
    # while i < 2: # fake trial number for code testing
        if cond == 1:
            trialno = i + 1
            Trial_SynchOnset.trial_synchonset(exp_data, subid, condno, cond, blockno, trialno)
        elif cond == 2:
            trialno = i + 1
            Trial_FixOnsetDelay.trial_fixonsetdelay(exp_data, subid, condno, cond, blockno, trialno)
        i = i + 1
        # check for quit (with the Esc key)
        if Header.defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()

    # Testing trials --------------------------------
    # 15 trials without feedback
    # 5 levels of onset delay (random shuffle for each block)
    l_dur = Header.l_Dur_test
    random.shuffle(l_dur)
    j = 0
    while j < Header.nTotal_test:
    # while j < 2: # fake trial number for code testing
        dur = l_dur[j]
        trialno = j + 1
        Trial_Testing.trial_testing(exp_data, subid, condno, cond, blockno, trialno, dur)
        j = j + 1
        # check for quit (with the Esc key)
        if Header.defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()

    return
