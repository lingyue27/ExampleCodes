import time

import Header
import numpy as np


# the same ending part for each type of the trials
# old design: 400ms mask + 200ms empty gap
# new design: 1~2s random gap between trials
def trial_end():

    # old design: mask
    # present a visual mask between trials for 400ms
    # Header.image_mask.draw()
    # Header.win.flip()
    # time.sleep(Header.Dur_mask)
    # Header.win.flip()

    # create random gap duration for each trial
    dur_trial_gap = np.random.uniform(Header.Dur_TRand_l, Header.Dur_TRand_u)

    # empty gap between trials for 200ms
    time.sleep(dur_trial_gap)
    Header.win.flip()

    return dur_trial_gap
