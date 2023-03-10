%%%%%%%%%%%%figure 2

%make max and time of max data
clear;
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_5dy_2002_2012_climatology_daily_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
mur_max=zeros(2093,1526);mur_sst_max=zeros(2093,1526);
mur_date=zeros(2093,1526);mur_date2=zeros(2093,1526);mur_date3=zeros(2093,1526);
mur_sst_date=zeros(2093,1526);mur_sst_date2=zeros(2093,1526);mur_sst_date3=zeros(2093,1526);
mn=zeros(6000);mnc=mn;xx=mn;xx2=mn;ic=0;
mn_mon=zeros(200);mnc_mon=mn_mon;xx_mon=mn_mon;xx2_mon=mn_mon;ic2=0;ic3=0;
for lyr=2002:2016
    clear mur_sst;
    for idyjl=1:365
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>279,continue;end; %to july 31 2016
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]        
        [a]=ncread(fname,'sst');
        sst=a;
        a=a-mur_clim(:,:,idyjl);
%        ic3=ic3+1;
%        mur_ts(ic3,1)=a(1300,850);
%        mur_ts(ic3,2)=a(1400,850);
%        mur_tsx(ic3)=lyr+(idyjl-1)/365;
        ia=find(~isnan(sst) & sst>mur_sst_max);
        if ~isnan(sst(2093,1400)),break;end;
        mur_sst_max(ia)=sst(ia);
        mur_sst_date(ia)=lyr;
        mur_sst_date2(ia)=idyjl;
        mur_sst_date3(ia)=imon;
        ia=find(~isnan(a) & a>mur_max);
        mur_max(ia)=a(ia);
        mur_date(ia)=lyr;
        mur_date2(ia)=idyjl;
        mur_date3(ia)=imon;
        ic=ic+1;
        ia=find(~isnan(a));
        mn(ic)=mn(ic)+sum(a(ia));
        mnc(ic)=mnc(ic)+length(ia);
        xx(ic)=lyr;
        xx2(ic)=idyjl;
        ic2=(lyr-2002)*12+imon;
        mn_mon(ic2)=mn_mon(ic2)+sum(a(ia));
        mnc_mon(ic2)=mnc_mon(ic2)+length(ia);
        xx_mon(ic2)=lyr;
        xx2_mon(ic2)=imon;
    end;
end;
mn=mn./mnc;
mn_mon=mn_mon./mnc_mon;
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_clim_max_5dy.nc');
write_nc3(fname,mur_max,'max',mur_date,'lyr',mur_date2,'day',mur_date3,'month');
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_max_5dy.nc');
write_nc3(fname,mur_sst_max,'max',mur_sst_date,'lyr',mur_sst_date2,'day',mur_sst_date3,'month');
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_clim_mean_v4.0_5dy.nc');
write_nc3(fname,mn,'mn',mnc,'cnt',xx,'lyr',xx2,'month');
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_clim_mean_mon_v4.0_5dy.nc');
write_nc3(fname,mn_mon,'mn',mnc_mon,'cnt',xx_mon,'lyr',xx2_mon,'month');

%max anomlies for different magnitudes
ia=find(mur_max>0);ib=find(mur_max>5);length(ib)/length(ia)
ia=find(mur_max>0);ib=find(mur_max>4);length(ib)/length(ia)
ia=find(mur_max>0);ib=find(mur_max>3);length(ib)/length(ia)

%print max maps
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\color_maps\');
figure(10); ax = usamap('all');
set(ax, 'Visible', 'off')
states = shaperead('usastatelo', 'UseGeoCoords', true);close(10);
close('all');;figure(10);colormap(r6);
lyr=2015;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
G.lat = ncread(url_sst,'lat',[11107],[1526]);
G.lon = ncread(url_sst,'lon',[3642],[2093]);
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_clim_max_5dy.nc');
[mur_max]=ncread(fname,'max');
[mur_date]=ncread(fname,'lyr');
[mur_date2]=ncread(fname,'day');
[mur_date3]=ncread(fname,'month');
%fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_clim_mean_v4.0_5dy.nc');
%[mn]=ncread(fname,'mn');
%[xx]=ncread(fname,'lyr');
%[xx2]=ncread(fname,'month');
ilnd=find(mur_max==0);

rmax2=[5 2016 12];rmin2=[0 2010 1];
iv=1;rmax=rmax2(iv);rmin=rmin2(iv);
dx=(rmax-rmin)/180;rlnd=rmax+dx*2;rmis=rmax+dx;
tem=mur_max;tem(find(tem>rmax))=rmax;
tem(find(tem>rmax))=rmax;tem(ilnd)=rmax+dx;tem(find(isnan(tem)))=rmax+dx*2;
subplot(2,3,iv),imagesc(G.lon,G.lat,tem',[rmin rmax+dx*3]);hold on;
plot(states(5).Lon,states(5).Lat,'k','linewidth',1)
plot(states(37).Lon,states(37).Lat,'k','linewidth',1)
plot(states(47).Lon,states(47).Lat,'k','linewidth',1)
axis image;axis([min(G.lon) max(G.lon) min(G.lat) max(G.lat)])
set(gca,'xtick',[-138:4:-118],'xticklabel',{'138W';''; '130W';'';'122W';''},'ytick',[34:4:48]);
gt=text(-120,48,'a');set(gt,'color','w','fontsize',12,'fontweight','bold');
pp=get(gca,'position');set(gca,'position',[pp(1)-.08 pp(2) pp(3:4)*1.4]);
gh=colorbar_thin2hxy(0,-.08);ctitle('SST (\circC)');set(gh,'xtick',[0:5],'tickLength',0.05)
freezeColors;freezeColors(gh)

iv=3;rmax=rmax2(iv);rmin=rmin2(iv);
dx=(rmax-rmin)/180;rlnd=rmax+dx*2;rmis=rmax+dx;
tem=mur_date3;tem(find(tem>rmax))=rmax;
tem(find(tem>rmax))=rmax;tem(ilnd)=rmax+dx;tem(find(isnan(tem)))=rmax+dx*2;
subplot(2,3,2),imagesc(G.lon,G.lat,tem',[rmin rmax+dx*3]);hold on;
plot(states(5).Lon,states(5).Lat,'k','linewidth',1)
plot(states(37).Lon,states(37).Lat,'k','linewidth',1)
plot(states(47).Lon,states(47).Lat,'k','linewidth',1)
axis image;axis([min(G.lon) max(G.lon) min(G.lat) max(G.lat)])
set(gca,'xtick',[-138:4:-118],'xticklabel',{'138W';''; '130W';'';'122W';''},'ytick',[]);
gt=text(-120,48,'b');set(gt,'color','w','fontsize',12,'fontweight','bold');
pp=get(gca,'position');set(gca,'position',[pp(1)-.05 pp(2) pp(3:4)*1.4]);
gh=colorbar_thin2hxy(0,-.08);ctitle('Month');set(gh,'xtick',[1:12],'tickLength',0.05,'xticklabel',{'1','','','4','','','7','','','10','',''})
freezeColors;freezeColors(gh)
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\max_5dy_sst5a.jpg');print('-f10','-djpeg','-r400',char(fname));

cc=colormap;clear cc2;
cc2(1,:)=[1 1 1];
cc2(2,:)=cc(30,:); %2013  blue
cc2(3,:)=cc(80,:); %2014 green
cc2(4,:)=cc(140,:); %2015 orange
cc2(5,:)=cc(170,:); %2016 red
cc2(6,:)=cc(181,:); %land grey
colormap(cc2);
iv=2;rmax=2016;rmin=2012;
dx=(rmax-rmin)/6;rlnd=rmax+dx*2;rmis=rmax+dx;
tem=mur_date;tem(find(tem>rmax))=rmax;tem(find(tem<rmin))=2012;
tem(find(tem>rmax))=rmax;tem(ilnd)=rmax+dx;tem(find(isnan(tem)))=rmax+dx*2;
subplot(2,3,3),imagesc(G.lon,G.lat,tem',[rmin rmax+dx*2]);hold on;
plot(states(5).Lon,states(5).Lat,'k','linewidth',1)
plot(states(37).Lon,states(37).Lat,'k','linewidth',1)
plot(states(47).Lon,states(47).Lat,'k','linewidth',1)
axis image;axis([min(G.lon) max(G.lon) min(G.lat) max(G.lat)])
set(gca,'xtick',[-138:4:-118],'xticklabel',{'138W';''; '130W';'';'122W';''},'ytick',[]);
pp=get(gca,'position');set(gca,'position',[pp(1)-.02 pp(2) pp(3:4)*1.4]);
gt=text(-120,48,'c');set(gt,'color','w','fontsize',12,'fontweight','bold');
gt=text(-140,27,'2013');set(gt,'color',cc2(2,:),'fontsize',12,'fontweight','bold');
gt=text(-134,27,'2014');set(gt,'color',cc2(3,:),'fontsize',12,'fontweight','bold');
gt=text(-128,27,'2015');set(gt,'color',cc2(4,:),'fontsize',12,'fontweight','bold');
gt=text(-122,27,'2016');set(gt,'color',cc2(5,:),'fontsize',12,'fontweight','bold');
%gh=colorbar_thin2hxy(0,-.08);ctitle('Year');set(gh,'xtick',[2002:2016],'tickLength',0.05,'xticklabel',{'2002','','','','2006','','','','2010','','','','2014','',''})
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\max_5dy_sst5.jpg');print('-f10','-djpeg','-r400',char(fname));


%max anomlies for different magnitudes
ia=find(mur_max>0);ib=find(mur_max>5);length(ib)/length(ia)
ia=find(mur_max>0);ib=find(mur_max>4);length(ib)/length(ia)
ia=find(mur_max>0);ib=find(mur_max>3);length(ib)/length(ia)

%with sst not anomaly
%print max maps
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\color_maps\');
figure(10); ax = usamap('all');
set(ax, 'Visible', 'off')
states = shaperead('usastatelo', 'UseGeoCoords', true);close(10);
close('all');;figure(10);colormap(r6);
lyr=2015;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
G.lat = ncread(url_sst,'lat',[11107],[1526]);
G.lon = ncread(url_sst,'lon',[3642],[2093]);
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_max_5dy.nc');
[mur_max]=ncread(fname,'max');
[mur_date]=ncread(fname,'lyr');
[mur_date2]=ncread(fname,'day');
[mur_date3]=ncread(fname,'month');
ilnd=find(mur_max==0);

rmax2=[25 2016 12];rmin2=[17 2010 1];
iv=1;rmax=rmax2(iv);rmin=rmin2(iv);
dx=(rmax-rmin)/180;rlnd=rmax+dx*2;rmis=rmax+dx;
tem=mur_max-273.15;tem(find(tem>rmax))=rmax;
tem(find(tem>rmax))=rmax;tem(ilnd)=rmax+dx;tem(find(isnan(tem)))=rmax+dx*2;
subplot(2,3,iv),imagesc(G.lon,G.lat,tem',[rmin rmax+dx*3]);hold on;
plot(states(5).Lon,states(5).Lat,'k','linewidth',1)
plot(states(37).Lon,states(37).Lat,'k','linewidth',1)
plot(states(47).Lon,states(47).Lat,'k','linewidth',1)
axis image;axis([min(G.lon) max(G.lon) min(G.lat) max(G.lat)])
set(gca,'xtick',[-138:4:-118],'xticklabel',{'138W';''; '130W';'';'122W';''},'ytick',[34:4:48]);
gt=text(-120,48,'a');set(gt,'color','w','fontsize',12,'fontweight','bold');
pp=get(gca,'position');set(gca,'position',[pp(1)-.08 pp(2) pp(3:4)*1.4]);
gh=colorbar_thin2hxy(0,-.08);ctitle('SST (\circC)');set(gh,'xtick',[17:25],'tickLength',0.05)
freezeColors;freezeColors(gh)

iv=3;rmax=rmax2(iv);rmin=rmin2(iv);
dx=(rmax-rmin)/180;rlnd=rmax+dx*2;rmis=rmax+dx;
tem=mur_date3;tem(find(tem>rmax))=rmax;
tem(find(tem>rmax))=rmax;tem(ilnd)=rmax+dx;tem(find(isnan(tem)))=rmax+dx*2;
subplot(2,3,2),imagesc(G.lon,G.lat,tem',[rmin rmax+dx*3]);hold on;
plot(states(5).Lon,states(5).Lat,'k','linewidth',1)
plot(states(37).Lon,states(37).Lat,'k','linewidth',1)
plot(states(47).Lon,states(47).Lat,'k','linewidth',1)
axis image;axis([min(G.lon) max(G.lon) min(G.lat) max(G.lat)])
set(gca,'xtick',[-138:4:-118],'xticklabel',{'138W';''; '130W';'';'122W';''},'ytick',[]);
gt=text(-120,48,'b');set(gt,'color','w','fontsize',12,'fontweight','bold');
pp=get(gca,'position');set(gca,'position',[pp(1)-.05 pp(2) pp(3:4)*1.4]);
gh=colorbar_thin2hxy(0,-.08);ctitle('Month');set(gh,'xtick',[1:12],'tickLength',0.05,'xticklabel',{'1','','','4','','','7','','','10','',''})
freezeColors;freezeColors(gh)
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\max_5dy_sst6a.jpg');print('-f10','-djpeg','-r400',char(fname));

cc=colormap;clear cc2;
cc2(1,:)=[1 1 1];
cc2(2,:)=cc(30,:); %2013  blue
cc2(3,:)=cc(80,:); %2014 green
cc2(4,:)=cc(140,:); %2015 orange
cc2(5,:)=cc(170,:); %2016 red
cc2(6,:)=cc(181,:); %land grey
colormap(cc2);
iv=2;rmax=2016;rmin=2012;
dx=(rmax-rmin)/6;rlnd=rmax+dx*2;rmis=rmax+dx;
tem=mur_date;tem(find(tem>rmax))=rmax;tem(find(tem<rmin))=2012;
tem(find(tem>rmax))=rmax;tem(ilnd)=rmax+dx;tem(find(isnan(tem)))=rmax+dx*2;
subplot(2,3,3),imagesc(G.lon,G.lat,tem',[rmin rmax+dx*2]);hold on;
plot(states(5).Lon,states(5).Lat,'k','linewidth',1)
plot(states(37).Lon,states(37).Lat,'k','linewidth',1)
plot(states(47).Lon,states(47).Lat,'k','linewidth',1)
axis image;axis([min(G.lon) max(G.lon) min(G.lat) max(G.lat)])
set(gca,'xtick',[-138:4:-118],'xticklabel',{'138W';''; '130W';'';'122W';''},'ytick',[]);
pp=get(gca,'position');set(gca,'position',[pp(1)-.02 pp(2) pp(3:4)*1.4]);
gt=text(-120,48,'c');set(gt,'color','w','fontsize',12,'fontweight','bold');
gt=text(-140,27,'2013');set(gt,'color',cc2(2,:),'fontsize',12,'fontweight','bold');
gt=text(-134,27,'2014');set(gt,'color',cc2(3,:),'fontsize',12,'fontweight','bold');
gt=text(-128,27,'2015');set(gt,'color',cc2(4,:),'fontsize',12,'fontweight','bold');
gt=text(-122,27,'2016');set(gt,'color',cc2(5,:),'fontsize',12,'fontweight','bold');
%gh=colorbar_thin2hxy(0,-.08);ctitle('Year');set(gh,'xtick',[2002:2016],'tickLength',0.05,'xticklabel',{'2002','','','','2006','','','','2010','','','','2014','',''})
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\max_5dy_sst6.jpg');print('-f10','-djpeg','-r400',char(fname));



