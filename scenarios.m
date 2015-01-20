function [p,pin,scen]=scenarios(type,varargin)
pin=[...
    {'desc';{'default';'low';'high'}} ...
    {'gamma';{1.20}} ...
    {'c1';{0.62;0.70;0.56}} ...
    {'c2';{0.96;0.99;0.92}} ...
    {'region';{2;1}} ...
    {'w';{0.07;0.05}} ...
    {'x';{0.08;0.06}} ...
    {'y';{0.09;0.07}} ...
    {'z';{0.32;0.30}} ...
    {'probs';{0.01;0.05}} ...
    {'probb';{0.04;0.06}} ...
    {'alphalr';{0;0.5;1}} ...
    {'alphab';{0;0.5;1}} ...
    {'chiu';{1;0;0.5}} ...
    {'chir';{1;0;0.5}} ...
    {'zeta';{0.40;0.20;0.60}} ...
    {'eff';{0.95;0.90;0.98}} ...
    {'res';{0.03;0.01;0.05}} ... % Resistance per year
    {'theta';{7.00;3.00;10}} ...
    {'sexratio';{0.5}} ...
    {'longdesc';{'Default intervention: 40% coverage of FSW, 0% coverage of MSMW and low-risk populations'}} ...
    {'fracsyphilis';{0.67;0.50;0.83}} ];
if nargin
    switch type
        case {'list' 'l'}
            scen.flatblr={'default','alphalr',1,'alphab',1};
            scenf.flatblr={'zeta',@(rates) rates.zeta*rates.probs*(1-rates.sexratio)};
            longdesc.flatblr=['Distribute the same number of treatments as in the default scenario ' ...
                'across the whole population'];
            scen.flatb={'default','alphab',1};
            scenf.flatb={'zeta',@(rates) rates.zeta*rates.probs*(1-rates.sexratio)/...
                (rates.probs*(1-rates.sexratio)+rates.probb*rates.sexratio)};
            longdesc.flatb=['Distribute the same number of treatments as in the default scenario ' ...
                'across FSW and MSMW'];

        case {'univariate' 'u'}
            for ii=[3:4 12:18 22]
                if nargin==1 || any(strcmp(pin{1,ii},varargin))
                    for jj=2:numel(pin{2,ii})
                        if ~isequal(pin{2,ii}{1},pin{2,ii}{jj})
                            scen.(sprintf('%s%d',pin{1,ii},jj))={'default',pin{1,ii},pin{2,ii}{jj}};
                            if pin{2,ii}{jj}<pin{2,ii}{1}
                                longdesc.(sprintf('%s%d',pin{1,ii},jj))=sprintf('Decrease %s to %4.2f',pin{1,ii},pin{2,ii}{jj});
                            else
                                longdesc.(sprintf('%s%d',pin{1,ii},jj))=sprintf('Increase %s to %4.2f',pin{1,ii},pin{2,ii}{jj});
                            end
                            
                        end
                    end
                end
            end
        case 's'
            scen=struct;
            longdesc=struct;
            for ii=1:3:length(varargin)
                scen.(varargin{ii})=varargin{ii+1};
                longdesc.(varargin{ii})=varargin{ii+2};
            end
        otherwise
            disp(type)
    end
else
    scen=struct();
end

%% Create cell-format default scenario
snames=fieldnames(scen);
p=cell(3,size(pin,2));
for ii=[1:4 12:size(pin,2)]
    p{1,ii}=pin{1,ii};
    p(2:3,ii)=pin{2,ii}(1);
end
for ii=5:11
    p{1,ii}=pin{1,ii};
    [p{2:3,ii}]=pin{2,ii}{:};
end

%% Append other cell-format scenarios
for ii=1:length(snames)
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
