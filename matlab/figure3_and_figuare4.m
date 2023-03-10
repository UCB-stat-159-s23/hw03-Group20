%bakun locations
clear;
load(strcat('f:\data\sst\jpl_mur\coast_sst_clim_icoast_direction.mat'),'xdir2');  %load coast direction
load(strcat('f:\data\sst\jpl_mur\coast_sst_clim_icoast.mat'));
svlat=[33 36 39 42 45 48];
for i=1:length(svlat),[~,isvlat(i)]=min(abs(xlat_coast-svlat(i)));end;
%xdir2=zeros(4600)*NaN;xdir2(2916:4403)=xdir(item(2916:4403))
lat_label={'San Diego' 'Monterey'  'Point Arena' 'Crescent City' 'Newport' 'La Push'};
%lat_label={'La Push' 'Westport' 'Columbia River' 'Newport' 'Coos Bay' 'Crescent City' 'Eureka' 'Bodega Bay' 'Monterey' 'Vandenberg' 'Los Angeles' 'San Diego'};
%lat_label2={'La_Push' 'Westport' 'Columbia_River' 'Newport' 'Coos_Bay' 'Crescent_City' 'Eureka' 'Bodega_Bay' 'Monterey' 'Vandenberg' 'Los_Angeles' 'San_Diego'};
clear sv_data sv_datax sv_data2 sv_data3;
for i=1:length(svlat),[~,isvlat(i)]=min(abs(xlat_coast-svlat(i)));
    rot_angle(i)=xdir2(isvlat(i))-90;end;

%load(strcat('f:\data\sst\jpl_mur\coast_sst_clim_hov_daily_profile_location_2001_2016.mat'),'sv','xx','xx2','xx3');
fname=strcat('f:\data\sst\jpl_mur\coast_sst_clim_era_int_hov_daily_profile_location_2001_2016_bakuna.nc');
%fname=strcat('f:\data\sst\jpl_mur\coast_sst_clim_era_int_hov_daily_profile_location_2001_2016.nc');
[sv]=ncread(fname,'sv');[xx]=ncread(fname,'xx');[xx2]=ncread(fname,'xx2');[xx3]=ncread(fname,'xx3');
%sv(5321:size(sv,1),:,1:5,:)=NaN;  %no CCMP after july 15 2015
%rotate wind speeds
%rot_angle=[110 95 90 82 73 103 75 133 110 90 150 105]-90;
for ic=1:size(sv,1)
    for i=1:1000
        for jj=1:size(sv,4)
            v=[sv(ic,i,4,jj) sv(ic,i,5,jj)]; %wind speed
            theta=rot_angle(jj);
            R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
            vR = v*R;
            sv_data3(ic,i,1,jj)=squeeze(vR(1));
            sv_data3(ic,i,2,jj)=squeeze(vR(2));
            v=[sv(ic,i,14,jj) sv(ic,i,15,jj)]; %stress
            theta=rot_angle(jj);
            R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
            vR = v*R;
            sv_data4(ic,i,1,jj)=squeeze(vR(1));
            sv_data4(ic,i,2,jj)=squeeze(vR(2));
        end;
    end;
end;
%put into sv_dy and sv_mon, just a re-org of matrx into day,year,data
clear sv_dy sv_mon
for i=1:size(sv,1)
    for j=1:size(sv,4)
        for k=1:15
            i1=xx3(i); %day
            i2=floor(xx(i));
            i3=xx2(i); %month
            sv_dy(i1,i2,k,j)=sv(i,999,k,j);
            sv_mon(i3,i2,k,j)=sv(i,999,k,j);
        end;
        sv_dy(i1,i2,16,j)=sv_data3(i,999,1,j); %wind speed
        sv_mon(i3,i2,16,j)=sv_data3(i,999,1,j);
        sv_dy(i1,i2,17,j)=sv_data3(i,999,2,j);
        sv_mon(i3,i2,17,j)=sv_data3(i,999,2,j);
        sv_dy(i1,i2,18,j)=sv_data4(i,999,1,j); %stress
        sv_mon(i3,i2,18,j)=sv_data4(i,999,1,j);
        sv_dy(i1,i2,19,j)=sv_data4(i,999,2,j);
        sv_mon(i3,i2,19,j)=sv_data4(i,999,2,j);
        sv_dy(i1,i2,20,j)=sv_data3(i,1,1,j); %sst offshore
        sv_mon(i3,i2,20,j)=sv_data3(i,1,1,j);
    end;
end;
%now average, put into tem1, average SST +-15 days average wind +-30 days
rho=1029; %kg/m3
rhoa=1.22; %kg/m3
tem1=squeeze(sv(:,999,:,:));  %check stuff from here
tem1(:,16,:)=squeeze(sv_data3(:,999,1,:));  %rotated  u
tem1(:,17,:)=squeeze(sv_data3(:,999,2,:));  %rotated  v
tem1(:,18,:)=squeeze(sv_data4(:,999,1,:));  %rotated stress u
tem1(:,19,:)=squeeze(sv_data4(:,999,2,:));  %rotated stress v
tem1(:,20,:)=squeeze(sv(:,1,6,:));  %sst off shore
ubar=sqrt(squeeze(sv_data3(:,999,1,:)).^2+squeeze(sv_data3(:,999,2,:)).^2);  %bakun from u
vv=squeeze(sv_data3(:,999,2,:));  %bakun from u
tem1(:,21,:)=rhoa*0.0013*ubar.*vv./(rho)*100;  %bakun from u not divided by f yet
%tem1(:,18,:)=squeeze(sv_data3(:,999,1,:));
%tem1(:,19,:)=squeeze(sv_data3(:,999,2,:));
%tem1(:,20,:)=squeeze(sv_data4(:,999,1,:));
%tem1(:,21,:)=squeeze(sv_data4(:,999,2,:));
for j=1:size(sv,4)
    for k=1:size(tem1,2)
        iwidth=15;
        %if k<6,iwidth=30;end;
        if k>=6 & k<12,iwidth=15;end;
        if k==20,iwidth=15;end;
        %if k>=12,iwidth=30;end;
        %iwidth=30;
        tem=tem1(:,k,j);
        tem2=tem;
        for i=1+iwidth:size(sv,1)-iwidth
            tem2(i)=mean(tem(i-iwidth:i+iwidth));
        end;
        tem1a(:,k,j)=tem2;
    end;
end;
%now tem1a contains smoothed data, so re=org into dy,yr,data array
sv_mon2=zeros(12,2016,21,12);sv_mon2_sq=sv_mon2;sv_mon2c=sv_mon2;
sv_dy2av=zeros(365,21,12);sv_dy2av_sq=sv_dy2av;sv_dy2avc=sv_dy2av;
for i=1:size(sv,1)
    for j=1:size(sv,4)
        for k=1:size(tem1a,2)
            i1=xx3(i); %day
            i2=floor(xx(i)); %year
            i3=xx2(i); %month
            sv_dy2(i1,i2,k,j)=tem1a(i,k,j);
            if isnan(tem1a(i,k,j)),continue;end;
            sv_dy2av(i1,k,j)=sv_dy2av(i1,k,j)+tem1a(i,k,j);
            sv_dy2av_sq(i1,k,j)=sv_dy2av_sq(i1,k,j)+tem1a(i,k,j).^2;
            sv_dy2avc(i1,k,j)=sv_dy2avc(i1,k,j)+1;
            sv_mon2(i3,i2,k,j)=sv_mon2(i3,i2,k,j)+tem1a(i,k,j);
            sv_mon2_sq(i3,i2,k,j)=sv_mon2_sq(i3,i2,k,j)+tem1a(i,k,j).^2;
            sv_mon2c(i3,i2,k,j)=sv_mon2c(i3,i2,k,j)+1;
        end;
    end;
end;
sv_dy2av=sv_dy2av./sv_dy2avc;
sv_dy2av_sq=sv_dy2av_sq./sv_dy2avc;
sv_dy2av_std=sqrt(sv_dy2av_sq-sv_dy2av.^2);
sv_mon2=sv_mon2./sv_mon2c;
sv_mon2_sq=sv_mon2_sq./sv_mon2c;
sv_mon2_std=sqrt(sv_mon2_sq-sv_mon2.^2);
%calculate first day of upwelling season two ways
%1) by first day alongshore wind stress negative
%2) by moving backwards from min wind stress to when it becomes positive
k=19;  %rotated stress  v
for j=2:size(sv,4)  %location
for lyr=2002:2016  %year
    [~,iloc]=min(sv_dy2(:,lyr,k,j));
    ia=find(sv_dy2(1:iloc,lyr,k,j)>0);
    if length(ia)>1,iupwell_season(lyr,j,1)=ia(length(ia));else,iupwell_season(lyr,j,1)=1;end;  %day started
    ia=find(sv_dy2(1:365,lyr,k,j)>0);ia=ia(find(ia>iloc));
    if length(ia)>1,iupwell_season(lyr,j,2)=ia(1);else,iupwell_season(lyr,j,2)=365;end;  %day end
    iupwell_season(lyr,j,3)=iupwell_season(lyr,j,2)-iupwell_season(lyr,j,1);
    iupwell_season(lyr,j,4)=iloc;  %day max upwell
end;end;
%now look at changes in wind speed and sst response during upwelling season
k=19;k1=6;clear svar1 svar2 svar3 svar4  %svar1=wind,svar2=sst
for j=2:size(sv,4)  %location
    for lyr=2003:2016
        istartdy=iupwell_season(lyr,j,1);
        ienddy=iupwell_season(lyr,j,2);
        for idyjl=istartdy:ienddy-1
            svar1(lyr,idyjl-istartdy+1,j)=sv_dy2(idyjl+1,lyr,k,j)-sv_dy2(idyjl,lyr,k,j); %\delta tauy
            svar2(lyr,idyjl-istartdy+1,j)=sv_dy2(idyjl+1,lyr,k1,j)-sv_dy2(idyjl,lyr,k1,j); %delta sst
            svar3(lyr,idyjl-istartdy+1,j)=sv_dy2(idyjl+1,lyr,k,j);  %tau y
            svar4(lyr,idyjl-istartdy+1,j)=sv_dy2(idyjl+1,lyr,k1,j); % sst
        end;end;end;


%calculate min and max
for i=1:365,
    for j=1:size(sv,4)
        for k=1:size(sv_dy2,3)
            rmax(i,k,j)=max(squeeze(sv_dy2(i,2002:2013,k,j)));
            rmin(i,k,j)=min(squeeze(sv_dy2(i,2002:2013,k,j)));
            rminsv(i,k,j)=min(squeeze(sv_dy2(i,2002:2015,k,j)));
            rmax_all(i,k,j)=max(squeeze(sv_dy2(i,2002:2015,k,j)));
            rmin_all(i,k,j)=min(squeeze(sv_dy2(i,2002:2015,k,j)));
            temx=squeeze(sv_dy2(i,2002:2013,k,j));
            ia=find(~isnan(temx));temx=temx(ia);
            SEM = std(temx); % Standard Error
%            SEM = std(temx)/sqrt(length(temx)); % Standard Error
 %           SEM = SEM * 1.96; %95 confidence interval
            rconf1(i,k,j)=mean(temx)+SEM;
            rconf2(i,k,j)=mean(temx);
            rconf3(i,k,j)=mean(temx)-SEM;
            xxp(i,1,k,j)=i-.5;
            xxp(i,2,k,j)=i+.5;
            xxp(i,3,k,j)=i+.5;
            xxp(i,4,k,j)=i-.5;
            yyp(i,1,k,j)=rmin(i,k,j);
            yyp(i,2,k,j)=rmin(i,k,j);
            yyp(i,3,k,j)=rmax(i,k,j);
            yyp(i,4,k,j)=rmax(i,k,j);
            yyp_std(i,1,k,j)=rconf3(i,k,j); %sv_dy2av(i,k,j)-sv_dy2av_std(i,k,j);
            yyp_std(i,2,k,j)=rconf3(i,k,j); %sv_dy2av(i,k,j)-sv_dy2av_std(i,k,j);
            yyp_std(i,3,k,j)=rconf1(i,k,j); %sv_dy2av(i,k,j)+sv_dy2av_std(i,k,j);
            yyp_std(i,4,k,j)=rconf1(i,k,j); %sv_dy2av(i,k,j)+sv_dy2av_std(i,k,j);
            yypa(i,1,k,j)=rconf3(i,k,j);
            yypa(i,2,k,j)=rconf3(i,k,j);
            yypa(i,3,k,j)=rconf1(i,k,j);
            yypa(i,4,k,j)=rconf1(i,k,j);
            ccp(i,:,k,j)=[.8 .8 .8];
        end;
    end;
end;
%calculate cumlative upwell/downwell
%use rmin 13 (v wind speed) goes negative for cumulative
sv_cumav=zeros(365,2016,21,12);
for i=1:365,for ii=2001:2016,for j=1:size(sv_dy2,3),for k=1:size(sv_dy2,4),
                ia=find(rminsv(:,15,k)<0);isv1=ia(1);
                if i<=isv1,sv_cumav(i,ii,j,k)=0;else,sv_cumav(i,ii,j,k)=sum(sv_dy2(isv1:i,ii,j,k));end;
            end;end;end;end;
sv_cumav2=zeros(365,13,12);
for i=1:365,for j=1:size(sv_cumav,3),for k=1:size(sv_cumav,4),
            sv_cumav2(i,j,k)=mean(squeeze(sv_cumav(i,2002:2013,j,k)));
        end;end;end;
%calculate min and max
for i=1:365,
    for j=1:size(sv_cumav,4)
        for k=1:size(sv_cumav,3)
            rmax2(i,k,j)=max(squeeze(sv_cumav(i,2002:2013,k,j)));
            rmin2(i,k,j)=min(squeeze(sv_cumav(i,2002:2013,k,j)));
            rmax2_all(i,k,j)=max(squeeze(sv_cumav(i,2002:2015,k,j)));
            rmin2_all(i,k,j)=min(squeeze(sv_cumav(i,2002:2015,k,j)));
            temx=squeeze(sv_cumav(i,2002:2013,k,j));
            ia=find(~isnan(temx));temx=temx(ia);
            SEM = std(temx)/sqrt(length(temx)); % Standard Error
            SEM = SEM * 1.96; %95 confidence interval
            rconf1a(i,k,j)=mean(squeeze(temx))+SEM;
            rconf2a(i,k,j)=mean(squeeze(temx));
            rconf3a(i,k,j)=mean(temx)-SEM;
            yyp2(i,1,k,j)=rmin2(i,k,j);
            yyp2(i,2,k,j)=rmin2(i,k,j);
            yyp2(i,3,k,j)=rmax2(i,k,j);
            yyp2(i,4,k,j)=rmax2(i,k,j);
            ccp(i,:,k,j)=[.8 .8 .8];
            yyp2a(i,1,k,j)=rconf3a(i,k,j);
            yyp2a(i,2,k,j)=rconf3a(i,k,j);
            yyp2a(i,3,k,j)=rconf1a(i,k,j);
            yyp2a(i,4,k,j)=rconf1a(i,k,j);
        end;
    end;
end;
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\read_routines\');

%svlat=[33 36 39 42 45 48];
ibakun_index=[11 10 9 8 7 6];
imap_index=  [1 2 3 4 5 6];
bi_xx=zeros(365,4,12);bi_yy=bi_xx;
for ig=1:length(imap_index)
    [fyr,data]=rd_bakun(ibakun_index(ig));id=imap_index(ig);
    %smooth
    data2=data;
    for i=1:length(data)
        iwidth=15;
        i1=i-iwidth;
        i2=i+iwidth;
        if i1<1,i1=1;end;
        if i2>length(data),i2=length(data);end;
        data2(i)=nanmean(data(i1:i2));
    end;
    mn=zeros(365,1);mnsq=mn;mnc=mn;
    for i=1:length(data)
        lyr=floor(fyr(i));
        idyjl=round((fyr(i)-floor(fyr(i)))*365+1);
        if isnan(data2(i)),continue;end;
        data3(lyr,idyjl,id)=data2(i);
        if lyr<2002 | lyr>2012,continue;end;
        %        if lyr<2002 | lyr>2012 | isnan(data2(i)),continue;end;
        mn(idyjl)=mn(idyjl)+data2(i);
        mnsq(idyjl)=mnsq(idyjl)+data2(i).^2;
        mnc(idyjl)=mnc(idyjl)+1;
    end;
    mn=mn./mnc;
    mnsq=mnsq./mnc;
    mnstd=sqrt(mnsq-mn.^2);
    bclim_dy_smooth3(:,id)=mn;
    bclim_dy_smooth3_std(:,id)=mnstd;
    lyr=floor(fyr);
    idyjl=round((fyr-floor(fyr))*365+1);
    for i=1:365,
        ia=find(i==idyjl & lyr>=2002 & lyr<=2012 & ~isnan(data2));
        bi_max=max(data2(ia));
        bi_mn=mean(data2(ia));
        bi_std=std(data2(ia));
        bi_min=min(data2(ia));
        bi_xx(i,:,id)=[i-.5 i+.5 i+.5 i-.5];
        bi_yy(i,:,id)=[bi_min bi_min bi_max bi_max];
        bi_yy2(i,:,id)=[bi_mn-bi_std bi_mn-bi_std bi_mn+bi_std bi_mn+bi_std];
    end;
end;

lambda=7.2921e-5; %rad/sec
rho=1029; %kg/m3
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\graphics\');
xlat=[33 36 39 42 45 48];
for i=1:length(svlat),[~,isvlat(i)]=min(abs(xlat_coast-svlat(i)));end;
%xdir2=zeros(4600)*NaN;xdir2(2916:4403)=xdir(item(2916:4403))
lat_label={'33N ~San Diego' '36N ~Monterey'  '39N ~Point Arena' '42N ~Crescent City' '45N ~Newport' '48N ~La Push'};
lat_label2={'33N ~San Diego' '36N ~Monterey'  '39N ~Point Arena' '42N ~Crescent City' '45N ~Newport' '48N ~La Push'};
%xlat=[47.57 46.55 46.11 44.38 43.25 41.47 40.46 38.19 36.35 34.43 33.56 32.44];
figure(11);clf;
jtem=[5 2];
%without upwelling colmn c
clf;ppsv=[0 0 .1237 .1026];iline=1.5;ipush=0.09;ipush2=-0.015;for jdata=1:2
    j=jtem(jdata);
    f=2*lambda*sind(xlat(j));
%    rscale=10^3/(rho*f);
%    rscale=100/(rho*f);
    ii=20;svar='SST';jj=(jdata-1)*4+1;
    xxmon=[1:365]/365*12;
    subplot(2,4,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp(i,:,ii,j),[.9 .9 .9]);set(gp,'linestyle','none');end;
%    plot([1:365],squeeze(rconf2(1:365,ii,j)),'k','linewidth',1.5);hold on;
    plot(xxmon,squeeze(sv_dy2(1:365,2016,ii,j)),'g','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2015,ii,j)),'r','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2014,ii,j)),'b','linewidth',1.5);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp_std(i,:,ii,j),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 7 23])
    %    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 365 min(rmin_all(:,6,j))-dx/10 max(rmax_all(:,20,j))+dx/10])
    if jdata==1,
        gt=text(1,19,'2014');set(gt,'color','b');
        gt=text(1,18,'2015');set(gt,'color','r');
        gt=text(1,1,'2016');set(gt,'color','g');
        gt=text(1,20,'Mean');set(gt,'color','k');
    end;
    if jdata==1,gt=text(.5,22,'a');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,22,'e');set(gt,'color','k');end;
    if jj==1,title('SST_{offshore}(\circC)');end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''});
    if jj<5,set(gca,'xticklabel',[]);end;
    %if jj>=25,xlabel('Day of Year');end; %
    if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    ylabel(lat_label2{j})
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    
    ii=6;svar='SST';jj=(jdata-1)*4+2;
    subplot(2,4,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp(i,:,ii,j),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(sv_dy2(1:365,2016,ii,j)),'g','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2015,ii,j)),'r','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2014,ii,j)),'b','linewidth',1.5);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp_std(i,:,ii,j),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 7 23])
    %    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 365 min(rmin_all(:,6,j))-dx/10 max(rmax_all(:,20,j))+dx/10])
    if jdata==1,gt=text(.5,22,'b');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,22,'f');set(gt,'color','k');end;
    if jj==2,title('SST_{coast}(\circC)');end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''});
    if jj<5,set(gca,'xticklabel',[]);end;
    %  if jj>=26,xlabel('Day of Year');end; %
    push_panel(ipush2,0);
    if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
       
    ii=19;svar='\tau_y';jj=(jdata-1)*4+3;rscale=1000/(rho*f);
%    ii=21;svar='\tau_y';jj=(jdata-1)*5+3;rscale=1/f;
    subplot(2,4,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,rscale*yyp(i,:,ii,j),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2016,ii,j)),'g','linewidth',iline);
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2015,ii,j)),'r','linewidth',iline);
    %    plot([1:217],squeeze(sv_dy2(1:217,2015,ii,j)),'r','linewidth',iline);
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2014,ii,j)),'b','linewidth',iline);
    plot([0 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,rscale*yyp_std(i,:,ii,j),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,rscale*squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 -280 280]); %axis([1 12 -0.09 0.09])
%    if jj==3,title('\tau_y (Nm^{-2})');end;
    if jj==3,title('\tau_y (m^{3}s^{-1}100m^{-1})');end;
    if jdata==1,gt=text(.5,250,'c');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,250,'g');set(gt,'color','k');end;
    %put lines for upwelling start
    if jdata==1,
    ix1=max(iupwell_season(2002:2013,5,1));ix1=ix1/365*12;
    hold on;plot([ix1 ix1],[-200 0],'y');gt=text(ix1-.3,-240,'3');set(gt,'color','k');
    ix1=min(iupwell_season(2002:2013,5,1));;ix1=ix1/365*12;plot([ix1 ix1],[-200 0],'y');gt=text(ix1-.2,-240,'2');set(gt,'color','k');
    ix1=iupwell_season(2015,5,1);;ix1=ix1/365*12;plot([ix1 ix1],[-200 0],'y');gt=text(ix1-.4,-240,'1');set(gt,'color','k');
    end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''});
    if jj<5,set(gca,'xticklabel',[]);end;
     push_panel(ipush2*1.8*.5,0);
   if jdata>1,push_panel(0,(jdata-1)*ipush);xlab=xlabel('Month');end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    
    ii=19;svar='\bakun_index';jj=(jdata-1)*4+4;
    subplot(2,4,jj),hold on;for i=1:365,gp=patch(bi_xx(i,:,j)/365*12,-bi_yy(i,:,j),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot([1:151]/365*12,-data3(2016,1:151,j),'g','linewidth',iline);
    plot(xxmon,-data3(2015,:,j),'r','linewidth',iline);
    plot(xxmon,-data3(2014,:,j),'b','linewidth',iline);
    plot([0 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(bi_xx(i,:,j)/365*12,-bi_yy2(i,:,j),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,-bclim_dy_smooth3(:,j),'k','linewidth',1);
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 -280 280])
    if jj==4,title('Bakun (m^{3}s^{-1}100m^{-1})');end;
    if jdata==1,gt=text(.5,250,'d');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,250,'h');set(gt,'color','k');end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''});
    if jj<5,set(gca,'xticklabel',[]);end;
    push_panel(ipush2*2.6*.3,0);
    if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''});
    if jj<5,set(gca,'xticklabel',[]);end;
    % if jj>=26,xlabel('Day of Year');end; %
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    gt=text(13,-290,'- Upwelling');set(gt,'Rotation',90)
    gt2=text(14.5,-290,'  Favorable');set(gt2,'Rotation',90)
    gt3=text(13,0,'+ Downwelling');set(gt3,'Rotation',90)
    gt4=text(14.5,0,'   Favorable');set(gt4,'Rotation',90)
end;
xlab.Position=[-2.0000 -362.7599   -1.0000];
adir='C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\review\origiinall_jpg\';
fname=strcat(adir,'all_daychangeF9a.jpg');
orient portrait;print('-f','-djpeg99','-r400',char(fname));


%figure 4
jtem=[5 2];
%without upwelling colmn c
clf;ppsv=[0 0 .1237 .1026];iline=1.5;ipush=0.09;ipush2=-0.015;for jdata=1:2
    j=jtem(jdata);
    f=2*lambda*sind(xlat(j));
%    rscale=10^3/(rho*f);
%    rscale=100/(rho*f);
    ii=20;svar='SST';jj=(jdata-1)*5+1;
    xxmon=[1:365]/365*12;
    subplot(2,5,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp(i,:,ii,j)-squeeze(rconf2(i,ii,j)),[.9 .9 .9]);set(gp,'linestyle','none');end;
%    plot([1:365],squeeze(rconf2(1:365,ii,j)),'k','linewidth',1.5);hold on;
    plot(xxmon,squeeze(sv_dy2(1:365,2016,ii,j))-squeeze(rconf2(1:365,ii,j)),'g','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2015,ii,j))-squeeze(rconf2(1:365,ii,j)),'r','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2014,ii,j))-squeeze(rconf2(1:365,ii,j)),'b','linewidth',1.5);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp_std(i,:,ii,j)-squeeze(rconf2(i,ii,j)),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(rconf2(1:365,ii,j))-squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 12 -5 5])
    %    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 365 min(rmin_all(:,6,j))-dx/10 max(rmax_all(:,20,j))+dx/10])
    if jdata==1,
        gt=text(1,-2.5,'2014');set(gt,'color','b');
        gt=text(1,-3.5,'2015');set(gt,'color','r');
        gt=text(1,-4.5,'2016');set(gt,'color','g');
        gt=text(1,-1.5,'Mean');set(gt,'color','k');
    end;
    if jdata==1,gt=text(2,4.5,'a');set(gt,'color','k');end;
    if jdata==2,gt=text(2,4.5,'d');set(gt,'color','k');end;
    if jj==1,title('\DeltaSST_{offshore}(\circC)');end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''},'ytick',[-5:5]);
    if jj<6,set(gca,'xticklabel',[]);end;
    %if jj>=25,xlabel('Day of Year');end; %
    if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    ylabel(lat_label2{j})
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    
    ii=6;svar='SST';jj=(jdata-1)*5+2;
    subplot(2,5,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp(i,:,ii,j)-squeeze(rconf2(i,ii,j)),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(sv_dy2(1:365,2016,ii,j))-squeeze(rconf2(1:365,ii,j)),'g','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2015,ii,j))-squeeze(rconf2(1:365,ii,j)),'r','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2014,ii,j))-squeeze(rconf2(1:365,ii,j)),'b','linewidth',1.5);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp_std(i,:,ii,j)-squeeze(rconf2(i,ii,j)),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(rconf2(1:365,ii,j))-squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 12 -5 5])
    %    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 365 min(rmin_all(:,6,j))-dx/10 max(rmax_all(:,20,j))+dx/10])
    if jdata==1,gt=text(2,4.5,'b');set(gt,'color','k');end;
    if jdata==2,gt=text(2,4.5,'e');set(gt,'color','k');end;
    if jj==2,title('\DeltaSST_{coast}(\circC)');end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''},'ytick',[-5:5]);
    if jj<6,set(gca,'xticklabel',[]);end;
    %  if jj>=26,xlabel('Day of Year');end; %
    push_panel(ipush2,0);
    if jdata>1,push_panel(0,(jdata-1)*ipush);xlabel('Month');end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
       
    ii=19;svar='\tau_y';jj=(jdata-1)*5+3;rscale=1000/(rho*f);
%    ii=21;svar='\tau_y';jj=(jdata-1)*5+3;rscale=1/f;
    subplot(2,5,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,rscale*yyp(i,:,ii,j)-rscale*squeeze(rconf2(i,ii,j)),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2016,ii,j))-rscale*squeeze(rconf2(1:365,ii,j)),'g','linewidth',iline);
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2015,ii,j))-rscale*squeeze(rconf2(1:365,ii,j)),'r','linewidth',iline);
    %    plot([1:217],squeeze(sv_dy2(1:217,2015,ii,j)),'r','linewidth',iline);
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2014,ii,j))-rscale*squeeze(rconf2(1:365,ii,j)),'b','linewidth',iline);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,rscale*yyp_std(i,:,ii,j)-rscale*squeeze(rconf2(i,ii,j)),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,rscale*squeeze(rconf2(1:365,ii,j))-rscale*squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 12 -200 200]); %axis([1 12 -0.09 0.09])
%    if jj==3,title('\tau_y (Nm^{-2})');end;
    if jj==3,title('\Delta\tau_y (m^{3}s^{-1}100m^{-1})');end;
    if jdata==1,gt=text(2,180,'c');set(gt,'color','k');end;
    if jdata==2,gt=text(2,180,'f');set(gt,'color','k');end;
    %put lines for upwelling start
    if jdata==1,
    ix1=max(iupwell_season(2002:2013,5,1));ix1=ix1/365*12;
    hold on;plot([ix1 ix1],[-140 0],'y');gt=text(ix1-.3,-150,'3');set(gt,'color','k');
    ix1=min(iupwell_season(2002:2013,5,1));;ix1=ix1/365*12;plot([ix1 ix1],[-140 0],'y');gt=text(ix1-.2,-150,'2');set(gt,'color','k');
    ix1=iupwell_season(2015,5,1);;ix1=ix1/365*12;plot([ix1 ix1],[-140 0],'y');gt=text(ix1-.4,-150,'1');set(gt,'color','k');
    end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''});
    if jj<6,set(gca,'xticklabel',[]);end;
     push_panel(ipush2*1.8*.5,0);
   if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    
    
  %  gt=text(12.5,-.9e-6,'- Upwelling');set(gt,'Rotation',90)
  %  gt2=text(13.5,-.9e-6,'  Favorable');set(gt2,'Rotation',90)
  %  gt3=text(12.5,.0e-6,'+ Downwelling');set(gt3,'Rotation',90)
  %  gt4=text(13.5,.0e-6,'   Favorable');set(gt4,'Rotation',90)
end;
adir='C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\review\origiinall_jpg\';
fname=strcat(adir,'all_anomaly.jpg');
orient portrait;print('-f','-djpeg99','-r400',char(fname));

%figure 4 vert
jtem=[5 2];
%without upwelling colmn c
clf;ppsv=[0 0 .1237 .1026];iline=1.5;ipush=0.09;ipush2=-0.015;for jdata=1:2
    j=jtem(jdata);
    f=2*lambda*sind(xlat(j));
%    rscale=10^3/(rho*f);
%    rscale=100/(rho*f);
    ii=20;svar='SST';jj=(jdata-1)+1;
    xxmon=[1:365]/365*12;
    subplot(3,2,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp(i,:,ii,j)-squeeze(rconf2(i,ii,j)),[.9 .9 .9]);set(gp,'linestyle','none');end;
%    plot([1:365],squeeze(rconf2(1:365,ii,j)),'k','linewidth',1.5);hold on;
    plot(xxmon,squeeze(sv_dy2(1:365,2016,ii,j))-squeeze(rconf2(1:365,ii,j)),'g','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2015,ii,j))-squeeze(rconf2(1:365,ii,j)),'r','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2014,ii,j))-squeeze(rconf2(1:365,ii,j)),'b','linewidth',1.5);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp_std(i,:,ii,j)-squeeze(rconf2(i,ii,j)),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(rconf2(1:365,ii,j))-squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 -3 5])
    %    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 365 min(rmin_all(:,6,j))-dx/10 max(rmax_all(:,20,j))+dx/10])
    if jdata==2,
        gt=text(2,4.5,'2014');set(gt,'color','b');
        gt=text(4.2,4.5,'2015');set(gt,'color','r');
        gt=text(6.4,4.5,'2016');set(gt,'color','g');
        gt=text(8.6,4.5,'Mean');set(gt,'color','k');
    end;
    gt=text(4,6,lat_label2{j});set(gt,'color','k');
    if jdata==1,gt=text(.5,4.5,'a');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,4.5,'c');set(gt,'color','k');end;
    if jdata==1,ylabel('\DeltaSST_{offshore}(\circC)');end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''},'ytick',[-5:5]);
    if jj<5,set(gca,'xticklabel',[]);end;
    if jdata==2,set(gca,'yticklabel',[]);end;
    %if jj>=25,xlabel('Day of Year');end; %
    if jdata>1,push_panel(-.09,0);end; %(jdata-1)*ipush);end;
    %ylabel()
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    
    ii=6;svar='SST';jj=(jdata-1)+3;
    subplot(3,2,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp(i,:,ii,j)-squeeze(rconf2(i,ii,j)),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(sv_dy2(1:365,2016,ii,j))-squeeze(rconf2(1:365,ii,j)),'g','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2015,ii,j))-squeeze(rconf2(1:365,ii,j)),'r','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2014,ii,j))-squeeze(rconf2(1:365,ii,j)),'b','linewidth',1.5);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp_std(i,:,ii,j)-squeeze(rconf2(i,ii,j)),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(rconf2(1:365,ii,j))-squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 -3 5])
    %    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 365 min(rmin_all(:,6,j))-dx/10 max(rmax_all(:,20,j))+dx/10])
    if jdata==1,gt=text(.5,4.5,'c');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,4.5,'d');set(gt,'color','k');end;
    if jdata==1,ylabel('\DeltaSST_{coast}(\circC)');end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''},'ytick',[-5:5]);
    if jj<5,set(gca,'xticklabel',[]);end;
     if jdata==2,set(gca,'yticklabel',[]);end;
   %  if jj>=26,xlabel('Day of Year');end; %
    %push_panel(ipush2,0);
        if jdata>1,push_panel(-.09,0);end; %(jdata-1)*ipush);end;
        push_panel(0,0.06);
    %if jdata>1,push_panel(0,(jdata-1)*ipush);xlabel('Month');end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
       
    ii=19;svar='\tau_y';jj=(jdata-1)+5;rscale=1000/(rho*f);
%    ii=21;svar='\tau_y';jj=(jdata-1)*5+3;rscale=1/f;
    subplot(3,2,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,rscale*yyp(i,:,ii,j)-rscale*squeeze(rconf2(i,ii,j)),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2016,ii,j))-rscale*squeeze(rconf2(1:365,ii,j)),'g','linewidth',iline);
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2015,ii,j))-rscale*squeeze(rconf2(1:365,ii,j)),'r','linewidth',iline);
    %    plot([1:217],squeeze(sv_dy2(1:217,2015,ii,j)),'r','linewidth',iline);
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2014,ii,j))-rscale*squeeze(rconf2(1:365,ii,j)),'b','linewidth',iline);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,rscale*yyp_std(i,:,ii,j)-rscale*squeeze(rconf2(i,ii,j)),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,rscale*squeeze(rconf2(1:365,ii,j))-rscale*squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 -200 200]); %axis([1 12 -0.09 0.09])
%    if jj==3,title('\tau_y (Nm^{-2})');end;
    if jdata==1,ylabel('\Delta\tau_y (m^{3}s^{-1}100m^{-1})');end;
    if jdata==1,gt=text(.5,180,'e');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,180,'f');set(gt,'color','k');end;
    %put lines for upwelling start
    if jdata==1,
    ix1=max(iupwell_season(2002:2013,5,1));ix1=ix1/365*12;
    hold on;plot([ix1 ix1],[-140 0],'y');gt=text(ix1-.3,-150,'3');set(gt,'color','k');
    ix1=min(iupwell_season(2002:2013,5,1));;ix1=ix1/365*12;plot([ix1 ix1],[-140 0],'y');gt=text(ix1-.2,-150,'2');set(gt,'color','k');
    ix1=iupwell_season(2015,5,1);;ix1=ix1/365*12;plot([ix1 ix1],[-140 0],'y');gt=text(ix1-.4,-150,'1');set(gt,'color','k');
    end;
    set(gca,'xtick',[1:12],'xticklabel',{'1' '' '3' '' '5' '' '7' '' '9' '' '11' ''});
    if jj<5,set(gca,'xticklabel',[]);end;
    if jdata==2,set(gca,'yticklabel',[]);end;
         if jdata>1,push_panel(-.09,0);end; %(jdata-1)*ipush);end;
        push_panel(0,0.12);
 %   push_panel(ipush2*1.8*.5,0);
  % if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    if jdata==2,xlab=xlabel('Month');end;
    
  %  gt=text(12.5,-.9e-6,'- Upwelling');set(gt,'Rotation',90)
  %  gt2=text(13.5,-.9e-6,'  Favorable');set(gt2,'Rotation',90)
  %  gt3=text(12.5,.0e-6,'+ Downwelling');set(gt3,'Rotation',90)
  %  gt4=text(13.5,.0e-6,'   Favorable');set(gt4,'Rotation',90)
end;
xlab.Position=[-.4000 -280  -1.0000];
adir='C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\review\origiinall_jpg\\';
fname=strcat(adir,'all_anomaly2.jpg');
orient portrait;print('-f','-djpeg99','-r400',char(fname));close('all');

%figure 3 vert
figure(11);clf;
jtem=[5 2];
%without upwelling colmn c
close('all');clf;ppsv=[0 0 .1237 .1026];iline=1.5;ipush=0.09;ipush2=-0.015;ic=0;clear gca_sv;for jdata=1:2
    j=jtem(jdata);
    f=2*lambda*sind(xlat(j));
%    rscale=10^3/(rho*f);
%    rscale=100/(rho*f);
    ii=20;svar='SST';jj=(jdata-1)+1;
    xxmon=[1:365]/365*12;
    subplot(4,2,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp(i,:,ii,j),[.9 .9 .9]);set(gp,'linestyle','none');end;
%    plot([1:365],squeeze(rconf2(1:365,ii,j)),'k','linewidth',1.5);hold on;
    gp=plot(xxmon,squeeze(sv_dy2(1:365,2016,ii,j)),'Color',[0 .5 0],'linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2015,ii,j)),'r','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2014,ii,j)),'b','linewidth',1.5);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp_std(i,:,ii,j),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 7 23])
    %    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 365 min(rmin_all(:,6,j))-dx/10 max(rmax_all(:,20,j))+dx/10])
    if jdata==1,
        gt=text(1,21,'Mean');set(gt,'color','k');
        gt=text(1,20,'2014');set(gt,'color','b');
        gt=text(1,19,'2015');set(gt,'color','r');
        gt=text(1,18,'2016');set(gt,'color',[0 .5 0]);
    end;
    if jdata==1,gt=text(.5,22,'a');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,22,'e');set(gt,'color','k');end;
    if jdata==1,ylabel('SST_{offshore}(\circC)');end;
    if jdata==2,push_panel(-0.03,0);end;
    set(gca,'xtick',[0:1:12],'xticklabel',{'       J' '       F' '       M' '       A' '       M' '       J' '       J' '       A' '       S' '       O' '       N' '       D' ''});
    %set(gca,'xticklabel',[]);if jdata==2,set(gca,'yticklabel',[]);end;
    if jdata==2,set(gca,'yticklabel',[]);end;
    %if jj>=25,xlabel('Day of Year');end; %
    %if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    title(lat_label2{j});
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    %ax2 = ticklabel;
    ic=ic+1;gca_sv(ic)=gca;

    ii=6;svar='SST';jj=(jdata-1)+3;
    subplot(4,2,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp(i,:,ii,j),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(sv_dy2(1:365,2016,ii,j)),'Color',[0 .5 0],'linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2015,ii,j)),'r','linewidth',1.5);
    plot(xxmon,squeeze(sv_dy2(1:365,2014,ii,j)),'b','linewidth',1.5);
    plot([1 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,yyp_std(i,:,ii,j),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 7 23])
    %    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([1 365 min(rmin_all(:,6,j))-dx/10 max(rmax_all(:,20,j))+dx/10])
    if jdata==1,gt=text(.5,22,'b');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,22,'f');set(gt,'color','k');end;
      %  if jdata==1,ylabel(SST_{coast}(\circC)');end;
if jdata==1,ylabel('SST_{coast}(\circC)');end;
    set(gca,'xtick',[0:1:12],'xticklabel',{'       J' '       F' '       M' '       A' '       M' '       J' '       J' '       A' '       S' '       O' '       N' '       D' ''});
    %set(gca,'xticklabel',[]);if jdata==2,set(gca,'yticklabel',[]);end;
    if jdata==2,set(gca,'yticklabel',[]);end;
    %  if jj>=26,xlabel('Day of Year');end; %
    if jdata==2,push_panel(-0.03,0);end;
 %   push_panel(ipush2,0);
 %   if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
     ic=ic+1;gca_sv(ic)=gca;
      %  ax2 = ticklabel;
  
    ii=19;svar='\tau_y';jj=(jdata-1)+5;rscale=1000/(rho*f);
%    ii=21;svar='\tau_y';jj=(jdata-1)*5+3;rscale=1/f;
    subplot(4,2,jj),hold on;for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,rscale*yyp(i,:,ii,j),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2016,ii,j)),'Color',[0 .5 0],'linewidth',iline);
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2015,ii,j)),'r','linewidth',iline);
    %    plot([1:217],squeeze(sv_dy2(1:217,2015,ii,j)),'r','linewidth',iline);
    plot(xxmon,rscale*squeeze(sv_dy2(1:365,2014,ii,j)),'b','linewidth',iline);
    plot([0 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(xxp(i,:,ii,j)/365*12,rscale*yyp_std(i,:,ii,j),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,rscale*squeeze(rconf2(1:365,ii,j)),'k','linewidth',1);hold on;
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 -300 300]); %axis([1 12 -0.09 0.09])
%    if jj==3,title('\tau_y (Nm^{-2})');end;
    if jdata==1,ylab3=ylabel({'\tau_y (m^{3}s^{-1}100m^{-1})'});end;
%    if jdata==1,ylab3=ylabel({'\tau_y';'(m^{3}s^{-1}100m^{-1})'});end;
    if jdata==1,gt=text(.5,270,'c');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,270,'g');set(gt,'color','k');end;
    %put lines for upwelling start
    if jdata==1,
    ix1=max(iupwell_season(2002:2013,5,1));ix1=ix1/365*12;
    hold on;plot([ix1 ix1],[-200 0],'y');gt=text(ix1-.3,-240,'3');set(gt,'color','k');
    ix1=min(iupwell_season(2002:2013,5,1));;ix1=ix1/365*12;plot([ix1 ix1],[-200 0],'y');gt=text(ix1-.2,-240,'2');set(gt,'color','k');
    ix1=iupwell_season(2015,5,1);;ix1=ix1/365*12;plot([ix1 ix1],[-200 0],'y');gt=text(ix1-.4,-240,'1');set(gt,'color','k');
    end;
    set(gca,'xtick',[0:1:12],'xticklabel',{'       J' '       F' '       M' '       A' '       M' '       J' '       J' '       A' '       S' '       O' '       N' '       D' ''});
    %set(gca,'xticklabel',[]);if jdata==2,set(gca,'yticklabel',[]);end;
    if jdata==2,set(gca,'yticklabel',[]);end;
    if jdata==2,push_panel(-0.03,0);end;
  %   push_panel(ipush2*1.8*.5,0);
  % if jdata>1,push_panel(0,(jdata-1)*ipush);xlabel('Month');end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);
    ic=ic+1;gca_sv(ic)=gca;
      %  ax2 = ticklabel;

    ii=19;svar='\bakun_index';jj=(jdata-1)+7;
    subplot(4,2,jj),hold on;for i=1:365,gp=patch(bi_xx(i,:,j)/365*12,-bi_yy(i,:,j),[.9 .9 .9]);set(gp,'linestyle','none');end;
    plot([1:151]/365*12,-data3(2016,1:151,j),'Color',[0 .5 0],'linewidth',iline);
    plot(xxmon,-data3(2015,:,j),'r','linewidth',iline);
    plot(xxmon,-data3(2014,:,j),'b','linewidth',iline);
    plot([0 365],[0 0],'color',[.6 .6 .6],'linewidth',1);
    for i=1:365,gp=patch(bi_xx(i,:,j)/365*12,-bi_yy2(i,:,j),[.65 .65 .65]);set(gp,'linestyle','none');end;
    plot(xxmon,-bclim_dy_smooth3(:,j),'k','linewidth',1);
    dx=max(rmax_all(:,ii,j))-min(rmin_all(:,ii,j));axis([0 12 -300 300])
    if jdata==1,ylab4=ylabel({'UI_{Bakun} (m^{3}s^{-1}100m^{-1})'});end;
%    if jdata==1,ylab4=ylabel({'UI_{Bakun}';'(m^{3}s^{-1}100m^{-1})'});end;
    if jdata==1,gt=text(.5,270,'d');set(gt,'color','k');end;
    if jdata==2,gt=text(.5,270,'h');set(gt,'color','k');end;
    set(gca,'xtick',[0:1:12],'xticklabel',{'       J' '       F' '       M' '       A' '       M' '       J' '       J' '       A' '       S' '       O' '       N' '       D' ''});
    %set(gca,'xticklabel',[]);if jdata==2,set(gca,'yticklabel',[]);end;
    if jdata==2,set(gca,'yticklabel',[]);end;
    %push_panel(ipush2*2.6*.5,0);
    if jdata==2,push_panel(-0.03,0);end;
   %if jdata>1,push_panel(0,(jdata-1)*ipush);end;
    set(gca,'box','on','fontsize',8);%pp=get(gca,'position');set(gca,'position',[pp(1:2) ppsv(3:4)]);    
    ic=ic+1;gca_sv(ic)=gca;
    xlab4=xlabel('Month');
   % ax2 = ticklabel;
end;
gc=get(gcf,'children');for i=1:8,gp=get(gc(i),'position');set(gc(i),'position',[gp(1:2) gp(3)*1.2 gp(4)*1.2]);end;
%gp=xlab4.Position;xlab4.Position=[gp(1)-.21 gp(2) gp(3)];
%gp=ylab5.Position;ylab5.Position=[gp(1)-.21 gp(2) gp(3)];
adir='C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\review\origiinall_jpg\';
fname=strcat(adir,'all_daychangeF9v.jpg');
orient tall;print('-f','-djpeg99','-r400',char(fname));





%figure 5
jtem=[5 2];
%without upwelling colmn c
clf;ppsv=[0 0 .1237 .1026];iline=1.5;ipush=0.09;ipush2=-0.015;for jdata=1:2
    j=jtem(jdata);
    f=2*lambda*sind(xlat(j));
    rho=1029; %kg/m3
    rscale=1000/(rho*f);
    
    jj=(jdata-1)*5+2;

    for iyr_temp=2014:2016,
        ip=jdata+(iyr_temp-2014)*2;
    x=xxmon;
    ii=6;y=squeeze(sv_dy2(1:365,iyr_temp,ii,j)); %-squeeze(rconf2(1:365,ii,j));
    ii=19;y1=rscale*squeeze(sv_dy2(1:365,iyr_temp,ii,j)); %-rscale*squeeze(rconf2(1:365,ii,j));
    subplot(3,2,ip), [hAx,hLine1,hLine2] = plotyy(x,y,x,y1);hold on;
    if iyr_temp==2014,    title(lat_label2{j});end;
    hLine1.LineWidth=.8;hLine1.Color='r';
    hLine2.LineWidth=.8;hLine2.Color='b';
    hAx(1).YColor='r';hAx(2).YColor='b';
    hAx(1).XLim=[0 12];hAx(2).XLim=[0 12];
    hAx(1).YLim=[7 23];hAx(2).YLim=[-200 200];
    hAx(1).YTick=[10:5:20];hAx(2).YTick=[-200:50:200];hAx(2).YTickLabel={'-200','','-100','','0','','100','','200'};
    x=xxmon;
    ii=6;y=squeeze(rconf2(1:365,ii,j));
    ii=19;y1=rscale*squeeze(rconf2(1:365,ii,j));
       [jAx,jLine1,jLine2] = plotyy(x,y,x,y1);
    jLine1.LineWidth=2;jLine1.Color='r';
    jLine2.LineWidth=2;jLine2.Color='b';
    if jdata==1,ylabel(hAx(1),'SST_{coast} (\circC)');end; % left y-axis
    if jdata==2,ylabel(hAx(2),'\tau_y (m^{3}s^{-1}100m^{-1})');end; % right y-axis
    jAx(1).XLim=[0 12];jAx(2).XLim=[0 12];
    jAx(1).YLim=[7 23];jAx(2).YLim=[-200 200];
    jAx(1).YColor='r';jAx(2).YColor='b';
    jAx(1).YTick=[10:5:20];jAx(2).YTick=[-200:50:200];jAx(2).YTickLabel={'-200','','-100','','0','','100','','200'};
    syr=num2str(iyr_temp,'%4.4i');gt=text(1,20,syr);gt.FontWeight='bold';gt.FontSize=12;
    end;
xlabel('Month');
end;
adir='C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\images\';
fname=strcat(adir,'all_anomaly2.jpg');
orient portrait;print('-f','-djpeg99','-r400',char(fname));