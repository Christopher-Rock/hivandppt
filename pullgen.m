function [data,results]=pullgen(intdirs,fname)
    %% Prepare
    for ii=1:length(intdirs)
        intdir=intdirs{ii};
        if intdir(end)~='/'&& intdir(end)~='\'
            intdir=[intdir '/'];
        end
        if ~isdir(intdir)
            error(['No HIV results found at ' 10 intdir ' - ' 10 ...
                'Please run small2HIV(cellop(p,''get'',''thisscenario''),simdir)']) %#ok<ERTAG>
        end
        intdirs{ii}=intdir;
    end
    sct=load([intdir 'input\PNGintPrepared']);
    timesteps=sct.ModelintSpecs.intsteps;
    steps_year=sct.ModelintSpecs.steps_year;
    labels=sct.labels;
    %% Obtain
    
    load([intdir 'Results/PngHIVIntervene1'],'HIVIntResults1')
    results=getPNGresults(HIVIntResults1,timesteps,steps_year,labels);
    data=results.(fname);
    data=zeros(size(data,1),length(intdirs));
    for ii=1:length(intdirs)
        load([intdir 'Results/PngHIVIntervene1'],'HIVIntResults1')
        results=getPNGresults(HIVIntResults1,timesteps,steps_year,labels);
        data(:,ii)=results.(fname);
    end
end

