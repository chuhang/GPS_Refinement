%image segmentation
[ L ] = imgSegmentation( img,0 );
%select central segment
[ newimg,mask ] = segSel( img,L );
%line segment detection
[ lines ] = lineSegDet( newimg,0 );
[ lines ] = filtericons( newimg,lines,0 );
%vp detection
save('lines.tmp', 'lines', '-ascii', '-tabs');
%disp(['[vpdetection] begin, might take a while, please wait...']);
tic
[status, result] = system('vpdetection lines.tmp lines.out');
t = toc;
%disp(['[vpdetection] end, ',num2str(t),' seconds elapsed.']);
out = load('lines.out');
lines = out(:,1:4);
labels = uint8(out(:,5)+1);
%find vp
[ vp,verla ] = findVP( newimg,lines,labels );
%find long lines
longlinenum=min(size(lines,1),70);
[ longlines,longind ] = selLong( newimg,lines,longlinenum,0 );
%detect left & right bounds
[ segsignal,colorsignal,inmasksignal ] = findBuildingRegion( newimg,lines,labels,vp,mask,longind,verla,0 );
[ finalprob,leftbound,rightbound ] = findBuildingFinal( newimg,segsignal,colorsignal,inmasksignal,0 );
[ lbfinal,rbfinal,cutlines,cutlabels,vervp ] = findBuildingImpr( newimg,vp,verla,lines,labels,leftbound,rightbound,longind,0 );
%detect middle corner
[ middleline ] = findMiddleLine( newimg,lbfinal,rbfinal,cutlines,cutlabels,vervp,verla,vp,mask,0 );
%find 1-d positions
[ horiVPHeight,finalcornerpos ] = findHoriVP( img,vp,verla,cutlabels,lbfinal,rbfinal,middleline,1 );