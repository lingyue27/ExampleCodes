import time

import Header


# the same starting part for each type of the trials
# 400ms fixation + 800ms standard stimulus (vibration)
def trial_start():

    sound = Header.sound
    Dur_st = Header.Dur_st

    # display fixation for 400ms
    Header.fixation.draw()
    Header.win.flip()
    time.sleep(Header.Dur_fix)

    # display tactile stimulus for 800ms
    sound.play()
    time.sleep(Dur_st)
    sound.stop()
