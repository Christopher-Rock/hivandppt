function [dataa,datas,dataa1,datas1,dataa2,datas2]=dopulltables(p,simdir)
    id=[simdir '/interventions/'];
    intv1=p{1+find(cell2mat(p(2:end,strcmp(p(1,:),'movedir')))==0, 1 ),1};
    load([id intv1 '_1' ...
        '/input/IndiParams'],'PNGparamsIndi')
    popsplit=PNGparamsIndi.popsplit;
    load([id 'BaselineInt/input/PNGintPrepared'],'ModelintSpecs','labels')
    timesteps=ModelintSpecs.intsteps;
    steps_year=ModelintSpecs.steps_year;
    
    dataa=zeros(timesteps/steps_year,size(p,1)/2+.5);
    datas=dataa;
    dataa1=dataa;
    datas1=dataa;
    dataa2=dataa;
    datas2=dataa;
    for ii=1:size(p,1)/2
        if ~p{ii*2,strcmp(p(1,:),'movedir')}
            iv=id;
        else
            iv=[simdir '/mess/' p{ii*2,1} '/interventions/'];
        end
        [dataa(:,ii), datas(:,ii), dataa1(:,ii), datas1(:,ii), dataa2(:,ii), datas2(:,ii)]=...
        pulltables([iv p{ii*2,1} sprintf('_%d',p{ii*2,strcmp(p(1,:),'intnum')})], ...
            timesteps,steps_year,labels);
    end
    [dataa(:,end),datas(:,end),dataa1(:,end),datas1(:,end),dataa2(:,end),datas2(:,end)]=...
        pulltables([id 'BaselineInt'],timesteps,steps_year,labels);
