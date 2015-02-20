function ratios=main(inrates,runset,nplot,popsplit,splot)
    clf;
    hold on;
    addnames=0;
    if nargin==1|strcmp(runset,'a')
        if isstruct(inrates)
            runs=numel(inrates);
        else
            runs=size(inrates,1)-1;
        end
        runset=1:runs;
    elseif isequal(runset,0)|isempty(runset)
        if isequal(runset,0)
            addnames=1; end
        if isstruct(inrates)
            runs=numel(inrates);
        else
            runs=size(inrates,1)-1;
        end
        runset=1:runs;
    elseif max(runset)>numel(inrates)
        error('MATLAB:badsubscript','RUNSET must not exceed NUMEL(INRATES)')
    end
    if nargin<3
        nplot=0;
        splot=0;
    elseif nargin<4
        splot=0;
    end
    quick=0;
    if strcmp(nplot,'quick')
        quick=1;
        quickarg=popsplit;
        nplot=0;
        splot=0;
    end
    %% Prepare for main loop
    disp([repmat(' ',1,numel(runset)-1),'|'])
    if ~isstruct(inrates)
        ratesall=assct(inrates);
    else
        ratesall=inrates;
    end
    if ~quick
        ratios=zeros(2,length(runset));
    else
        ratios1=smallsti(ratesall(runset(1)),'quick',quickarg);
        ratios=repmat(ratios1,1,length(runset));
    end
    try %#ok<TRYNC>
    oldfig=get(gcf,'Number');
    clf(oldfig-1+2*(oldfig<=1),'reset')
    end
    if ~nplot
        %% Main loop 1
        for run=runset
            rates=ratesall(run);
            if ~quick
                ratios(:,run==runset)=smallsti(rates);
            else
                ratios(:,run==runset)=smallsti(rates,'quick',quickarg);
            end
            set(gca,'ColorOrderIndex',1)
            fprintf('1')
        end
    else
        run=runset(1);
        rates=ratesall(run);
        [ratios(:,run==runset),~,~,prpl1,popint]=smallsti(rates);
        prpls=zeros(length(runset),length(prpl1));
        ppis=zeros(length(runset),length(popint(4,:)));
        prpls(1,:)=prpl1;
        ppis(1,:)=popint(4,:);
        fprintf('1')
        %% Main loop 2
        for run=runset(2:end)
            rates=ratesall(run);
            [ratios(:,run==runset),~,~,prpls(run==runset,:),popint]=smallsti(rates);
            ppis(run==runset,:)=popint(4,:);
            set(gca,'ColorOrderIndex',1)
            fprintf('1')
        end
    end
    %% Close out
    fprintf('\n')
    hold off;
    if addnames
        ratios=array2table(reshape(ratios,size(ratios).*[2 .5]),'VariableNames',inrates(2:2:end,1)');
    end
    %% NPLOT
    if nplot
        sprpl=prpls(1:2:end,:)*(1-popsplit)+prpls(2:2:end,:)*popsplit;
        sppis=ppis(1:2:end,:)*(1-popsplit)+ppis(2:2:end,:)*popsplit;
        plotmany(ratesall(runset),sprpl);
%         clf;hold all
%         cc=hsv(length(runset));set(gca,'ColorOrder',cc)
%         plot((0:length(prpl1)-1)./rates.steps,sppis)% sprpl)
%         legend({sprintf('Cov 0.%d FSWs, freq. %d py',ratesall(runset(1)).zeta*100,ratesall(runset(1)).tau)})
%         for run=runset(3:2:end)
%             legend([get(legend(gca),'String') {sprintf('Cov 0.%d FSWs, freq. %d py',ratesall(run).zeta*100,ratesall(run).tau)}])
%         end
    end
    %% SPLOT
    if splot
        numvers=sum(strcmp({ratesall.desc},'default'));
        plotcmp(ratios(2,:),numvers/2,popsplit);
    end
end

