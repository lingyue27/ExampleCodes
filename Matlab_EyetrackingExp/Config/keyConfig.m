function [my_key] = keyConfig
% ----------------------------------------------------------------------
% [my_key] = keyConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Unify key names and return a structure containing each key names.
% ----------------------------------------------------------------------
% Input(s) :
% none
% ----------------------------------------------------------------------
% Output(s):
% my_key : structure containing keyboard settings
% ----------------------------------------------------------------------
% Lukasz GRZECZKOWSKI                    (lukasz.grzeczkowski@gmail.com)
% Updated...........15 | 07 | 2019
% Project.....................CHIB
% Version........................4
% ----------------------------------------------------------------------
%
% Define keyboard config
% ----------------------
KbName('UnifyKeyNames');
my_key.escape = KbName('ESCAPE');
my_key.space  = KbName('Space');
my_key.up     = KbName('UpArrow');
my_key.down   = KbName('DownArrow');
my_key.left   = KbName('LeftArrow');
my_key.right  = KbName('RightArrow');

end