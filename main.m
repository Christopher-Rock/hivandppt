function ratios=main(inputs)
    runs=size(inputs,1)-1;
    ratios=zeros(3,runs);
    for run=1:runs
        rates=getrates(inputs,run);
        ratios(:,run)=smallsti(rates);
    end
end