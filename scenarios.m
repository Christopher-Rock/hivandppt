function [p,pin,scen]=scenarios(type,str)
pin=[...
    {'desc';{'default';'low';'high'}} ...
    {'gamma';{1.20}} ...
    {'c1';{0.92;0.96;0.84}} ...
    {'c2';{0.96;0.99;0.92}} ...
    {'region';{2;1}} ...
    {'w';{0.07;0.05}} ...
    {'x';{0.08;0.06}} ...
    {'y';{0.09;0.07}} ...
    {'z';{0.32;0.30}} ...
    {'probs';{0.01;0.05}} ...
    {'probb';{0.04;0.06}} ...
    {'alphalr';{0;0.5;1}} ...
    {'alphab';{1;0.75;1.25}} ...
    {'chiu';{1;0;0.5}} ...
    {'chir';{1;0;0.5}} ...
    {'zeta';{0.40;0.20;0.60}} ...
    {'eff';{0.95;0.90;0.98}} ...
    {'res';{0.03;0.01;0.05}} ... % Resistance per year
    {'theta';{7.00;3.00;10}} ...
    {'sexratio';{0.5}} ];
 
if nargin
    switch type
        case {'list' 'l'}
%             scen.lowerzeta={'default','zeta',0.4};
        case {'univariate' 'u'}
            for ii=[2:3 12:18]
                if nargin==1 || strcmp(pin{1,ii},str)
                    for jj=2:numel(pin{2,ii})
                        if ~isequal(pin{2,ii}{1},pin{2,ii}{jj})
                            scen.(sprintf('%s%d',pin{1,ii},jj))={'default',pin{1,ii},pin{2,ii}{jj}};
                        end
                    end
                end
            end
        otherwise
            disp(type)
    end
else
    scen=struct();
end

%% Create cell format
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

for ii=1:length(snames)
    [p,rownums]=cellop(p,'new',scen.(snames{ii}));
    p=cellop(p,'set',rownums,'desc',snames{ii});
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
