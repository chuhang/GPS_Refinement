function [ middleline ] = findMiddleLine( img,lbfinal,rbfinal,cutlines,cutlabels,vervp,verla,vp,mask,display )
%find all intersections of non-vertical lines
useless=zeros(1,size(vp,1));
for ii=1:size(vp,1)
    if (vp(ii,1)==0) && (vp(ii,2)==0)
        useless(ii)=1;
    end
    if (vp(ii,1)>lbfinal) && (vp(ii,1)<rbfinal)
        useless(ii)=1;
    end
    if (vp(ii,2)>size(img,1)) || (vp(ii,2)<1)
        useless(ii)=1;
    end
end
horilines=cutlines(cutlabels~=verla,:);
horilabels=cutlabels(cutlabels~=verla,:);
yy=size(img,1);
inters=[];
for ii=1:(size(horilines,1)-1)
    if useless(horilabels(ii))==1
        continue;
    end
    l1=cross([horilines(ii,1:2),1],[horilines(ii,3:4),1]);
    for jj=2:size(horilines,1)
        if useless(horilabels(jj))==1
            continue;
        end
        if horilabels(ii)~=horilabels(jj)
            l2=cross([horilines(jj,1:2),1],[horilines(jj,3:4),1]);
            interhomo=cross(l1,l2);
            inter=round([interhomo(1)/interhomo(3),interhomo(2)/interhomo(3)]);
            l=cross([vervp,1],[inter,1]);
            xx=round((-l(3)-l(2)*yy)/l(1));
            if (xx>lbfinal) && (xx<rbfinal) && (inter(1)>1) && (inter(1)<size(img,2)) && (inter(2)>1) && (inter(2)<size(img,1))
                if mask(inter(2),inter(1))==1
                    inters=[inters;inter];
                end
            end
        end
    end
end
%find the middle vertical line
verlines=cutlines(cutlabels==verla,:);
linescores1=zeros(1,size(img,2));
inters=[inters,ones(size(inters,1),1)];
for ii=1:size(verlines,1)
    l=cross([vervp,1],[verlines(ii,1:2),1]);
    xx=round((-l(3)-l(2)*yy)/l(1));
    %if this line lays in the building region
    if (xx>lbfinal+20) && (xx<rbfinal-20)
        %if more than two intersects are on the line
        if length(inters)>35
            l=cross([verlines(ii,1:2),1],[verlines(ii,3:4),1]);
            l=l';
            dis=abs(inters*l)/sqrt(l(1)^2+l(2)^2);
            if sum((dis<10))>2
                linescores1(1,xx)=max([linescores1(1,xx),sqrt((verlines(ii,3)-verlines(ii,1))^2+(verlines(ii,4)-verlines(ii,2))^2)]);
            end
        else
            linescores1(1,xx)=max([linescores1(1,xx),sqrt((verlines(ii,3)-verlines(ii,1))^2+(verlines(ii,4)-verlines(ii,2))^2)]);
        end
    end
end
linescores2=zeros(1,size(img,2));
for ii=1:size(img,2)
    xmin=max([1,ii-20]);
    xmax=min([size(img,2),ii+20]);
    linescores2(1,ii)=0.1*sum(linescores1(xmin:xmax));
end
linescores3=linescores1+linescores2;
middleline=find(linescores3==max(linescores3));
%distribution of interxx
if display==1
    figure;
    plot(linescores3);
    figure;
    imshow(img);
    hold on;
    plot([vervp(1),lbfinal],[vervp(2),size(img,1)],'-');
    plot([vervp(1),rbfinal],[vervp(2),size(img,1)],'-');
    plot([vervp(1),middleline],[vervp(2),size(img,1)],'-');
end
end