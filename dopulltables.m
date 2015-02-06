function [dataa,datas]=dopulltables(p,simdir)
    id=[simdir '/interventions/'];
    load([id p{2,1} '_1' ...
        '/input/IndiParams'],'PNGparamsIndi')
    popsplit=PNGparamsIndi.popsplit;
    load([id 'BaselineInt/input/PNGintPrepared'],'ModelintSpecs','labels')
    timesteps=ModelintSpecs.intsteps;
    steps_year=ModelintSpecs.steps_year;
    
    dataa=zeros(timesteps/steps_year,size(p,1)/2+.5);
    datas=dataa;
    for ii=1:size(p,1)/2
        [dataa(:,ii), datas(:,ii)]=pulltables([id p{ii*2,1} sprintf('_%d',p{ii*2,strcmp(p(1,:),'intnum')})], ...
            timesteps,steps_year,labels);
    end
    [dataa(:,end),datas(:,end)]=pulltables([id 'BaselineInt'],timesteps,steps_year,labels);
