function sct=assct(cll,rows)
    if nargin==1
        sct=cell2struct(cll(2:end,:),cll(1,:),2);
    else
        sct=cell2struct(cll(rows+1,:),cll(1,:),2);
    end
end