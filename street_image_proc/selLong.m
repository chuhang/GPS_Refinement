function [ longlines,longind ] = selLong( img,lines,linenum,display )
dis=sqrt((lines(:,3)-lines(:,1)).^2+(lines(:,4)-lines(:,2)).^2);
[newdis,ind]=sort(dis,'descend');
ind=ind(1:linenum);
longlines=lines(ind,:);
longind=ind;

if display==1
    imshow(img);
    hold on;
    for ii=1:length(longlines)
        plot([longlines(ii,1) longlines(ii,3)],[longlines(ii,2) longlines(ii,4)],'Color','g','LineWidth',1);
    end
    hold off;
end
end