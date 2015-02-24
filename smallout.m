function stis=smallout(p,rowin1)
    stis=zeros(10,8);
    [~,popwith,rates,~]=smallsti(assct(p,rowin1));
    for jj=5:8
        stis(:,jj)=yearly(popwith(jj-4,:),rates.steps,rates.intlength);
    end
    [~,popwith,rates,~]=smallsti(assct(p,rowin1+1));
    for jj=1:4
        stis(:,jj)=yearly(popwith(jj,:),rates.steps,rates.intlength);
    end
    if ~strcmp(p(rowin1+1,1),p(rowin1+2,1))
        error('Not a rural and an urban from the same scenario. ') %#ok<ERTAG>
    else
        fprintf('Scenario: %s\n',p{rowin1+1,1})
    end
end
    
    
    
    
    
    
    
    
    
    
    
    
    
function annual=yearly(x,steps,intlength)
    annual=x(round(steps/3):steps:intlength)';
end
