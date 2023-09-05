import time
import Header


def feedback_judgement(reproduction):
    # provide feedback
    # too short: < 720ms; accurate: 720 ~ 880ms; too long: > 880ms
    feedback = ''
    if reproduction < Header.Dur_acc_l:
        Header.image_fb_short.draw()
        Header.win.flip()
        feedback = 0
    elif Header.Dur_acc_l <= reproduction <= Header.Dur_acc_u:
        Header.image_fb_acc.draw()
        Header.win.flip()
        feedback = 1
    elif reproduction > Header.Dur_acc_u:
        Header.image_fb_long.draw()
        Header.win.flip()
        feedback = 2

    time.sleep(Header.Dur_fb)
    Header.win.flip()

    return feedback
