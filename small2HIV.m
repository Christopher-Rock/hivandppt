function small2HIV(p,project,runset)
% SMALL2HIV Write small model results into PNG HIV Model format, 
%     then run PNG HIV Model intervention.
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
        %% Evaluate stis
        stis=smallout(p,run);
        %% Test whether intervention exists, if not create new intervention
        if ~isdir([workdir 'input'])
            fprintf(['Creating new intervention: ' intname '...']) 
            mkdir(workdir);
            copyfile([wdir 'BaselineInt'],workdir(1:end-1),'f')
            copyfile([wdir 'BaselineInt.mat'],[workdir(1:end-1) '.mat'])
            fprintf(' done. \n')
            skip=0;
        else
            %% Otherwise, test whether STI levels have changed
            if isequal(round(xlsread(xby,'AK2:AR13'),12),stis)
                skip=1;
                fprintf('No change in results for %s, skipping. \n',intname)
            else skip=0;
            end
        end
        %% Run PngHIVInt on new data
        if ~skip
            %% Output stis to Excel
            xlswrite(xby,stis,'AK2:AR13');
            %% Convert Excel
            intyears = convertParamsInt([workdir '\input']);
            DataGetterInt(project,intname,intyears,1);
            %% Run simulation
            numyears = DataFixerInt(workdir);
            prepareIntParams([ns(workdir) '\input\'],12,numyears)
            PngHIVInt(projectdir,workdir)
        end
        %% Report back to command line
        fprintf('Interventions complete: %d of %d \n',run/2+0.5,max(runset)/2+0.5)
    end
end

