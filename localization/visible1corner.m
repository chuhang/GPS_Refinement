function [ isvisible ] = visible1corner( ptxpos,ptypos,blocks,whichblock,whichcorner )
isvisible=1;
sightline=cross([ptxpos,ptypos,1],[blocks(whichblock).pts(whichcorner,:),1]);
minx=min([ptxpos,blocks(whichblock).pts(whichcorner,1)]);
maxx=max([ptxpos,blocks(whichblock).pts(whichcorner,1)]);
for ii=1:length(blocks)
    nowpts=blocks(ii).pts;
    if ii==whichblock
        if whichcorner==1
            somept1=[nowpts(2,:),1;nowpts(3,:),1];
            somept2=[nowpts(3,:),1;nowpts(4,:),1];
        end
        if whichcorner==2
            somept1=[nowpts(3,:),1;nowpts(4,:),1];
            somept2=[nowpts(4,:),1;nowpts(1,:),1];
        end
        if whichcorner==3
            somept1=[nowpts(4,:),1;nowpts(1,:),1];
            somept2=[nowpts(1,:),1;nowpts(2,:),1];
        end
        if whichcorner==4
            somept1=[nowpts(1,:),1;nowpts(2,:),1];
            somept2=[nowpts(2,:),1;nowpts(3,:),1];
        end
        buildingbounds=cross(somept1,somept2,2);
        somept3=repmat(sightline,2,1);
        inters=cross(somept3,buildingbounds,2);
        inters=[inters(:,1)./inters(:,3),inters(:,2)./inters(:,3)];
        somexdata=[somept1(:,1)';somept2(:,1)'];
        minxdata=min(somexdata);
        maxxdata=max(somexdata);
        onsight=intersect(find(inters(:,1)<maxx),find(inters(:,1)>minx));
        onbound=intersect(find(inters(:,1)<maxxdata'),find(inters(:,1)>minxdata'));
        if ~isempty(intersect(onsight,onbound))
            isvisible=0;
            break;
        end
    else
        somept1=[nowpts,ones(size(nowpts,1),1)];
        somept2=[nowpts(2:end,:);nowpts(1,:)];
        somept2=[somept2,ones(size(nowpts,1),1)];
        buildingbounds=cross(somept1,somept2,2);
        somept3=repmat(sightline,size(nowpts,1),1);
        inters=cross(somept3,buildingbounds,2);
        inters=[inters(:,1)./inters(:,3),inters(:,2)./inters(:,3)];
        somexdata=[somept1(:,1)';somept2(:,1)'];
        minxdata=min(somexdata);
        maxxdata=max(somexdata);
        onsight=intersect(find(inters(:,1)<maxx),find(inters(:,1)>minx));
        onbound=intersect(find(inters(:,1)<maxxdata'),find(inters(:,1)>minxdata'));
        if ~isempty(intersect(onsight,onbound))
            isvisible=0;
            break;
        end
    end
end
end