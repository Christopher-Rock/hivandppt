figdir='T:/Crock/SmallModel/Figures/';
col=[
     6   158   207
   165   190   106
    53    42   134
   248   250    13
     0     0     0]/256*.9;
Nr=[[.47 .03 .475 .025]' [.48 .02 .495 .005]'];
rows=@(A,rows)A(rows,:);
    %% Prevalence plot 1
    clf
    smallsti(assct(scenarios,2));
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs, urban','Cov=75%, Freq=6/year'});
    
    ylim([0 .18])
    
    l=get(gca,'Children');
    for ii=2:5
        l(ii).Annotation.LegendInformation.IconDisplayStyle='off';
    end
    legend('General males','MSMW','General females','FSW','Overall')
    set(gca,'YGrid','on')
    set(gca,'YTick',0:.02:.2)
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'urban UBSTI.png'])
    
    %% Prevalence plot 2 (copy and paste)
    clf
    smallsti(assct(scenarios,1));
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs, rural','Cov=75%, Freq=6/year'});
    
    ylim([0 .18])
    set(gca,'YTick',0:.02:.2)
    
    l=get(gca,'Children');
    for ii=2:5
        l(ii).Annotation.LegendInformation.IconDisplayStyle='off';
    end
    legend('General males','MSMW','General females','FSW','Overall')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'rural UBSTI.png'])
    
    %% Prevalence plot combined

    % Calculate sum 
    [temp1,~,rates]=smallsti(assct(scenarios,2),'quick','{pop,popint,totint}');
    temp2=smallsti(assct(scenarios,1),'quick','{pop,popint,totint}');
    steps=rates.steps;
    intstart=rates.intstart;
    intlength=rates.intlength;
    clf
    popsplit=.14;
    for ii=1:3
        temp3{ii}=temp1{ii}*popsplit+temp2{ii}*(1-popsplit); 
    end
    [pop,popint,totint]=deal(temp3{:});
    
    % Plot
    plot ((0:intstart+intlength)/steps,pop(:,1:intstart+intlength+1)')
    holdnow=ishold(gcf);  hold all;
    set(gca,'ColorOrderIndex',1)
    plot((intstart:intstart+intlength)/steps,popint(:,1:intlength+1)')
    hold all
    plot((0:intstart+intlength)/steps,totint([ones(1,intstart) 1:end]),'k-')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs, overall','Cov=75%, Freq=6/year'});
    
    ylim([0 .18])
    set(gca,'YTick',0:.02:.2)
    
    l=get(gca,'Children');
    for ii=2:5
        l(ii).Annotation.LegendInformation.IconDisplayStyle='off';
    end
    legend('General males','MSMW','General females','FSW','Overall')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'Overall UBSTI.png'])
    
    %% Incidence plot (both regions)
    clf
    dopullpop(scenarios,1,simdir);
    legend('General males','MSMW','General females','FSW','Overall','Location','NorthWest')
    gca;ans.Children;ans(1).Color=[0 0 0]; %#ok<NOANS>
    xlabel('Years');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV', 'Cov=75%, Freq=6/year'})
    ylim([0 0.08])
    set(gca,'YGrid','on')
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV.png'])

    %% Prevalence plot urban
    for ii=1:4
        [~,~,totintu(ii,:)]=smalln(scenarios,ii*2,Nr(:,1)); %#ok<*SAGROW>
    end
    totintu(5,:)=totintu(1,1);
    if any(totintu(:,1)-totintu(1,1)),
        error here %#ok<ERTAG>
    end
        % Plot
    clf
    shg
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot((0:intstart+intlength)'/steps,totintu(:,[ones(1,intstart) 1:end])')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs, urban','(various FSW treatment patterns)'});
    
    ylim([0,.041])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'urban UBSTI scen.png'])
    

    %% Prevalence plot rural
    for ii=1:4
        [~,~,totintr(ii,:)]=smalln(scenarios,ii*2-1,Nr(:,2)); %#ok<*SAGROW>
    end
    totintr(5,:)=totintr(1,1);
    if any(totintr(:,1)-totintr(1,1)),
        error here %#ok<ERTAG>
    end

        % Plot
    clf
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot((0:intstart+intlength)'/steps,totintr(:,[ones(1,intstart) 1:end])')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs, rural','(various FSW treatment patterns)'});
        
    ylim([0,.041])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'rural UBSTI scen.png'])
    
    

    
    %% Prevalence plot overall
    for ii=1:4
        [~,~,totintr(ii,:)]=smalln(scenarios,ii*2-1,Nr(:,2)); %#ok<*SAGROW>
    end
    totintr(5,:)=totintr(1,1);
    if any(totintr(:,1)-totintr(1,1)),
        error here %#ok<ERTAG>
    end
    for ii=1:4
        [~,~,totintu(ii,:)]=smalln(scenarios,ii*2,Nr(:,1)); %#ok<*SAGROW>
    end
    totintu(5,:)=totintu(1,1);
    if any(abs(totintu(:,1)-totintu(1,1))>1e-14),
        error here %#ok<ERTAG>
    end
    totinto=totintu*popsplit+totintr*(1-popsplit);
        % Plot
    clf
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot((0:intstart+intlength)'/steps,totinto(:,[ones(1,intstart) 1:end])')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs, overall','(various FSW treatment patterns)'});    
    
    ylim([0,.04])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'Overall UBSTI scen.png'])

    %% Incidence plot bypatt
    
    clf
    incallunsc=dopulltables(scenarios,simdir);
    incall=bsxfun(@rdivide,incallunsc,incallunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(1:12,1-incall([ones(1,2) 1:end],:))
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV'})
    ylim([0 0.08])
    set(gca,'YGrid','on')
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV scen.png'])
    
        %% Prevalence plot men
    for ii=1:4
        [~,~,mtotintr(ii,:)]=smalln(scenarios('f'),ii*2-1,Nr(:,2)); %#ok<*SAGROW>
    end
    mtotintr(5,:)=mtotintr(1,1);
    if any(mtotintr(:,1)-mtotintr(1,1)),
        error pherer %#ok<ERTAG>
    end
    for ii=1:4
        [~,~,mtotintu(ii,:)]=smalln(scenarios('f'),ii*2,Nr(:,1)); %#ok<*SAGROW>
    end
    mtotintu(5,:)=mtotintu(1,1);
    if any(abs(mtotintu(:,1)-mtotintu(1,1))>1e-14),
        error phereu %#ok<ERTAG>
    end
    mtotinto=mtotintu*popsplit+mtotintr*(1-popsplit);
        % Plot
    clf
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot((0:intstart+intlength)'/steps,mtotinto(:,[ones(1,intstart) 1:end])')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence (all populations)');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs','Treating males and MSMW'});    
    
    ylim([0,.04])
    
    legend({...
        'Cov=20%, Freq=6/year',...
        'Cov=20%, Freq=12/year',...
        'Cov=30%, Freq=6/year',...
        'Cov=30%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'UBSTI males.png'])
    
    
            %% Prevalence plot women
    for ii=1:4
        [~,~,ftotintr(ii,:)]=smalln(scenarios('f'),8+ii*2-1,Nr(:,2)); %#ok<*SAGROW>
    end
    ftotintr(5,:)=ftotintr(1,1);
    if any(ftotintr(:,1)-ftotintr(1,1)),
        error pherer %#ok<ERTAG>
    end
    for ii=1:4
        [~,~,ftotintu(ii,:)]=smalln(scenarios('f'),8+ii*2,Nr(:,1)); %#ok<*SAGROW>
    end
    ftotintu(5,:)=ftotintu(1,1);
    if any(abs(ftotintu(:,1)-ftotintu(1,1))>1e-14),
        error phereu %#ok<ERTAG>
    end
    ftotinto=ftotintu*popsplit+ftotintr*(1-popsplit);
        % Plot
    clf
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot((0:intstart+intlength)'/steps,ftotinto(:,[ones(1,intstart) 1:end])')
    
%     addend(12,mtotinto(1:4,end)',col)
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence (all populations)');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs','Treating females and FSW'});    
    
    ylim([0,.04])
    
    legend({...
        'Cov=20%, Freq=6/year',...
        'Cov=20%, Freq=12/year',...
        'Cov=30%, Freq=6/year',...
        'Cov=30%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'UBSTI females.png'])
    
    
                %% Prevalence plot allpop
    for ii=1:4
        [~,~,mtotintr(ii,:)]=smalln(scenarios('f'),16+ii*2-1,Nr(:,2)); %#ok<*SAGROW>
    end
    mtotintr(5,:)=mtotintr(1,1);
    if any(mtotintr(:,1)-mtotintr(1,1)),
        error pherer %#ok<ERTAG>
    end
    for ii=1:4
        [~,~,mtotintu(ii,:)]=smalln(scenarios('f'),16+ii*2,Nr(:,1)); %#ok<*SAGROW>
    end
    mtotintu(5,:)=mtotintu(1,1);
    if any(abs(mtotintu(:,1)-mtotintu(1,1))>1e-14),
        error phereu %#ok<ERTAG>
    end
    mtotinto=mtotintu*popsplit+mtotintr*(1-popsplit);
        % Plot
    clf
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot((0:intstart+intlength)'/steps,mtotinto(:,[ones(1,intstart) 1:end])')
    
%     addend(12,mtotinto(1:4,end)',col)
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence (all populations)');
    
    % Create xlabel
    xlabel('Years');
    
    % Create title
    title({'Prevalence of UBSTIs','Treating all sub-populations'});    
    
    ylim([0,.04])
    
    legend({...
        'Cov=10%, Freq=6/year',...
        'Cov=10%, Freq=12/year',...
        'Cov=15%, Freq=6/year',...
        'Cov=15%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'UBSTI allpop.png'])
    
        %% Incidence plot men
    
    clf
    mincallunsc=dopulltables(rows(scenarios('f'),1:9),simdir);
    mincall=bsxfun(@rdivide,mincallunsc,mincallunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(1:12,1-mincall([ones(1,2) 1:end],:))
    legend({...
        'Cov=20%, Freq=6/year',...
        'Cov=20%, Freq=12/year',...
        'Cov=30%, Freq=6/year',...
        'Cov=30%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV', 'Treating males and MSMW'})
    ylim([0 0.08])
    set(gca,'YGrid','on')
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV men.png'])

    
    
        %% Incidence plot women
    
    clf
    mincallunsc=dopulltables(rows(scenarios('f'),[1 10:17]),simdir);
    mincall=bsxfun(@rdivide,mincallunsc,mincallunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(1:12,1-mincall([ones(1,2) 1:end],:))
    legend({...
        'Cov=20%, Freq=6/year',...
        'Cov=20%, Freq=12/year',...
        'Cov=30%, Freq=6/year',...
        'Cov=30%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV', 'Treating females and FSW'})
    ylim([0 0.08])
    set(gca,'YGrid','on')
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV women.png'])

        %% Incidence plot both
    
    clf
    mincallunsc=dopulltables(rows(scenarios('f'),[1 18:25]),simdir);
    mincall=bsxfun(@rdivide,mincallunsc,mincallunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(1:12,1-mincall([ones(1,2) 1:end],:))
    legend({...
        'Cov=10%, Freq=6/year',...
        'Cov=10%, Freq=12/year',...
        'Cov=15%, Freq=6/year',...
        'Cov=15%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV', 'Treating all populations'})
    ylim([0 0.08])
    set(gca,'YGrid','on')
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV allpop.png'])
    
    %% Prevalence plot bypop
    

    pptemp=[scenarios; scenarios('f')];
    pp=pptemp([1:9 11:end],:);
    totintp=zeros(24,121);
    for ii=1:32
        totintp(ii,:)=smallsti(assct(pp,ii),'quick','totint');
    end
    clf
%     totintps=cat(2,totintp{:});
    plotcmp(totintp(:,end),4,popsplit)
