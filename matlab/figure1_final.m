
%figure 1

%%%%%%%%%%%%%%%%%%%%%10-6-2016
loc3=[
   42.837 -124.563  %cape blanco
   40.44  -124.408 %cape mendocino
   44.634 -124.061 %newport
   36.598 -121.8922 %monterey
   34.417 -119.700 %santa Barbara
   ];
figure(10); ax = usamap('all');
states = shaperead('usastatelo', 'UseGeoCoords', true);close(10);
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\graphics\');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\color_maps');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\read_routines\');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_anomaly_2002_2012_v4.0.nc');
[mur_clim_anom_std]=ncread(fname,'mur_clim_anom_std');
ip=0;        clf;colormap(anom_color);
close('all');figure(10);colormap(anom_color);cc=colormap;
ilen=size(cc);min_std=min(min(min(mur_clim_anom_std)));max_std=max(max(max(mur_clim_anom_std)));
rmax=3;rmin=-3;;dx=(rmax-rmin)/200;
rscale=[rmin+dx/2:dx:rmax-dx/2];
ia=find(abs(rscale)<min_std);for i=1:length(ia),cc(ia(i),:)=[1 1 1];end;
colormap(cc);
for lyr=2014:2016
    syr=num2str(lyr,'%4.4i');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_monthly_',syr,'_v4.0.nc');
    a=ncread(fname,'sst');
    %icoast=ones(1526,1)*2093;for j=1:1526,for i=1200:2093,if isnan(a(i,j,1)),icoast(j)=i-1;break;end;end;end;
    %a2=a;for k=1:12,for j=1:1526,mna=mean(a(icoast(j)-1000:icoast(j)-700,j,k));a2(:,j,k)=a(:,j,k)-mna;end;end;
    a2=a-mur_clim;
    a3=a2;for i=1:12,tem=a3(:,:,i);tem(find(abs(tem)<mur_clim_anom_std(:,:,i)))=0;a3(:,:,i)=tem;end;
    titmon={'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
    for im=1:12
        if im>9 & lyr==2016,continue;end;
        jj=0;%colormap(r6);
        [idyjl]=dy2jul(lyr,im,1);
        %[idyjl]=dy2jul(lyr,6,26);
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        url_sst=strcat('F:\data\sst\jpl_mur\nc\20160303-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc');
%        url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
        lat = ncread(url_sst,'lat',[11107],[1526]);
        lon = ncread(url_sst,'lon',[3642 ],[2093]);
        tem=a3(:,:,im);
        tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
        ip=(im-1)*3+1+lyr-2014;
%        ip=round(im/2)+lyr-2014;
        subplot(12,3,ip),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
        set(gca,'fontsize',8);
        if ip==1,title('2014');end;
        if ip==2,title('2015');end;
        if ip==3,title('2016');end;
        axis([-132.27 -117 32.88 48.25]);
        if lyr>2014,set(gca,'yticklabel',[]);end;
        if ip<33,set(gca,'xticklabel',[]);end;
        push_panel(0,0.01);
        if ip>3,push_panel(0,0.01);end;
        if ip>6,push_panel(0,0.01);end;
        if ip>9,push_panel(0,0.01);end;
        if ip>12,push_panel(0,0.01);end;
        if ip>15,push_panel(0,0.01);end;
        if ip>18,push_panel(0,0.01);end;
        if ip>21,push_panel(0,0.01);end;
        if ip>24,push_panel(0,0.01);end;
        if ip>27,push_panel(0,0.01);end;
        if ip>30,push_panel(0,0.01);end;
        if ip>33,push_panel(0,0.01);end;
        hold on;[c,h]=contour(lon,lat,tem',[rmin:1:rmax],'k');
        plot(states(5).Lon,states(5).Lat,'k','linewidth',.5)
        plot(states(37).Lon,states(37).Lat,'k','linewidth',.5)
        plot(states(47).Lon,states(47).Lat,'k','linewidth',.5)
        gt=text(-124,47,titmon(im));set(gt,'fontweight','bold','fontsize',8,'color',[1 1 1]);
        pp=get(gca,'position');set(gca,'position',[pp(1) pp(2) pp(3:4)*1.1]);
       if lyr==2015,pp=get(gca,'position');set(gca,'position',[pp(1)-.2 pp(2) pp(3:4)]);end;
       if lyr==2016,pp=get(gca,'position');set(gca,'position',[pp(1)-.4 pp(2) pp(3:4)]);end;
    end;
end;
%make empty map
for im=12:12
    %        if im>7 & lyr==2016,continue;end;
    jj=0;%colormap(r6);
    [idyjl]=dy2jul(lyr,im,1);
    %[idyjl]=dy2jul(lyr,6,26);
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    url_sst=strcat('F:\data\sst\jpl_mur\nc\20160303-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc');
    %        url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    tem=a3(:,:,7);
    tem(find(~isnan(tem)))=0;tem(isnan(tem))=rmax+dx*2;
    ip=(im-1)*3+1+lyr-2014;
    %        ip=round(im/2)+lyr-2014;
    subplot(12,3,ip),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
    set(gca,'fontsize',8);
    if ip==1,title('2014');end;
    if ip==2,title('2015');end;
    if ip==3,title('2016');end;
    axis([-132.27 -117 32.88 48.25]);
        if lyr>2014,set(gca,'yticklabel',[]);end;
        if ip<33,set(gca,'xticklabel',[]);end;
        push_panel(0,0.01);
        if ip>3,push_panel(0,0.015);end;
        if ip>6,push_panel(0,0.01);end;
        if ip>9,push_panel(0,0.01);end;
        if ip>12,push_panel(0,0.01);end;
        if ip>15,push_panel(0,0.01);end;
        if ip>18,push_panel(0,0.01);end;
        if ip>21,push_panel(0,0.01);end;
        if ip>24,push_panel(0,0.01);end;
        if ip>27,push_panel(0,0.01);end;
        if ip>30,push_panel(0,0.01);end;
        if ip>33,push_panel(0,0.01);end;
        hold on; %[c,h]=contour(lon,lat,tem',[rmin:1:rmax],'k');
        plot(states(5).Lon,states(5).Lat,'k','linewidth',.5)
        plot(states(37).Lon,states(37).Lat,'k','linewidth',.5)
        plot(states(47).Lon,states(47).Lat,'k','linewidth',.5)
        %gt=text(-124,47,titmon(im));set(gt,'fontweight','bold','fontsize',8,'color',[1 1 1]);
        pp=get(gca,'position');set(gca,'position',[pp(1) pp(2) pp(3:4)*1.1]);
       if lyr==2015,pp=get(gca,'position');set(gca,'position',[pp(1)-.2 pp(2) pp(3:4)]);end;
       if lyr==2016,pp=get(gca,'position');set(gca,'position',[pp(1)-.4 pp(2) pp(3:4)]);end;
    end;
hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('\DeltaSST (\circC)'));
hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
set(hh,'position',[.226 .2 .205 .01]);
hold on;plot(loc3(:,2),loc3(:,1),'r.');
gt=text(-130,34,'No data');set(gt,'fontweight','bold','fontsize',8,'color',[0 0 0],'rotation',[90]);
orient tall;
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\images\anom\mnth_allB5.jpg');
print('-f','-djpeg99','-r400',fname);



