function my_bar(scr,color,rect)
% ----------------------------------------------------------------------
% my_bar(scr,color,rect)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a circle or oval in position (x,y) with radius (r).
% ----------------------------------------------------------------------
% Input(s) :
% scr = Window Pointer                              ex : wptr
% color = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% x = position x of the center                      ex : x = 550
% y = position y of the center                      ex : y = 330
% r = radius for X (in pixel)                       ex : r = 25
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Original script by Martin SZINTE             
% Updated :         22 | 07 | 2018
% Project :                   IBCH
% Version :                    1.0
% ----------------------------------------------------------------------
Screen('FillRect', scr, color, rect )


end