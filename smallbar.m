function smallbar(results,names,tablename,figuredir)
    dbs=dbstatus;
    global dbifwarn
    dbifwarn=any(strcmp({dbs.cond},'warning'));
    dbstop if warning;
    clf;
    bar(results')
        legend(names,'Location',[0.7 0.65 0.2 0.15])
    title(tablename)
    set(gca,'xticklabel',{'STI drop after 3 years','STI drop after 10 years', ...
        'HIV drop after 10 years'})
    % ti = get(gca,'TightInset');
    saveas(gcf,[figuredir strrep(tablename,char(10),' ')],'png')
    0;
    if ~dbifwarn
        dbclear if warning
    end
end
