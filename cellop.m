function cll=cellop(cll,func,varargin)
    switch func
        case 'rm'
            cll=rm(cll,varargin);
        case 'set'
            cll=set(cll,varargin);
        case 'rep'
            cll=rep(cll,varargin);
        case 'new'
            cll=new(cll,varargin);
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

function cll=rep(cll,args)
    if numel(args)==1
        reps=ones(size(args{1}));
    else
        reps=args{2};
    end
    for ii = args{1}
        for jj=1:reps
            cll=[cll(1:ii+1,:); cll(ii+1:end,:)];
        end
    end
end

function cll=new(cll,args)
    for ii=1:numel(args)
        source=find(strcmp(cll(:,strcmp(cll(1,:),'desc')),args{ii}{1}));
        cll=rep(cll,{source-1});
        cll=set(cll,[{source} args{ii}{2:end}]);
        cll{source+1,strcmp(cll(1,:),'desc')}=[];
    end
end
