from psychopy import core, event

import Header
import Phase_Adapt
import Phase_test


def one_cond(exp_data, subid, condno, cond):
    # Adaptation phase --------------------------------
    # 50 trials + 10n
    # display the instruction for adaptation phase
    Header.image_adapt_intro.draw()
    Header.win.flip()
    event.waitKeys(keyList=["space"])
    Header.win.flip()

    # run adaptation phase
    blockno = 0
    Phase_Adapt.phase_adapt(exp_data, subid, condno, cond, blockno)

    # display break image between the adaptation and testing phase
    Header.image_break_adapt.draw()
    Header.win.flip()
    event.waitKeys(keyList=["space"])
    Header.win.flip()

    # Testing phase --------------------------------
    # 13 blocks (top-up trials + testing trials)
    # display the instruction for testing phase (2 pages)
    Header.image_test_intro.draw()
    Header.win.flip()
    event.waitKeys(keyList=["space"])
    Header.win.flip()

    Header.image_test_intro2.draw()
    Header.win.flip()
    event.waitKeys(keyList=["space"])
    Header.win.flip()

    # run testing phase
    blockno = 1
    # run in each block
    while blockno <= Header.nBlock_test:
        Phase_test.phase_test(exp_data, subid, condno, cond, blockno)
        if blockno < Header.nBlock_test:
            Header.image_break_block.draw()
            Header.win.flip()
            event.waitKeys(keyList=["space"])
            Header.win.flip()
        blockno = blockno + 1
        if Header.defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()

    return
