function [ horiVPHeight,finalcornerpos ] = findHoriVP( img,vp,verla,cutlabels,lbfinal,rbfinal,middleline,display )
%find hori vps
equalthres=40;
vpscores=zeros(size(vp,1),1);
for ii=1:size(vp,1)
    if ii==verla
        continue;
    end
    for jj=1:size(vp,1)
        if abs(vp(jj,2)-vp(ii,2))<equalthres
            vpscores(ii)=vpscores(ii)+sum(cutlabels==jj);
        end
    end
    vpscores(ii)=vpscores(ii)+sum(cutlabels==ii);
end
[maxscore,ind]=max(vpscores);
horiVPHeight=vp(ind,2);
%compute intersections
vervp=vp(verla,:);
l=cross([1,horiVPHeight,1],[100,horiVPHeight,1]);
l1=cross([vervp,1],[lbfinal,size(img,1),1]);
l2=cross([vervp,1],[middleline,size(img,1),1]);
l3=cross([vervp,1],[rbfinal,size(img,1),1]);
in1=cross(l,l1);
in2=cross(l,l2);
in3=cross(l,l3);
finalcornerpos=[in1(1)/in1(3),in2(1)/in2(3),in3(1)/in3(3)];
%visualize
if display==1
    imshow(img);
    hold on;
    plot([1,size(img,2)],[horiVPHeight,horiVPHeight],'r-');
    %plot([size(img,2)/2,size(img,2)/2],[1,size(img,1)],'r-');
    plot([vervp(1),lbfinal],[vervp(2),size(img,1)],'-','LineWidth',3);
    plot([vervp(1),rbfinal],[vervp(2),size(img,1)],'-','LineWidth',3);
    plot([vervp(1),middleline],[vervp(2),size(img,1)],'-','LineWidth',3);
end
end