function [popint,pop]=smallsti(rates)
    % Populations m, f, s
    % At each time step, 
    tmax=270;
    intstart=240;
    numgroups=12;
    pop=zeros(3,tmax);pop(:,1)=0.02;
    for t=2:tmax
        pop(:,t)=smallstiloop(pop(:,t-1),rates);
    end
    popintout=zeros(3+numgroups,tmax-intstart+1);
    popintout(1:2,1)=pop(1:2,intstart);
    popintout(3:end,1)=pop(3,intstart);
    for tint=2:tmax-intstart+1
        popintout(:,tint)=smalltsti(popintout(:,tint-1),rates);
        g=mod(tint-intstart-1,numgroups)+1;
        popintout(3+g,tint)=0;% Or,itself times CoveragePerVisit, since not everyone will turn up each six months
        %Do something with changes in groups, migration, etc.
    end
    popint=zeros(3,tmax-intstart+1);
    popint(1:2,:)=popintout(1:2,:);
    popint(3,:)=mean(popintout(4:end,:))*rates(5)+popintout(3,:)*(1-rates(5));

    plot (1:tmax,pop',intstart:tmax,popint')
    ylim(0:1);legend({'m','f','s','m_int','f_int','s_int'})
    
    
    % rates to_m to_f to_s recover coverage
%     rates=[0.1 0.1 0.2 0.05 .60];