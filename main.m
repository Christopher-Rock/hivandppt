function ratios=main(inrates,runset)
    clf;
    hold on;
    addnames=0;
    if nargin==1
        if isstruct(inrates)
            runs=numel(inrates);
        else
            runs=size(inrates,1)-1;
        end
        runset=1:runs;
    elseif runset==0
        addnames=1;
        if isstruct(inrates)
            runs=numel(inrates);
        else
            runs=size(inrates,1)-1;
        end
        runset=1:runs;
    elseif max(runset)>numel(inrates)
        error('MATLAB:badsubscript','RUNSET must not exceed NUMEL(INRATES)')
    end
    disp([repmat(' ',1,numel(runset)-1),'|'])
    ratios=zeros(2,length(runset));
    for run=runset
        if ~isstruct(inrates)
            rates=assct(inrates([1 run+1],:));
        else
            rates=inrates(run);
        end
        ratios(:,run==runset)=smallsti(rates);
        fprintf('1')
    end
    fprintf('\n')
    hold off;
    if addnames
        ratios=array2table(reshape(ratios,size(ratios).*[2 .5]),'VariableNames',inrates(2:2:end,1)');
    end
end

