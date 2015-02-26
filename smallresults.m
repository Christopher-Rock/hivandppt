function [ratios,withnames]=smallresults(p,dirty,nosave,simdirmove)
    disp(datestr(now))
    simdir='C:/Users/Crock/Documents/r2/lowfs';
    if ~simdirmove
        id1=[simdir '/interventions/'];
    else
        id1=[simdir '/mess/' p{end,1} '/interventions/'];
    end
    load([id1 p{end,1} '_1' ...
        '/input/IndiParams'],'PNGparamsIndi')
    popsplit=PNGparamsIndi.popsplit;
    load([id1 'BaselineInt/input/PNGintPrepared'],'ModelintSpecs','labels')
    timesteps=ModelintSpecs.intsteps;
    steps_year=ModelintSpecs.steps_year;
    ratios=zeros(size(p,1)/2-0.5,4);
    %% Run main if necessary
    runmain=1;
    if nargin<3,nosave=0;end
    try load([id1 'smallratiosraw'],'ratiosraw','ptest') %#ok<TRYNC>
        if isequal(p,ptest) %#ok<NODEF>
            runmain=0;
            if nargin==2
                if dirty
                    runmain=1;
                end
            end
        end
    end
    if runmain
        ratiosraw=main(p)';
        ptest=p; %#ok<NASGU>
        if ~nosave
            save([id1 'smallratiosraw' inputname(1)],'ratiosraw','ptest')
        end
    end
    %% Populate ratios
    ratios(:,[1 2])=ratiosraw(1:2:end,:)*(1-popsplit)+ratiosraw(2:2:end,:)*popsplit;
    if ~simdirmove
        id=id1;
        movestr='';
    else
        id=[simdir '/interventions/'];
    end
    for ii=2:2:size(p,1)-1
        if simdirmove
            movestr=['/mess/' p{ii,1}];
        end
        ratios(ii/2,3:4)=pulltable([simdir movestr '/interventions/' p{ii,1} sprintf('_%d',p{ii,strcmp(p(1,:),'intnum')})], ...
            timesteps,steps_year,labels);
    end
    ratios(:,3:4)=1-ratios(:,3:4)./repmat(pulltable([id1 'BaselineInt'],timesteps,steps_year,labels),...
        size(ratios,1),1);
    if nargout==2
        withnames=[p(2:2:end,1) sprintf('_%d',repmat(1:5,size(p,1)/5,1)) num2cell(ratios)];
    end
    disp(datestr(now))
end
