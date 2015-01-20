function ratios=smallresults(p)
    simdir='C:/Users/Crock/Documents/r2';
    id=[simdir '/interventions/'];
    load([id p{2,1} '/input/IndiParams'],'PNGparamsIndi')
    popsplit=PNGparamsIndi.popsplit;
    ratios=zeros(size(p,1)/2-0.5,3); %#ok<PREALL>
    ratiosraw=main(p)';
    ratios=ratiosraw(3:2:end,:)*(1-popsplit)+ratiosraw(2:2:end,:)*popsplit;
    for ii=1:2:size(p,1)-1
        ratios((ii+1)/2,3)=pulltable([id p{ii,1}]);
    end
    
    
