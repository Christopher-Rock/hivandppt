%%%     SENSITIVITIES

lfrac=ones(3,1)*0.9;
ufrac=ones(3,1)*1.1;
lsti=lfrac(1);usti=ufrac(1);
psti=scenarios('STI',lfrac(1),ufrac(1),'nobase');
small2results(simdir,figdir,'move','c',psti,'n')
pfs=scenarios('r','fs2','fs3','nobase');
small2results(simdir,figdir,'move','c',pfs,'n')
pn=scenarios('m',{'gamma','c1frac','c2frac','res','phi'}, ...
    [lfrac(3) ufrac(3)],'nobase');
pv=scenarios('s','theta2',{'theta',3.5},'theta3',{'theta',14},'eff2',{'eff',0.945},...
    'eff3',{'eff',0.955});
pchi=scenarios('s','chir2',{'chir',0});
pm=[pv; pn(2:end,:)];
pmchi=[pm;pchi(strcmp(pchi(:,1),'chir2'),:)];
small2results(simdir,figdir,'c',pmchi,'n')
ps=[psti;pfs(2:end,:)];
pall=[pm;ps(2:end,:)];
propminus=@(A,B)(A-B)./B;
popmerge=@(x,popsplit)x(:,2:2:end)*popsplit+x(:,1:2:end)*(1-popsplit);
endmerge=@(x)1-bsxfun(@rdivide,x(end,1:end-1,:),x(end,end,:));
cutshape=@(x,y,f)bsxfun(f,reshape(x,4,[]),y(:));
cutm=@(x)cutshape(x(5:end),x(1:4),propminus);
cuts=@(x,y)cutshape(x,y(1:4),propminus);

mstiresultswithzero=main(pm);
mstiresults=popmerge(mstiresultswithzero(2,:),popsplit);
mstiout=cutm(mstiresults);

sstiresultswithzero=main(ps);
sstiresults=popmerge(sstiresultswithzero(2,:),popsplit);
sstiout=cuts(sstiresults,mstiresults);



mhivts=dopulltables(pm,simdir);
mhivresults=1-mhivts(end,1:end-1)./mhivts(end,end);
mhivout=bsxfun(propminus,reshape(mhivresults(end,5:end),4,[]),mhivresults(end,1:4)');

shivts=sdopulltables(ps,simdir);
shivresults=1-bsxfun(@rdivide,shivts(end,1:end-1,:),shivts(end,end,:));
shivout=bsxfun(propminus,reshape(shivresults,4,[]),mhivresults(end,1:4)'); %#ok<REDEF>


[~,~,chihivts]=dopulltables(pchi,simdir);
chihivresults=1-chihivts(end,1:end-1)./chihivts(end,end);
chihivout=bsxfun(propminus,reshape(chihivresults(end,5:end),4,[]),chihivresults(end,1:4)');
chistiresultswithzero=main(pchi);
chistiout=cutm(popmerge(rows(chistiresultswithzero,2),popsplit));
chitgtout=cutm(popmerge(rows(chistiresultswithzero,1),popsplit));

stiout=[mstiout sstiout];
hivout=[mhivout shivout];
stiresultswithzero=[mstiresultswithzero sstiresultswithzero];
tgtresults=popmerge(stiresultswithzero(1,:),popsplit);tgtout=cutm(tgtresults);
