function [dataa,datas,dataa1,datas1,dataa2,datas2]=pulltables(intdir,timesteps,steps_year,labels)
    if intdir(end)~='/'&& intdir(end)~='\'
        intdir=[intdir '/'];
    end
    if ~isdir(intdir)
        error(['No HIV results found at ' 10 intdir ' - ' 10 ...
            'Please run small2HIV(cellop(p,''get'',''thisscenario''),simdir)']) %#ok<ERTAG>
    end
    load([intdir 'Results/PngHIVIntervene1'],'HIVIntResults1')
    results=getPNGresults(HIVIntResults1,timesteps,steps_year,labels);
    dataa=results.incall';
    datas=results.incs1'+results.incs2';
    dataa1=results.incs1'+results.incf1'+results.incm1'+results.incb1';
    datas1=results.incs1;
    dataa2=results.incs2'+results.incf2'+results.incm2'+results.incb2';
    datas2=results.incs2;
end

