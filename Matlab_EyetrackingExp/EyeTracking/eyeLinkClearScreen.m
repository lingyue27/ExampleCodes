function eyeLinkClearScreen(color)
% ----------------------------------------------------------------------
% eyeLinkClearScreen(color)
% ----------------------------------------------------------------------
% Goal of the function :
% Clear screen on the eyelink display.
% ----------------------------------------------------------------------
% Input(s) :
% color : color of the background (1 to 15)
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 19 / 12 / 2016
% Project :     FeatureGhost
% Version :     1.0
% ----------------------------------------------------------------------

Eyelink('command','clear_screen %d',color);

end