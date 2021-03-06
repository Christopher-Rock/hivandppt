function [p,tables,pin,scen,scenblocks,ps]=scenarios(type,varargin)
% SCENARIOS Create cell containing parameter values.
%           For each set of values, there are 10 scenarios to run.
%
%
%% Define indices
const=-2;
regional=-1;
sensit=1;
al=2;
ch=3;
cv=4;
pin=[...
    {'desc';const;{'default';'low';'high'}} ...
    {'ac';const;{1}} ...
    {'ar';const;{100}} ...
    {'csm';const;{240}} ...
    {'rsm';const;{1}} ...
    {'cfm';const;{4}} ...
    {'rfm';const;{0.7}} ...
    {'gamma';sensit;{1;1*1.1;1*.9}} ...
    {'theta';sensit;{7;3;14;}} ...
    {'phi';sensit;{0.50,0.5*1.1,0.5*.9}} ...
    {'psifrac';sensit;{1}} ...
    {'eff';sensit;{0.95;1-.05*1.1;1-.05*.9}} ...
    {'res';sensit;{0.01;0.01*1.1;0.01*.9}} ... % Resistance per year
    {'probbmod';sensit;{1;1.1;0.9}} ...
    {'probsmod';sensit;{1;1.1;0.9}} ...
    {'c1frac';sensit;{1}}...
    {'c2frac';sensit;{1}}...    
    {'movedir';const;{0}} ...
    {'region';regional;{2;1}} ...
    {'w';regional;{0.07;0.05}} ...
    {'x';regional;{0.08;0.06}} ...
    {'y';regional;{0.09;0.07}} ...
    {'z';regional;{0.32;0.30}} ...
    {'probs';regional;{0.01;0.05}} ...
    {'probb';regional;{0.04;0.06}} ...
    {'alpham';al;{0;0.5;.2}} ...
    {'alphaf';al;{0;0.5;.2}} ...
    {'alphab';al;{0;0.5;.2}} ...
    {'alphas';al;{1}} ...
    {'chiu';ch;{1;0;0.5}} ...
    {'chir';ch;{1;0;0.5}} ...
    {'zeta';cv;{0.75;0.5}} ...
    {'tau';cv;{6;12}} ...
    {'intnum';cv;{3;1;2;4}} ...
    {'sexratio';const;{0.5}} ...
    {'oldphi';const;{0.5}} ...
    {'fs';const;{2.4}} ...
    {'longdesc';const;{'Default intervention'}} ];
blocks=cell2mat(pin(2,:));
npin=find(blocks==sensit);
ipin=find(blocks==al|blocks==ch|blocks==cv);
upin=[npin ipin];
%% Complaints
for ii={
        },disp(ii);end
%% Group scenarios
    tablein={
        'as',['Consequences of applying intervention to ' 10 ...
        'general females and males instead of FSW'] ,{'exception';'swapal'}
        'aa','i',{'alphalr';'flatlr'}
        'ab','i',{'alphab';'flatb'}
        'ch','i',{'chir';'chiu'}
        'cv','i',{'zeta';'tau'}
        'gmph','s',{'gamma';'psi';}
        'durr','s',{'phi';'eff';'res';'theta';}
        'ulev','s',{'exception';'phipsi2';'highsti'}
        'pbmd','s',{'probbmod';'probsmod'}
        'alph','i',{'giveb';'addb';'givef';'addf';'givem';'addm'}
        'ashr','i',{'propb'}
        }';
    tables=gettables(tablein);
    if nargin==0
        tables={'def';{'default'}};
    end
    



    scenblocks=[];
    if nargin==0
        type={};
        scen=struct();
        longdesc=struct();
    end
    if isa(type,'char')
        type={type};
    end
    
    userscens=varargin(~strcmp(varargin,'blocks')&~strcmp(varargin,'subset')&~strcmp(varargin,'nobase'));
    for t = type
    %% Generate additional scenario descriptors
        switch t{:}
            case {'list' 'l'}
                %% Cases considered in final output
                for dummy=1
                    L={
                        'swapal' al {'default','alphalr',1,'alphas',0} {} ...
                        ['Provide PPT to general males ' 10 ...
                        'and females, and not to FSW']
                        'flatlr2' al {'default','alphalr',0.5,'alphab',0.5} ...
                        {'zeta',@(rates) rates.zeta*rates.probs*(1-rates.sexratio)./ ...
                        (0.5+0.5*rates.probs*(1-rates.sexratio))} ''
                        'flatlr3' al {'default','alphalr',1,'alphab',1} ...
                        {'zeta',@(rates) rates.zeta*rates.probs*(1-rates.sexratio)} ''
                        'flatb2' al {'default','alphab',0.5} ...
                        {'zeta',@(rates) rates.zeta*rates.probs*(1-rates.sexratio)/...
                        (rates.probs*(1-rates.sexratio)+0.5*rates.probb*rates.sexratio)} ''
                        'flatb3' al {'default','alphab',1} ...
                        {'zeta',@(rates) rates.zeta*rates.probs*(1-rates.sexratio)/...
                        (rates.probs*(1-rates.sexratio)+rates.probb*rates.sexratio)} ''
                        'phipsi2' sensit {'default','phi',0.67,'psi',0.83} {} 'High phi and psi'
                        'highsti' sensit {'default'} {'w',@(rates)rates.w*2; ...
                        'x',@(rates)rates.x*2;'y',@(rates)rates.y*2; ...
                        'z',@(rates)rates.z*2} 'High starting sti'
                        }';
                end
                %end
                if any(strcmp(varargin,'n'))
                    fg=1;
                    fa=0.2;
                    L={
%                         'propb' al {'default','alphab',1} ...
%                         {'zeta',@(rates)rates.zeta*rates.probs*(1-rates.sexratio)/...
%                         (rates.probs*(1-rates.sexratio)+rates.probb*rates.sexratio)} ...
%                         'Move PPT among MSMW and FSW'
                        'giveb' al {'default','alphas',1-fg} ...
                        {'alphab',@(rates)fg*rates.probs/(rates.probb)*2} ... % NEED SEXRATIO=1
                        [num2str(fg*100) '% of PPT moved to MSMW']
                        'addb' al {'default'} {'alphab',@(rates)0.2*rates.probs/rates.probb} ...
                        'Provide 20% PPT to MSMW and FSW'
%                         'propf' al {'default','alphaf',1} ...
%                         {'zeta',@(rates) rates.zeta*rates.probs} ...
%                         'Move PPT among general females and FSW'
                        'givef' al {'default','alphas',1-fg} ...
                        {'alphaf',@(rates)fg*rates.probs/(1-rates.probs)*20} ...
                        [num2str(fg*100) '% of PPT coverage moved to general females']
                        'addf' al {'default'} {'alphaf',@(rates)0.2*rates.probs/(1-rates.probs)} ...
                        'Provide 20% PPT to general females and FSW'
                        'givem' al {'default','alphas',1-fg} ...
                        {'alpham',@(rates)fg*rates.probs/(1-rates.probs)*20} ...
                        [num2str(fg*100) '% of PPT coverage moved to general males']
                        'addm' al {'default'} {'alpham',@(rates)0.2*rates.probs/(1-rates.probs)} ...
                        'Provide 20% PPT to general males and FSW'
                    }';
                elseif any(strcmp(varargin,'b'))
                    if ~strcmp(varargin(end),'b')&isnumeric(varargin{[false strcmp(varargin(1:end-1),'b')]})
                        fg=varargin{[false strcmp(varargin(1:end-1),'b')]};
                    else
                        fg=[0.1 0.3 0.5 0.6 0.9 1];
                    end
                    L=cell(length(fg),5);
                    for ii=1:length(fg)
                        L(ii,:)={['giveb' num2str(round(fg(ii)*10,0))] al {'default','alphas',1-fg(ii)} ...
                        {'alphab',@(rates)fg(ii)*rates.probs/(rates.probb)} ... % NEED SEXRATIO=1
                        [num2str(fg(ii)*100) '% of PPT moved to MSMW']};
                    end
                    L=L';
                elseif any(strcmp(varargin,'f'))
                    fg=[0.1 0.3 0.5 0.7 0.9 1];
                    L=cell(length(fg),5);
                    for ii=1:length(fg)
                        L(ii,:)={['givef' num2str(round(fg(ii)*10,0))] al {'default','alphas',1-fg(ii)} ...
                            {'alphaf',@(rates)fg(ii)*rates.probs/(1-rates.probs)} ... % NEED SEXRATIO=1
                            [num2str(fg(ii)*100) '% of PPT moved to general females']};
                    end
                    L=L';
                elseif any(strcmp(varargin,'m'))
                    fg=[0.1 0.3 0.5 0.7 0.9 1];
                    L=cell(length(fg),5);
                    for ii=1:length(fg)
                        L(ii,:)={['giveb' num2str(round(fg(ii)*10,0))] al {'default','alphas',1-fg(ii)} ...
                            {'alphab',@(rates)fg(ii)*rates.probs/(1-rates.probb)} ... % NEED SEXRATIO=1
                            [num2str(fg(ii)*100) '% of PPT moved to general males']};
                    end
                    L=L';
                elseif any(strcmp(varargin,'o'))
                    L={'zeros' al {'default','zeta',1,'eff',0.8,'res',Inf,'tau',12} {} 'Zero I_S'
                        'zerob' al {'default','alphas',0,'alphab',.83,'zeta',1,'eff',0.8,'res',Inf,'tau',12} ...
                        {'eff',@(rates)rates.eff*rates.probs/rates.probb} 'Zero I_B'
                        }';
                elseif any(strcmp(varargin,'c'))
                    a1=.2; A1=sprintf('%d',a1*100);
                    a2=.24; A2=sprintf('%d',a2*100);
                    L={ ['m' A1] al {'default' 'alpham' a1 'alphab' a1 'alphas' 0} {} ['Treat males at ' A1 '%']
                        ['m' A2] al {'default' 'alpham' a2 'alphab' a2 'alphas' 0} {} ['Treat males at ' A2 '%']
                        ['f' A1] al {'default' 'alphaf' a1 'alphas' a1} {} ['Treat females at ' A1 '%']
                        ['f' A2] al {'default' 'alphaf' a2 'alphas' a2} {} ['Treat females at ' A2 '%']
                        ['mix' A1] al {'default' 'alpham' a1/2 'alphaf' a1/2 'alphab' a1/2 'alphas' a1/2} {} [A1 '% mix']
                        ['mix' A2] al {'default' 'alpham' a2/2 'alphaf' a2/2 'alphab' a2/2 'alphas' a2/2} {} [A2 '% mix']
                        }';
                end
                for ii=1:size(tables,2)
                    tables{2,ii}=tables{2,ii}(ismember(tables{2,ii},[{'default'} L(1,:)]));
                end
                tables=tables(:,cellfun(@length,tables(2,:))>1);
                for ii=1:size(L,2)
                    scen.(L{1,ii})=L{3,ii};
                    if ~isempty(L{4,ii})
                        scenf.(L{1,ii})=L{4,ii};
                    end
                    if ~isempty(L{5,ii})
                        longdesc.(L{1,ii})=L{5,ii};
                    end
                    scenblocks=[scenblocks L{2,ii}]; %#ok<*AGROW>
                end
            case 'STI'
                scen=struct();
                tables={'sti';{'default';'sti2';'sti3'}};
            case 'r'
                scen=struct();
                for ii=userscens(:)'
                    scen.(ii{:})={'default','movedir',1};
                end
                tables={'varname';{'default';userscens(:)}};
                scenblocks=[scenblocks ones(1,length(userscens)*sensit)];
            case {'univariate' 'u'}
                %% Standard sensitivity analysis by data in table
                if any(strcmp(varargin,'subset'))
                    cmp=varargin{[false strcmp(varargin(1:end-1),'subset')]};
                    if iscell(cmp)
                        cmp=cmp(:);
                    elseif strcmp(cmp,'s')
                        cmp={'psi' 'phi' 'gamma' 'theta' 'eff' 'res' }';
                    end
                    for ii=1:size(tables,2)
                        tables{2,ii}=tables{2,ii}(ismember(tables{2,ii},[{'default'};cmp;strcat(cmp,'2');strcat(cmp,'3')]));
                    end
                    tables=tables(:,cellfun(@length,tables(2,:))>1);
                end
                for ii=upin
                    if any(strcmp(varargin,'nos'))
                        extra={'alphas',0};
                    else
                        extra={};
                    end
                    if ~any(strcmp(varargin,'subset'))|any(strcmp(pin{1,ii},cmp))
                        for jj=2:numel(pin{3,ii})
                            if ~isequal(pin{3,ii}{1},pin{3,ii}{jj})
                                scen.(sprintf('%s%d',pin{1,ii},jj))=[{'default',pin{1,ii},pin{3,ii}{jj}} extra];
                                longdesc.(sprintf('%s%d',pin{1,ii},jj))= ...
                                    getlongdesc(pin{1,ii},pin{3,ii}{jj}, ...
                                    pin{3,ii}{jj}<pin{3,ii}{1} );
                                scenblocks=[scenblocks blocks(ii)];
                            end
                        end
                    end
                end
            case 's'
                %% Specify new scenarios from command line
                if any(strncmp(type,'u',1))
                    error('Cannot mix ''u'' and ''s''') %#ok<ERTAG>
                end
                for ii=1:2:length(userscens)-1
                    scen.(userscens{ii})=[{'default'} userscens{ii+1}];
                    scenblocks=[scenblocks 4];
                end
                tables= [{'s'};{userscens(1:2:end)'}];
                if ~any(strcmp('nobase',varargin))
                    tables{2,1}=[{'default'};tables{2,1}];
                end
            case {'e' 'tz'}
                %% Do nothing
                scen=struct();
                tables={'title';{'default'}};
            case 'f'
                %% Treat other sub-pops
                alphaset={
                    @(zz){'alpham',zz,'alphab',zz,'alphas',0,'zeta',1}
                    @(zz){'alphaf',zz,'alphas',zz,'zeta',1}
                    @(zz){'alpham',zz/2,'alphab',zz/2,'alphaf',zz/2,'alphas',zz/2,'zeta',1}
                    };
                zetaset=[.2 .3];
                nameset={'men','women','both'};
                if nargin==2
                    alphaset=alphaset(strcmp(nameset,varargin{1}));
                    nameset=nameset(strcmp(nameset,varargin{1}));
                end                    
                temp={};
                for ii=1:length(alphaset)
                    for zz=zetaset
                        scen.(sprintf('%s%d',nameset{ii},zz*10))=['default',alphaset{ii}(zz)];
                        temp=[temp;sprintf('%s%d',nameset{ii},zz*10)];
                    end
                end
                tables={'bypop';temp};
                scenblocks=[scenblocks repmat(al,1,6)];
            case 'm'
                %% Multiply list by factors
                for ii=varargin{1}(:)'
                    scen.([ii{:} '2'])={'default'};
                    scenf.([ii{:} '2'])={ii{:},@(rates)rates.(ii{:})*varargin{2}(1)};
                    scen.([ii{:} '3'])={'default'};
                    scenf.([ii{:} '3'])={ii{:},@(rates)rates.(ii{:})*varargin{2}(2)};
                    scenblocks=[scenblocks ones(1,length(varargin{1})*2)*sensit];
                end
                        
            otherwise
                %% Probable error
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
pnew=pbase([1  2 3  2 3  2 3  2 3 ],:);
pnew=cellop(pnew,'set',1:2,'zeta',pin{3,strcmp('zeta',pin(1,:))}{2},'intnum',1);
pnew=cellop(pnew,'set',3:4,'zeta',pin{3,strcmp('zeta',pin(1,:))}{2},'tau',pin{3,strcmp('tau' ,pin(1,:))}{2},'intnum',2);
pnew=cellop(pnew,'set',7:8,'tau',pin{3,strcmp('tau',pin(1,:))}{2},'intnum',4);
p=pnew;

if any(strcmp(type,'f'))
    p=pnew(1:5,:); %#ok<NASGU> % remember to adjust for the header row!
end

%% Modify tau and zeta if desired
if any(strcmp(type,'tz'))
    zetas=varargin{1};
    taus=varargin{2};
    p=p([1 repmat(2:3,1,length(zetas)*length(taus))],:);
    for ii=1:length(zetas)
        p(1+(length(taus)*(2*ii-2)+1:length(taus)*2*ii),strcmp(p(1,:),'zeta'))={zetas(ii)};
    end
    p(2:end,strcmp(p(1,:),'tau'))=num2cell(reshape(repmat(taus(:),numel(zetas),2)',1,[]));
end

    
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

%% Deal with specific cases
if isa(type,'char')
    type={type};
end
for t = type
    switch t{:}
        case 'STI'
            sz=size(p,1)-1;
            p=p([1:end 2:end 2:end],:);
            p(sz+2:2*sz+1,1)={'sti2'};
            p(2*sz+2:3*sz+1,1)={'sti3'};
            p(rpinds(p,{'sti2','sti3'}),cpind(p,'movedir'))={1};
            p(rpind(p,'sti2'),cpinds(p,{'w','x','y','z'}))=num2cell(cell2mat(...
                p(rpind(p,'sti2'),cpinds(p,{'w','x','y','z'})))*varargin{1});
            p(rpind(p,'sti3'),cpinds(p,{'w','x','y','z'}))=num2cell(cell2mat(...
                p(rpind(p,'sti3'),cpinds(p,{'w','x','y','z'})))*varargin{2});
            tables={'sti';{'default';'sti2';'sti3'}};
    end
end
%% Remove unmodified scenarios if required
if any(strcmp(type,'f'))|any(strcmp(varargin,'nobase'))
    p=p(~rpind(p,'default'),:);
end

end


function tables=gettables(tablein)
    tables=cell(size(tablein)-[1 0]);
    for ii=1:size(tables,2)
        if strcmp(tablein{1,ii},'alph')
            tables{1,ii}='Effect of providing PPT to other populations';
            tables{2,ii}=[{};'default';tablein{3,ii}];
        elseif strcmp(tablein{1,ii},'ashr')
            tables{1,ii}='Effect of providing PPT equally to FSW and MSMW';
            tables{2,ii}=[{};'default';tablein{3,ii}];
        else
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
                elseif length(namein)==4
                    tables{1,ii}=[titlestr namein{1} cjn namein{2}];
                    tables{2,ii}={'default';[namein{1} '2'];[namein{1} '3'];[namein{2} '2'];[namein{2} '3']; ...
                        [namein{3} '2'];[namein{3} '3'];[namein{4} '2'];[namein{4} '3']};
                elseif length(namein)==3
                    tables{1,ii}=[titlestr namein{1} cjn namein{2}];
                    tables{2,ii}={'default';[namein{1} '2'];[namein{1} '3'];[namein{2} '2'];[namein{2} '3']; ...
                        [namein{3} '2'];[namein{3} '3'];};
                end
            else
                if 0
                else
                    tables{1,ii}=tablein{2,ii};
                    tables{2,ii}=['default';namein(2:end)];
                end
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
            sprintf('Increase alpha_{all} to %4.2f,',value)
                    'reducing zeta accordingly.   '];
    elseif strncmp(name,'flatb',5)
        thislongdesc=[
            sprintf('Increase alpha_b to %4.2f, ',value)
                    'reducing zeta accordingly.'];
    end
        
end

function ind=cpind(p,str)
    ind=strcmp(p(1,:),str);
end
function ind=cpinds(p,strs)
    ind=ismember(p(1,:),strs);
end
function ind=rpind(p,str)
    ind=strcmp(p(:,1),str);
end
function ind=rpinds(p,strs)
    ind=ismember(p(:,1),strs);
end
function val=cpval(p,str)
    val=p(:,cpind(p,str));
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
