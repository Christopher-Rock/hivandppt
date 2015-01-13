function ratios=main(inrates,runset)
    clf;
    hold on;
    if nargin==1
        if isstruct(inrates)
            runs=numel(inrates);
        else
            runs=size(inrates,1)-1;
        end
        runset=1:runs;
    elseif max(runset)>numel(inrates)
        error('MATLAB:badsubscript','RUNSET must not exceed NUMEL(INRATES)')
    end
    ratios=zeros(3,length(runset));
    for run=runset
        if ~isstruct(inrates)
            rates=getrates(inrates,run);
        else
            rates=inrates(run);
        end
        ratios(:,run==runset)=smallsti(rates);
    end
    hold off;
end