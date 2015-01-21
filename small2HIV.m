function small2HIV(p,project,runset)
    if nargin==2
        runset=1:2:size(p,1)-2;
    end
    if project(end)~='/'&& project(end)~='\'
        project=[project '/'];
    end
    projectdir=project;
    wdir=[project 'interventions/'];
    disp(datestr(now))
    fprintf('This is small2HIV. Running your model for %d interventions. \n', ...
        numel(runset))
    % project='C:/Users/Crock/Documents/r2/lowfs'
    for run=runset
        intname=p{run+1,1};
        workdir=[project 'interventions/' intname '/'];
        fileby=[workdir 'input/BioYearInt'];
        xby=[fileby '.xls'];
        %% Test whether intervention exists, if not create new intervention
        if ~isdir([workdir 'input'])
            fprintf(['Creating new intervention: ' intname '...']) 
            mkdir(workdir);
            copyfile([wdir 'BaselineInt'],workdir(1:end-1),'f')
            copyfile([wdir 'BaselineInt.mat'],[workdir(1:end-1) '.mat'])
            fprintf(' done. \n')
        end
        %% Output stis to Excel
        stis=smallout(p,run);
        xlswrite(xby,stis,'AK2:AR13');
        %% Convert Excel
        intyears = convertParamsInt([workdir '\input']);
        DataGetterInt(project,intname,intyears,1);
        %% Run simulation
        numyears = DataFixerInt(workdir);
        prepareIntParams([ns(workdir) '\input\'],12,numyears)
        PngHIVInt(projectdir,workdir)
        %% Report back to command line
        fprintf('Interventions complete: %d of %d \n',run/2+0.5,max(runset)/2+0.5)
    end
end

