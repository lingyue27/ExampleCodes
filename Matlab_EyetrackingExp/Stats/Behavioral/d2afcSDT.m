function d=d2afcSDT(p)
% ----------------------------------------------------------------------
% d=d2afc(p)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute the d' for a 2AFC task using SDT formula z(hit) - z(FA)
% ----------------------------------------------------------------------
% Input(s) :
% p : percentage correct
% ----------------------------------------------------------------------
% Output(s):
% d : d' sensitivity
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 23 / 12 / 2016
% Project :     FeatureGhost
% Version :     2.0
% ----------------------------------------------------------------------

% these lines below are necessary as if p equal 1 or 0 the z are infinite
if p == 1
    p = 0.99;
elseif p == 0
    p = 0.01;
end

pHit_all = p;   % proportion of saying correct when correct
pFA_all  = 1-p; % proportion of saying correct when not correct

d = (norminv(pHit_all) - norminv(pFA_all));

end