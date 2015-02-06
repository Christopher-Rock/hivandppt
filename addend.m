function addend(x,y,colors)
%% Setup
    ax=gca;
    h=ax.YLim(2)/8;
    wo=diff(ax.XLim)/2;
    hold on
%%  Do this with a bar plot
    h=bar([x x+wo],[zeros(1,4);y(:)'])
    
%% Try to do this with rectangles
%     for ii=1:length(y)
%         rectangle('Position',[x+wo*(.5+mod(ii,2)),y(ii)-h/2,wo,h],'FaceColor',colors(ii,:))
%         text(x+wo*(.55+mod(ii,2)),y(ii),sprintf('%2g%%',round(y(ii)*100,1)),'color',[1 1 1])
% %         plot([x x+wo*(1+mod(ii,2))],[y(ii) y(ii)],'LineStyle','--','color',colors(ii,:))
%     end
