function [inc]=dopullpop(p,ii,simdir)
        id=[simdir '/interventions/'];
    load([id p{2,1} '_1' ...
        '/input/IndiParams'],'PNGparamsIndi')
    popsplit=PNGparamsIndi.popsplit;
    load([id 'BaselineInt/input/PNGintPrepared'],'ModelintSpecs','labels')
    timesteps=ModelintSpecs.intsteps;
    steps_year=ModelintSpecs.steps_year;
    rates=assct(p,ii);
    N=[rates.sexratio*[1-rates.probb rates.probb] (1-rates.sexratio)*...
        [1-rates.probs rates.probs] 1];
    datan=pullpop([id p{ii*2,1} sprintf('_%d',p{ii*2,strcmp(p(1,:),'intnum')})], ...
            timesteps,steps_year,labels);
    scalen=bsxfun(@rdivide,datan,datan(1,:));
    plot((1:timesteps/steps_year)',scalen)
    hold on
    set(gca,'ColorOrderIndex',1)
    datab=pullpop([id 'BaselineInt'],timesteps,steps_year,labels);
    scaleb=bsxfun(@rdivide,datab,datab(1,:));
    plot((1:timesteps/steps_year)',scaleb)
    clf
    plot(1:timesteps/steps_year,1-datan./datab);
    
end
    function data=pullpop(intdir,timesteps,steps_year,labels)
    if intdir(end)~='/'&& intdir(end)~='\'
        intdir=[intdir '/'];
    end
    if ~isdir(intdir)
        error(['No HIV results found at ' 10 intdir ' - ' 10 ...
            'Please run small2HIV(cellop(p,''get'',''thisscenario''),simdir)']) %#ok<ERTAG>
    end
    load([intdir 'Results/PngHIVIntervene1'],'HIVIntResults1')
    results=getPNGresults(HIVIntResults1,timesteps,steps_year,labels);
    datas=results.incs1+results.incs2;
    dataf=results.incf1+results.incf2;
    datam=results.incm1+results.incm2;
    datab=results.incb1+results.incb2;
    dataa=results.incall;
    data=[datam' datab' dataf' datas' dataa'];
end
