figdir='T:/Crock/SmallModel/Figures/';
col=[
     6   158   207
   165   190   106
    53    42   134
   248   250    13
     0     0     0]/256*.9;
Nr=[[.47 .03 .475 .025]' [.48 .02 .495 .005]'];
rows=@(A,rows)A(rows,:);
popsplit=.14;
    %% rates
    [~,~,rates]=smallsti(assct(scenarios,2));
    steps=rates.steps;
    intstart=rates.intstart;
    intlength=rates.intlength;
    %% Prevalence plot 1
    clf
    smallsti(assct(scenarios,2));
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs, urban','Cov=75%, Freq=6/year'});
    
    ylim([0 .18])
    
    l=get(gca,'Children');
    for ii=2:5
        l(ii).Annotation.LegendInformation.IconDisplayStyle='off';
    end
    legend('General males','MSMW','General females','FSW','Overall')
    set(gca,'YGrid','on')
    set(gca,'YTick',0:.02:.2)
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'urban STI.png'])
    
    %% Prevalence plot 2 (copy and paste)
    clf
    smallsti(assct(scenarios,1));
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs, rural','Cov=75%, Freq=6/year'});
    
    ylim([0 .18])
    set(gca,'YTick',0:.02:.2)
    
    l=get(gca,'Children');
    for ii=2:5
        l(ii).Annotation.LegendInformation.IconDisplayStyle='off';
    end
    legend('General males','MSMW','General females','FSW','Overall')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'rural STI.png'])
    
    %% Prevalence plot combined

    % Calculate sum 
    [temp1,~,~]=smallsti(assct(scenarios,2),'quick','{pop,popintout(:,:,1),totint}');
    temp2=smallsti(assct(scenarios,1),'quick','{pop,popintout(:,:,1),totint}');
    clf
    for ii=1:3
        temp3{ii}=temp1{ii}*popsplit+temp2{ii}*(1-popsplit); 
    end
    [pop,popint,totint]=deal(temp3{:});
    pop=pop./pop;
    popint=bsxfun(@rdivide,popint,popint(:,1));
    totint=bsxfun(@rdivide,totint,totint(1));
    
    % Plot
    plot ((0:intstart+intlength)/steps-2,pop(:,1:intstart+intlength+1)')
    holdnow=ishold(gcf);  hold all;
    set(gca,'ColorOrderIndex',1)
    plot((intstart:intstart+intlength)/steps-2,popint(:,1:intlength+1)')
    hold all
%     plot((0:intstart+intlength)/steps-2,totint([ones(1,intstart) 1:end]),'k-')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs, overall','Cov=75%, Freq=6/year'});
    
    ylim([0 .18])
    set(gca,'YTick',0:.02:.2)
    
    ylim([0 1])
    set(gca,'YTick',0:.1:1)
    l=get(gca,'Children');
    for ii=2:5
        l(ii).Annotation.LegendInformation.IconDisplayStyle='off';
    end
    legend('General males','MSMW','General females','FSW','Overall','Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'Overall STI.png'])
    
    %% Incidence plot (both regions)
    clf
    dopullpop(scenarios,1,simdir);
    legend('General males','MSMW','General females','FSW','Overall','Location','NorthWest')
    gca;ans.Children;ans(1).Color=[0 0 0]; %#ok<NOANS>
    xlabel('Years since start of intervention');
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
    plot((0:intstart+intlength)'/steps-2,totintu(:,[ones(1,intstart) 1:end])')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs, urban','(various FSW treatment patterns)'});
    
    ylim([0,.0415])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'urban STI scen.png'])
    

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
    plot((0:intstart+intlength)'/steps-2,totintr(:,[ones(1,intstart) 1:end])')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs, rural','(various FSW treatment patterns)'});
        
    ylim([0,.0415])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'rural STI scen.png'])
    
    

    
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
    plot((0:intstart+intlength)'/steps-2,totinto(:,[ones(1,intstart) 1:end])')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs, overall','(various FSW treatment patterns)'});    
    
    ylim([0,.0415])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'Overall STI scen.png'])

    %% Incidence plot rur bypatt
    
    clf
    [~,~,~,~,incrurunsc,incfswrurunsc]=dopulltables(scenarios,simdir);
    incall=bsxfun(@rdivide,incrurunsc,incrurunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(-1:10,[zeros(2,5);1-incall])
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years since start of intervention');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV','Urban regions'})
    ylim([0 0.1])
    set(gca,'YGrid','on')
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV scen urb.png'])
    %% Incidence plot urb bypatt
    
    clf
    [~,~,incurbunsc,incfswurbunsc]=dopulltables(scenarios,simdir);
    incall=bsxfun(@rdivide,incurbunsc,incurbunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(-1:10,1-[ones(2,5);incall])
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years since start of intervention');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV','Urban regions'})
    ylim([0 0.1])
    set(gca,'YGrid','on')
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV scen urb.png'])
    
    %% Incidence plot bypatt
    
    clf
    [incallunsc,incfswunsc,incurbunsc,incfswurbunsc]=dopulltables(scenarios,simdir);
    incall=bsxfun(@rdivide,incallunsc,incallunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(-1:10,1-incall([ones(1,2) 1:end],:))
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years since start of intervention');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV'})
    ylim([0 0.1])
    set(gca,'YGrid','on')
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV scen.png'])
    
    %% FSW all prev bypatt
    whichset='a';
    %% PPT FSW prev bypatt
    for ii=1:4
        totintr(ii,:)=smallsti(assct(scenarios,ii*2-1),'quick','popintout(4,:,2)'''); %#ok<*SAGROW>
    end
    totintr(5,:)=totintr(1,1);
    if any(totintr(:,1)-totintr(1,1)),
        error here %#ok<ERTAG>
    end
    for ii=1:4
        totintu(ii,:)=smallsti(assct(scenarios,ii*2),'quick','popintout(4,:,2)'''); %#ok<*SAGROW>
    end
    totintu(5,:)=totintu(1,1);
    if any(abs(totintu(:,1)-totintu(1,1))>1e-14),
        error here %#ok<ERTAG>
    end
    totinto=totintu*popsplit+totintr*(1-popsplit);
        % Plot
    clf
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    
    disp(whichset);
    switch whichset
        case 'a'
            plot((0:intstart+intlength)'/steps-2,totinto(:,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, all PPT FSW','(various FSW treatment patterns)'});
        case 'r'
            plot((0:intstart+intlength)'/steps-2,totintr(:,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, rural PPT FSW','(various FSW treatment patterns)'});
        case 'u'
            plot((0:intstart+intlength)'/steps-2,totintu(:,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, urban PPT FSW','(various FSW treatment patterns)'});
    end
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
        
    % Create title
    
    ylim([0,.16])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthEast')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'PPT ' whichset ' FSW STI.png'])
    
    %% FSW whichset prev bypatt
    for ii=1:4
        totintr(ii,:)=smallsti(assct(scenarios,ii*2-1),'quick','popint(4,:)'''); %#ok<*SAGROW>
    end
    totintr(5,:)=totintr(1,1);
    if any(totintr(:,1)-totintr(1,1)),
        error here %#ok<ERTAG>
    end
    for ii=1:4
        totintu(ii,:)=smallsti(assct(scenarios,ii*2),'quick','popint(4,:)'''); %#ok<*SAGROW>
    end
    totintu(5,:)=totintu(1,1);
    if any(abs(totintu(:,1)-totintu(1,1))>1e-14),
        error here %#ok<ERTAG>
    end
    totinto=totintu*popsplit+totintr*(1-popsplit);
        % Plot
    clf
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    disp(whichset);
    switch whichset
        case 'a'
            plot((0:intstart+intlength)'/steps-2,totinto(:,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, all FSW','(various FSW treatment patterns)'});
        case 'r'
            plot((0:intstart+intlength)'/steps-2,totintr(:,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, rural FSW','(various FSW treatment patterns)'});
        case 'u'
            plot((0:intstart+intlength)'/steps-2,totintu(:,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, urban FSW','(various FSW treatment patterns)'});
    end
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention'); 
    
    ylim([0,.16])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthEast')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'FSW ' whichset ' STI.png'])
    
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
    plot((0:intstart+intlength)'/steps-2,mtotinto(:,[ones(1,intstart) 1:end])')
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence (all populations)');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs','Treating males and MSMW'});    
    
    ylim([0,.0415])
    
    legend({...
        'Cov=20%, Freq=6/year',...
        'Cov=20%, Freq=12/year',...
        'Cov=30%, Freq=6/year',...
        'Cov=30%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'STI males.png'])
    
    
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
    plot((0:intstart+intlength)'/steps-2,ftotinto(:,[ones(1,intstart) 1:end])')
    
%     addend(12,mtotinto(1:4,end)',col)
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence (all populations)');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs','Treating females and FSW'});    
    
    ylim([0,.0415])
    
    legend({...
        'Cov=20%, Freq=6/year',...
        'Cov=20%, Freq=12/year',...
        'Cov=30%, Freq=6/year',...
        'Cov=30%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'STI females.png'])
    
    
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
    plot((0:intstart+intlength)'/steps-2,mtotinto(:,[ones(1,intstart) 1:end])')
    
%     addend(12,mtotinto(1:4,end)',col)
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence (all populations)');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs','Treating all sub-populations'});    
    
    ylim([0,.0415])
    
    legend({...
        'Cov=10%, Freq=6/year',...
        'Cov=10%, Freq=12/year',...
        'Cov=15%, Freq=6/year',...
        'Cov=15%, Freq=12/year',...
        'Baseline scenario'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'STI allpop.png'])
    
        %% Incidence plot men
    
    clf
    mincallunsc=dopulltables(rows(scenarios('f'),1:9),simdir);
    mincall=bsxfun(@rdivide,mincallunsc,mincallunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(-1:10,1-mincall([ones(1,2) 1:end],:))
    legend({...
        'Cov=20%, Freq=6/year',...
        'Cov=20%, Freq=12/year',...
        'Cov=30%, Freq=6/year',...
        'Cov=30%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years since start of intervention');
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
    plot(-1:10,1-mincall([ones(1,2) 1:end],:))
    legend({...
        'Cov=20%, Freq=6/year',...
        'Cov=20%, Freq=12/year',...
        'Cov=30%, Freq=6/year',...
        'Cov=30%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years since start of intervention');
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
    plot(-1:10,1-mincall([ones(1,2) 1:end],:))
    legend({...
        'Cov=10%, Freq=6/year',...
        'Cov=10%, Freq=12/year',...
        'Cov=15%, Freq=6/year',...
        'Cov=15%, Freq=12/year',...
        'Baseline scenario'},'Location','NorthWest')
    xlabel('Years since start of intervention');
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
