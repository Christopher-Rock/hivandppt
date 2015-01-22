function [p,tables,pin,scen,scenblocks,ps]=scenarios(type,varargin)
%% Define indices
const=-2;
regional=-1;
sensit=1;
al=2;
ch=3;
cv=4;
pin=[...
    {'desc';const;{'default';'low';'high'}} ...
    {'gamma';sensit;{1.20;0.8;1.8}} ...
    {'c1';sensit;{0.62;0.70;0.56}} ...
    {'c2';sensit;{0.96;0.99;0.92}} ...
    {'theta';sensit;{365.25/122;365.25/365;365.25/91}} ...
    {'phi';sensit;{0.67;0.50;0.83}} ...
    {'eff';sensit;{0.95;0.90;0.98}} ...
    {'res';sensit;{0.03;0.01;0.05}} ... % Resistance per year
    {'region';regional;{2;1}} ...
    {'w';regional;{0.07;0.05}} ...
    {'x';regional;{0.08;0.06}} ...
    {'y';regional;{0.09;0.07}} ...
    {'z';regional;{0.32;0.30}} ...
    {'probs';regional;{0.01;0.05}} ...
    {'probb';regional;{0.04;0.06}} ...
    {'alphalr';al;{0;0.5;1}} ...
    {'alphab';al;{0;0.5;1}} ...
    {'alphas';al;{1}} ...
    {'chiu';ch;{1;0;0.5}} ...
    {'chir';ch;{1;0;0.5}} ...
    {'zeta';cv;{0.75;0.5;0.9}} ...
    {'tau';cv;{1;2;12}} ...
    {'sexratio';const;{0.5}} ...
    {'longdesc';const;{'Default intervention'}} ];
blocks=cell2mat(pin(2,:));
npin=find(blocks==sensit);
ipin=find(blocks==al|blocks==ch|blocks==cv);
upin=[npin ipin];

%% Group scenarios
    tablein={
        'as',['Consequences of applying intervention to ' 10 ...
        'general females and males instead of FSW'] ,{'exception';'swapal'}
        'aa','i',{'alphalr';'flatlr'}
        'ab','i',{'alphab';'flatb'}
        'ch','i',{'chir';'chiu'}
        'cv','i',{'zeta';'tau'}
        'gmph','s',{'gamma';'phi'}
        'sbpf','s',{'c1';'c2'}
        'durr','s',{'theta'}
        'efrs','s',{'eff';'res'}
        }';
    tables=gettables(tablein);
    



    scenblocks=[];
    if nargin==0
        type={};
        scen=struct();
        longdesc=struct();
    end
    if isa(type,'char')
        type={type};
    end
    for t = type
        switch t{:}
            case {'list' 'l'}
                scen.swapal={'default','alphalr',1,'alphas',0};
                scenblocks=[scenblocks al al];
                scen.flatlr2={'default','alphalr',0.5,'alphab',0.5};
                scenf.flatlr2={'tau',@(rates) rates.tau*rates.probs*(1-rates.sexratio)./ ...
                    (0.5+0.5*rates.probs*(1-rates.sexratio))};
                scenblocks=[scenblocks al al]; %#ok<*AGROW>
                scen.flatlr3={'default','alphalr',1,'alphab',1};
                scenf.flatlr3={'tau',@(rates) rates.tau*rates.probs*(1-rates.sexratio)};
                scen.flatb2={'default','alphab',0.5};
                scenf.flatb2={'tau',@(rates) rates.tau*rates.probs*(1-rates.sexratio)/...
                    (rates.probs*(1-rates.sexratio)+0.5*rates.probb*rates.sexratio)};
                scen.flatb3={'default','alphab',1};
                scenf.flatb3={'tau',@(rates) rates.tau*rates.probs*(1-rates.sexratio)/...
                    (rates.probs*(1-rates.sexratio)+rates.probb*rates.sexratio)};
                scenblocks=[scenblocks al al];
            case {'univariate' 'u'}
                for ii=upin
                    if ~any(strcmp(varargin,'subset'))|any(strcmp(pin{1,ii},varargin))
                        for jj=2:numel(pin{3,ii})
                            if ~isequal(pin{3,ii}{1},pin{3,ii}{jj})
                                scen.(sprintf('%s%d',pin{1,ii},jj))={'default',pin{1,ii},pin{3,ii}{jj}};
                                longdesc.(sprintf('%s%d',pin{1,ii},jj))= ...
                                    getlongdesc(pin{1,ii},pin{3,ii}{jj}, ...
                                    pin{3,ii}{jj}<pin{3,ii}{1} );
                                scenblocks=[scenblocks blocks(ii)];
                            end
                        end
                    end
                end
            case 's'
                if any(strncmp(type,'u',1))
                    error('Cannot mix ''u'' and ''s''') %#ok<ERTAG>
                end
                userscens=varargin(~strcmp(varargin,'blocks')&~strcmp(varargin,'subset'));
                for ii=1:4:length(userscens)-1
                    scen.(userscens{ii})=userscens{ii+1};
                    longdesc.(userscens{ii})=userscens{ii+2};
                    scenblocks=[scenblocks userscens{ii+3}];
                end
            otherwise
                disp(type)
        end
    end


%% Create cell-format default scenario
snames=fieldnames(scen);
pbase=cell(3,size(pin,2));
for ii=find(blocks~=regional)
    pbase{1,ii}=pin{1,ii};
    pbase(2:3,ii)=pin{3,ii}(1);
end
for ii=find(blocks==regional)
    pbase{1,ii}=pin{1,ii};
    [pbase{2:3,ii}]=pin{3,ii}{:};
end
p=pbase;
    
%% Append other cell-format scenarios
blocksinuse=find(ismember(1:max(blocks),blocks));
ps=cell(numel(blocksinuse),1    );
for block=blocksinuse
    for ii=1:length(snames)
        if scenblocks(ii)==block
            [p,rownums]=cellop(p,'new',scen.(snames{ii}));
            p=cellop(p,'set',rownums,'desc',snames{ii});
            try
                p(rownums+1,strcmp(p(1,:),'longdesc'))={longdesc.(snames{ii})};
            catch
                p(rownums+1,strcmp(p(1,:),'longdesc'))={getlongdesc(snames{ii},0,0)};
            end
            if exist('scenf','var')
                if isfield(scenf,snames{ii})
                    for jj=1:size(scenf.(snames{ii}),1)
                        for hh=rownums
                            p{hh+1,strcmp(p(1,:),scenf.(snames{ii}){jj,1})}=scenf.(snames{ii}){jj,2}(assct(p,hh));
                        end
                    end
                end
            end
        end
    end
    if any(strcmp(varargin,'blocks'))
        ps{block}=p;
        p=pbase;
    end
end
end


function tables=gettables(tablein)
    tables=cell(size(tablein)-[1 0]);
    for ii=1:size(tables,2)
        namein=tablein{3,ii};
        if ~strcmp(namein{1},'exception')
            if isequal(tablein{2,ii},'s')
                titlestr='Sensitivity to ';
                cjn=' and ';
            elseif isequal(tablein{2,ii},'i')
                titlestr='Consequences of varying ';
                cjn=' or ';
            end
            if length(namein)==2
                tables{1,ii}=[titlestr namein{1} cjn namein{2}];
                tables{2,ii}={'default';[namein{1} '2'];[namein{1} '3'];[namein{2} '2'];[namein{2} '3']};
                if strcmp(namein{1},'alphab')
                    tables{1,ii}='Consequences of extending PPT to MSMW';
                elseif strcmp(namein{1},'alphalr')
                    tables{1,ii}='Consequences of extending PPT to all populations';
                end
            elseif length(namein)==1
                tables{1,ii}=[titlestr namein{1}];
                tables{2,ii}={'default';[namein{1} '2'];[namein{1} '3']};
            elseif length(namein)==7
            end
        else
            if 0
            else
                tables{1,ii}=tablein{2,ii};
                tables{2,ii}=['default';namein(2:end)];
            end
        end
    end
    if any(cellfun('isempty',tables))
        error('Problem with gettables, please debug. ') %#ok<ERTAG>
    end
end

function thislongdesc=getlongdesc(name,value,lessthan)
    replacements = {
        'c1' 'c_1'
        'c2' 'c_2'
        'eff' 'epsilon'
        'res' 'rho'
        'alphalr' 'alpha_{all}'
        'alphab' 'alpha_b'
        'chiu' 'chi_u'
        'chir' 'chi_r'
        };
    if any(strcmp(name,replacements(:,1)))
        name=replacements{strcmp(replacements(:,1),name),2};
    end
    if lessthan
        thislongdesc=sprintf('Decrease %s to %4.2f',name,value);
    else
        thislongdesc=sprintf('Increase %s to %4.2f',name,value);
    end
    if strncmp(name,'flatlr',6)
        thislongdesc=[
            sprintf('Increase alpha_{all} to %4.2f, ',value)
                    'reducing tau accordingly.     '];
    elseif strncmp(name,'flatb',5)
        thislongdesc=[
            sprintf('Increase alpha_b to %4.2f, ',value)
                    'reducing tau accordingly. '];
    end
        
end
 % TODO: Find some values for gamma (dependence on duration of infection)




 
% %% Old style
% p=[ ...    
%     {'desc'      'gamma'     'c1'        'c2'         'betam'      'betab'      'betaf'      'betas'
%      'lower'     1.2         0.96        0.99         -0.765       -0.176       -1.64        -10.36
%      'default'   1.2         0.92        0.96         -0.765       -0.176       -1.64        -10.36
%      'upper'     1.2         0.84        0.92         -0.765       -0.176       -1.64        -10.36 } ...
%     {'zeta'     'eff'       'res'       'att'        'per'        'theta'    
%      0.2        0.9         0.01        0.7          2            0
%      0.5        0.95        0.025       0.9          1            3
%      0.8        0.98        0.05        1            0.5          7         } ...
%     {'Nm'       'Nb'        'Ns'        'Nf'
%      0.5        0.02        0.05        0.47
%      0.5        0.04        0.01        0.47 
%      0.5        0.06        0.5         0.47}];
