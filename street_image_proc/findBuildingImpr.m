function [ lbfinal,rbfinal,cutlines,cutlabels,vervp ] = findBuildingImpr( img,vp,verla,lines,labels,leftbound,rightbound,longind,display )
%adjust the bound
vervp=vp(verla,:);
yy=size(img,1);
pts=[];
for ii=1:size(lines,1)
    if (labels(ii)==verla) && (sum(longind==ii)==1)
        l=cross([vervp,1],[lines(ii,1:2),1]);
        xx=(-l(3)-l(2)*yy)/l(1);
        pts=[pts,xx];
    end
end
lfpts=pts(pts>(leftbound-20));
lbfinal=round(min(lfpts));
rtpts=pts(pts<(rightbound+20));
rbfinal=round(max(rtpts));
%select lines that are in the boundary
linesel=zeros(size(lines,1),1);
for ii=1:size(lines,1)
    l1=cross([vervp,1],[lines(ii,1:2),1]);
    l2=cross([vervp,1],[lines(ii,3:4),1]);
    xx1=(-l1(3)-l1(2)*yy)/l1(1);
    xx2=(-l2(3)-l2(2)*yy)/l2(1);
    if (xx1>(lbfinal-10)) && (xx1<(rbfinal+10)) && (xx2>(lbfinal-10)) && (xx2<(rbfinal+10))
        linesel(ii)=1;
    end
end
cutlines=lines(linesel==1,:);
cutlabels=labels(linesel==1,:);

if display==1
    imshow(img);
    hold on;
    plot([vervp(1),lbfinal],[vervp(2),size(img,1)],'-');
    plot([vervp(1),rbfinal],[vervp(2),size(img,1)],'-');
    for ii=1:size(cutlines,1)
        plot([cutlines(ii,1),cutlines(ii,3)],[cutlines(ii,2),cutlines(ii,4)],'-g');
    end
end
end