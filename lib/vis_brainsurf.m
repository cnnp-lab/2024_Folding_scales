function h=vis_brainsurf(facesl,vertsl,facesr,vertsr,yl,ttstr,meshsmooth)

if meshsmooth==1
    vertsl=sms(vertsl,facesl,5,0.5);
    vertsr=sms(vertsr,facesr,5,0.5);
end


h=figure('Position', [10 10 900 900])
trisurf(facesl,vertsl(:,2),vertsl(:,1),vertsl(:,3),'FaceColor',[0.85 0.8 0.75],'EdgeColor',[0.1 0.1 0.1],'EdgeAlpha',0.0);
hold on
trisurf(facesr,vertsr(:,2),vertsr(:,1),vertsr(:,3),'FaceColor',[0.85 0.8 0.75],'EdgeColor',[0.1 0.1 0.1],'EdgeAlpha',0.0);
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
title(ttstr)