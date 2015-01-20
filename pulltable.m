function data=pulltable(intdir,timesteps,steps_year,labels)
    if intdir(end)~='/'&& intdir(end)~='\'
        intdir=[intdir '/'];
    end
    load([intdir 'Results/PngHIVIntervene1'],'HIVIntResults1')
    results=getPNGresults(HIVIntResults1,timesteps,steps_year,labels);
    data=results.incall(end);
end

