function [resultss,tabless]=small2results(simdir,figuredir,varargin)
% SMALL2RESULTS Plots resultss, calculating if necessary
% [resultss,tabless]=SMALL2RESULTS(simdir,figuredir)
% [resultss,tabless]=SMALL2RESULTS(simdir,figuredir,'clean')
% [resultss,tabless]=SMALL2RESULTS(simdir,figuredir,'clean',resultss)
% [resultss,tabless]=SMALL2RESULTS(simdir,figuredir,'psset',psset)
    if nargin==0
        error(['Please exit the debugger, then evaluate ' sprintf('\n') ...
            'simdir=''C:/Users/Crock/Documents/r2/lowfs''' sprintf('\n')...
            'figuredir=''T:/Crock/SmallModel/Figures/''' 10 ...
            'resultss=small2results(simdir,figuredir)'])  %#ok<ERTAG>
    end
    if nargin==1
        error(['Please exit the debugger, then evaluate ' 10 ...
            'figuredir=''T:/Crock/SmallModel/Figures/''' 10 ...
            'resultss=small2results(simdir,figuredir)'])  %#ok<ERTAG>
    end
    clean=0;
    cleanresults=0;
    userpsset=0;
    userscenarios=0;
    simdirmove=0;
    repname=0;
    noplot=nargout==0;
    if nargin>2
        ii=1;
        while ii<=length(varargin)
            switch varargin{ii}
                case 'clean'
                    clean=1;
                    ii=ii+1;
                    if ii<=length(varargin)
                        if isa(varargin{ii}{1},'numeric')
                            resultss=varargin{ii};
                            cleanresults=1;
                            ii=ii+1;
                        else
                            resultss=cell(size(psset));
                        end
                    end
                case 'psset'
                    psset=varargin{ii+1};
                    userpsset=1;
                    ii=ii+2;
                case 'subset'
                    [p,tables]=scenarios('u','subset',varargin{ii+1}(:));
                    userscenarios=1;
                    ii=ii+2;
                case 'scen'
                    [p,tables]=scenarios(varargin{ii+1}{:});
                    userscenarios=1;
                    ii=ii+2;
                case 'c'
                    p=varargin{ii+1};
                    tables={'users2r';unique(p(2:end,1))};
                    userscenarios=1;
                    ii=ii+2;
                case 'move'
                    simdirmove=1;
                    ii=ii+1;
                case 'repname'
                    repname=1;
                    ii=ii+2;
                case 'n'
                    noplot=1;
                    ii=ii+1;
                case 'y'
                    noplot=0;
                    ii=ii+1;
            end
        end
    end
    if ~userscenarios
        [p,tables]=scenarios({'u','l'}); end
    if ~userpsset
        psset=1:size(tables,2); end
    tabless=tables{:,psset};
    numvers=sum(strcmp(p(:,1),p{2,1}));
    scentodo=numel(cat(1,tables{2,psset}))*numvers/2;
    scensofar=0;
    fprintf('This is %s. Generating results for %d scenarios. \n', ...
        mfilename,scentodo)
    for ii=psset
        thisp=getrows(p,tables{2,ii});
        if ~cleanresults
            if ~clean
                small2HIV(thisp,simdir,simdirmove);
            end
            if ~nargout
                results=smallresults(thisp,1,1,simdirmove);
            end
        else
            results=resultss{ii};
        end
        names=cellop(p(1:2:end,:),'get',tables{2,ii},'longdesc');
        if ~noplot
            smallbar(results,names(2:end),tables{1,ii},figuredir)
        end
        resultss{psset==ii}=results;
        scensofar=scensofar+length(names)-1;
        fprintf('%s: We have completed %d of %d scenarios. \n', ...
            mfilename,scensofar,scentodo)
    end
end

function pout=getrows(p,names)
    numvers=sum(strcmp(p(:,1),p{2,1}));
    pout=cell(numvers*length(names)+1,size(p,2));
    pout(1,:)=p(1,:);
    for ii=1:length(names)
        pout(numvers*(ii-1)+2:numvers*ii+1,:)=p(strcmp(p(:,1),names{ii}),:);
    end
end
    
