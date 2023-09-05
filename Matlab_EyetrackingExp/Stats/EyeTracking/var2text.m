function  [stimtext] = var2text(stimvar,side,expDes)
    

if  stimvar < 0;  side = (abs(side-1))-1; end

switch side
    case -1; sideTxt = expDes.stimSide{2,1};
    case  1; sideTxt = expDes.stimSide{2,2};
end

stimtext1 = num2str(abs(stimvar));
if  stimvar < 0
    stimtext2= [sideTxt 'c' stimtext1];
elseif stimvar > 0
    stimtext2= [sideTxt 'c' stimtext1];
elseif stimvar == 0
    stimtext2 = 'cc';
end

stimtext = stimtext2;