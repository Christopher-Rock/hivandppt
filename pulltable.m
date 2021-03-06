function [data,results]=pulltable(intdir,timesteps,steps_year,labels)
    if intdir(end)~='/'&& intdir(end)~='\'
        intdir=[intdir '/'];
    end
    if ~isdir(intdir)
        error(['No HIV results found at ' 10 intdir ' - ' 10 ...
            'Please run small2HIV(cellop(p,''get'',''thisscenario''),simdir)']) %#ok<ERTAG>
    end
    load([intdir 'Results/PngHIVIntervene1'],'HIVIntResults1')
    results=getPNGresults(HIVIntResults1,timesteps,steps_year,labels);
    dataa=results.incall(end);
    datas=results.incs1(end)+results.incs2(end);
    data=[datas dataa];
end

