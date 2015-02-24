function [diff,fullpath]=difffold(newdir,olddir)
    temp=dir(newdir);
    nd={temp.name};
    nd=nd(strncmp(fliplr('.mat'),cellfun(@fliplr,nd,'UniformOutput',0),4));
    temp=dir(olddir);
    od={temp.name};
    od=od(strncmp(fliplr('.mat'),cellfun(@fliplr,od,'UniformOutput',0),4));
    if ~all(ismember(od,nd))
        error('%s missing some files from %s',olddir,newdir) %#ok<ERTAG>
    end
    for ii=od
        str=ii{1};
        if strcmp(str(end-3:end),'.mat')
            nsct.(str(1:end-4))=load([ws(newdir) str]);
            osct.(str(1:end-4))=load([ws(olddir) str]);
        end
    end
    [fullpath,diff]=structdiff(osct,nsct);
end

function out=ws(in)
    if ~ismember(in(end),{'/','\'})
        out=[in '/'];
    else
        out=in;
    end
end
function [diff,fullpath]=structdiff(in1,in2)
    diff=struct();
    fullpath=struct();
    fnames=fieldnames(in1);
    for ii=fnames'
        str=ii{:};
        if isstruct(in1.(str))
            [tempd,tempf]=structdiff(in1.(str),in2.(str));
            for jj=fieldnames(tempd)'
                diff.([str '__' jj{:}])=tempd.(jj{:});
            end
            for jj=fieldnames(tempf)'
                fullpath.(jj{:})=tempf.(jj{:});
                if any(strfind('__',jj{:}))
                    throw ME
                end
            end
        else
            try
            if ~isequal(in1.(str),in2.(str))
                replace=1;
                v1=in1.(str);
                v2=in2.(str);
                if length(v1)<length(v2)
                    if isequal(v1(1:length(v1)),v2(1:length(v1)))
                        replace=0;
                    end
                elseif  length(v2)<length(v1)
                    if isequal(v2(1:length(v2)),v1(1:length(v2)))
                        replace=0;
                    end
                end
                if replace
                    diff.(str)=pad(in1.(str), in2.(str));
                    fullpath.(str)=pad(in1.(str), in2.(str));
                end
            end
            catch ME
                if ~strcmp(ME.identifier,'MATLAB:nonExistentField')
                    throw ME
                end
            end
        end
    end
    if any(cell2mat(strfind(fieldnames(fullpath),'__')))
        throw ME
    end
    if length(dbstack())==2
        0;
    end
end
function out=pad(v1,v2)
    if length(v1)<length(v2)
        out=nan(length(v2),2);
        out(1:length(v1),1)=v1;
        out(:,2)=v2;
    else
        
        out=nan(length(v1),2);
        out(1:length(v2),2)=v2;
        out(:,1)=v1;
    end
end
