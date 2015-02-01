function [ thetasol,xsol,ysol,visiblesol ] = solveAllBlocks( mapimg,blocks,pos1,pos2,pos3,f,checkvisibility,display )
for ii=1:length(blocks)
    pts=blocks(ii).pts;
    [thetanow,xnow,ynow]=solveBlock(pts,pos1,pos2,pos3,f,0);
    if checkvisibility==1
    visiblenow=zeros(4,1);
    if (visible1corner( xnow(1),ynow(1),blocks,ii,1 )==1) && (visible1corner( xnow(1),ynow(1),blocks,ii,2 )==1) && (visible1corner( xnow(1),ynow(1),blocks,ii,3 )==1)
        visiblenow(1,1)=1;
    end
    if (visible1corner( xnow(2),ynow(2),blocks,ii,2 )==1) && (visible1corner( xnow(2),ynow(2),blocks,ii,3 )==1) && (visible1corner( xnow(2),ynow(2),blocks,ii,4 )==1)
        visiblenow(2,1)=1;
    end
    if (visible1corner( xnow(3),ynow(3),blocks,ii,3 )==1) && (visible1corner( xnow(3),ynow(3),blocks,ii,4 )==1) && (visible1corner( xnow(3),ynow(3),blocks,ii,1 )==1)
        visiblenow(3,1)=1;
    end
    if (visible1corner( xnow(4),ynow(4),blocks,ii,4 )==1) && (visible1corner( xnow(4),ynow(4),blocks,ii,1 )==1) && (visible1corner( xnow(4),ynow(4),blocks,ii,2 )==1)
        visiblenow(4,1)=1;
    end
    else
    visiblenow=ones(4,1);
    end
    thetasol(((ii-1)*4+1):(ii*4),1)=thetanow;
    xsol(((ii-1)*4+1):(ii*4),1)=xnow;
    ysol(((ii-1)*4+1):(ii*4),1)=ynow;
    visiblesol(((ii-1)*4+1):(ii*4),1)=visiblenow;
end
if display==1;
    figure;
    imshow(mapimg);
    hold on;
    for ii=1:length(thetasol)
        if visiblesol(ii)==1
            plot(xsol(ii,1),size(mapimg,1)-ysol(ii,1),'.','MarkerSize',15);
            sightlen=50;
            xsi=xsol(ii,1)+sightlen*cos(thetasol(ii,1));
            ysi=ysol(ii,1)+sightlen*sin(thetasol(ii,1));
            plot([xsol(ii,1),xsi],[size(mapimg,1)-ysol(ii,1),size(mapimg,1)-ysi]);
        end
    end
end
end