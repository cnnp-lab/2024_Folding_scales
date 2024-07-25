clear all
close all
%you need to have gramm on your path for the plots to work!
%https://uk.mathworks.com/matlabcentral/fileexchange/54465-gramm-data-visualization-toolbox

%also note this script uses only 10 young and 10 older subjects, as the
%data would be too big otherwise to share. The final paper used far more
%subjects, but please refer to our follow-up publication for the full data
%and analysis details: https://arxiv.org/abs/2311.13501
%But this code shows the principle and was used to produce the figures in
%the earlier versions of this paper.



load('../data/subjects/CamCAN.mat')

lrstr='lr';


minscale=1;%images are assumed to be 1mm isotropic in orig resolution

scales=fliplr([0.25:0.25:1 1.5:0.5:3 4:15]);
pathcolor={
    %males 20
    'CamCAN/sub-CC110062','#ff9d02';
    'CamCAN/sub-CC110606','#ff9d02';
    'CamCAN/sub-CC120061','#ff9d02';
    'CamCAN/sub-CC120409','#ff9d02';
    'CamCAN/sub-CC120550','#ff9d02';
    %females 20
    'CamCAN/sub-CC110182','#ffd086';
    'CamCAN/sub-CC120123','#ffd086';
    'CamCAN/sub-CC120347','#ffd086';
    'CamCAN/sub-CC120376','#ffd086';
    'CamCAN/sub-CC120462','#ffd086';
%     %males 50
%     'CamCAN/sub-CC420060','ff7302';
%     'CamCAN/sub-CC420202','ff7302';
%     'CamCAN/sub-CC420217','ff7302';
%     'CamCAN/sub-CC420226','ff7302';
%     'CamCAN/sub-CC420322','ff7302';
%     %females 50
%     'CamCAN/sub-CC420259','#ffbc86';
%     'CamCAN/sub-CC420260','#ffbc86';
%     'CamCAN/sub-CC420392','#ffbc86';
%     'CamCAN/sub-CC420493','#ffbc86';
%     'CamCAN/sub-CC420566','#ffbc86';
    %males 80
    'CamCAN/sub-CC711128','#ff4902';
    'CamCAN/sub-CC720103','#ff4902';
    'CamCAN/sub-CC720119','#ff4902';
    'CamCAN/sub-CC720329','#ff4902';
    'CamCAN/sub-CC720511','#ff4902';
    %females 80
    'CamCAN/sub-CC721418','#ffa886';
    'CamCAN/sub-CC721519','#ffa886';
    'CamCAN/sub-CC721585','#ffa886';
    'CamCAN/sub-CC721618','#ffa886';
    'CamCAN/sub-CC721648','#ffa886';

    };


%% 

pathstr=pathcolor(:,1);
clr=pathcolor(:,2);
CTable=[];
for c=1:length(clr)%all subjects
    for lr=1:2

        Ti=table();
        fn=['../data/subjects/' pathstr{c} '/AllScales_hemi=' lrstr(lr) '.mat'];
        if exist(fn,'file')==2
            load(fn)



            %read out data from collectScales output
            scales=SubjectDataTable.Scale;
            GMVOL=SubjectDataTable.GM_Vol;
            AT=SubjectDataTable.At;
            CH=SubjectDataTable.CH;
            WMAt=SubjectDataTable.WM_area;
            NTRI=SubjectDataTable.n_Tri;

            %calculate 2ndary variables
            T=(GMVOL./AT);
            GI=AT./CH;
            


            %put into table
            ss=strsplit(pathstr{c},'/');
            datasetname=ss{1};
            subjID=ss{2};

            if datasetname=="CamCAN"
                fid=find(string(CamCAN.SubjID)==subjID);
                age=CamCAN.Age(fid);
            end


            AGECAT=ones(size(T))*round(age,-1);
            SID=repmat(string(subjID),length(T),1);
            DATASET=repmat(string(datasetname),length(T),1);




            %derive K, I, S

            AT=log10(AT);
            CH=log10(CH);
            GMVOL=log10(GMVOL);
            T=log10(T.^2);
            

            u=AT;w=CH;v=T;

            K= u + 0.25.*v + -1.25.*w;
            K=K./norm([1 0.25 -1.25]);
            
            I=u+v+w;
            I=I./norm([1 1 1]);

            S=3/2*u + -9/4.*v + 3/4.*w;
            S=S./norm([3/2 -9/4 3/4]);


            Ti=table(SID,DATASET,AGECAT,scales,AT,CH,GMVOL,T,K,I,S);

        end

        CTable=[CTable; Ti];

    end
end


%%
DATASET=CTable.DATASET;
DATASETN=DATASET;
DATASETN(DATASET=="CamCAN")=1;

DATASETN=str2double(DATASETN);

%% compare CamCAN only 80 vs 20 

close all
clear g
clc
g(1,1)=gramm('x',CTable.scales,'y',CTable.K,'color',CTable.AGECAT,'subset',DATASETN==1);
g(1,1).stat_summary('type','std');
g(1,1).geom_point('alpha',0.1);
g(1,1).set_names('x','scale','y','K normed')


g(2,1)=gramm('x',CTable.scales,'y',CTable.I,'color',CTable.AGECAT,'subset',DATASETN==1);
g(2,1).stat_summary('type','std');
g(2,1).geom_point('alpha',0.1);
g(2,1).set_names('x','scale','y','I normed')



g(3,1)=gramm('x',CTable.scales,'y',CTable.S,'color',CTable.AGECAT,'subset',DATASETN==1);
g(3,1).stat_summary('type','std');
g(3,1).set_names('x','scale','y','S normed')
g(3,1).geom_point('alpha',0.1);


g(1,2)=gramm('x',CTable.scales,'y',CTable.AT,'color',CTable.AGECAT,'subset',DATASETN==1);
g(1,2).stat_summary('type','std');
g(1,2).set_names('x','scale','y','log A_t')
g(1,2).geom_point('alpha',0.1);


g(2,2)=gramm('x',CTable.scales,'y',CTable.CH,'color',CTable.AGECAT,'subset',DATASETN==1);
g(2,2).stat_summary('type','std');
g(2,2).set_names('x','scale','y','log A_e')
g(2,2).geom_point('alpha',0.1);

g(3,2)=gramm('x',CTable.scales,'y',CTable.T,'color',CTable.AGECAT,'subset',DATASETN==1);
g(3,2).stat_summary('type','std');
g(3,2).set_names('x','scale','y','log T^2')
g(3,2).geom_point('alpha',0.1);



figure(1);
g.draw();

%% calculate ageing effect sizes with 20 y.o in CamCAN as baseline
clc

ageref=20;%20 or 80 possible
agecmp=80;

fid=find(CTable.SID==CTable.SID(1) & CTable.scales~=0);
scales=sort(CTable.scales(fid));


z=zeros(size(scales));
Keff=z;Seff=z;Ieff=z;
CHeff=z;Ateff=z;Teff=z;
for s=1:length(scales)
    scale=scales(s);
    refIDs=find(CTable.DATASET=="CamCAN" & CTable.scales==scale & CTable.AGECAT==ageref);
    cmpIDs=find(CTable.DATASET=="CamCAN" & CTable.scales==scale & CTable.AGECAT==agecmp);
    
    [~,~,stats]=ranksum(CTable.K(refIDs),CTable.K(cmpIDs));
    Keff(s)=stats.zval;
    
    [~,~,stats]=ranksum(CTable.I(refIDs),CTable.I(cmpIDs));
    Ieff(s)=stats.zval;
    
    [~,~,stats]=ranksum(CTable.S(refIDs),CTable.S(cmpIDs));
    Seff(s)=stats.zval;
    
    [~,~,stats]=ranksum(CTable.AT(refIDs),CTable.AT(cmpIDs));
    Ateff(s)=stats.zval;
    
    [~,~,stats]=ranksum(CTable.CH(refIDs),CTable.CH(cmpIDs));
    CHeff(s)=stats.zval;
    
    [~,~,stats]=ranksum(CTable.T(refIDs),CTable.T(cmpIDs));
    Teff(s)=stats.zval;
end

al=6;
figure(11)
subplot(3,2,1)
plot(scales,Keff)
title('K')
ylim([-al al])

subplot(3,2,2)
plot(scales,Ateff)
title('log 10 A_t')
ylim([-al al])

subplot(3,2,3)
plot(scales,Ieff)
title('I')
ylim([-al al])

subplot(3,2,4)
plot(scales,CHeff)
title('log10 A_e')
ylim([-al al])

subplot(3,2,5)
plot(scales,Seff)
title('S')
ylim([-al al])

subplot(3,2,6)
plot(scales,Teff)
title('log10 T^2')
ylim([-al al])


sgtitle(['Effect sizes Age ' num2str(ageref) ' vs age ' num2str(agecmp) ' (CamCAN)'])


