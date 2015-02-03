function plotmany(ratesall,fiverows,defrow)
    if iscell(ratesall),
        ratesall=assct(ratesall); end
    runset=1:2:length(ratesall);
    [~,~,rates]=smallsti(ratesall(1));
    clf;hold all
    cc=hsv(length(runset));set(gca,'ColorOrder',cc)
    plot((0:size(fiverows,2)-1)./rates.steps,fiverows)
    legend({sprintf('Cov 0.%d FSWs, freq. %d py',ratesall(runset(1)).zeta*100,ratesall(runset(1)).tau)})
    for run=runset(2:end)
        legend([get(legend(gca),'String') {sprintf('Cov 0.%d FSWs, freq. %d py',ratesall(run).zeta*100,ratesall(run).tau)}])
    end
    xlabel('Years since intervention')
    ylabel('Prevalence of _')
    if nargin==3
        plot((0:size(fiverows,2)-1)./rates.steps,defrow,'k');
        legend([get(legend(gca),'String') {'Baseline case (no intervention)'}])
    end
end
