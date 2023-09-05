from psychopy import visual, event, core
from pyglet.window import key

import time

import Header
import Trial_Start
import Trial_End


def trial_testing(exp_data, subid, condno, cond, blockno, trialno, dur):

    keystate = key.KeyStateHandler()
    Header.win.winHandle.push_handlers(keystate)

    clock = core.Clock()
    sound = Header.sound

    # display fixation and 1st stimulus
    Trial_Start.trial_start()

    # display visual stimulus again when the key "space" is pressed
    event.waitKeys(keyList='space')
    t_start = clock.getTime()
    time.sleep(dur)

    # play sound for vibration
    sound.play()
    while keystate[key.SPACE]:
        # display fixation during the vibration
        Header.fixation.draw()
        Header.win.flip()
        if Header.defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()
    # stop when key release
    if not keystate[2]:
        sound.stop()
        Header.win.flip()

    # calculate the time
    t_end = clock.getTime()
    reproduction = t_end - t_start

    # display mask and between trial gap
    dur_trial_gap = Trial_End.trial_end()

    # always no feedback in this condition
    feedback = 0

    # trial type: Adptation: 0, test: 1
    trialtype = 1

    # write the result
    exp_data.append(
        [
            subid,
            condno,
            cond,
            blockno,
            trialno,
            dur,
            t_start,
            t_end,
            reproduction,
            feedback,
            trialtype,
            dur_trial_gap
        ]
    )
    print(exp_data)

    return reproduction


# for testing individual trial
# exp_data = []
# trial_testing(exp_data, 1, 1, 1, 1, 0.2)
