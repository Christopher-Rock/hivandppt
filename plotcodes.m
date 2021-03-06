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
decreaseby=@(x) 1-bsxfun(@rdivide,x,x(1,:));

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
    
    set(gca,'FontSize',13)
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
    
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'rural STI.png'])
    
    %% Prevalence plot combined
%     for offset=0:2:6;
    offset=4;
    % Calculate sum 
    temp1=smallsti(assct(scenarios,2+offset),'quick','[popintout(:,:,1);popintout(4,:,2)]');
    temp2=smallsti(assct(scenarios,1+offset),'quick','[popintout(:,:,1);popintout(4,:,2)]');
    clf
    popintout=temp1*popsplit+temp2*(1-popsplit); 
    popintoutp=1-bsxfun(@rdivide,popintout,popintout(:,1));
    disp([offset; popintoutp(:,end)./popintoutp(end,end)])
    % Plot
    set(gca,'ColorOrderIndex',1)
    plot((intstart:intstart+intlength)/steps-2,popintoutp(:,1:intlength+1)')
    hold all
%     plot((0:intstart+intlength)/steps-2,totint([ones(1,intstart) 1:end]),'k-')
    % Prettify
    % Create ylabel
    ylabel('Proportional decrease in prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    % Create title
    title({'Prevalence of STIs, overall','Cov=75%, Freq=6/year'});
    
    xlim([-2 10])
    plot(0,0,'k.','MarkerSize',18)
    ylim([0 .18])
    set(gca,'YTick',0:.02:.2)
    
    ylim([0 1])
    set(gca,'YTick',0:.1:1)

    legend('General males','MSMW','General females','FSW not receiving PPT','FSW receiving PPT','Start of intervention','Location','West')
%     end
    set(gca,'YGrid','on')
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'Overall STI.png'])
    
    %% Incidence plot (both regions)
    clf
    dopullpop(scenarios,1,simdir,2);
    hold on
    plot(0,0,'k.','MarkerSize',18)
    legend('General males','MSMW','General females','FSW','Start of intervention','Location','NorthWest')
    xlabel('Years since start of intervention');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV', 'Cov=75%, Freq=6/year'})
    ylim([0 0.08])
    set(gca,'YGrid','on')
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV.png'])

    %% Prevalence plot overall
    rch='a';
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
    switch rch
        case 'a'
            plot((0:intstart+intlength)'/steps-2,totinto(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, all PNG','(various FSW treatment patterns)'});
            hold on
            plot(0,totinto(1,1),'k.','MarkerSize',18)
        case 'u'
            plot((0:intstart+intlength)'/steps-2,totintu(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, urban areas','(various FSW treatment patterns)'});
            hold on
            plot(0,totintu(1,1),'k.','MarkerSize',18)
        case 'r'
            plot((0:intstart+intlength)'/steps-2,totintr(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, rural areas','(various FSW treatment patterns)'});
            hold on
            plot(0,totintr(1,1),'k.','MarkerSize',18)
    end
    
            
    
    % Prettify
    % Create ylabel
    ylabel('Prevalence');
    
    % Create xlabel
    xlabel('Years since start of intervention');
    
    ylim([0,.0415])
    
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Start of intervention'},'Location','SouthWest')
    
    set(gca,'YGrid','on')
    
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'STI scen' rch '.png'])

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
        'Start of intervention'},'Location','NorthWest')
    xlabel('Years since start of intervention');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV','Rural areas'})
    hold on
    plot(0,0,'k.','MarkerSize',18)
    ylim([0 0.1])
    set(gca,'YGrid','on')
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV scen rur.png'])
    %% Incidence plot urb bypatt
    
    clf
    [~,~,incurbunsc,incfswurbunsc]=dopulltables(scenarios,simdir);
    incall=bsxfun(@rdivide,incurbunsc,incurbunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(-1:10,1-[ones(2,4);incall(:,1:4)])
    hold on
    plot(0,0,'k.','MarkerSize',18)
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Start of intervention'},'Location','NorthWest')
    xlabel('Years since start of intervention');
    ylabel('Decrease in incidence compared to baseline')
    title({'Decrease in incidence of HIV','Urban areas'})
    ylim([0 0.1])
    set(gca,'YGrid','on')
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV scen urb.png'])
    
    %% Incidence plot bypatt
    
    clf
    [incallunsc,incfswunsc,incurbunsc,incfswurbunsc]=dopulltables(scenarios,simdir);
    incall=bsxfun(@rdivide,incallunsc,incallunsc(:,end));
    set(gca,'ColorOrderIndex',1),set(gca,'ColorOrder',col),hold on
    plot(-1:10,1-[ones(2,4);incall(:,1:4)])
    hold on
    plot(0,0,'k.','MarkerSize',18)
    legend({...
        'Cov=50%, Freq=6/year',...
        'Cov=50%, Freq=12/year',...
        'Cov=75%, Freq=6/year',...
        'Cov=75%, Freq=12/year',...
        'Start of intervention'},'Location','NorthWest')
    xlabel('Years since start of intervention');
    ylabel('Decrease in incidence compared to no PPT')
    title({'Decrease in incidence of HIV','All PNG'})
    ylim([0 0.1])
    set(gca,'OuterPosition',[0 0.05 1 0.9])
    set(gca,'YGrid','on')
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'HIV scen.png'])
    
    %% PPT FSW prev bypatt
    wset='a';
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
    
    disp(wset);
    switch wset
        case 'a'
            plot((0:intstart+intlength)'/steps-2,totinto(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, all PPT FSW','(various FSW treatment patterns)'});
            hold on
            plot(0,totinto(1,1),'k.','MarkerSize',18)
        case 'r'
            plot((0:intstart+intlength)'/steps-2,totintr(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, rural PPT FSW','(various FSW treatment patterns)'});
            hold on
            plot(0,totintr(1,1),'k.','MarkerSize',18)
        case 'u'
            plot((0:intstart+intlength)'/steps-2,totintu(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, urban PPT FSW','(various FSW treatment patterns)'});
            hold on
            plot(0,totintu(1,1),'k.','MarkerSize',18)
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
        'Start of intervention'},'Location','Best')
    
    set(gca,'YGrid','on')
    
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'PPT ' whichset ' FSW STI.png'])
    
    %% Both FSW prev bypatt
    whichset='a';
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
            plot((0:intstart+intlength)'/steps-2,totinto(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, all FSW','(various FSW treatment patterns)'});
            hold on
            plot(0,totinto(1,1),'k.','MarkerSize',18)
        case 'r'
            plot((0:intstart+intlength)'/steps-2,totintr(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, rural FSW','(various FSW treatment patterns)'});
            hold on
            plot(0,totintr(1,1),'k.','MarkerSize',18)
        case 'u'
            plot((0:intstart+intlength)'/steps-2,totintu(1:4,[ones(1,intstart) 1:end])')
            title({'Prevalence of STIs, urban FSW','(various FSW treatment patterns)'});
            hold on
            plot(0,totintu(1,1),'k.','MarkerSize',18)
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
        'Start of intervention'},'Location','Best')
    
    set(gca,'YGrid','on')
    
    set(gca,'FontSize',13)
    set(gcf,'PaperPosition',[0 0 13.5 9])
    saveas(gcf,[figdir 'FSW ' whichset ' STI.png'])
    
    %% Sensitivity plots
    doseparately={
        'sti'
        'fs'
        };
    dospecial={
        'theta'
        'chir'
        };
    domin={
        'phi'
        'gamma'
        %'c1'
        %'c2'
        'eff'
        'res'
        };
    separatescenarios=scenarios('s','phid45',{'phi',.45},'phid55',{'phi',.55},...
        'fs2',{'fs',2.4*.9},'fs3',{'fs',2.4*1.1},'nobase');
    specialscenarios=scenarios('s','theta2',{'theta',3.5},'theta3',{'theta',14},...
        'chir2',{'chir',0},'nobase');
    minscenarios=scenarios('m',domin,[0.9 1.1]);
    %% Sensitivity plots
    exist('stiout','var');exist('hivout','var');exist('chihivout','var');
    exist('pall','var');exist('propminus','var');
    sensitivities;
    greater=any(abs(hivout)>0.03);
    sennames=pall(10:8:end,1);
    blacklist={'c1frac2','c1frac3','c2frac2','c2frac3'};
    grs={'Increase duration by 10%'
        'Decrease duration by 10%'
        ['Increase proportion of' ...
        ' curable STIs by 10%  ']
        ['Decrease proportion of' ...
        ' curable STIs by 10%  ']
        'Decrease STI prevalences by 10%'
        'Increase STI prevalences by 10%'
        'Increase cofactor by 10%'
        'Decrease cofactor by 10%'};
    ngrs={'Decrease protection to 3.5 days'
        'Increase protection to 14 days'
        'Decrease effectiveness to 94.5%'
        'Increase effectiveness to 95.5%'
        'Decrease resistance to 0.9%/year'
        'Increase resistance to 1.1%/year'};
        
    greaternc=greater&~ismember(sennames,blacklist)';
    ngreaternc=~greater&~ismember(sennames,blacklist)';
    mybar(grs,tgtout(:,greaternc),'targeted STI prevalences',col,[figdir 'stigr.png'],'SouthEast')
    mybar(ngrs,tgtout(:,ngreaternc),'targeted STI prevalences',col,[figdir 'stingr.png'])
    mybar(grs,hivout(:,greaternc),'HIV incidence',col,[figdir 'hivgr.png'],'SouthEast')
    mybar(ngrs,hivout(:,ngreaternc),'HIV incidence',col,[figdir 'hivngr.png'],'SouthEast')
    mybar({'Provide PPT only in urban areas'},chihivout,'HIV incidence in urban areas',col,[figdir 'hivchi.png'],'Best','lone')
    
    
        
    
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
    
    set(gca,'FontSize',13)
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
    
    set(gca,'FontSize',13)
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
    
    set(gca,'FontSize',13)
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
    set(gca,'FontSize',13)
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
    set(gca,'FontSize',13)
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
    set(gca,'FontSize',13)
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
