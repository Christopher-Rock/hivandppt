function [dataa,datas,dataa1,datas1,dataa2,datas2]=sdopulltables(p,simdir)
    runstopull=(size(p,1)-1)/2;
    fprintf('Pulling %d tables.\n%s\n',runstopull,[repmat(' ',1,runstopull-1) '.'])
    im=[simdir '/mess/'];
    load([im p{2,1} '/interventions/BaselineInt/input/PNGintPrepared'],'ModelintSpecs','labels')
    timesteps=ModelintSpecs.intsteps;
    steps_year=ModelintSpecs.steps_year;
    
    numints=sum(ismember(p(2:end,1),p(2,1)))/2;
    numsens=(size(p,1)-1)/numints/2;
    dataa=zeros(timesteps/steps_year,numints+1,numsens);
    datas=dataa;
    dataa1=dataa;
    datas1=dataa;
    dataa2=dataa;
    datas2=dataa;
    if mod(numsens,1)
        error 'p must have the same number of rows for each description!' %#ok<ERTAG>
    end
    for jj=1:numsens
        for ii=1:numints
            d=(jj-1)*numints*2+2*ii;
            [dataa(:,ii,jj), datas(:,ii,jj), dataa1(:,ii,jj), datas1(:,ii,jj), dataa2(:,ii,jj), datas2(:,ii,jj)]=...
                pulltables([im p{d,1} '/interventions/' p{d,1} sprintf('_%d',p{d,strcmp(p(1,:),'intnum')})], ...
                timesteps,steps_year,labels);
            fprintf('.')
        end
        [dataa(:,end,jj),datas(:,end,jj),dataa1(:,end,jj),datas1(:,end,jj),dataa2(:,end,jj),datas2(:,end,jj)]=...
        pulltables([im p{d,1} '/interventions/BaselineInt'],timesteps,steps_year,labels);
    end
fprintf('\n')    
end

