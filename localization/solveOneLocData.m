function [ thetaall,xall,yall,visibleall ] = solveOneLocData( mapimg,blocks,inputdata,checkvisibility,display )
num1=4*length(blocks);
for ii=1:size(inputdata,1)
    [ f(ii),pos1,pos2,pos3 ] = getFPos( inputdata(ii,1),inputdata(ii,2),inputdata(ii,3),inputdata(ii,4),inputdata(ii,5) );
    [ thetaall(1:num1,ii),xall(1:num1,ii),yall(1:num1,ii),visibleall(1:num1,ii) ] = solveAllBlocks( mapimg,blocks,pos1,pos2,pos3,f(ii),checkvisibility,0 );
end
if display==1
    figure;
    imshow(mapimg);
    hold on;
    plot(xall(1,1),size(mapimg,1)-yall(1,1),'b*','MarkerSize',15);
    sightlen=500;
    xsi=xall(1,1)+sightlen*cos(thetaall(1,1));
    ysi=yall(1,1)+sightlen*sin(thetaall(1,1));
    plot([xall(1,1),xsi],[size(mapimg,1)-yall(1,1),size(mapimg,1)-ysi],'LineWidth',1);
    for ii=2:length(thetaall)
        if visibleall(ii)==1
            plot(xall(ii,1),size(mapimg,1)-yall(ii,1),'bo','MarkerSize',5);
        end
    end
end
end