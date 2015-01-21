function [ps,pin,scen,scenblocks]=scenarios(type,varargin)
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
    {'fracsyphilis';sensit;{0.67;0.50;0.83}} ...
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
    {'chiu';ch;{1;0;0.5}} ...
    {'chir';ch;{1;0;0.5}} ...
    {'zeta';cv;{0.75;0.5;0.9}} ...
    {'tau';cv;{4;2;12}} ...
    {'sexratio';const;{0.5}} ...
    {'longdesc';const;{'Default intervention: 40% coverage of FSW, 0% coverage of MSMW and low-risk populations'}} ];

blocks=cell2mat(pin(2,:));
npin=find(blocks==sensit);
ipin=find(blocks==al|blocks==ch|blocks==cv);
upin=[npin ipin];

    scenblocks=[];
    if isa(type,'char')
        type={type};
    end
    for t = type
        switch t{:}
            case {'list' 'l'}
                scen.flatblr={'default','alphalr',1,'alphab',1};
                scenf.flatblr={'zeta',@(rates) rates.zeta*rates.probs*(1-rates.sexratio)}; %#ok<*AGROW>
                longdesc.flatblr=['Distribute the same number of treatments as in the default scenario ' ...
                    'across the whole population'];
                scenblocks=[scenblocks al];
                scen.flatb={'default','alphab',1};
                scenf.flatb={'zeta',@(rates) rates.zeta*rates.probs*(1-rates.sexratio)/...
                    (rates.probs*(1-rates.sexratio)+rates.probb*rates.sexratio)};
                longdesc.flatb=['Distribute the same number of treatments as in the default scenario ' ...
                    'across FSW and MSMW'];
                scenblocks=[scenblocks al];
                
            case {'univariate' 'u'}
                for ii=upin
                    if nargin==1 || any(strcmp(pin{1,ii},varargin))
                        for jj=2:numel(pin{3,ii})
                            if ~isequal(pin{3,ii}{1},pin{3,ii}{jj})
                                scen.(sprintf('%s%d',pin{1,ii},jj))={'default',pin{1,ii},pin{3,ii}{jj}};
                                if pin{3,ii}{jj}<pin{3,ii}{1}
                                    longdesc.(sprintf('%s%d',pin{1,ii},jj))=sprintf('Decrease %s to %4.2f',pin{1,ii},pin{3,ii}{jj});
                                else
                                    longdesc.(sprintf('%s%d',pin{1,ii},jj))=sprintf('Increase %s to %4.2f',pin{1,ii},pin{3,ii}{jj});
                                end
                                scenblocks=[scenblocks blocks(ii)];
                            end
                        end
                    end
                end
            case 's'
                scen=struct;
                longdesc=struct;
                for ii=1:4:length(varargin)
                    scen.(varargin{ii})=varargin{ii+1};
                    longdesc.(varargin{ii})=varargin{ii+2};
                    scenblocks=[scenblocks varargin{ii+3}];
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

%% Append other cell-format scenarios
blocksinuse=find(ismember(1:max(blocks),blocks));
ps=cell(1,1,numel(blocksinuse));
for block=blocksinuse
    p=pbase;
    for ii=1:length(snames)
        if scenblocks(ii)==block
            [p,rownums]=cellop(p,'new',scen.(snames{ii}));
            p=cellop(p,'set',rownums,'desc',snames{ii});
            p(rownums+1,strcmp(p(1,:),'longdesc'))={longdesc.(snames{ii})};
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
    ps{1,1,block}=p;
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
