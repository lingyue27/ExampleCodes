from psychopy import visual, event, core
from pyglet.window import key


import time

import Header
import Trial_Start
import Trial_Feedback
import Trial_End


def trial_fixonsetdelay(exp_data, subid, condno, cond, blockno, trialno):

    dur = Header.Dur_delay

    keystate = key.KeyStateHandler()
    Header.win.winHandle.push_handlers(keystate)

    clock = core.Clock()
    sound = Header.sound

    # display fixation and 1st stimulus
    Trial_Start.trial_start()

    # display tactile stimulus again when the key "space" is pressed
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

    # print('keystate:', keystate[2])

    # calculate the time
    t_end = clock.getTime()
    reproduction = t_end - t_start

    # provide feedback
    # too short: < 720ms; accurate: 720 ~ 880ms; too long: > 880ms
    feedback = Trial_Feedback.feedback_judgement(reproduction)

    # display mask and between trial gap
    dur_trial_gap = Trial_End.trial_end()

    # always no feedback in this condition
    feedback = 0

    # trial type: Adptation: 0, test: 1
    trialtype = 0

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
# trial_fixonsetdelay(exp_data, 1, 1, 1, 1)
