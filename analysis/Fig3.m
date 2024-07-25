clear all
close all
% addpath('../lib/')%add the lib to path, wherever you have put it.
%similar code structure as the main part of Fig 2

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

%%
pathstr=pathcolorinfo(:,1);
clr=pathcolorinfo(:,2);
slopes=[];
cis=[];
grps=[];
grpclrs=[];
origTAll=[];


X_all=[];
x_all={};
scales_all={};
rsf_all={};

mK=[];
mS=[];

for c=1:length(clr)
    %convert colour:
    colour = sscanf(clr{c}(2:end),'%2x%2x%2x',[1 3])/255;
    
    
for lr=1:2
    
    fn=['../data/subjects/' pathstr{c} '/AllScales_hemi=' lrstr(lr) '.mat'];
    if exist(fn,'file')==2
        grpclrs=[grpclrs; colour];
        load(fn)

        

        %read out data from collectScales output
        scales=SubjectDataTable.Scale;
        GMVOL=SubjectDataTable.GM_Vol;
        AT=SubjectDataTable.At;
        CH=SubjectDataTable.CH;
        

        %calculate 2ndary variables
        T=(GMVOL./AT);
        GI=AT./CH;
        

        %----------------

        %which datapoints to consider
        ssid=~isnan(GI) & ~isnan(T) & abs(GI)~=Inf & abs(T)~=Inf & log10(AT)-log10(CH)>=0.000000001;
%         ssid=~isnan(GI) & ~isnan(T) & abs(GI)~=Inf & abs(T)~=Inf;

        %derive K, I, S
        u=log10(AT);w=log10(CH);v=log10(T.^2);
        K= u + 0.25.*v + -1.25.*w;
        K_hat=K./norm([1 0.25 -1.25]);
        
        I=u+v+w;
        I_hat=I./norm([1 1 1]);
        
        S=3/2*u + -9/4.*v + 3/4.*w;
        S_hat=S./norm([3/2 -9/4 3/4]);

        figure(3)
        hold on
        plot(S_hat(ssid),K_hat(ssid),'-','Color',colour)
        scatter(S_hat(ssid),K_hat(ssid),50,colour,'filled')
%         scatter(S_hat(~ssid),K_hat(~ssid),50,colour)
        hold off
        mK=[mK;nanmean(K_hat)];
        mS=[mS;nanmean(S_hat)];

    else
        warning([fn ' not loaded'])
    end
end
end

std(mK)
std(mS)


figure(3)

hold on
kn=norm([1 0.25 -1.25]);
sn=norm([3/2 -9/4 3/4]);
s=1.5:0.1:3.8;
k=-1/9*s./kn*sn;
plot(s,k,'Color',[0 0 0])
hold off

xlabel('S')
ylabel('K')
xlim([1.5 3.8])
axis equal
axis equal
