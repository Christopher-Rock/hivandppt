function pullhiv(p,simdir)
    if nargin==1,error('simdir=''C:/Users/Crock/Documents/r2/lowfs'';'),end %#ok<ERTAG>
    id=[simdir '/interventions/'];
    load([id p{2,1} '_1' '/input/IndiParams'],'PNGparamsIndi')
    load([id 'BaselineInt/input/PNGintPrepared'],'ModelintSpecs')
    timesteps=ModelintSpecs.intsteps;
    runset=2:2:size(p,1);
    sinc=zeros(length(runset),timesteps);
    for ii=runset
        intdir=[id p{ii,1} sprintf('_%d',p{ii,strcmp(p(1,:),'intnum')})];
        load([intdir '/Results/PngHIVIntervene1'],'HIVIntResults1')
        sinc(ii/2,:)=permute(sum(sum(HIVIntResults1.incidence(:,:,2:end),2),1),[1 3 2]);
    end
        load([id 'BaselineInt/Results/PngHIVIntervene1'],'HIVIntResults1')
        defrow=permute(sum(sum(HIVIntResults1.incidence(:,:,2:end),2),1),[1 3 2]);
    plotmany(p,sinc,defrow);
end
    
