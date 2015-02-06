function sratios=plotcmp(results,numcases,popsplit)
    if nargin==3
        rratios=results(1:2:end)*(1-popsplit)+results(2:2:end)*popsplit;
    else
        rratios=results;
    end
    if size(rratios,2)==1,
        rratios=rratios'; end
    origs=repmat(rratios(1:numcases),1,(length(rratios)-numcases)/numcases);
    sratios=rratios(numcases+1:end)-origs;
    sratios=sratios./origs;
    bar(reshape(sratios,[numcases length(sratios)/numcases])')
end
