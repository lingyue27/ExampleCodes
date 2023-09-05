from psychopy import core

import Header
import Trial_SynchOnset
import Trial_FixOnsetDelay


def phase_adapt(exp_data, subid, condno, cond, blockno):
    # Training round --------------------------------
    # 50 trials with feedback
    # according to the condition type (synchronous /random onset)
    i = 0
    while i < Header.nTrial_adap:
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

    # Reenforcing round --------------------------------
    # 10 trials with feedback for each round
    # check the accuracy and decide if need to do more rounds
    dur_mean = 0
    while dur_mean < Header.Dur_acc_l or dur_mean > Header.Dur_acc_u:
        j = 0
        dur_sum = 0
        while j < Header.nTrial_rep:
        # while j < 2: # fake trial number for code testing
            dur_reprod = 0
            if cond == 1:
                trialno = j + 1 + Header.nTrial_adap
                dur_reprod = Trial_SynchOnset.trial_synchonset(exp_data, subid, condno, cond, blockno, trialno)
            elif cond == 2:
                trialno = j + 1 + Header.nTrial_adap
                dur_reprod = Trial_FixOnsetDelay.trial_fixonsetdelay(exp_data, subid, condno, cond, blockno, trialno)
            j = j + 1
            dur_sum = dur_sum + dur_reprod
            # check for quit (with the Esc key)
            if Header.defaultKeyboard.getKeys(keyList=["escape"]):
                core.quit()
        dur_mean = dur_sum / Header.nTrial_rep

    return
