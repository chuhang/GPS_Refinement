function [ lines ] = filtericons( img,lines,display )
filtered=ones(size(lines,1),1);
iconarea=zeros(size(img,1),size(img,2));
iconarea(1:40,600:size(img,2))=1;
iconarea(600:size(img,1),920:size(img,2))=1;
iconarea(1:10,1:size(img,2))=1;
iconarea(1:size(img,1),1:10)=1;
for ii=1:size(lines,1)
    pt1=round(lines(ii,1:2));
    pt1(pt1<=0)=1;
    pt2=round(lines(ii,3:4));
    pt2(pt2<=0)=1;
    if iconarea(pt1(2),pt1(1))==1 || iconarea(pt2(2),pt2(1))==1
        filtered(ii)=0;
    end
end
lines=lines(filtered==1,:);
if display==1
    imshow(img);
    hold on;
    for ii=1:length(lines)
        plot([lines(ii,1) lines(ii,3)],[lines(ii,2) lines(ii,4)],'Color','g','LineWidth',1);
    end
    hold off;
end
end