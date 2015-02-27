function mybar(names, data, metric, col, savestr,loc,varargin)
    if nargin<6,loc='Best';end
    lone=0;
    if any(strcmp(varargin,'lone'))
        lone=1;
        data=[data zeros(4,1)];
    end
    if isa(names,'char'),names={names};end
    labels=cellfun(@(x)x(1:end),names,'UniformOutput',false);
 %   labels=strcat(repmat({'Increase ';'Decrease '},length(names)/2,1),labels);
    clf
    set(gca,'ColorOrder',col)
    bar(data'*100)
    b=get(gca,'xtick')+0.5;
    if lone
        b=b(1);
    end
    c1=get(gca,'ytick');
    c=(c1(1))*b./b;
    try
    a=text(1,c,labels,'rotation',0,'HorizontalAlignment','center','VerticalAlignment','top','FontSize',13);
    catch
        0;
    end
    set(gca,'XTick',[])
    ylabel('Change in impact of PPT (%)')
    title({['Sensitivity of ' metric], ' to changes in parameters'})
    set(gca,'FontSize',13)
    g=gca;
    xlim([min(b)-1 max(b)+0.1])
    g.OuterPosition=[-0.05*(length(names)>6) 0.1 1.1 0.9];
    set(gcf,'PaperPosition',[0 0 12 8]);
    hold on
    plot([b(1:end-1);b(1:end-1)]+0.05,repmat(ylim',1,length(b)-1),'k--')
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',},'Location',loc)
    
    if ~isempty(savestr)
        saveas(gcf,savestr)
    end
end
