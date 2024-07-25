function h=vis_brainwhitesurf(facesl,vertsl,facesr,vertsr,whitefl, whitefr, whitevl, whitevr,yl,ttstr,meshsmooth)

if meshsmooth==1
    vertsl=sms(vertsl,facesl,5,0.5);
    vertsr=sms(vertsr,facesr,5,0.5);
    whitevl=sms(whitevl,whitefl,5,0.5);
    whitevr=sms(whitevr,whitefr,5,0.5);
end


h=figure('Position', [0 0 1800 900])
subplot(1,2,1)
trisurf(facesl,vertsl(:,2),vertsl(:,1),vertsl(:,3),'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.1 0.1 0.1],'EdgeAlpha',0.0);
hold on
trisurf(facesr,vertsr(:,2),vertsr(:,1),vertsr(:,3),'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.1 0.1 0.1],'EdgeAlpha',0.0);
hold off
axis equal
xlim(yl)
lightangle(0,45)
lightangle(0,90+45)
view(-90,90)
material shiny
% material([0.45 0.45 0.55 6])
lighting gouraud

grid off
axis off
set(gcf,'color','w');
title(['Pial surface ' ttstr])



subplot(1,2,2)
trisurf(whitefl,whitevl(:,2),whitevl(:,1),whitevl(:,3),'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.1 0.1 0.1],'EdgeAlpha',0.0);
hold on
trisurf(whitefr,whitevr(:,2),whitevr(:,1),whitevr(:,3),'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.1 0.1 0.1],'EdgeAlpha',0.0);
hold off
axis equal
xlim(yl)
lightangle(0,45)
lightangle(0,90+45)
view(-90,90)
material shiny
% material([0.45 0.45 0.55 6])
lighting gouraud

grid off
axis off
set(gcf,'color','w');
title(['White matter surface ' ttstr])