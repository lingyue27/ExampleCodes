function drawCompVal(figSet) 
% ----------------------------------------------------------------------
% drawCompVal(figSet) 
% ----------------------------------------------------------------------
% Goal of the function :
% Draw main position comparison values
% ----------------------------------------------------------------------
% Input(s) :
% figSet : figure settings
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited  by Lukasz GRZECZKOWSKI (lukasz.grzeczkowski@gmail.com)
% Last update : 14 / 03 / 2016
% Project :     FeatureGhost
% Version :     3.0
% ----------------------------------------------------------------------
hold on;
stepX = 0.25;
stepY = 0.25;

% define axis and arrange data in that axis
xGrid           = linspace(-1.25,1.25,size(figSet.yTickNameL1,2)*2+1);
yGrid           = -0.75:stepY:0.75;
lengthTick      = 0.1;
rangeGraph      = yGrid(end) - yGrid(1);
rangeData       = figSet.maxScale - figSet.minScale;
xPlot1          = xGrid(2:2:end);
xPlot2          = xGrid(2:2:end);
yPlot1          = -(figSet.yPlot1-figSet.minScale)*(rangeGraph/rangeData)+yGrid(end);yPlot1 = yPlot1';
if ~isempty(figSet.yPlot2)
    yPlot2      = -(figSet.yPlot2-figSet.minScale)*(rangeGraph/rangeData)+yGrid(end);yPlot2 = yPlot2';
end
if figSet.showStats
	yPlot1_eb_min = -(figSet.yPlot1_eb_min-figSet.minScale)*(rangeGraph/rangeData)+yGrid(end);yPlot1_eb_min = yPlot1_eb_min';
	yPlot1_eb_max = -(figSet.yPlot1_eb_max-figSet.minScale)*(rangeGraph/rangeData)+yGrid(end);yPlot1_eb_max = yPlot1_eb_max';
    if ~isempty(figSet.yPlot2)
        yPlot2_eb_min = -(figSet.yPlot2_eb_min-figSet.minScale)*(rangeGraph/rangeData)+yGrid(end);yPlot2_eb_min = yPlot2_eb_min';
        yPlot2_eb_max = -(figSet.yPlot2_eb_max-figSet.minScale)*(rangeGraph/rangeData)+yGrid(end);yPlot2_eb_max = yPlot2_eb_max';
    end
end

% x axis/label
xaxisX = linspace(xGrid(1),xGrid(end),100);
yaxisX = yGrid(end)+stepY/2;
plot(xaxisX,0*xaxisX+yaxisX,'k','LineWidth',figSet.axisWidth)
if ~isempty(figSet.yTickNameL2)
    ytextAxisX1 = yaxisX+0.2;
    ytextAxisX2 = yaxisX+0.35;
else
    ytextAxisX1 = yaxisX+0.275;
    ytextAxisX2 = yaxisX+0.375;
end

ytickX = yaxisX:0.01:yaxisX+lengthTick/1.5;
numTName = 0;
for tTick = 2:2:size(xGrid,2);
    numTName = numTName+1;
    plot(xGrid(tTick)+ytickX*0,ytickX,'LineWidth',figSet.axisWidth,'Color',figSet.black)
    text(xGrid(tTick),ytextAxisX1,sprintf('%s',figSet.yTickNameL1{numTName}),'HorizontalAlignment','center','FontSize',figSet.tickFontSize,'FontName',figSet.fontName);
    if ~isempty(figSet.yTickNameL2)
        text(xGrid(tTick),ytextAxisX2,sprintf('%s',figSet.yTickNameL2{numTName}),'HorizontalAlignment','center','FontSize',figSet.tickFontSize,'FontName',figSet.fontName);
    end
end
text(0,ytextAxisX2+0.2,'Conditions','HorizontalAlignment','center','FontSize',figSet.labelFontSize,'FontName',figSet.fontName)

% y axis/label
yaxisY = linspace(yGrid(1),yGrid(end),100);
xaxisY = xGrid(1)-stepX/2;
plot(0*yaxisY+xaxisY,yaxisY,'LineWidth',figSet.axisWidth,'Color',[0,0,0])
xtextAxisX = xaxisY-0.2;
xtickY = xaxisY:-0.01:xaxisY-lengthTick/1.5;
ytickY = linspace(yGrid(1),yGrid(end),figSet.tickNum);
labelY = linspace(figSet.maxScale,figSet.minScale,figSet.tickNum);

for tTick = 1:figSet.tickNum
    plot(xtickY,xtickY*0+ytickY(tTick),'LineWidth',figSet.axisWidth,'Color',figSet.black)
    text(xtextAxisX,ytickY(tTick),sprintf('%1.3g',labelY(tTick)),'HorizontalAlignment','center','FontSize',figSet.tickFontSize,'FontName',figSet.fontName);
end
text(xtextAxisX-0.3,0,figSet.unitTxt,'HorizontalAlignment','center','Rotation',90,'FontSize',figSet.labelFontSize,'FontName',figSet.fontName)

% background
fill([xGrid(1),xGrid(end),xGrid(end),xGrid(1)],[yGrid(1),yGrid(1),yGrid(end),yGrid(end)],'r','FaceColor',figSet.beige,'LineStyle','none')

% plot data
sepGap = 0.15;
if ~figSet.draw2Values
    xPlot1 = xPlot1 - sepGap/2;
    xPlot2 = xPlot2 + sepGap/2;
end

% plot ci bars
if figSet.showStats
    for tPlotEB = 1:size(yPlot1,2)
        ebY1 = linspace(yPlot1_eb_min(tPlotEB),yPlot1_eb_max(tPlotEB),20);
        ebX1 = ebY1*0 + xPlot1(tPlotEB);
        plot(ebX1,ebY1,'Color',figSet.colPlot1,'LineWidth',figSet.ebWidth)
        if ~isempty(figSet.yPlot2)
            ebY2 = linspace(yPlot2_eb_min(tPlotEB),yPlot2_eb_max(tPlotEB),20);
            ebX2 = ebY2*0 + xPlot2(tPlotEB);
            plot(ebX2,ebY2,'Color',figSet.colPlot2,'LineWidth',figSet.ebWidth) 
        end
    end
end 

% plot statistics bars
if figSet.showStats
    if isempty(figSet.starComp)
        for tComp = 1:size(figSet.starRes,1)
            if ~figSet.draw2Values
                xComp = linspace(xPlot1(tComp),xPlot2(tComp),20);
            else
                xComp = linspace(xPlot1(1),xPlot1(2),20);
            end
            yComp = xComp*0+yGrid(end)-0.1;
            
            plot(xComp,yComp,'LineWidth',figSet.axisWidth/2,'Color',figSet.black)
            yStar = yComp-0.1;
            if figSet.starRes(tComp) ~= 0
                starSize = figSet.starSizeVal(abs(figSet.starRes(tComp))+1);
                plot(mean(xComp),yStar(1),'p','LineWidth',figSet.axisWidth,'MarkerEdgeColor',figSet.black,'MarkerFaceColor',figSet.black,'MarkerSize',starSize)
            else
                text(mean(xComp),yStar(1),'ns','HorizontalAlignment','center','VerticalAlignment','middle','Color',figSet.black,...
                    'FontSize',figSet.tickFontSize,'FontName',figSet.fontName);
            end
        end
    else
        for tComp = 1:size(figSet.starComp,1)
            xComp = linspace(xPlot1(figSet.starComp(tComp,1)),xPlot1(figSet.starComp(tComp,2)),20);
            yComp = xComp*0+yGrid(end)-(0.025 + 0.075*tComp);
            
            yStar = yComp;
            
            if mod(tComp,2)
                xStar = xGrid(1)+0.1;
                colStar = figSet.gray50;
            else
                xStar = xGrid(end)-0.1;
                colStar = figSet.black;
            end
            plot(xComp,yComp,'-','LineWidth',figSet.axisWidth/2,'Color',colStar)
            if figSet.starRes(tComp) ~= 0
                starSize = figSet.starSizeVal(abs(figSet.starRes(tComp))+1);
                plot(xStar,yStar(1),'p','LineWidth',figSet.axisWidth,'MarkerEdgeColor',colStar,'MarkerFaceColor',colStar,'MarkerSize',starSize)
            else
                text(xStar,yStar(1),'ns','HorizontalAlignment','center','VerticalAlignment','middle','Color',colStar,...
                    'FontSize',figSet.tickFontSize,'FontName',figSet.fontName);
            end
        end
    end
end


% plot data dots
plot(xPlot1,yPlot1,'s','MarkerSize',6,'MarkerEdgeColor',figSet.colPlot1,'MarkerFaceColor',figSet.white,...
    'LineWidth',figSet.ebWidth,'Color',figSet.colPlot1);

if ~isempty(figSet.yPlot2)
    plot(xPlot2,yPlot2,'s','MarkerSize',6,'MarkerEdgeColor',figSet.colPlot2,'MarkerFaceColor',figSet.white,...
        'LineWidth',figSet.ebWidth,'Color',figSet.colPlot2);
end


% Title column
text(0,yGrid(1)-1*stepY,figSet.textPlot,'HorizontalAlignment','center','FontSize',figSet.labelFontSize,'FontName',figSet.fontName);

% plot colored dot legend
if ~isempty(figSet.legTxt)
    
    plot(xGrid(1)-3*stepX,yGrid(end)+stepY*4.4,'s','MarkerSize',4,'LineWidth',figSet.ebWidth,'MarkerFaceCol', figSet.white,'MarkerEdgeCol', figSet.colPlot1);
    text(xGrid(1)-2.5*stepX,yGrid(end)+stepY*4.4,figSet.legTxt{1},'HorizontalAlignment','left','FontSize',figSet.legFontSize,'FontName',figSet.fontName);
    if size(figSet.legTxt,2) == 2
        plot(xGrid(1)-3*stepX,yGrid(end)+stepY*5.1,'s','MarkerSize',4,'LineWidth',figSet.ebWidth,'MarkerFaceCol', figSet.white,'MarkerEdgeCol', figSet.colPlot2);
        text(xGrid(1)-2.5*stepX,yGrid(end)+stepY*5.1,figSet.legTxt{2},'HorizontalAlignment','left','FontSize',figSet.legFontSize,'FontName',figSet.fontName);
    end
    
end

if figSet.showStats
    if figSet.leg
        xLegStar1 = xGrid(1)+2*stepX;       xLegStar3 = xGrid(1)+8*stepX;
        xLegStar2 = xLegStar1;              xLegStar4 = xLegStar3;
        yLegStar1 = yGrid(end)+stepY*4.4;   yLegStar2 = yGrid(end)+stepY*5.1;
        yLegStar3 = yLegStar1;              yLegStar4 = yLegStar2;
    else
        xLegStar1 = xGrid(1);               xLegStar3 = xGrid(1)+6.5*stepX;
        xLegStar2 = xLegStar1;              xLegStar4 = xLegStar3;
        yLegStar1 = yGrid(end)+stepY*4.4;   yLegStar2 = yGrid(end)+stepY*5.1;
        yLegStar3 = yLegStar1;              yLegStar4 = yLegStar2;
    end
    
    plot(xLegStar1,yLegStar1,'p','LineWidth',figSet.axisWidth,'MarkerEdgeColor',figSet.black,'MarkerFaceColor',figSet.black,'MarkerSize',figSet.starSizeVal(2))
    plot(xLegStar2,yLegStar2,'p','LineWidth',figSet.axisWidth,'MarkerEdgeColor',figSet.black,'MarkerFaceColor',figSet.black,'MarkerSize',figSet.starSizeVal(3))
    plot(xLegStar3,yLegStar3,'p','LineWidth',figSet.axisWidth,'MarkerEdgeColor',figSet.black,'MarkerFaceColor',figSet.black,'MarkerSize',figSet.starSizeVal(4))
    plot(xLegStar4,yLegStar4,'p','LineWidth',figSet.axisWidth,'MarkerEdgeColor',figSet.black,'MarkerFaceColor',figSet.black,'MarkerSize',figSet.starSizeVal(5))
    
    text(xLegStar1+0.5*stepX,yLegStar1,'{\itp} < 0.05','HorizontalAlignment','left','VerticalAlignment','middle','Color',figSet.black,'FontSize',figSet.legFontSize,'FontName',figSet.fontName)
    text(xLegStar2+0.5*stepX,yLegStar2,'0.05 < {\itp} \leq 0.01','HorizontalAlignment','left','VerticalAlignment','middle','Color',figSet.black,'FontSize',figSet.legFontSize,'FontName',figSet.fontName)
    text(xLegStar3+0.5*stepX,yLegStar3,'0.01 < {\itp} \leq 0.005','HorizontalAlignment','left','VerticalAlignment','middle','Color',figSet.black,'FontSize',figSet.legFontSize,'FontName',figSet.fontName)
    text(xLegStar4+0.5*stepX,yLegStar4,'0.005 < {\itp} \leq 0.001','HorizontalAlignment','left','VerticalAlignment','middle','Color',figSet.black,'FontSize',figSet.legFontSize,'FontName',figSet.fontName)
end



end