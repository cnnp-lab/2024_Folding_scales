clear all
close all
%addpath('../lib/') %add the lib to path, wherever you have put it.

%note all "melting" steps have been performed already and the outputs are
%saved in the data folder. This script is only collating the information
%and plotting it and running stats.

%setup basic definitions:
lrstr='lr';

pathcolorinfo={
%     'WalnutN1','#9A6324';
%     'WalnutN3','#9A6324';    
    'Marmoset','#469599';
    'Daphne','#ffe119';%this is a macaque
    'chimp','#e6194B';
    

    'HCP/103414','#4363d8';%this is a human from HCP


    'colobus','#2ad47f';
    'aotus','#f58231';
    'galago','#911eb4';
    'pithecia','#a5ed4c';
    'cebus','#f032e6';
    'lagothrix','#000099';
    'lophocebus','#42d4f4';
    };



%% loop over all species and both hemispheres
pathstr=pathcolorinfo(:,1);
clr=pathcolorinfo(:,2);
slopes=[];
rsqs=[];
cis=[];
grps=[];
grpclrs=[];
origTAll=[];


X_all=[];
x_all={};
scales_all={};
rsf_all={};

for c=1:length(clr)%species
    %convert colour:
    colour = sscanf(clr{c}(2:end),'%2x%2x%2x',[1 3])/255;
    
    
for lr=1:2%hemispheres
    
    fn=['../data/subjects/' pathstr{c} '/AllScales_hemi=' lrstr(lr) '.mat'];
    if exist(fn,'file')==2
        grpclrs=[grpclrs; colour];
        load(fn)

        %read out cortical thickness and area from original surface

        fnsurff=['../data/subjects/' pathstr{c} '/'];        
        fnsurf=[fnsurff 'thickness.mat'];
        ot=load(fnsurf);
        os=load([fnsurff 'areas.mat']);
        
        origT=ot.origT(lr);
        origAe=os.origAe(lr);
        origAt=os.origAt(lr);
        
        origI=2*log10(origT)+log10(origAt)+log10(origAe);
        
        

        %read out data from collectScales output
        scales=SubjectDataTable.Scale;
        GMVOL=SubjectDataTable.GM_Vol;
        AT=SubjectDataTable.At;
        CH=SubjectDataTable.CH;
        WMAt=SubjectDataTable.WM_area;
        NTRI=SubjectDataTable.n_Tri;

        %calculate 2ndary variables
        T=(GMVOL./AT);
        
        I=2*log10(T)+log10(AT)+log10(CH);

        T_ratio=T./origT;
        I_ratio = I./origI;
        
        rscales=scales.*I_ratio(end-1)/scales(end-1);%this is the fixed rescaling factor l_r as described in Suppl S3.1
        validscale=T_ratio>=1 & I_ratio>=1;


        AT_r=AT./(rscales.^2);
        CH_r=CH./(rscales.^2);
        T_r=T./(rscales);
       
  
        y=log10(AT_r.*sqrt(T_r));
        x=log10(CH_r);

        y_orig=log10(origAt.*sqrt(origT));
        x_orig=log10(origAe);
        %----------------

        %remove invalid datapoints (e.g. where melting has gone beyond the
        %smooth limit
        ssid=~isnan(x) & ~isnan(y) & abs(x)~=Inf & abs(y)~=Inf & log10(AT)-log10(CH)>=0;

        %derive scaling slope
        if sum(ssid&validscale)>=4
            
    %       
            mdl=fitlm(x(ssid&validscale),y(ssid&validscale));
            b=mdl.Coefficients.Estimate;
            ci=mdl.coefCI;
            ci=ci(2,:);
            slopes=[slopes; b(2)];
            rsqs=[rsqs; mdl.Rsquared.Ordinary];
            X_all=[X_all;x(ssid&validscale) y(ssid&validscale) ones(size(scales(ssid&validscale)))*c]
        else
            b=[0 0];
        end


        figure(1)
        hold on
        %scatter(x(ssid),y(ssid),50,colour,'filled')
        plot(x(ssid&validscale),y(ssid&validscale),'-','Color', colour)
%         scatter(x(~ssid),y(~ssid),50,colour)
%         plot(x,y,'-','Color', colour)



        scatter(x_orig,y_orig,50, colour,'filled')
        hold off

        x_all{c,lr}=x;
        y_all{c,lr}=y;
        scales_all{c,lr}=scales;
        rsf_all{c,lr}=I_ratio(end-1)/scales(end-1);

    else
        warning([fn ' not loaded'])
    end
end
end


figure(1)
hold on
x=0:0.5:6;
y=x;
plot(x,y,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y+1,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y+2,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y+3,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y+4,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y+5,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y-1,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y-2,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y-3,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y-4,'LineWidth',0.25,'Color',[0.8 0.8 0.8])
plot(x,y-5,'LineWidth',0.25,'Color',[0.8 0.8 0.8])

plot(x,1.25*y,'LineWidth',0.25,'Color',[1 0 0])%added a red line to show slope of 1.25 for reference
hold off

xlim([x(1) x(end)])
ylim([y(1) y(end)])
axis equal


    xlabel('log10 Ae (rescaled vox)')
    ylabel('log10 At * sqrt T (rescaled vox)')




%% mixed effect model of all slopes 
clc
T_lme=table(X_all(:,1),X_all(:,2),X_all(:,3));
mdlme=fitlme(T_lme,'Var2~Var1+(1|Var3)')

%% dot plot of all slopes

plot_opts.mkr_size = repmat(90,1,length(slopes));
plot_opts.lw = 5;
plot_opts.mkrs = repmat('s',1,length(slopes));
plot_opts.clrs = grpclrs;
plot_opts.center_ticks = false;
% [f,h,n_el,bin_x]=dot_plot(slopes,grps,[0.95-0.03/2:0.03:1.52+0.03/2],plot_opts)
% set(f,'Units','centimeters','Position',[5 5 15 7])   
% set(gca,'XTick',0.95:0.03:1.52,'FontSize',10,...
%     'XMinorTick','off')
% 
% [f,h,n_el,bin_x]=dot_plot(slopes,grps,[0.8:0.02:1.5],plot_opts)
% set(f,'Units','centimeters','Position',[5 5 15 7])   
% set(gca,'XTick',0.89:0.02:1.51,'FontSize',10,...
%     'XMinorTick','off')
% 

binsteps=0.02;
binbounds=[fliplr(1.25-binsteps/2:-binsteps:1)  binsteps/2+1.25:binsteps:1.5]

[f,h,n_el,bin_x]=dot_plot(slopes,1:length(slopes),binbounds,plot_opts)
set(f,'Units','centimeters','Position',[5 5 15 7])   
set(gca,'XTick',binbounds+binsteps/2,'FontSize',10,...
    'XMinorTick','off')

%% plot surfaces
%All surfaces are stored in the data folders. for example:
load('../data/subjects/chimp/Vis/Surfpial_hemi=l_scale=0.97724.mat')
facesl=faces;vertsl=v;

load('../data/subjects/chimp/Vis/Surfpial_hemi=r_scale=0.97724.mat')
facesr=faces;vertsr=v;

h=vis_brainsurf(facesl,vertsl,facesr,vertsr,[-100 100],'chimp',0)
%note this plot is without smoothing the mesh, if you want to turn
%smoothing on (recommended for smaller scales) you need to add iso2mesh to
%your path, as it uses the sms function: https://github.com/fangq/iso2mesh/blob/master/sms.m
