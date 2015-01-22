function [cll,rownums]=cellop(cll,func,varargin)
    switch func
        case 'rm'
            cll=rm(cll,varargin);
        case 'set'
            cll=set(cll,varargin);
        case 'get'
            cll=get(cll,varargin);
        case 'rep'
            cll=rep(cll,varargin);
        case 'new'
            [cll,rownums]=new(cll,varargin);
    end
end

function cll=rm(cll,args)
    if isa(args{1},'char')
        cll=cll(:,~strcmp(cll(1,:),args{1}));
    else
        for ii=1:length(args{1})
            cll=rm(cll,args{1}{ii});
        end
    end
end

function cll=set(cll,args)
    fnames=cll(1,:);
    for ii=2:2:numel(args)        
        cll(args{1}+1,strcmp(fnames,args{ii}))=num2cell(args{ii+1},2);
    end
end

function cll=get(cll,args)
    if isa(args{1},'cell')
        rownames=args{1};
    else
        rownames=args(1);
    end
    if length(args)>= 2
        if isa(args{2},'cell')
            colnames=args{2};
        else
            colnames=args(2);
        end
        colindices=zeros(1,size(cll,2));
        for ii=1:length(colnames)
            colindices=colindices|strcmp(cll(1,:),colnames{ii});
        end
    else
        colindices=1:size(cll,2)>0;
    end
    rowindices=zeros(size(cll,1),1);
    for ii=1:length(rownames)
        rowindices=rowindices|strcmp(cll(:,1),rownames{ii});
        rowindices(1)=1;
    end

    cll=cll(rowindices,colindices);
end

function cll=rep(cll,args)
    if numel(args)==1
        reps=ones(size(args{1}));
    else
        reps=args{2};
    end
    cumuladd=size(cll,1)+1;
    cll=[cll;cell(sum(reps),size(cll,2))];
    for ii = args{1}(:)'
        for jj=1:reps
            cll(cumuladd,:)=cll(ii+1,:); 
            cumuladd=cumuladd+1;
        end
    end
end

function [cll,rownums]=new(cll,args)
    for ii=1:numel(args)
        rowsin=find(strcmp(cll(:,strcmp(cll(1,:),'desc')),args{ii}{1}));
        if isempty(rowsin)
            error([args{ii}{1} ' is not a description. ']) %#ok<ERTAG>
        end
        cll=rep(cll,{rowsin-1});
        rownums=size(cll,1)-(1:numel(rowsin));%make numel(args)=number of new rows
        cll=set(cll,[{rownums} args{ii}{2:end}]);
        cll(rownums+1,strcmp(cll(1,:),'desc'))={[]};
    end
end
