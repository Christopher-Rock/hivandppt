function resultss=small2results(simdir)
    if nargin==0
        error(['Please exit the debugger, then evaluate ' sprintf('\n') ...
            'simdir=''C:/Users/Crock/Documents/r2/lowfs''' sprintf('\n')...
            'results=small2results(simdir)'])  %#ok<ERTAG>
    end
    ps=scenarios({'u' 'l'});
    resultss=cell(size(ps));
    for ii=1:numel(ps)
        p=ps{ii};
        small2HIV(p,simdir);
        results=smallresults(p,1,1);
        resultss{1,1,ii}=results;
    end
end
