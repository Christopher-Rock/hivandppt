function [pop,popint,totint]=smalln(p,ii,N,quickarg)
        if nargin==3
            quickarg='{pop,popint,totint}';
        end
        temp1=smallsti(assct(p,ii),'quick',quickarg);
        if ~isa(temp1,'cell')
            temp1={temp1};
        end
        temp=cell(size(temp1));
        for ii=1:length(temp1)
            temp{ii}=sum(bsxfun(@times,temp1{ii},N));
        end
        if nargout==1
            pop=temp;
        elseif nargout==3
            [pop,popint,totint]=deal(temp{:});
        end
end
