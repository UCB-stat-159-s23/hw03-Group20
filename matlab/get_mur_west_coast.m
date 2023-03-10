addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
lyr=2014;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
a = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
G.lat = ncread(url_sst,'lat');
G.lon = ncread(url_sst,'lon');
% url_sst='http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/2013/012/20130112-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2'
% ncdisp(url_sst)
% G.lat = ncread(url_sst,'lat');
% G.lon = ncread(url_sst,'lon');
% a = ncread(url_sst,'analysed_sst',[3840 8192 1],[5660 4600 1]);
for lyr=2016:2016
    clear mur_sst;
    for idyjl=230:dyinyr(lyr)
        [lyr idyjl]
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>279,continue;end;
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
        a = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\west_coast_sst_',syr,sjdy,'_v4.0.nc');
        write_nc3(fname,a,'sst');
    end;
end;

%23 40 63
for lyr=2002:2002
    clear mur_sst;
    idyjl=153;
        [lyr idyjl]
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>167,continue;end;
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
%        url_sst=strcat('F:\data\sst\jpl_mur\nc\',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc');
        a = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_',syr,sjdy,'_v4.0.nc');
        write_nc3(fname,a,'sst');
end;

%make daily climatology
mur_clim=zeros(2093,1526,12);mur_clim_sq=zeros(2093,1526,12);mur_climc=mur_clim;
for lyr=2002:2012
    clear mur_sst;
    for idyjl=1:dyinyr(lyr)
        [lyr idyjl]
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>194,continue;end;
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
%        url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
%        a = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
%        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_',syr,sjdy,'_v4.0.nc');
%        write_nc3(fname,a,'sst');
%        a = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\west_coast_sst_',syr,sjdy,'_v4.0.nc');
        a=ncread(fname,'sst');        
        if lyr<=2012,
            ia=find(~isnan(a));
            tem=mur_clim(:,:,imon);temsq=mur_clim_sq(:,:,imon);temc=mur_climc(:,:,imon);
            tem(ia)=tem(ia)+a(ia);temsq(ia)=temsq(ia)+a(ia).^2;temc(ia)=temc(ia)+1;
            mur_clim(:,:,imon)=tem; mur_climsq(:,:,imon)=temsq;mur_climc(:,:,imon)=temc;
        end;
    end;
end;
mur_clim=mur_clim./mur_climc;
mur_clim_sq=mur_clim_sq./mur_climc;
mur_clim_std=sqrt(mur_clim_sq-mur_clim.^2);
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
write_nc3(fname,mur_clim,'mur_clim',mur_clim_sq,'mur_clim_sq',mur_clim_std,'mur_clim_std');


%make daily mur into monthly climatology ANOMALY STD
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_2002_2012_climatology_daily_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
mur_clim_anom=zeros(2093,1526,12);mur_clim_anom_sq=zeros(2093,1526,12);mur_clim_anomc=mur_clim_anom;
for lyr=2002:2012
    clear mur_sst;
    for idyjl=1:365
        [lyr idyjl]
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>194,continue;end;
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
%        url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
%        a = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
%        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_',syr,sjdy,'_v4.0.nc');
%        write_nc3(fname,a,'sst');
%        a = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_',syr,sjdy,'_v4.0.nc');
        a=ncread(fname,'sst'); 
        a2=a-mur_clim(:,:,idyjl);
        ia=find(~isnan(a2));
        tem=mur_clim_anom(:,:,imon);temsq=mur_clim_anom_sq(:,:,imon);temc=mur_clim_anomc(:,:,imon);
        tem(ia)=tem(ia)+a(ia);temsq(ia)=temsq(ia)+a(ia).^2;temc(ia)=temc(ia)+1;
        mur_clim_anom(:,:,imon)=tem; mur_clim_anom_sq(:,:,imon)=temsq;mur_clim_anomc(:,:,imon)=temc;
    end;
end;
mur_clim_anom=mur_clim_anom./mur_clim_anomc;
mur_clim_anom_sq=mur_clim_anom_sq./mur_clim_anomc;
mur_clim_anom_std=sqrt(mur_clim_anom_sq-mur_clim_anom.^2);
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_anomaly_2002_2012_v4.0.nc');
write_nc3(fname,mur_clim_anom,'mur_clim_anom',mur_clim_anom_sq,'mur_clim__anom_sq',mur_clim_anom_std,'mur_clim_anom_std');




%make 5 and 10 day averages
clear;
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
asv=zeros(2093,1526,10)*NaN;
for lyr=2016:2016
    clear mur_sst;
    istart_dy=220;
    for idyjl=istart_dy:279 %1:dyinyr(lyr)
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>279,continue;end;
     %   if idyjl<100,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\west_coast_sst_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]
        [a]=ncread(fname,'sst');
      %  if lyr==2016 & idyjl==63,a=zeros(2093,1526)*NaN;end;
      %  if lyr==2016 & idyjl==23,a=zeros(2093,1526)*NaN;end;
      %  if lyr==2016 & idyjl==40,a=zeros(2093,1526)*NaN;end;
        %a=a-mur_clim(:,:,imon);
        asv(:,:,1:9)=asv(:,:,2:10);
        asv(:,:,10)=a;
        if idyjl-10<istart_dy,continue;end;
        mn=zeros(2093,1526);mnc=mn;
        for i=1:10
            tem=asv(:,:,i);
            ia=find(~isnan(tem));
            mn(ia)=mn(ia)+tem(ia);
            mnc(ia)=mnc(ia)+1;
        end;
        mn=mn./mnc;
        [iyr,idy]=day_increment(lyr,idyjl,-5)
        syr=num2str(iyr,'%4.4i');sjdy=num2str(idy,'%3.3i');
        fname=strcat('f:\data\sst\jpl_mur\10dy\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
        write_nc3(fname,mn,'sst');
        mn=zeros(2093,1526);mnc=mn;
        for i=3:7
            tem=asv(:,:,i);
            ia=find(~isnan(tem));
            mn(ia)=mn(ia)+tem(ia);
            mnc(ia)=mnc(ia)+1;
        end;
        mn=mn./mnc;
        [iyr,idy]=day_increment(lyr,idyjl,-5);
      %  if idy<115,continue;end;
        syr=num2str(iyr,'%4.4i');sjdy=num2str(idy,'%3.3i');
        fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
        write_nc3(fname,mn,'sst');
    end;
end;

%make 20 day averages
clear;
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
asv=zeros(2093,1526,20)*NaN;
for lyr=2016:2016
    clear mur_sst;
    istart_dy=180;
    for idyjl=istart_dy:dyinyr(lyr)
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>279,continue;end;
     %   if idyjl<100,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\west_coast_sst_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]
        [a]=ncread(fname,'sst');
      %  if lyr==2016 & idyjl==63,a=zeros(2093,1526)*NaN;end;
      %  if lyr==2016 & idyjl==23,a=zeros(2093,1526)*NaN;end;
      %  if lyr==2016 & idyjl==40,a=zeros(2093,1526)*NaN;end;
        %a=a-mur_clim(:,:,imon);
        asv(:,:,1:19)=asv(:,:,2:20);
        asv(:,:,20)=a;
        if idyjl-20<istart_dy,continue;end;
        mn=zeros(2093,1526);mnc=mn;
        for i=1:20
            tem=asv(:,:,i);
            ia=find(~isnan(tem));
            mn(ia)=mn(ia)+tem(ia);
            mnc(ia)=mnc(ia)+1;
        end;
        mn=mn./mnc;
        [iyr,idy]=day_increment(lyr,idyjl,-10)
        syr=num2str(iyr,'%4.4i');sjdy=num2str(idy,'%3.3i');
        fname=strcat('f:\data\sst\jpl_mur\20dy\west_coast_sst_20dy_',syr,sjdy,'_v4.0.nc');
        write_nc3(fname,mn,'sst');
        mn=zeros(2093,1526);mnc=mn;
    end;
end;


%make monthly averages
clear;
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_5dy_2002_2012_climatology_daily_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
for lyr=2016:2016
    mn=zeros(2093,1526,12);mnc=mn;mnsq=mn;mna=zeros(2093,1526,12);mnasq=mna;mnac=mna;
    for idyjl=1:dyinyr(lyr)
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>279,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\west_coast_sst_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]
        [a]=ncread(fname,'sst');
      %  if lyr==2016 & idyjl==63,a=zeros(2093,1526)*NaN;end;
      %  if lyr==2016 & idyjl==23,a=zeros(2093,1526)*NaN;end;
      %  if lyr==2016 & idyjl==40,a=zeros(2093,1526)*NaN;end;
        tem=a;ia=find(~isnan(tem));
        m1=mn(:,:,imon);m1sq=mnsq(:,:,imon);m1c=mnc(:,:,imon);
        m1(ia)=m1(ia)+tem(ia);
        m1sq(ia)=m1sq(ia)+tem(ia).^2;
        m1c(ia)=m1c(ia)+1;
        mn(:,:,imon)=m1;mnsq(:,:,imon)=m1sq;mnc(:,:,imon)=m1c;
        idy2=idyjl;if idyjl==366,idy2=365;end;
        tem=a-mur_clim(:,:,idy2);m1sq=mnasq(:,:,imon);ia=find(~isnan(tem));
        m1=mna(:,:,imon);m1c=mnac(:,:,imon);
        m1(ia)=m1(ia)+tem(ia);
        m1sq(ia)=m1sq(ia)+tem(ia).^2;
        m1c(ia)=m1c(ia)+1;
        mna(:,:,imon)=m1;mnasq(:,:,imon)=m1sq;mnac(:,:,imon)=m1c;
    end;
    mn=mn./mnc;
    mnsq=mnsq./mnc;
    mnstd=sqrt(mnsq-mn.^2);
    mna=mna./mnac;
    mnasq=mnasq./mnac;
    mnastd=sqrt(mnasq-mna.^2);
    syr=num2str(lyr,'%4.4i');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_monthly_',syr,'_v4.0.nc');
    write_nc3(fname,mn,'sst',mnsq,'sst_sq',mnstd,'sst_std');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_anomaly_monthly_',syr,'_v4.0.nc');
    write_nc3(fname,mna,'sst',mnasq,'sst_sq',mnastd,'sst_std');
end;
 
%make 3monthly averages
clear;
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_5dy_2002_2012_climatology_daily_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
for lyr=2002:2016
    syr=num2str(lyr,'%4.4i');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_monthly_',syr,'_v4.0.nc');
    write_nc3(fname,mn,'sst');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_anomaly_monthly_',syr,'_v4.0.nc');
    write_nc3(fname,mna,'sst');
    mn=zeros(2093,1526,12);mnc=mn;mna=zeros(2093,1526,12);mnac=mna;
    for idyjl=1:dyinyr(lyr)
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>279,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\west_coast_sst_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]
        [a]=ncread(fname,'sst');
%        if lyr==2016 & idyjl==63,a=zeros(2093,1526)*NaN;end;
%        if lyr==2016 & idyjl==23,a=zeros(2093,1526)*NaN;end;
%        if lyr==2016 & idyjl==40,a=zeros(2093,1526)*NaN;end;
        tem=a;ia=find(~isnan(tem));
        m1=mn(:,:,imon);m1c=mnc(:,:,imon);
        m1(ia)=m1(ia)+tem(ia);
        m1c(ia)=m1c(ia)+1;
        mn(:,:,imon)=m1;mnc(:,:,imon)=m1c;
        idy2=idyjl;if idyjl==366,idy2=365;end;
        tem=a-mur_clim(:,:,idy2);ia=find(~isnan(tem));
        m1=mna(:,:,imon);m1c=mnac(:,:,imon);
        m1(ia)=m1(ia)+tem(ia);
        m1c(ia)=m1c(ia)+1;
        mna(:,:,imon)=m1;mnac(:,:,imon)=m1c;
    end;
    mn=mn./mnc;
    mna=mna./mnac;
    syr=num2str(lyr,'%4.4i');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_monthly_',syr,'_v4.0.nc');
    write_nc3(fname,mn,'sst');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_anomaly_monthly_',syr,'_v4.0.nc');
    write_nc3(fname,mna,'sst');
end;


%make climatology 10 dy
clear;
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
mur_clim=zeros(2093,1526,365);mur_climc=zeros(2093,1526,365);
for lyr=2002:2012
    clear mur_sst;
    for idyjl=1:365
        if lyr==2002 & idyjl<152,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\10dy\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]
        [a]=ncread(fname,'sst');
        tem=mur_clim(:,:,idyjl);
        temc=mur_climc(:,:,idyjl);
        ia=find(~isnan(a));
        tem(ia)=tem(ia)+a(ia);
        temc(ia)=temc(ia)+1;
        mur_clim(:,:,idyjl)=tem;
        mur_climc(:,:,idyjl)=temc;
    end;
end;
mur_clim=mur_clim./mur_climc;
fname=strcat('f:\data\sst\jpl_mur\10dy\west_coast_sst_10dy_2002_2012_climatology_daily_v4.0.nc');
write_nc3(fname,mur_clim,'mur_clim');

%make climatology 20 dy
clear;
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
mur_clim=zeros(2093,1526,365);mur_climc=zeros(2093,1526,365);
for lyr=2002:2012
    clear mur_sst;
    for idyjl=1:365
        if lyr==2002 & idyjl<152,continue;end;
   %     if lyr==2016 & idyjl>117,continue;end;
   %     if lyr==2016 & idyjl==63,continue;end;
   %     if lyr==2016 & idyjl==23,continue;end;
   %     if lyr==2016 & idyjl==40,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_20dy_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]
        [a]=ncread(fname,'sst');
        tem=mur_clim(:,:,idyjl);
        temc=mur_climc(:,:,idyjl);
        ia=find(~isnan(a));
        tem(ia)=tem(ia)+a(ia);
        temc(ia)=temc(ia)+1;
        mur_clim(:,:,idyjl)=tem;
        mur_climc(:,:,idyjl)=temc;
    end;
end;
mur_clim=mur_clim./mur_climc;
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_20dy_2002_2012_climatology_daily_v4.0.nc');
write_nc3(fname,mur_clim,'mur_clim');

%make climatology 5dy
clear;
%fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
%[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
mur_clim=zeros(2093,1526,365);mur_clim_sq=zeros(2093,1526,365);mur_climc=zeros(2093,1526,365);
for lyr=2002:2012
    clear mur_sst;
    for idyjl=1:365
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>194,continue;end;
   %     if lyr==2016 & idyjl==63,continue;end;
   %     if lyr==2016 & idyjl==23,continue;end;
   %     if lyr==2016 & idyjl==40,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]
        [a]=ncread(fname,'sst');
        tem=mur_clim(:,:,idyjl);
        temsq=mur_clim_sq(:,:,idyjl);
        temc=mur_climc(:,:,idyjl);
        ia=find(~isnan(a));
        tem(ia)=tem(ia)+a(ia);
        temsq(ia)=temsq(ia)+a(ia).^2;
        temc(ia)=temc(ia)+1;
        mur_clim(:,:,idyjl)=tem;
        mur_clim_sq(:,:,idyjl)=temsq;
        mur_climc(:,:,idyjl)=temc;
    end;
end;
mur_clim=mur_clim./mur_climc;
mur_clim_sq=mur_clim_sq./mur_climc;
mur_clim_std=sqrt(mur_clim_sq-mur_clim.^2);
fname=strcat('f:\data\sst\jpl_mur\5dy\west_coast_sst_5dy_2002_2012_climatology_daily_v4.0.nc');
write_nc3(fname,mur_clim,'mur_clim',mur_clim_sq,'mur_clim_sq',mur_clim_std,'mur_clim_std',mur_climc,'mur_clim_cnt');

%make climatology 5dy monthly
clear;
mur_clim=zeros(2093,1526,12);mur_clim_sq=zeros(2093,1526,12);mur_climc=zeros(2093,1526,12);
for lyr=2002:2012
    clear mur_sst;
    for idyjl=1:365
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>194,continue;end;
   %     if lyr==2016 & idyjl==63,continue;end;
   %     if lyr==2016 & idyjl==23,continue;end;
   %     if lyr==2016 & idyjl==40,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]
        [a]=ncread(fname,'sst');
        tem=mur_clim(:,:,imon);
        temsq=mur_clim_sq(:,:,imon);
        temc=mur_climc(:,:,imon);
        ia=find(~isnan(a));
        tem(ia)=tem(ia)+a(ia);
        temsq(ia)=temsq(ia)+a(ia).^2;
        temc(ia)=temc(ia)+1;
        mur_clim(:,:,imon)=tem;
        mur_clim_sq(:,:,imon)=temsq;
        mur_climc(:,:,imon)=temc;
    end;
end;
mur_clim=mur_clim./mur_climc;
mur_clim_sq=mur_clim_sq./mur_climc;
mur_clim_std=sqrt(mur_clim_sq-mur_clim.^2);
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_monthly_2002_2012_climatology_daily_v4.0.nc');
write_nc3(fname,mur_clim,'mur_clim',mur_clim_sq,'mur_clim_sq',mur_clim_std,'mur_clim_std',mur_climc,'mur_clim_cnt');

%make hov
clear;lyr=2015;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
[a]=ncread(fname,'sst');
icoast=ones(size(a,2),1)*2093;for j=1:size(a,2),for i=1:size(a,1),if isnan(a(i,j)),icoast(j)=i;break;end;end;end; 
icoast(529)=icoast(528); %fix up point in sf bay
icoast(1148)=icoast(1147); %fix up point in yakwina bay
icoast(1295:1297)=icoast(1294); %fix up point in columbia
icoast(1333:1338)=icoast(1332); %fix up point in columbia
icoast(1357)=icoast(1356); %fix up point in in columbia
icoast(1492:1509)=icoast(1491); %fix up point in p.sound
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
G.lat = ncread(url_sst,'lat',[11107],[1526]);
G.lon = ncread(url_sst,'lon',[3642],[2093]);
clear icoast_lat icoast_lon;
for j=1:size(a,2)
    icoast_lat((size(a,1)-icoast(j)+1):size(a,1),j)=G.lat(j);
    icoast_lon((size(a,1)-icoast(j)+1):size(a,1),j)=G.lon(1:icoast(j));
end;
clf;imagesc(a');hold on;for j=1:size(a,2),plot(icoast(j),j,'w.');end;

clear;
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_icoast.nc');
[icoast]=ncread(fname,'icoast');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_icoast_lon.nc');
[icoast_lon]=ncread(fname,'icoast_lon');
[icoast_lat]=ncread(fname,'icoast_lat');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_2002_2012_climatology_daily_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
for ianom=1:2
    for lyr=2002:2016
        mur_hova=zeros(2093,1526,365)*NaN;ic=0;clear xx xx2 xx3;
        for idyjl=1:365
            ic=ic+1;
            xx(ic)=lyr;xx2(ic)=idyjl;xx3(ic)=lyr+(idyjl-1)/365;
            if lyr==2002 & idyjl<152,continue;end;
            if lyr==2016 & idyjl>194,break;end;
            %if lyr==2016 & idyjl==63,continue;end;
            %if lyr==2016 & idyjl==23,continue;end;
            %if lyr==2016 && idyjl==40,continue;end;
            %if lyr==2016 & idyjl>116,break;end;
            [imon,idym]=jul2dy(lyr,idyjl);
            syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
            fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
            if ~exist(fname),continue;end;
            [lyr idyjl]
            [a]=ncread(fname,'sst');
            for j=1:size(a,2)
                if ianom==1,mur_hova((size(a,1)-icoast(j)+1):size(a,1),j,ic)=a(1:icoast(j),j)-273.15;end;
                if ianom==2,mur_hova((size(a,1)-icoast(j)+1):size(a,1),j,ic)=a(1:icoast(j),j)-mur_clim(1:icoast(j),j,idyjl);end;
            end;
        end;
        if ianom==1,fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_sst_hovmul_',syr,'.nc');write_nc3(fname,mur_hova,'mur_sst',xx,'xx',xx2,'xx2',xx3,'xx3');end;
        if ianom==2,fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_',syr,'.nc');write_nc3(fname,mur_hova,'mur_anom',xx,'xx',xx2,'xx2',xx3,'xx3');end;
    end;
end;


%make yearly files at specific location hovmuller
clear;
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_icoast.nc');
[icoast]=ncread(fname,'icoast');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_icoast_lon.nc');
[icoast_lon]=ncread(fname,'icoast_lon');
[icoast_lat]=ncread(fname,'icoast_lat');
colormap(r6);cc=colormap;
xlatsv=[33 36 39 42 45 48];ic=0;
for ianom=1:2
    for lyr=2002:2016
        [lyr]
        syr=num2str(lyr,'%4.4i');
        if ianom==1,fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_sst_hovmul_',syr,'.nc');[mur_hova]=ncread(fname,'mur_sst');end;
        if ianom==2,fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_',syr,'.nc');[mur_hova]=ncread(fname,'mur_anom');end;
        [xx3]=ncread(fname,'xx3');
        ilen=size(xx3,2);
        for ii=1:ilen
            ic=ic+1;
            for i=1:length(xlatsv)
                [~,j]=min(abs(icoast_lat(2093,:)-xlatsv(i)));
                ia=find(icoast_lon(:,j)~=0);
                hov_sv(1:length(ia),ic,i)=squeeze(mur_hova(ia,j,ii));
                hov_sv(length(ia)+1:2069,ic,i)=NaN;
                hov_y(ic)=xx3(ii);
                hov_x(1:length(ia),i)=squeeze(icoast_lon(ia,j));
            end;
        end;
    end;
    if ianom==1,
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_sst_hovmul_5lat_',syr,'.nc');
        write_nc3(fname,hov_sv,'sst_anom');
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_sst_hovmul_5latx_',syr,'.nc');
        write_nc3(fname,hov_x,'xx');
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_sst_hovmul_5laty_',syr,'.nc');
        write_nc3(fname,hov_y,'yy');
    end;
    if ianom==2,
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5lat_',syr,'.nc');
        write_nc3(fname,hov_sv,'sst_anom');
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5latx_',syr,'.nc');
        write_nc3(fname,hov_x,'xx');
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5laty_',syr,'.nc');
        write_nc3(fname,hov_y,'yy');
    end;
end;


clf;ia=find(hov_y>0);plot(hov_y(ia),hov_sv(1,ia,1));hold on;plot(hov_y(ia),hov_sv(2068,ia,1));;axis([2002.5 2016.5 -4 4])


%map 2002.5 - present
syr='2016';
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5lat_',syr,'.nc');
[hov_sv]=ncread(fname,'sst_anom');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5latx_',syr,'.nc');
[hov_x]=ncread(fname,'xx');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5laty_',syr,'.nc');
[hov_y]=ncread(fname,'yy');
%close('all');figure(10);colormap(r6);cc=colormap;
close('all');figure(10);colormap(anom_color);cc=colormap;
xlatsv=[33 36 39 42 45 48];rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
alet={'A)','B)','C)','D)','E)','F)'};
for i=1:length(xlatsv)
    ia=find(hov_x(:,i)~=0);
    tem=squeeze(hov_sv(ia,:,i));
    tem(find(tem>rmax))=rmax;
    subplot(1,6,i),imagesc(hov_x(ia,i),hov_y,tem',[rmin rmax+dx*3]);
    title(strcat(alet{i},num2str(xlatsv(i),'%2.2i'),'N'));
    set(gca,'ytick',[2003:2016]);
    if i>1,set(gca,'yticklabel',{});end;
    set(gca,'xtick',[-140 -135 -130 -125]);
    set(gca,'xticklabel',{'';'135W';'';'125W'});
    set(gca,'ytick',[]);
    pp=get(gca,'position');set(gca,'position',[pp(1:2) pp(3)*1.1 pp(4)]);
    axis([min(hov_x(ia,i)) max(hov_x(ia,i)) 2002.5 max(hov_y) ])
end;
orient tall;
ch=colorbar_thin2hxy(-.31,-0.10);ctitle('\DeltaSST (K)');
cp=get(ch,'position');set(ch,'position',[cp(1)-.05 cp(2) .2 .01])
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\hov_5dy_sst.jpg');print('-f10','-djpeg',char(fname));
%close('all');figure(10);colormap(r6);cc=colormap;
close('all');figure(10);colormap(anom_color);cc=colormap;
xlatsv=[33 36 39 42 45 48];rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
alet={'A)','B)','C)','D)','E)','F)'};
for i=1:length(xlatsv)
    ia=find(hov_x(:,i)~=0);
    tem=squeeze(hov_sv(ia,:,i));
    tem(find(tem>rmax))=rmax;
    subplot(1,6,i),imagesc(hov_x(ia,i),hov_y,tem',[rmin rmax+dx*3]);
    title(strcat(alet{i},num2str(xlatsv(i),'%2.2i'),'N'));
    set(gca,'ytick',[2003:.25:2016]);
    if i>1,set(gca,'yticklabel',{});end;
    set(gca,'xtick',[-140 -135 -130 -125]);
    set(gca,'xticklabel',{'';'135W';'';'125W'});
    pp=get(gca,'position');set(gca,'position',[pp(1:2) pp(3)*1.1 pp(4)]);
    axis([min(hov_x(ia,i)) max(hov_x(ia,i)) 2013 max(hov_y) ])
end;
orient tall;
ch=colorbar_thin2hxy(-.31,-0.10);ctitle('\DeltaSST (K)');
cp=get(ch,'position');set(ch,'position',[cp(1)-.05 cp(2) .2 .01])
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\hov_5dy_2013sst.jpg');print('-f10','-djpeg',char(fname));
close('all');figure(10);colormap(anom_color);cc=colormap;
xlatsv=[33 42 48];rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
alet={'A)','B)','C)','D)','E)','F)'};
for i=1:3 %length(xlatsv)
    ia=find(hov_x(:,i)~=0);
    tem=squeeze(hov_sv(ia,:,i));
    tem(find(tem>rmax))=rmax;
    subplot(2,6,i),imagesc(hov_x(ia,i),hov_y,tem',[rmin rmax+dx*3]);
    title(strcat(alet{i},num2str(xlatsv(i),'%2.2i'),'N'));
    set(gca,'ytick',[2003:2016]);
    if i>1,set(gca,'yticklabel',{});end;
    set(gca,'xtick',[-140 -135 -130 -125]);
    set(gca,'xticklabel',{'';'135W';'';'125W'});
    pp=get(gca,'position');set(gca,'position',[pp(1:2) pp(3)*1.1 pp(4)]);
    axis([min(hov_x(ia,i)) max(hov_x(ia,i)) 2013 max(hov_y) ])
end;
orient tall;
ch=colorbar_thin2hxy(-.31,-0.10);ctitle('\DeltaSST (K)');
cp=get(ch,'position');set(ch,'position',[cp(1)+.14 cp(2)-.04 .2 .01])
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\hov_5dy_2013sstA.jpg');print('-f10','-djpeg',char(fname));

%map 2002.5 - present SMOOTHED 30 days need to look inot NaN
syr='2016';
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5lat_',syr,'.nc');
[hov_sv]=ncread(fname,'sst_anom');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5latx_',syr,'.nc');
[hov_x]=ncread(fname,'xx');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_anom_hovmul_5laty_',syr,'.nc');
[hov_y]=ncread(fname,'yy');
%smooth +-30 days
mn=zeros(size(hov_sv));mnc=mn;
mn2=zeros(size(hov_sv,1),365,size(hov_sv,3));mn2c=mn2; %clim hov
for i=1:size(hov_sv,2)
    for ii=i-30:i+30
        if ii<1 | ii>size(hov_sv,2),continue;end;
        for j=1:size(hov_sv,1)
            for k=1:size(hov_sv,3)
                mn(j,i,k)=mn(j,i,k)+hov_sv(j,ii,k);
                mnc(j,i,k)=mnc(j,i,k)+1;
            end;
        end;
    end;
end;
mn=mn./mnc;
for i=1:size(hov_sv,2)
        for j=1:size(hov_sv,1)
            for k=1:size(hov_sv,3)
                lyr=floor(hov_y(i));
                ii=round((hov_y(i)-lyr)*365+1);
                if lyr>2012,continue;end;
                mn2(j,ii,k)=mn2(j,ii,k)+hov_sv(j,i,k);
                mn2c(j,ii,k)=mn2c(j,ii,k)+1;
            end;
        end;
end;
mn2=mn2./mn2c;
hov_sv=mn;
%close('all');figure(10);colormap(r6);cc=colormap;
close('all');figure(10);colormap(anom_color);cc=colormap;
xlatsv=[33 36 39 42 45 48];rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
incr=[-3+dx/2:dx:3-dx/2];ia=find(abs(incr)<.5);for i=1:length(ia),cc(ia(i),:)=[1 1 1];end;colormap(cc);
alet={'A)','B)','C)','D)','E)','F)'};
for i=1:length(xlatsv)
    ia=find(hov_x(:,i)~=0);
    tem=squeeze(hov_sv(ia,:,i));
    tem(find(tem>rmax))=rmax;
    subplot(1,6,i),imagesc(hov_x(ia,i),hov_y,tem',[rmin rmax+dx*3]);
    title(strcat(alet{i},num2str(xlatsv(i),'%2.2i'),'N'));
    set(gca,'ytick',[2003:2016]);
    if i>1,set(gca,'yticklabel',{});end;
    set(gca,'xtick',[-140 -135 -130 -125]);
    set(gca,'xticklabel',{'';'135W';'';'125W'});
    set(gca,'ytick',[]);
    pp=get(gca,'position');set(gca,'position',[pp(1:2) pp(3)*1.1 pp(4)]);
    axis([min(hov_x(ia,i)) max(hov_x(ia,i)) 2002.5 max(hov_y) ])
end;
orient tall;
ch=colorbar_thin2hxy(-.31,-0.10);ctitle('\DeltaSST (K)');
cp=get(ch,'position');set(ch,'position',[cp(1)-.17 cp(2) .4 .01])
set(ch,'Ticks',[-2.5:.5:2.5]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\hov_5dy_sst_smoothed.jpg');print('-f10','-djpeg',char(fname));
%close('all');figure(10);colormap(r6);cc=colormap;
close('all');figure(10);colormap(anom_color);cc=colormap;
xlatsv=[33 36 39 42 45 48];rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
incr=[-3+dx/2:dx:3-dx/2];ia=find(abs(incr)<.5);for i=1:length(ia),cc(ia(i),:)=[1 1 1];end;colormap(cc);
alet={'A)','B)','C)','D)','E)','F)'};
for i=1:length(xlatsv)
    ia=find(hov_x(:,i)~=0);
    tem=squeeze(hov_sv(ia,:,i));
    tem(find(tem>rmax))=rmax;
    subplot(1,6,i),imagesc(hov_x(ia,i),hov_y,tem',[rmin rmax+dx*3]);
    title(strcat(alet{i},num2str(xlatsv(i),'%2.2i'),'N'));
    set(gca,'ytick',[2003:.25:2016]);
    if i>1,set(gca,'yticklabel',{});end;
    set(gca,'xtick',[-140 -135 -130 -125]);
    set(gca,'xticklabel',{'';'135W';'';'125W'});
    pp=get(gca,'position');set(gca,'position',[pp(1:2) pp(3)*1.1 pp(4)]);
    axis([min(hov_x(ia,i)) max(hov_x(ia,i)) 2013 max(hov_y) ])
end;
orient tall;
ch=colorbar_thin2hxy(-.31,-0.10);ctitle('\DeltaSST (K)');
cp=get(ch,'position');set(ch,'position',[cp(1)-.17 cp(2) .4 .01])
set(ch,'Ticks',[-2.5:.5:2.5]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\hov_5dy_2013sst_smoothed.jpg');print('-f10','-djpeg',char(fname));

syr='2016';
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_sst_hovmul_5lat_',syr,'.nc');
[hov_sv]=ncread(fname,'sst_anom');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_sst_hovmul_5latx_',syr,'.nc');
[hov_x]=ncread(fname,'xx');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_sst_hovmul_5laty_',syr,'.nc');
[hov_y]=ncread(fname,'yy');
mn2=zeros(size(hov_sv,1),365,size(hov_sv,3));mn2c=mn2; %clim hov
for i=1:size(hov_sv,2)
        for j=1:size(hov_sv,1)
            for k=1:size(hov_sv,3)
                lyr=floor(hov_y(i));
                ii=round((hov_y(i)-lyr)*365+1);
                if lyr<2002 & idyjl<152,continue;end;
                if lyr>2012,continue;end;
                if hov_sv(j,i,k)==0,continue;end;
                mn2(j,ii,k)=mn2(j,ii,k)+hov_sv(j,i,k);
                mn2c(j,ii,k)=mn2c(j,ii,k)+1;
            end;
        end;
end;
mn2=mn2./mn2c;
%climatology
close('all');figure(10);colormap(anom_color);cc=colormap;
xlatsv=[33 36 39 42 45 48];rmax=18;rmin=6;dx=(rmax-rmin)/(length(cc)-2);
incr=[rmin+dx/2:dx:rmax-dx/2];ia=find(abs(incr)<.05);for i=1:length(ia),cc(ia(i),:)=[1 1 1];end;colormap(cc);
alet={'A)','B)','C)','D)','E)','F)'};
for i=1:length(xlatsv)
    ia=find(hov_x(:,i)~=0);
    tem=squeeze(mn2(ia,:,i));
    tem(find(tem>rmax))=rmax;
    subplot(1,6,i),imagesc(hov_x(ia,i),[1:365],tem',[rmin rmax+dx*3]);
    title(strcat(alet{i},num2str(xlatsv(i),'%2.2i'),'N'));
    set(gca,'ytick',[1:25:365]);
    if i>1,set(gca,'yticklabel',{});end;
    set(gca,'xtick',[-140 -135 -130 -125]);
    set(gca,'xticklabel',{'';'135W';'';'125W'});
    pp=get(gca,'position');set(gca,'position',[pp(1:2) pp(3)*1.1 pp(4)]);
    axis([min(hov_x(ia,i)) max(hov_x(ia,i)) 1 365 ])
end;
orient tall;
ch=colorbar_thin2hxy(-.31,-0.10);ctitle('\DeltaSST (K)');
cp=get(ch,'position');set(ch,'position',[cp(1)-.17 cp(2) .4 .01])
set(ch,'Ticks',[6:4:18]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\hov_5dy_2013sst_clim.jpg');print('-f10','-djpeg',char(fname));
%climatology
close('all');figure(10);colormap(anom_color);cc=colormap;
xlatsv=[33 36 39 42 45 48];rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
incr=[rmin+dx/2:dx:rmax-dx/2];ia=find(abs(incr)<.05);for i=1:length(ia),cc(ia(i),:)=[1 1 1];end;colormap(cc);
alet={'A)','B)','C)','D)','E)','F)'};
for i=1:length(xlatsv)
    ia=find(hov_x(:,i)~=0);
    tem=squeeze(mn2(ia,:,i));
    tmn=mean(squeeze(mn2(1:300,:,i)),1);
    for j=1:size(tem,1),tem(j,:)=tem(j,:)-tmn;end;
    tem(find(tem>rmax))=rmax;
    subplot(1,6,i),imagesc(hov_x(ia,i),[1:365],tem',[rmin rmax+dx*3]);
    title(strcat(alet{i},num2str(xlatsv(i),'%2.2i'),'N'));
    set(gca,'ytick',[1:25:365]);
    if i>1,set(gca,'yticklabel',{});end;
    set(gca,'xtick',[-140 -135 -130 -125]);
    set(gca,'xticklabel',{'';'135W';'';'125W'});
    pp=get(gca,'position');set(gca,'position',[pp(1:2) pp(3)*1.1 pp(4)]);
    axis([min(hov_x(ia,i)) max(hov_x(ia,i)) 1 365 ])
end;
orient tall;
ch=colorbar_thin2hxy(-.31,-0.10);ctitle('\DeltaSST (K)');
cp=get(ch,'position');set(ch,'position',[cp(1)-.17 cp(2) .4 .01])
set(ch,'Ticks',[6:4:18]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\hov_5dy_2013sst_clim_minusoffshore.jpg');print('-f10','-djpeg',char(fname));




colormap(r6);cc=colormap;
xlatsv=[33 36 39 42 45];rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
for i=1:length(xlatsv)
    [~,j]=min(abs(icoast_lat(2093,:)-xlatsv(i)));
    ia=find(icoast_lon(:,j)~=0);
    tem=squeeze(mur_hova(ia,j,:));
    tem(find(tem>rmax))=rmax;
    subplot(1,5,i),imagesc(icoast_lon(ia,j),xx3,tem',[rmin rmax+dx*3]);
    title(strcat(num2str(xlatsv(i),'%2.2i'),'N'));
    if i>1,set(gca,'yticklabel',{});end;
    pp=get(gca,'position');set(gca,'position',[pp(1:2) pp(3)*1.1 pp(4)]);
end;
orient tall;
colorbar_thin2hxy(-.31,-0.10);ctitle('\DeltaSST (K)');
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\hov_5dy_sst.jpg');print('-f10','-djpeg',char(fname));

%calculate phase speed
xlatsv=[33 36 39 42 45];rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
for i=1:length(xlatsv)
    [~,j]=min(abs(icoast_lat(2093,:)-xlatsv(i)));
    ia=find(icoast_lon(:,j)~=0);
    tem=squeeze(mur_hova(ia,j,:));
    tem(find(tem>rmax))=rmax;
    x1=icoast_lon(ia,j)*111*cosd(xlatsv(i));
    x2=xx3;
    figure(i);clf;colormap(r6);imagesc(x1,x2,tem',[rmin rmax+dx*3]);
    x1a=min(round(x1/100)*100);
    x1b=max(round(x1/100)*100);
    set(gca,'xtick',[x1a:100:x1b]);
end;


figure(1);colormap(r6),imagesc(mur_max',[0 6.1]);figure(2);colormap(r6),imagesc(mur_date',[2002 2016]);figure(3);colormap(r6),imagesc(mur_date2',[1 365]);
ii=1400;jj=1100;[u,uu]=jul2dy(mur_date(ii,jj),mur_date2(ii,jj))


%10day stuff
clear;
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_10dy_2002_2012_climatology_daily_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
%calculate max and date of max
mur_max=zeros(2093,1526);mur_date=zeros(2093,1526);mur_date2=zeros(2093,1526);
mn=zeros(6000);mnc=mn;xx=mn;xx2=mn;ic=0;
mn_mon=zeros(200);mnc_mon=mn_mon;xx_mon=mn_mon;xx2_mon=mn_mon;ic2=0;
for lyr=2002:2016
    clear mur_sst;
    for idyjl=1:365
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>117,continue;end;
        if lyr==2016 & idyjl==63,continue;end;
        if lyr==2016 & idyjl==23,continue;end;
        if lyr==2016 & idyjl==40,continue;end;
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
        if ~exist(fname),continue;end;
        [lyr idyjl]        
        [a]=ncread(fname,'sst');
        a=a-mur_clim(:,:,idyjl);
        ia=find(~isnan(a) & a>mur_max);
        mur_max(ia)=a(ia);
        mur_date(ia)=lyr;
        mur_date2(ia)=idyjl;
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
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_max_10dy.nc');
write_nc3(fname,mur_max,'max',mur_date,'lyr',mur_date2,'month');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_mean_v4.0_10dy.nc');
write_nc3(fname,mn,'mn',mnc,'cnt',xx,'lyr',xx2,'month');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_mean_mon_v4.0_10dy.nc');
write_nc3(fname,mn_mon,'mn',mnc_mon,'cnt',xx_mon,'lyr',xx2_mon,'month');

url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
G.lat = ncread(url_sst,'lat',[11107],[1526]);
G.lon = ncread(url_sst,'lon',[3642],[2093]);
ilnd=find(isnan(mur_max));
clf;colormap(r12a);rmax=5;rmin=.5;dx=(rmax-rmin)/200;colormap(r6);cc=colormap;
tem=mur_max;tem(find(tem>rmax))=rmax;tem(ilnd)=rmax+dx;tem(find(isnan(tem)))=rmax+dx*2;
imagesc(G.lon,G.lat,tem',[rmin rmax+dx*3]);
colorbar_thin2xy(0,0);ctitle('SST (K)');

%make figure for bill proposal, daily images
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\color_maps');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\graphics\');
load('f:\data\topo\bath.mat','b200_lon','b200_lat','b1000_lon','b1000_lat');
for lyr=2002:2015
    clear mur_sst;
    [idyjl]=dy2jul(lyr,7,28);
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
    lat = ncread(url_sst,'lat',[11107],[1526 ]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    clf;subplot(2,3,1),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-132 -127 25.5 31])
    title(strcat('July 28,',syr));push_panel(0,.02);
    colorbar_thin2hxy(0,-0.16);ctitle('SST (\circC)')
    fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\ECO_forecasting\images\CAupwell',syr,'.jpg');
    print('-f','-djpeg99',fname);
end;

iyr=[2011 2014 2015];clf;
for i=1:3
    lyr=iyr(i);
    clear mur_sst;
    [idyjl]=dy2jul(lyr,7,28);
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
    lat = ncread(url_sst,'lat',[11107],[1526 ]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    subplot(2,3,i),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;axis([-132 -127 25.5 31])
    title(strcat('July 28,',syr));push_panel(0,.02);
    if i==2,hh=colorbar_thin2hxy(0,-0.16);ctitle('SST (\circC)');hp=get(hh,'position');set(hh,'position',[.41 hp(2) hp(3)*2.6 hp(4)]);end;
end;
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\ECO_forecasting\images\CAupwell_panel.jpg');
print('-f','-djpeg99',fname);

    url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
    a = ncread(url_sst,'analysed_sst',[3642 9000 1],[2093 8999 1]);
    lat = ncread(url_sst,'lat',[9000],[8999]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);



clf;jj=1;close('all');colormap(r6);
for lyr=2003:2015
    clear mur_sst;
    [idyjl]=dy2jul(lyr,7,26);
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    %url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    %a1 = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    jj=jj+1;
    if jj==6,jj=jj+1;end;
    subplot(3,5,jj),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-127.27 -121.778 36.88 42.93]);
%    subplot(3,5,jj),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-132 -127 25.5 31]);
    hold on;[c,h]=contour(lon,lat,tem',[13 13],'k');
    gt=text(-123.9750,42.3798,strcat(syr));set(gt,'fontweight','bold','fontsize',8);
    xup=-0.0251;yup=0.07;
    if floor(jj/5)*5+2==jj,push_panel(xup,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+3==jj,push_panel(xup*2,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+4==jj,push_panel(xup*3,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+0==jj,push_panel(xup*4,0);set(gca,'ytick',[]);end;
    if lyr>2006,push_panel(0,yup);end;
    if lyr>2010,push_panel(0,yup);end;   
   % if lyr~=2003 & lyr~=2007 & lyr~=2011,set(gca,'ytick',[]);end;
    if lyr<2011,set(gca,'xtick',[]);end;
    if lyr==2007,svpp=get(gca,'position');end;
    if lyr==2011,svpp2=get(gca,'position');end;
    if lyr==2014,hh=colorbar_thin2hxy(0,-0.16);ctitle('SST (\circC)');hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);end;
end;
H=axes('position',[svpp2(1) svpp(2) svpp(3) svpp(4)*2+.01]);
lyr=2002;  [idyjl]=dy2jul(lyr,7,26);
[lyr idyjl]
[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
[a]=ncread(fname,'sst');
tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-127.27 -121.778 36.88 42.93]);
hold on;[c,h]=contour(lon,lat,tem',[13 13],'k');
gt=text(-123.9750,42.3798,strcat(syr));set(gt,'fontweight','bold','fontsize',8);
set(gca,'xtick',[]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\ECO_forecasting\images\CAupwell_panel_sf_to_or_border.jpg');
print('-f','-djpeg99',fname);


figure(10); ax = usamap('all');
set(ax, 'Visible', 'off')
states = shaperead('usastatelo', 'UseGeoCoords', true);close(10);
plot(states(5).Lon,states(5).Lat,'k')
plot(states(37).Lon,states(37).Lat,'k')
plot(states(47).Lon,states(47).Lat,'k')

%bigger 2002
figure(1);
clf;jj=1;close('all');colormap(r6);
for lyr=2003:2015
    clear mur_sst;
    [idyjl]=dy2jul(lyr,7,26);
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    %url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    %a1 = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    jj=jj+1;
    if jj==6,jj=jj+1;end;
    subplot(3,5,jj),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-127.27 -121.778 36.88 46.25]);
%    subplot(3,5,jj),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-132 -127 25.5 31]);
    hold on;[c,h]=contour(lon,lat,tem',[13 13],'k');
    plot(states(5).Lon,states(5).Lat,'k')
    plot(states(37).Lon,states(37).Lat,'k')
    plot(states(47).Lon,states(47).Lat,'k')
    gt=text(-123.9750,45,strcat(syr));set(gt,'fontweight','bold','fontsize',8);
    xup=-0.0251;yup=0.07;
    if floor(jj/5)*5+2==jj,push_panel(xup,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+3==jj,push_panel(xup*2,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+4==jj,push_panel(xup*3,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+0==jj,push_panel(xup*4,0);set(gca,'ytick',[]);end;
    if lyr>2006,push_panel(0,yup);end;
    if lyr>2010,push_panel(0,yup);end;   
   % if lyr~=2003 & lyr~=2007 & lyr~=2011,set(gca,'ytick',[]);end;
    if lyr<2011,set(gca,'xtick',[]);end;
    if lyr==2007,svpp=get(gca,'position');end;
    if lyr==2011,svpp2=get(gca,'position');end;
    if lyr==2014,hh=colorbar_thin2hxy(0,-0.16);ctitle('SST (\circC)');hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);end;
end;
H=axes('position',[svpp2(1) svpp(2) svpp(3) svpp(4)*2+.01]);
lyr=2002;  [idyjl]=dy2jul(lyr,7,26);
[lyr idyjl]
[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
[a]=ncread(fname,'sst');
tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-127.27 -121.778 36.88 42.93]);
hold on;[c,h]=contour(lon,lat,tem',[13 13],'k');
    plot(states(5).Lon,states(5).Lat,'k')
    plot(states(37).Lon,states(37).Lat,'k')
    plot(states(47).Lon,states(47).Lat,'k')
gt=text(-123.9750,45,strcat(syr));set(gt,'fontweight','bold','fontsize',8);
set(gca,'xtick',[]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\ECO_forecasting\images\CAupwell_panel_sf_to_wash_border.jpg');
print('-f','-djpeg99',fname);
axis([-127.27 -121.778 36.88 48.75]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\ECO_forecasting\images\CAupwell_panel_sf_to_washA_border.jpg');
print('-f','-djpeg99',fname);

%same size 2002 with colorbar tucked up into image
figure(1);
clf;jj=0;close('all');colormap(r6);
for lyr=2002:2015
    clear mur_sst;
    [idyjl]=dy2jul(lyr,7,26);
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    %url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    %a1 = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    jj=jj+1;
    %if jj==6,jj=jj+1;end;
    subplot(3,5,jj),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-127.27 -121.778 36.88 46.25]);
%    subplot(3,5,jj),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-132 -127 25.5 31]);
    hold on;[c,h]=contour(lon,lat,tem',[13 13],'k');
    plot(states(5).Lon,states(5).Lat,'k')
    plot(states(37).Lon,states(37).Lat,'k')
    plot(states(47).Lon,states(47).Lat,'k')
    gt=text(-123.9750,45,strcat(syr));set(gt,'fontweight','bold','fontsize',8);
    xup=-0.0251;yup=0.07;
    if floor(jj/5)*5+2==jj,push_panel(xup,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+3==jj,push_panel(xup*2,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+4==jj,push_panel(xup*3,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+0==jj,push_panel(xup*4,0);set(gca,'ytick',[]);end;
    if jj>5,push_panel(0,yup);end;
    if jj>10,push_panel(0,yup);end;   
   % if lyr~=2003 & lyr~=2007 & lyr~=2011,set(gca,'ytick',[]);end;
    if jj<11,set(gca,'xtick',[]);end;
    if jj==7,svpp=get(gca,'position');end;
    if jj==11,svpp2=get(gca,'position');end;
    if lyr==2014,hh=colorbar_thin2hxy(0,-0.16);ctitle('SST (\circC)');hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);end;
end;
set(hh,'position',[.68 .35 .13 hp(4)*1.2]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\ECO_forecasting\images\CAupwell_panel_sf_to_washB_border.jpg');
print('-f','-djpeg99',fname);

smon3={'May';'Jun';'July';'Aug';'Sep';};
for imon_do=5:9
figure(1);
clf;jj=0;close('all');colormap(r6);
for lyr=2002:2016
    jj=jj+1;
    if imon_do==5 & lyr==2002,continue;end;
    if imon_do>5 & lyr==2016,continue;end;
    clear mur_sst;
    [idyjl]=dy2jul(lyr,imon_do,26);
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    %url_sst=strcat('http://opendap.jpl.nasa.gov/opendap/OceanTemperature/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/',syr,'/',sjdy,'/',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    %a1 = ncread(url_sst,'analysed_sst',[3642 11107 1],[2093 1526 1]);
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_10dy_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    %if jj==6,jj=jj+1;end;
    subplot(3,5,jj),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-127.27 -121.778 36.88 46.25]);
%    subplot(3,5,jj),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis([-132 -127 25.5 31]);
    hold on;[c,h]=contour(lon,lat,tem',[12 12],'k');
    plot(states(5).Lon,states(5).Lat,'k')
    plot(states(37).Lon,states(37).Lat,'k')
    plot(states(47).Lon,states(47).Lat,'k')
    gt=text(-123.9750,45,strcat(syr));set(gt,'fontweight','bold','fontsize',8);
    xup=-0.0251;yup=0.07;
    if floor(jj/5)*5+2==jj,push_panel(xup,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+3==jj,push_panel(xup*2,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+4==jj,push_panel(xup*3,0);set(gca,'ytick',[]);end;
    if floor(jj/5)*5+0==jj,push_panel(xup*4,0);set(gca,'ytick',[]);end;
    if jj>5,push_panel(0,yup);end;
    if jj>10,push_panel(0,yup);end;   
   % if lyr~=2003 & lyr~=2007 & lyr~=2011,set(gca,'ytick',[]);end;
   if jj==11,gt1=text(-126,34,'- 12\circC');set(gt,'fontweight','bold','fontsize',8);end;
   if jj<11,set(gca,'xtick',[]);end;
    if jj==7,svpp=get(gca,'position');end;
    if jj==11,svpp2=get(gca,'position');end;
    if lyr==2014,hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat(smon3{imon_do-4},' 26, SST_{10dy av} (\circC)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);end;
end;
%set(hh,'position',[.68 .35 .13 hp(4)*1.2]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\ECO_forecasting\images\CAupwell_panel_sf_to_washB_border_',smon3{imon_do-4},'.jpg');
print('-f','-djpeg99',fname);
end;




%make figure for proposal
fname='\\Gentemann-bigpc\f\\data\ccmp_winds\v02.0\Y2008\M04\CCMP_Wind_Analysis_20080406_V02.0_L3.0_RSS.nc'
[xlat]=ncread(fname,'latitude');
[xlon]=ncread(fname,'longitude');
lyr=2014
idyjl=255;
[lyr idyjl]
[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
lat = ncread(url_sst,'lat',[11107],[1526]);
lon = ncread(url_sst,'lon',[3642 ],[2093]);

%individual
titmon={'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};
for idyjl=100:10:255
    clf;jj=0;%colormap(r6);
    lyr=2014
    %[idyjl]=dy2jul(lyr,6,26);
    clf;colormap(anom_color);    
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=max(max(tem))-2;;rmin=min(min(tem))+2;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    %if jj==6,jj=jj+1;end;
    imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;[c,h]=contour(lon,lat,tem',[rmin:2:rmax],'k');
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2)
    gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat(smon,'/',sdym,'/',syr,':SST_{5dy av} (\circC)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[.23 .12 .49 .03]);
    fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\PO_upwell\images\sst',sjdy,'.jpg');
    print('-f','-djpeg99',fname);
    
    fname=strcat('f:\data\ccmp_winds\v02.0\daily_nc\map\',syr,'\ccmp_daily_ave_map_',syr,sjdy,'.nc'); %
    if exist(fname),
        [av_curl]=ncread(fname,'av_curl');
        [av_stress_u]=ncread(fname,'av_stress_u');
        [av_stress_v]=ncread(fname,'av_stress_v');
    end;
    clf;colormap(anom_color);
    tem=av_stress_v;rmax=max(max(tem))/8;;rmin=-rmax;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    imagesc(xlon-360,xlat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2);
    [c,h]=contour(xlon-360,xlat,tem',[-.1:.1:.1],'k');
    gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat(smon,'/',sdym,'/',syr,': \tau_{y} (Nm^{-2})'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[.23 .12 .49 .03]);
    fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\PO_upwell\images\stressv',sjdy,'.jpg');
    print('-f','-djpeg99',fname);
    
    clf;colormap(anom_color);
    tem=av_curl;rmax=max(max(tem))/30;;rmin=-rmax;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=20;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    imagesc(xlon-360,xlat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2);
    [c,h]=contour(xlon-360,xlat,tem',[-.1:.1:.1],'k');
    gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat(smon,'/',sdym,'/',syr,': Curl (Nm^{-3})'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[.23 .12 .49 .03]);
    fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\PO_upwell\images\curl',sjdy,'.jpg');
    print('-f','-djpeg99',fname);

        clf;jj=0;%colormap(r6);
    lyr=2014
    %[idyjl]=dy2jul(lyr,6,26);
    clf;colormap(anom_color);    
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=max(max(tem))-2;;rmin=min(min(tem))+2;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    %if jj==6,jj=jj+1;end;
    subplot(1,3,1),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;[c,h]=contour(lon,lat,tem',[rmin:2:rmax],'k');
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2)
    %gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
%    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat(smon,'/',sdym,'/',syr,':SST_{5dy av} (\circC)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('SST_{5dy av} (\circC)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[.13 .35 .19 .03]);
    
    fname=strcat('f:\data\ccmp_winds\v02.0\daily_nc\map\',syr,'\ccmp_daily_ave_map_',syr,sjdy,'.nc'); %
    if exist(fname),
        [av_curl]=ncread(fname,'av_curl');
        [av_stress_u]=ncread(fname,'av_stress_u');
        [av_stress_v]=ncread(fname,'av_stress_v');
    end;
    
    tem=av_stress_v;rmax=max(max(tem))/8;;rmin=-rmax;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    subplot(1,3,2),imagesc(xlon-360,xlat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2);
    [c,h]=contour(xlon-360,xlat,tem',[-.1:.1:.1],'k');
%    gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('\tau_{y} (Nm^{-2})'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[.41 .35 .19 .03]);
    
    
    tem=av_curl;rmax=max(max(tem))/30;;rmin=-rmax;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=20;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    subplot(1,3,3),imagesc(xlon-360,xlat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2);
    [c,h]=contour(xlon-360,xlat,tem',[-.1:.1:.1],'k');
 %   gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('Curl (Nm^{-3})'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[.69 .35 .19 .03]);
    
    fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\PO_upwell\images\all',sjdy,'.jpg');
    print('-f','-djpeg99',fname);

end;
    
%grouping
titmon={'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};
for idyjl=100:10:255
    clf;jj=0;%colormap(r6);
    lyr=2014
    %[idyjl]=dy2jul(lyr,6,26);
    clf;colormap(anom_color);
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
    [a]=ncread(fname,'sst');
    tem=a-273.15;rmax=max(max(tem))-2;;rmin=min(min(tem))+2;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    %if jj==6,jj=jj+1;end;
    subplot(1,3,1),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    dc=(rmax-rmin)/10;  hold on;[c,h]=contour(lon,lat,tem',[rmin:dc:rmax],'k');
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2)
    %gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2) pp(3:4)*1.1]);
    %    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat(smon,'/',sdym,'/',syr,':SST_{5dy av} (\circC)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('SST_{5dy av} (\circC)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[pp(1) .35 pp(3)*1.1 .03]);
    
    fname=strcat('f:\data\ccmp_winds\v02.0\daily_nc\map\',syr,'\ccmp_daily_ave_map_',syr,sjdy,'.nc'); %
    if exist(fname),
        [av_curl]=ncread(fname,'av_curl');
        [av_stress_u]=ncread(fname,'av_stress_u');
        [av_stress_v]=ncread(fname,'av_stress_v');
    end;
    
    tem=av_stress_v;rmax=max(max(tem))/8;;rmin=-rmax;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    subplot(1,3,2),imagesc(xlon-360,xlat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2);
    dc=(rmax-rmin)/10;    hold on;[c,h]=contour(xlon-360,xlat,tem',[rmin:dc:rmax],'k');set(gca,'yticklabel','');
    %    gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1)-.03 pp(2) pp(3:4)*1.1]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('\tau_{y} (Nm^{-2})'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[pp(1)-.03 .35 pp(3)*1.1 .03]);
    
    
    tem=av_curl;rmax=max(max(tem))/30;;rmin=-rmax;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=20;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    subplot(1,3,3),imagesc(xlon-360,xlat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2);
    dc=(rmax-rmin)/10;    hold on;[c,h]=contour(xlon-360,xlat,tem',[rmin:dc:rmax],'k');set(gca,'yticklabel','');
    %   gt=text(-121.9750,47,strcat(smon,'/',sdym,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    set(gca,'yticklabel','');
    pp=get(gca,'position');set(gca,'position',[pp(1)-.06 pp(2) pp(3:4)*1.1]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('Curl (Nm^{-3})'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[pp(1)-.06 .35 pp(3)*1.1 .03]);
    
    fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\PO_upwell\images\all',sjdy,'.jpg');
    print('-f','-djpeg99',fname);
    
end;


%individual SST only, anomaly
%calculate anomaly
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\color_maps');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\read_routines\');
lyr=2014;syr=num2str(lyr,'%4.4i');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_monthly_',syr,'_v4.0.nc');
a=ncread(fname,'sst');
icoast=ones(1526,1)*2093;for j=1:1526,for i=1200:2093,if isnan(a(i,j,1)),icoast(j)=i-1;break;end;end;end;
a2=a;for k=1:12,for j=1:1526,mna=mean(a(icoast(j)-1000:icoast(j)-700,j,k));a2(:,j,k)=a(:,j,k)-mna;end;end;
close('all');figure(10);colormap(anom_color);cc=colormap;
titmon={'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
for im=1:12
    clf;jj=0;%colormap(r6);
    [idyjl]=dy2jul(lyr,im,1);
    %[idyjl]=dy2jul(lyr,6,26);
    clf;colormap(anom_color);    
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    %fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
    %[a]=ncread(fname,'sst');
%    tem=a2(:,:,im);rmax=max(max(tem));;rmin=min(min(tem));dx=(rmax-rmin)/200;
    tem=a2(:,:,im);rmax=3;rmin=-3;;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    %if jj==6,jj=jj+1;end;
    imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
    axis([-132.27 -117 32.88 48.25]);
    hold on;[c,h]=contour(lon,lat,tem',[rmin:.5:rmax],'k');
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2)
    gt=text(-121.9750,47,strcat(smon,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('\DeltaSST (K)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[.23 .12 .49 .03]);
    fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\PO_upwell\images\sst_anom',syr,smon,'.jpg');
    print('-f','-djpeg99',fname);
end;
for im=1:12
    clf;jj=0;
    [idyjl]=dy2jul(lyr,im,1);
    %[idyjl]=dy2jul(lyr,6,26);
    clf;colormap(anom_color);    
    [lyr idyjl]
    [imon,idym]=jul2dy(lyr,idyjl);
    syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
    url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
    lat = ncread(url_sst,'lat',[11107],[1526]);
    lon = ncread(url_sst,'lon',[3642 ],[2093]);
    %fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_5dy_',syr,sjdy,'_v4.0.nc');
    %[a]=ncread(fname,'sst');
%    tem=a2(:,:,im);rmax=max(max(tem));;rmin=min(min(tem));dx=(rmax-rmin)/200;
    tem=a2(:,:,im);rmax=3;rmin=-3;;dx=(rmax-rmin)/200;
    %tem=a-273.15;rmax=17;rmin=10;dx=(rmax-rmin)/200;
    tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
    %if jj==6,jj=jj+1;end;
    imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
    axis([-136.27 -117 32.88 48.25]);
    hold on;plot(lon(icoast-700),lat(1:1526),'k.')
    plot(lon(icoast-1000),lat(1:1526),'k.')
    gt=text(double(lon(icoast(1526)-1000)),double(lat(1526)+.1),'x_1');set(gt,'fontweight','bold','fontsize',8);
    gt=text(double(lon(icoast(1526)-700)),double(lat(1526)+.1),'x_2');set(gt,'fontweight','bold','fontsize',8);
    hold on;[c,h]=contour(lon,lat,tem',[rmin:.5:rmax],'k');
    plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
    plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
    plot(states(47).Lon,states(47).Lat,'k','linewidth',2)
    gt=text(-121.9750,47,strcat(smon,'/',syr));set(gt,'fontweight','bold','fontsize',8);
    pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
    hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('\DeltaSST (K)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
    set(hh,'position',[.23 .12 .49 .03]);
    fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\proposals\nasa\NASA_2016\PO_upwell\images\sst_anom2',syr,smon,'.jpg');
    print('-f','-djpeg99',fname);
end;




%for paper
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\color_maps');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\read_routines\');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
for lyr=2014:2016
    syr=num2str(lyr,'%4.4i');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_monthly_',syr,'_v4.0.nc');
    a=ncread(fname,'sst');
    %icoast=ones(1526,1)*2093;for j=1:1526,for i=1200:2093,if isnan(a(i,j,1)),icoast(j)=i-1;break;end;end;end;
    %a2=a;for k=1:12,for j=1:1526,mna=mean(a(icoast(j)-1000:icoast(j)-700,j,k));a2(:,j,k)=a(:,j,k)-mna;end;end;
    a2=a-mur_clim;
    close('all');figure(10);colormap(anom_color);cc=colormap;
    titmon={'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
    for im=1:12
        clf;jj=0;%colormap(r6);
        [idyjl]=dy2jul(lyr,im,1);
        %[idyjl]=dy2jul(lyr,6,26);
        clf;colormap(anom_color);
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
        lat = ncread(url_sst,'lat',[11107],[1526]);
        lon = ncread(url_sst,'lon',[3642 ],[2093]);
        tem=a2(:,:,im);rmax=3;rmin=-3;;dx=(rmax-rmin)/200;
        tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
        imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
        axis([-132.27 -117 32.88 48.25]);
        hold on;[c,h]=contour(lon,lat,tem',[rmin:.5:rmax],'k');
        plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
        plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
        plot(states(47).Lon,states(47).Lat,'k','linewidth',2)
        gt=text(-121.9750,47,strcat(smon,'/',syr));set(gt,'fontweight','bold','fontsize',8);
        pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
        hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('\DeltaSST (K)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
        set(hh,'position',[.23 .12 .49 .03]);
        fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\images\anom\mnth_',syr,smon,'.jpg');
        print('-f','-djpeg99',fname);
        clf;jj=0;%colormap(r6);
        [idyjl]=dy2jul(lyr,im,1);
        %[idyjl]=dy2jul(lyr,6,26);
        clf;colormap(anom_color);
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
        lat = ncread(url_sst,'lat',[11107],[1526]);
        lon = ncread(url_sst,'lon',[3642 ],[2093]);
        tem=a(:,:,im)-273.15;rmax=17;rmin=10;;dx=(rmax-rmin)/200;
        tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
        imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
        axis([-132.27 -117 32.88 48.25]);
        hold on;[c,h]=contour(lon,lat,tem',[rmin:.5:rmax],'k');
        plot(states(5).Lon,states(5).Lat,'k','linewidth',2)
        plot(states(37).Lon,states(37).Lat,'k','linewidth',2)
        plot(states(47).Lon,states(47).Lat,'k','linewidth',2)
        gt=text(-121.9750,47,strcat(smon,'/',syr));set(gt,'fontweight','bold','fontsize',8);
        pp=get(gca,'position');set(gca,'position',[pp(1) pp(2)+.1 pp(3:4)*.9]);
        hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('SST (K)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
        set(hh,'position',[.23 .12 .49 .03]);
        fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\images\anom\mnth_sst_',syr,smon,'.jpg');
        print('-f','-djpeg99',fname);
    end;
end;

addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\graphics\');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\color_maps');
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\read_routines\');
fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_clim_2002_2012_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
ip=0;        clf;colormap(anom_color);
close('all');figure(10);colormap(anom_color);cc=colormap;
for lyr=2014:2015
    syr=num2str(lyr,'%4.4i');
    fname=strcat('f:\data\sst\jpl_mur\west_coast_sst_monthly_',syr,'_v4.0.nc');
    a=ncread(fname,'sst');
    %icoast=ones(1526,1)*2093;for j=1:1526,for i=1200:2093,if isnan(a(i,j,1)),icoast(j)=i-1;break;end;end;end;
    %a2=a;for k=1:12,for j=1:1526,mna=mean(a(icoast(j)-1000:icoast(j)-700,j,k));a2(:,j,k)=a(:,j,k)-mna;end;end;
    a2=a-mur_clim;
    titmon={'Jan';'Feb';'Mar';'Apr';'May';'Jun';'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'};rmax=3;rmin=-3;dx=(rmax-rmin)/(length(cc)-2);
    for im=1:2:12
        jj=0;%colormap(r6);
        [idyjl]=dy2jul(lyr,im,1);
        %[idyjl]=dy2jul(lyr,6,26);
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
        lat = ncread(url_sst,'lat',[11107],[1526]);
        lon = ncread(url_sst,'lon',[3642 ],[2093]);
        tem=a2(:,:,im);rmax=3;rmin=-3;;dx=(rmax-rmin)/200;
        tem(find(tem>rmax))=rmax;tem(isnan(tem))=rmax+dx*2;
        ip=im+lyr-2014;
%        ip=round(im/2)+lyr-2014;
        subplot(6,2,ip),imagesc(lon,lat,tem',[rmin rmax+dx*4]);axis image;
        set(gca,'fontsize',8);
        if ip==1,title('2014');end;
        if ip==2,title('2015');end;
        axis([-132.27 -117 32.88 48.25]);
        if lyr==2015,set(gca,'yticklabel',[]);end;
        if ip<11,set(gca,'xticklabel',[]);end;
        push_panel(0,0.015);
        if ip>2,push_panel(0,0.015);end;
        if ip>4,push_panel(0,0.015);end;
        if ip>6,push_panel(0,0.015);end;
        if ip>8,push_panel(0,0.015);end;
        if ip>10,push_panel(0,0.015);end;
        hold on;[c,h]=contour(lon,lat,tem',[rmin:1:rmax],'k');
        plot(states(5).Lon,states(5).Lat,'k','linewidth',.5)
        plot(states(37).Lon,states(37).Lat,'k','linewidth',.5)
        plot(states(47).Lon,states(47).Lat,'k','linewidth',.5)
        gt=text(-124,47,titmon(im));set(gt,'fontweight','bold','fontsize',8,'color',[1 1 1]);
        pp=get(gca,'position');set(gca,'position',[pp(1) pp(2) pp(3:4)*1.1]);
        if lyr==2015,pp=get(gca,'position');set(gca,'position',[pp(1)-.35 pp(2) pp(3:4)]);end;
    end;
end;
hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('\DeltaSST (K)'));hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
set(hh,'position',[.27 .11 .18 .02]);
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\images\anom\mnth_all.jpg');
print('-f','-djpeg99',fname);



%with 2016
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
        if im>6 & lyr==2016,continue;end;
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
hh=colorbar_thin2hxy(0,-0.16);ctitle(strcat('\DeltaSST (\circC)'));
hp=get(hh,'position');set(hh,'position',[.29 hp(2) hp(3)*2.6 hp(4)*1.2]);
set(hh,'position',[.226 .2 .205 .01]);
orient tall;
fname=strcat('C:\Users\gentemann\Google Drive\f_drive\docs\papers\in_prep\pac_anom\coast\images\anom\mnth_allB3.jpg');
print('-f','-djpeg99',fname);


%make big pacific

addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
lyr=2014;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
G.lat = ncread(url_sst,'lat',[10107],[1526+1100+1030-30]);
G.lon = ncread(url_sst,'lon',[3642-2000],[2093+2000+1200]);
a = ncread(url_sst,'analysed_sst',[3642-2000 11107-1000 1],[2093+2000+1200 1030+1526+1100-30 1]);


addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
lyr=2014;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
%a2 = ncread(url_sst,'analysed_sst',[3642-2000 11107 1],[2093+2000 1526+1100 1]);
a = ncread(url_sst,'analysed_sst',[3642-2000 11107-1000 1],[2093+2000+1200 1030 1]);
%a2(4094:5293,:)=NaN;
%a(:,1031:1001+2626-1)=a2(:,31:2626);
G.lat = ncread(url_sst,'lat');
G.lon = ncread(url_sst,'lon');
% url_sst='http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/2013/012/20130112-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2'
% ncdisp(url_sst)
% G.lat = ncread(url_sst,'lat');
% G.lon = ncread(url_sst,'lon');
% a = ncread(url_sst,'analysed_sst',[3840 8192 1],[5660 4600 1]);
av=zeros(5293,1030);avc=av;av2=av;lyrsv=2016;imonsv=1;
%av=zeros(4093,2626);avc=av;av2=av;lyrsv=2016;imonsv=1;
for lyr=2002:2016
    for idyjl=1:dyinyr(lyr)
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>333,continue;end;
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        if imonsv~=imon,
            av=av./avc;
            av2=av2./avc;
            %av2=sqrt(av2-av.^2);
            syr=num2str(lyrsv,'%4.4i');smon=num2str(imonsv,'%2.2i');
            fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_',syr,smon,'_v4.0_south.nc');
%            fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_',syr,smon,'_v4.0.nc');
            write_nc3(fname,av,'sst',av2,'sst_sq',avc,'cnt');
            imonsv=imon;lyrsv=lyr;
            av=zeros(5293,1030);av2=av;avc=av;
%            av=zeros(4093,2626);av2=av;avc=av;
        end;
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
        if lyr==2016,if idyjl==23 | idyjl==40 | idyjl==63,
                url_sst=strcat('F:\data\sst\jpl_mur\nc\',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc');
            end;end;
        %a = ncread(url_sst,'analysed_sst',[3642-2000 11107 1],[2093+2000 1526+1100 1]);
        a = ncread(url_sst,'analysed_sst',[3642-2000 11107-1000 1],[2093+2000+1200 1030 1]);
        ia=find(~isnan(a));
        av(ia)=av(ia)+a(ia);
        av2(ia)=av2(ia)+a(ia).^2;
        avc(ia)=avc(ia)+1;
    end;
end;

%av=zeros(4093,2626,12);avc=av;av2=av;lyrsv=2002;imonsv=6;
av=zeros(5293,1030,12);avc=av;av2=av;lyrsv=2002;imonsv=6;
for lyr=2002:2012
    for imon=1:12
        [lyr imon]
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_',syr,smon,'_v4.0_south.nc');
%        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_',syr,smon,'_v4.0.nc');
        if ~exist(fname),continue;end;
        a=ncread(fname,'sst');
        a2=ncread(fname,'sst_sq');
        ac=ncread(fname,'cnt');
        ia=find(~isnan(a));
        tem=av(:,:,imon);tem(ia)=tem(ia)+a(ia).*ac(ia);av(:,:,imon)=tem;
        tem=av2(:,:,imon);tem(ia)=tem(ia)+a2(ia).*ac(ia);av2(:,:,imon)=tem;
        tem=avc(:,:,imon);tem(ia)=tem(ia)+ac(ia);avc(:,:,imon)=tem;
    end;
end;
av=av./avc;
av2=av2./avc;
%fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_2002_2012_clim_v4.0.nc');
fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_2002_2012_clim_v4.0_south.nc');
write_nc3(fname,av,'mur_clim',av2,'mur_clim_sq');

lyr=2014;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
G.lat = ncread(url_sst,'lat',[11107],[1526+1100]);
G.lon = ncread(url_sst,'lon',[3642-2000],[2093+2000]);
fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_lat_v4.0.nc');
write_nc3(fname,G.lat,'lat');
fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_lon_v4.0.nc');
write_nc3(fname,G.lon,'lon');
fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_2002_2012_clim_v4.0.nc');
[mur_clim]=ncread(fname,'mur_clim');
for lyr=2014:2016
    av=zeros(4093,2626,12);av2=av;
    for imon=1:12
        [lyr idyjl]
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_',syr,smon,'_v4.0.nc');
        if ~exist(fname),continue;end;
        a=ncread(fname,'sst');
        a2=ncread(fname,'sst_sq');
        ac=ncread(fname,'cnt');
        ia=find(~isnan(a));
        av(:,:,imon)=a-mur_clim(:,:,imon);
        av2(:,:,imon)=a;
    end;
    if lyr==2016,av(:,:,11:12)=NaN;end;
    fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_anom_',syr,'_v4.0.nc');
    write_nc3(fname,av,'sst_anom');
    fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_',syr,'_v4.0.nc');
    write_nc3(fname,av2,'sst');
end;
fname=strcat('f:\data\sst\jpl_mur\west_coast4.0\east_pac_sst_anom_2015_v4.0.nc');
[av]=ncread(fname,'sst_anom');

%make bigger pacific 4.1
addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
lyr=2014;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('http://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/L4/GLOB/JPL/MUR/',syr,'/',sjdy,'/',syr,smon,sdym,'-JPL-L4UHfnd-GLOB-v01-fv04-MUR.nc.bz2');
G.lat = ncread(url_sst,'lat',[9607],[4256]);
G.lon = ncread(url_sst,'lon',[642],[6593]);
a = ncread(url_sst,'analysed_sst',[642 9607 1],[6593 4256 1]);

url_sst=strcat('F:\data\sst\jpl_mur\v4.1\',syr,'\',sjdy,'\',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
G.lat2 = ncread(url_sst,'lat');
G.lon2 = ncread(url_sst,'lon');
a = ncread(url_sst,'analysed_sst',[705 10554 1],[7242 4675 1]);



addpath('C:\Users\gentemann\Google Drive\d_drive\matlab\tools\');
lyr=2014;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('F:\data\sst\jpl_mur\v4.1\',syr,'\',sjdy,'\',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
a = ncread(url_sst,'analysed_sst',[705 10554 1],[7242 4675 1]);
G.lat = ncread(url_sst,'lat');
G.lon = ncread(url_sst,'lon');
av=zeros(7242,4675);avc=av;av2=av;lyrsv=2016;imonsv=1;
for lyr=2002:2016
    for idyjl=1:dyinyr(lyr)
        if lyr==2002 & idyjl<152,continue;end;
        if lyr==2016 & idyjl>333,continue;end;
        [lyr idyjl]
        [imon,idym]=jul2dy(lyr,idyjl);
        if imonsv~=imon,
            av=av./avc;
            av2=av2./avc;
            %av2=sqrt(av2-av.^2);
            syr=num2str(lyrsv,'%4.4i');smon=num2str(imonsv,'%2.2i');
            fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_',syr,smon,'_v4.1.nc');
            write_nc3(fname,av,'sst',av2,'sst_sq',avc,'cnt');
            imonsv=imon;lyrsv=lyr;
            av=zeros(7242,4675);av2=av;avc=av;
        end;
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
        url_sst=strcat('F:\data\sst\jpl_mur\v4.1\',syr,'\',sjdy,'\',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
        a = ncread(url_sst,'analysed_sst',[705 10554 1],[7242 4675 1]);
        ia=find(~isnan(a));
        av(ia)=av(ia)+a(ia);
        av2(ia)=av2(ia)+a(ia).^2;
        avc(ia)=avc(ia)+1;
    end;
end;

av=zeros(7242,4675,12);avc=av;av2=av;lyrsv=2002;imonsv=6;
for lyr=2002:2012
    for imon=1:12
        [lyr imon]
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');
            fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_',syr,smon,'_v4.1.nc');
        if ~exist(fname),continue;end;
        a=ncread(fname,'sst');
        a2=ncread(fname,'sst_sq');
        ac=ncread(fname,'cnt');
        ia=find(~isnan(a));
        tem=av(:,:,imon);tem(ia)=tem(ia)+a(ia).*ac(ia);av(:,:,imon)=tem;
        tem=av2(:,:,imon);tem(ia)=tem(ia)+a2(ia).*ac(ia);av2(:,:,imon)=tem;
        tem=avc(:,:,imon);tem(ia)=tem(ia)+ac(ia);avc(:,:,imon)=tem;
    end;
end;
av=av./avc;
av2=av2./avc;
fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_2002_2012_clim_v4.1.nc');
write_nc3(fname,av,'mur_clim',av2,'mur_clim_sq');

lyr=2014;idyjl=1;[imon,idym]=jul2dy(lyr,idyjl);
syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');sjdy=num2str(idyjl,'%3.3i');sdym=num2str(idym,'%2.2i');
url_sst=strcat('F:\data\sst\jpl_mur\v4.1\',syr,'\',sjdy,'\',syr,smon,sdym,'090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc');
a = ncread(url_sst,'analysed_sst',[705 10554 1],[7242 4675 1]);
G.lat = ncread(url_sst,'lat',[10554],[4675]);
G.lon = ncread(url_sst,'lon',[705],[7242]);
fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_lat_v4.1.nc');
write_nc3(fname,G.lat,'lat');
fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_lon_v4.1.nc');
write_nc3(fname,G.lon,'lon');
fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_2002_2012_clim_v4.1.nc');
[mur_clim]=ncread(fname,'mur_clim');
for lyr=2015:2015
    av=zeros(7242,4675,12);av2=av;
    for imon=1:12
        [lyr idyjl]
        syr=num2str(lyr,'%4.4i');smon=num2str(imon,'%2.2i');
        fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_',syr,smon,'_v4.1.nc');
        if ~exist(fname),continue;end;
        a=ncread(fname,'sst');
        a2=ncread(fname,'sst_sq');
        ac=ncread(fname,'cnt');
        ia=find(~isnan(a));
        av(:,:,imon)=a-mur_clim(:,:,imon);
        av2(:,:,imon)=a;
    end;
    if lyr==2016,av(:,:,11:12)=NaN;end;
    fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_anom_',syr,'_v4.1.nc');
    write_nc3(fname,av,'sst_anom');
    fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_',syr,'_v4.1.nc');
    write_nc3(fname,av2,'sst');
end;

fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_anom_2015_v4.1.nc');
ncread(fname,av,'sst_anom');
fname=strcat('f:\data\sst\jpl_mur\east_pac_v4.1\east_pac_sst_anom_2015_05_v4.1.nc');
write_nc3(fname,av(:,:,5),'sst_anom');






