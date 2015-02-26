function popwith=joinsti(popint,otherlevel)
    popwith=1-bsxfun(@times,1-popint,1-otherlevel);
end
