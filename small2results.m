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
    if nargin>1
        ii=1;
        while ii<length(varargin)
            switch varargin{ii}
                case 'clean'
                    clean=1;
                    ii=ii+1;
                    if isa(varargin{ii}{1},'numeric')
                        resultss=varargin{ii};
                        cleanresults=1;
                        ii=ii+1;
                    else
                        resultss=cell(size(psset));
                    end
                case 'psset'
                    psset=varargin{ii+1};
                    userpsset=1;
                    ii=ii+2;
            end
        end
    end
    [p,tables]=scenarios({'u','l'});
    if ~userpsset
        psset=1:length(tables); end
    tabless=tables{:,psset};
    scentodo=numel(cat(1,tables{2,psset}));
    scensofar=0;
    fprintf('This is %s. Generating results for %d scenarios. \n', ...
        mfilename,scentodo)
    for ii=psset
        thisp=getrows(p,tables{2,ii});
        if ~cleanresults
            if ~clean
                small2HIV(thisp,simdir);
            end
            results=smallresults(thisp,1,1);
        else
            results=resultss{ii};
        end
        names=cellop(p(1:2:end,:),'get',tables{2,ii},'longdesc');
        smallbar(results,names(2:end),tables{1,ii},figuredir)
        resultss{psset==ii}=results;
        scensofar=scensofar+length(names)-1;
        fprintf('%s: We have completed %d of %d scenarios. \n', ...
            mfilename,scensofar,scentodo)
    end
end

function pout=getrows(p,names)
    pout=cell(2*length(names)+1,size(p,2));
    pout(1,:)=p(1,:);
    for ii=1:length(names)
        pout(2*ii:2*ii+1,:)=p(strcmp(p(:,1),names{ii}),:);
    end
end
    
