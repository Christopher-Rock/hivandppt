%%%     SENSITIVITIES

lfrac=ones(3,1)*0.9;
ufrac=ones(3,1)*1.1;
lsti=lfrac(1);usti=ufrac(1);
psti=scenarios('STI',lsti,usti,'nobase');
small2results(simdir,figdir,'move','c',psti,'n')
pfs=scenarios('r','fs2','fs3','nobase');
small2results(simdir,figdir,'move','c',pfs,'n')
pn=scenarios('m',{'gamma','c1frac','c2frac','eff','res'}, ...
    [lfrac(3) ufrac(3)],'nobase');
pv=scenarios('s','theta2',{'theta',3.5},'theta3',{'theta',14});
pchi=scenarios('s','chir2',{'chir',0});
pm=[pv; pn(2:end,:)];
pmchi=[pm;pchi(strcmp(pchi(:,1),'chir2'),:)];
small2results(simdir,figdir,'c',pmchi,'n')
pall=[pm;pfs(2:end,:);psti(2:end,:)];
ps=[psti;pfs(2:end,:)];
propminus=@(A,B)(A-B)./B;

stiresultswithzero=main(pall);
stiresults=stiresultswithzero(2,2:2:end)*popsplit+stiresultswithzero(2,1:2:end)*(1-popsplit);
stiout=bsxfun(propminus,reshape(stiresults(5:end),4,[]),stiresults(1:4)');

mhivts=dopulltables(pm,simdir);
mhivresults=1-mhivts(end,1:end-1)./mhivts(end,end);
mhivout=bsxfun(propminus,reshape(mhivresults(end,5:end),4,[]),mhivresults(end,1:4)');

shivts=sdopulltables(ps,simdir);
shivresults=1-bsxfun(@rdivide,shivts(end,1:end-1,:),shivts(end,end,:));
shivout=bsxfun(propminus,reshape(shivresults,4,[]),mhivresults(end,1:4)'); %#ok<REDEF>

hivout=[mhivout shivout];

[~,~,chihivts]=dopulltables(pchi,simdir);
chihivresults=1-chihivts(end,1:end-1)./chihivts(end,end);
chihivout=bsxfun(propminus,reshape(chihivresults(end,5:end),4,[]),chihivresults(end,1:4)');
