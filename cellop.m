function cllout=cellop(cll,func,varargin)
    switch func
        case 'rm'
            cllout=rm(cll,varargin);
    end
end

function cllout=rm(cll,varargin)
    if isa(varargin{1},'char')
        cllout=cll(:,~strcmp(cll(1,:),varargin{1}));
    else
        for ii=1:length(varargin{1})
            cll=rm(cll,varargin{1}{ii});
        end
        cllout=cll;
    end
end