function small2HIV(p,simdir)
    if simdir(end)~='/'&& simdir(end)~='\'
        simdir=[simdir '/'];
    end
    % r2='C:/Users/Crock/Documents/r2/lowfs'
    pops={'m','b','f','s'};
    fileby=[simdir 'interventions/%d/input/BioYearInt'];
    thisint=1;
    load(sprintf(fileby,thisint),'PNGintBioVals','biointyrs')
    for output=1:size(p,1)-1
        [~,popint,rates,pop]=smallsti(assct(p,output));
        nomatch=1;
        for jj=1:4
            if all((PNGintBioVals.(['sti_' pops{jj} '1'])(1)-pop(jj,end)).^2<0.0001)
                PNGintBioVals.(['sti_' pops{jj} '1'])=yearly(popint(jj,:),rates.steps,rates.intlength);
                nomatch=0;
            elseif all((PNGintBioVals.(['sti_' pops{jj} '2'])(1)-pop(jj,end)).^2<0.0001)
                PNGintBioVals.(['sti_' pops{jj} '2'])=yearly(popint(jj,:),rates.steps,rates.intlength);
                nomatch=0;
            end
        end
        if nomatch
            error(['Simulated baseline levels of STI not close to HIV model' ...
                '\n\n   pop(:,end) =\n\n    %f\n%f\n%f\n%f'],pop(:,end))
        end
        if numel(PNGintBioVals.sti_m1)~=biointyrs
            error('yintlength ~= biointyrs') %#ok
        end
    end
    fprintf([sprintf(fileby,thisint) '\n'])
    save(sprintf(fileby,thisint),'PNGintBioVals','-append')
end

function annual=yearly(x,steps,intlength)
    annual=x(1:steps:intlength)';
end
