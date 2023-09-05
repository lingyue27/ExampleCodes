import psychopy as py
import numpy as np
import os
import sys

from psychopy import visual, event, core, sound, gui

import random
import pprint

#from numpy.random import random, randint, normal, shuffle
#from numpy.random import random, randint, normal, shuffle

# Import predefined function
import Header
import OneCond

# Participant info
# -------------------------------------------------------------------------
# Info window
gui = gui.Dlg()

gui.addField("Subject ID:")
gui.addField("Initial:")
gui.addField("Gender:\n(F/M)")
gui.addField("Age:")

gui.show()

sub_id = gui.data[0]
subID = int(sub_id)
sub_initial = gui.data[1]
sub_gender = gui.data[2]
sub_age = gui.data[3]

print(gui.data)

# Create data file
par_path = "ParInfo_" + sub_id + "_" + sub_initial + ".txt"
data_path = "Sub_" + sub_id + "_" + sub_initial + ".csv"

if os.path.exists(data_path):
    sys.exit("Data path " + data_path + " already exists!")

par_Info = "SubID:" + sub_id + "\nInitial:" + sub_initial + "\nGender:" + sub_gender + "\nAge:" + sub_age
# print(par_Info)

f = open(par_path, "w+")
f.write(par_Info)
f.close()


exp_data = []
# -------------------------------------------------------------------------

# Setup the window
# -------------------------------------------------------------------------
# win = visual.Window(
#     size=[1366, 768], fullscr=False, screen=0,
#     winType='pyglet', allowGUI=True, allowStencil=False,
#     monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
#     blendMode='avg', useFBO=True) # window from previous version

# win = visual.Window(
#     size=[1440, 900],
#     units="pix",
#     fullscr=True,
#     color=[1, 1, 1]
# )
# Mouse invisible in the window
Header.win.mouseVisible = False
# -------------------------------------------------------------------------


# Instruction
# -------------------------------------------------------------------------
Header.image_intro.draw()
Header.win.flip()
event.waitKeys(keyList=["space"])
print("instruction")

# Header.text_int.draw()
# Header.win.flip()
# print(Header.test)
# event.waitKeys(keyList=["space"])
# -------------------------------------------------------------------------

# AutoTrial.AutoTrial()
Cond = Header.Cond
random.shuffle(Cond)
CondNo = 1
while CondNo <= Header.nCond:
    Cond = Header.Cond[CondNo-1]
    OneCond.one_cond(exp_data, subID, CondNo, Cond)
    if CondNo < Header.nCond:
        Header.image_break_cond.draw()
        Header.win.flip()
        event.waitKeys(keyList=["space"])
        Header.win.flip()
    CondNo = CondNo + 1
    if Header.defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()

# Save data file
# All results must in the format of number but not string
np.savetxt(
    data_path,
    exp_data,
    delimiter=","
)
data = np.loadtxt(
    data_path,
    delimiter=","
)
# print(data.tolist())
Header.image_end.draw()
Header.win.flip()
event.waitKeys()
Header.win.close()
