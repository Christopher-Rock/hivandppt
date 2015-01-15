function ratios=getrates(inputs)
    runs=size(inputs,1)-1;
    vars=size(inputs,2);
    ratios=zeros(3,runs);
    for run=1:runs
        for ii=1:vars
            rates.(inputs{1,ii})=inputs{run+1,ii};
        end
        rates.Nf=1-rates.Nm-rates.Ns;
        rates.betafm=(rates.ac*rates.kfm+rates.ar*rates.rfm)/rates.steps;
        rates.betasm=(rates.ac*rates.ksm+rates.ar*rates.rsm)/rates.steps;
        rates.betamf=rates.betafm*rates.Nf/rates.Nm;
        rates.betams=rates.betasm*rates.Ns/rates.Nm;
        rates.run=run;
        ratios(:,run)=smallsti(rates);
    end
end