function [ratios,withnames]=smallresults(p,dirty)
    simdir='C:/Users/Crock/Documents/r2/lowfs';
    id=[simdir '/interventions/'];
    load([id p{2,1} '/input/IndiParams'],'PNGparamsIndi')
    popsplit=PNGparamsIndi.popsplit;
    load([id 'BaselineInt/input/PNGintPrepared'],'ModelintSpecs','labels')
    timesteps=ModelintSpecs.intsteps;
    steps_year=ModelintSpecs.steps_year;
    ratios=zeros(size(p,1)/2-0.5,3);
    runmain=1;
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
        save([id 'smallratiosraw' inputname(1)],'ratiosraw','ptest')
    end
    ratios(:,[1 3])=ratiosraw(1:2:end,:)*(1-popsplit)+ratiosraw(2:2:end,:)*popsplit;
    for ii=2:2:size(p,1)-1
        ratios(ii/2,2)=pulltable([id p{ii,1}],timesteps,steps_year,labels);
    end
    ratios(:,2)=ratios(:,2)/pulltable([id 'BaselineInt'],timesteps,steps_year,labels);
    withnames=[p(2:2:end,1) num2cell(ratios)];
end
