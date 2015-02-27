function eigs=reigs(p,runset)
    if nargin==1
        runset=(1:size(p,1)-1);
    end
    eigs=zeros(size(runset))';
    for ii=runset
        eigs(ii==runset)=rteigs(p([1;ii+1],:));
    end
end
