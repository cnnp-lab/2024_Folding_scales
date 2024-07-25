function h=vis_brainvoxslice(piall,whitel,voxl,pialr,whiter,voxr,scale,rm_cc,sl_pct)

slicel=round(size(voxl.in_pial,3)*sl_pct);

slicer=round(size(voxr.in_pial,3)*sl_pct);

%% move pialv and white v to vox space

piall.v_vox=(piall.v-[voxl.xmin voxl.ymin voxl.zmin])/scale - [0 0 slicel-scale/2];
whitel.v_vox=(whitel.v-[voxl.xmin voxl.ymin voxl.zmin])/scale - [0 0 slicel-scale/2];

pialr.v_vox=(pialr.v-[voxr.xmin voxr.ymin voxr.zmin])/scale - [0 0 slicer-scale/2];
whiter.v_vox=(whiter.v-[voxr.xmin voxr.ymin voxr.zmin])/scale - [0 0 slicer-scale/2];


%% remove cc voxels? (note this is removed in the estimateScale() function, but not saved, hence doing it again here
for lri=1:2
    if rm_cc.do==1
        joffset=0;
        bordersizemin=scale+joffset; %in mm
        bordersize=bordersizemin+3*scale;
        
        
        if lri==1
            cclabel=single(rm_cc.Thicknessl>0);
            in_pial=voxl.in_pial;
            in_white=voxl.in_white;
            xmin=floor(min(whitel.v(:,1)))-bordersize;
            xmax=ceil(max(whitel.v(:,1)))+bordersize;
            ymin=floor(min(whitel.v(:,2)))-bordersize;
            ymax=ceil(max(whitel.v(:,2)))+bordersize;
            zmin=floor(min(whitel.v(:,3)))-bordersize;
            zmax=ceil(max(whitel.v(:,3)))+bordersize;
            verts=piall.v;
        elseif lri==2
            cclabel=single(rm_cc.Thicknessr>0);
            in_pial=voxr.in_pial;
            in_white=voxr.in_white;
            xmin=floor(min(whiter.v(:,1)))-bordersize;
            xmax=ceil(max(whiter.v(:,1)))+bordersize;
            ymin=floor(min(whiter.v(:,2)))-bordersize;
            ymax=ceil(max(whiter.v(:,2)))+bordersize;
            zmin=floor(min(whiter.v(:,3)))-bordersize;
            zmax=ceil(max(whiter.v(:,3)))+bordersize;
            verts=pialr.v;
        end

        ribbon=(in_pial-in_white);
        ribbon(ribbon<0)=0;
        vid=find(ribbon>0);
        [vid_x,vid_y,vid_z]=ind2sub(size(ribbon),vid);
        pvv=[vid_y,vid_x,vid_z]*scale+[xmin ymin zmin]-scale/2;%convert to the same space as pialv, don't ask me why x and y are swapped, the indexing function swaps it.
        pvv_label=matchSurfLabel(cclabel,verts,pvv);    
        rmids=find(pvv_label==0);
        ind = sub2ind(size(ribbon),vid_x(rmids),vid_y(rmids),vid_z(rmids));
        ribbon(ind)=0;
        
        if lri==1
            voxl.ribbon=ribbon;
        elseif lri==2
            voxr.ribbon=ribbon;
        end
    
    else
        
        
        if lri==1
            GM=voxl.in_pial-voxl.in_white;
            GM=GM>0;
            voxl.ribbon=GM;
        elseif lri==2
            GM=voxr.in_pial-voxr.in_white;
            GM=GM>0;
            voxr.ribbon=GM;
        end
        
    end

end
%%
h=figure('Position',[0 0 210*4 297*4])

tiledlayout(2,2, 'Padding', 'none', 'TileSpacing', 'compact'); 

    nexttile    

imagesc(flipud(~voxl.ribbon(:,:,slicel)))
colormap gray
axis equal
zlim([-scale/2 +scale/2])
yl=max([size(voxl.in_pial,1) size(voxr.in_pial,1)]);
xl=max([size(voxl.in_pial,2) size(voxr.in_pial,2)]);
ylim([0 yl])
xlim([0 xl])
grid off
axis off

    nexttile    
imagesc(flipud(~voxr.ribbon(:,:,slicer)))
colormap gray
axis equal
zlim([-scale/2 +scale/2])
ylim([0 yl])
xlim([0 xl])
grid off
axis off



    nexttile    
trisurf(whitel.f,whitel.v_vox(:,1),whitel.v_vox(:,2),whitel.v_vox(:,3),'FaceColor',[0 1 0],'EdgeColor',[0 1 0],'LineWidth',2)
hold on
trisurf(piall.f,piall.v_vox(:,1),piall.v_vox(:,2),piall.v_vox(:,3),'FaceColor',[1 0 0],'EdgeColor',[1 0 0],'LineWidth',2)
hold off
axis equal
zlim([-scale/2 +scale/2])
ylim([0 yl])
xlim([0 xl])
view(0,90)
grid off
axis off

    nexttile    
trisurf(whiter.f,whiter.v_vox(:,1),whiter.v_vox(:,2),whiter.v_vox(:,3),'FaceColor',[0 1 0],'EdgeColor',[0 1 0],'LineWidth',2)
hold on
trisurf(pialr.f,pialr.v_vox(:,1),pialr.v_vox(:,2),pialr.v_vox(:,3),'FaceColor',[1 0 0],'EdgeColor',[1 0 0],'LineWidth',2)
hold off
axis equal
zlim([-scale/2 +scale/2])
ylim([0 yl])
xlim([0 xl])
view(0,90)
grid off
axis off
set(gcf,'color','w');



