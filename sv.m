function p=sv(p,varargin)
    for ii=1:2:length(varargin)
        if length(varargin{ii})==1
            p(2:end,strcmp(varargin{ii},p(1,:)))=varargin(ii+1);
        else
            p(2:end,strcmp(varargin{ii},p(1,:)))=num2cell(varargin{ii+1});
        end
    end
end
