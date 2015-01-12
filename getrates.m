function rates=getrates(inputs,run) %#ok<INUSD>
%% Select row of inputs (run)
    if nargin==1
        run=1;
    end
%% Add uncalculated variables to rates
    vars=size(inputs,2);
    for ii=1:vars
        rates.(inputs{1,ii})=inputs{run+1,ii};
    end
%% Add calculated variables to rates
    rates.Nf=1-rates.Nm-rates.Ns;
    rates.betafm=(rates.ac*rates.kfm+rates.ar*rates.rfm)/rates.steps;
    rates.betasm=(rates.ac*rates.ksm+rates.ar*rates.rsm)/rates.steps;
    rates.betamf=rates.betafm*rates.Nf/rates.Nm;
    rates.betams=rates.betasm*rates.Ns/rates.Nm;
%% Add run number
    if nargin == 1
        rates.run=0;
    else
        rates.run=run;
    end
end