function small2HIVC(p,cproject,runset,baselines)
% SMALL2HIV Write small model results into PNG HIV Model format, 
%     then run PNG HIV Model intervention.
    if nargin==2
        runset=1:2:size(p,1)-2;
    end
    if nargin<4
        baselines=unique(p(1+runset,1));
        baselines=baselines(~strcmp(baselines,'default'));
    end
    if cproject(end)~='/'&& cproject(end)~='\'
        cproject=[cproject '/'];
    end
    fprintf('This is small2HIVC. Running HIV models for your scenarios for %d baseline scenarios. \n', ...
        numel(baselines))
    for ii=1:length(baselines)
        %% Create folder if necessary
        folder_name=[upfolder(cproject) baselines{ii}];
        workdir=[folder_name '\'];
        if ~isdir(folder_name)
            mkdir(folder_name)
            % ** mkdir all the project folders **
            mkdir([folder_name '\input\']);
            mkdir([folder_name '\calibration\']);
            mkdir([folder_name '\calibration\HIVBurn\']);
            mkdir([folder_name '\calibration\PopBurn\']);
            mkdir([folder_name '\calibration\HIVCalibrate\']);
            mkdir([folder_name '\calibration\Results\']);
            mkdir([folder_name '\interventions\']);
            mkdir([folder_name '\interventions\Results\']);
            mkdir([folder_name '\pastcompare\']);
            mkdir([folder_name '\pastcompare\Results\']);
        end
        copyfile([cproject 'input\'],[folder_name '\input\'],'f');
        copyfile([cproject(1:end-1) '.mat'],[folder_name '.mat'])
        %% Update parameters
        sti=zeros(1,8);
        for region=1:2
            stilevel=getfrombase(p,baselines{ii},region,'w','x','y','z');
            [equilib,otherlevel]=splitsti(stilevel,getfrombase(p,baselines{ii},0,'phi','oldphi'));
            sti((1:4)+(region-1)*4)=joinsti(equilib,otherlevel)';
            tst((1:4)+(region-1)*4)=stilevel; %#ok<AGROW>
        end
        if any(tst~=sti)
            sti=sti(ones(24,1),:);
            xlswrite([folder_name '\input\BioYear.xls'],sti,'AK2:AR25');
            regs={'1' '2'};
            snames=strcat(repmat(strcat('sti_',{'m','b','f','s'}),1,2),regs([ones(1,4) ones(1,4)+1]));
            sct=load([folder_name '\input\BioYear']);
            for ij=1:length(snames)
                sct.PNGparamsBioVals.(snames{ij})=sti(ij)*ones(size(sct.PNGparamsBioVals.(snames{ij})));
            end
            save([folder_name '\input\BioYear'],'-struct','sct')
        end
        fs=getfrombase(p,baselines{ii},0,'fs');
        xlswrite([folder_name '\input\IndiParams.xls'],'K2')
        sct=load([folder_name '\input\IndiParams']);
        sct.PNGparamsIndi.fs=fs;
        save([folder_name '\input\IndiParams'],'-struct','sct')
        
        %% Run model
        calyears = DataFixer(workdir);
        globalstepsyear=12;
        numinfected=10;
        prepareParams(workdir,globalstepsyear,50,13,calyears,numinfected); 

PngPopBurn(folder_name,'\calibration');
PngHIVBurn(folder_name,'\calibration');
PngHIVCal(folder_name,'\calibration');

%% Prepare for and perform baseline intervention
baseIntYears = 10; 

if ~isdir([workdir 'interventions\BaselineInt\'])
    mkdir([workdir 'interventions\BaselineInt\']);
    mkdir([workdir 'interventions\BaselineInt\Results\']);
    mkdir([workdir 'interventions\BaselineInt\input\'])
    mkdir([workdir 'interventions\BaselineInt\sticalib\']);
end

% Copy age related input files
copyfile([workdir 'input\BioAge.mat'],[workdir 'interventions\BaselineInt\input\BioAge.mat'],'f');
copyfile([workdir 'input\PopAge.mat'],[workdir 'interventions\BaselineInt\input\PopAge.mat'],'f');
copyfile([workdir 'input\ClinicAge.mat'],[workdir 'interventions\BaselineInt\input\ClinicAge.mat'],'f');

    copyfile([workdir 'input\BioAge.xls'],[workdir 'interventions\BaselineInt\input\BioAge.xls'],'f');
    copyfile([workdir 'input\PopAge.xls'],[workdir 'interventions\BaselineInt\input\PopAge.xls'],'f');
    copyfile([workdir 'input\ClinicAge.xls'],[workdir 'interventions\BaselineInt\input\ClinicAge.xls'],'f');

    prepareIntParamsBase([workdir '\input\'],[workdir 'interventions\BaselineInt\input\'],globalstepsyear,baseIntYears,1);

PngHIVInt(workdir(1:end-1),[workdir 'interventions\BaselineInt\'])%,10

destStr = [baselines{ii} 'BaselineInt'];
save([workdir 'interventions\BaselineInt.mat'],'destStr','-append');

DataGetterInt(workdir,'BaselineInt',baseIntYears,0); 
DataFixerInt([workdir 'interventions\BaselineInt\']);
prepareIntParams([workdir 'interventions\BaselineInt\input\'],globalstepsyear,baseIntYears)

%% Run SMALL2HIV
small2HIV(p([true strcmp(p(2:end),baselines{ii})],:),workdir)
    %% Report back to command line
    fprintf('Baseline simulations complete: %d of %d \n',ii,length(baselines))
    end
    
end

function vals=getfrombase(p,rowname,region,varargin)
    if ~region
        prows=strcmp(p(:,1),rowname);
    else
        prows=strcmp(p(:,1),rowname)&[0 p{2:end,strcmp(p(1,:),'region')}]'==region;
    end
    vals=zeros(length(varargin),1);
    for ii=1:length(varargin)
        temp=p(prows,strcmp(p(1,:),varargin{ii}));
        if any([temp{:}]-temp{1})
            error here %#ok<ERTAG>
        else
            vals(ii)=temp{1};
        end
    end
end
        
