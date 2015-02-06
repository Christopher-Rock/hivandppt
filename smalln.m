function [pop,popint,totint]=smalln(p,ii,N)
        temp1=smallsti(assct(p,ii),'quick','{pop,popint,totint}');
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
