function [pop,popint,totint]=getsmall(p,ii,popsplit)
        temp1=smallsti(assct(p,ii+1),'quick','{pop,popint,totint}');
        temp2=smallsti(assct(p,ii+2),'quick','{pop,popint,totint}');
        temp=cell(size(temp1));
        for ii=1:length(temp1)
            temp{ii}=temp1{ii}*popsplit+temp2{ii}*(1-popsplit);
        end
        if nargout==1
            pop=temp;
        elseif nargout==3
            [pop,popint,totint]=deal(temp{:});
        end
end
