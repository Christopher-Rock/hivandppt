function stis=smallannual(p,rowin1)
    stis=zeros(12,8);
    [~,popint,rates,~]=smallsti(assct(p,rowin));
    for jj=5:8
        stis(:,jj)=yearly(popint(jj-4,:),rates.steps,rates.intlength);
    end
    [~,popint,rates,~]=smallsti(assct(p,rowin1+1));
    for jj=1:4
        stis(:,jj)=yearly(popint(jj,:),rates.steps,rates.intlength);
    end
    input('')
end
    
    
    
    
    
    
    
    
    
    
    
    
    
function annual=yearly(x,steps,intlength)
    annual=x(1:steps:intlength)';
end
