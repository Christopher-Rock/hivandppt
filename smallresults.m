function [ratios,withnames]=smallresults(p,dirty,nosave)
    disp(datestr(now))
    simdir='C:/Users/Crock/Documents/r2/lowfs';
    id=[simdir '/interventions/'];
    load([id p{2,1} '_1' ...
        '/input/IndiParams'],'PNGparamsIndi')
    popsplit=PNGparamsIndi.popsplit;
    load([id 'BaselineInt/input/PNGintPrepared'],'ModelintSpecs','labels')
    timesteps=ModelintSpecs.intsteps;
    steps_year=ModelintSpecs.steps_year;
    ratios=zeros(size(p,1)/2-0.5,4);
    %% Run main if necessary
    runmain=1;
    if nargin<3,nosave=0;end
    try load([id 'smallratiosraw'],'ratiosraw','ptest') %#ok<TRYNC>
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
            save([id 'smallratiosraw' inputname(1)],'ratiosraw','ptest')
        end
    end
    %% Populate ratios
    ratios(:,[1 2])=ratiosraw(1:2:end,:)*(1-popsplit)+ratiosraw(2:2:end,:)*popsplit;
    for ii=2:2:size(p,1)-1
        ratios(ii/2,3:4)=pulltable([id p{ii,1} sprintf('_%d',p{ii,strcmp(p(1,:),'intnum')})], ...
            timesteps,steps_year,labels);
    end
    ratios(:,3:4)=1-ratios(:,3:4)./repmat(pulltable([id 'BaselineInt'],timesteps,steps_year,labels),...
        size(ratios,1),1);
    if nargout==2
        withnames=[p(2:2:end,1) sprintf('_%d',repmat(1:5,size(p,1)/5,1)) num2cell(ratios)];
    end
    disp(datestr(now))
end
