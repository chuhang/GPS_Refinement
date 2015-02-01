function [ segsignal,colorsignal,inmasksignal ] = findBuildingRegion( img,lines,labels,vp,mask,longind,verla,display )
%find vertical vp
vervp=vp(verla,:);
%compute span of every line
yy=size(img,1);
verspan=20;
spans=zeros(size(lines,1),2);
for ii=1:size(lines,1)
    if labels(ii)==verla
        l=cross([vervp,1],[lines(ii,1:2),1]);
        xx=(-l(3)-l(2)*yy)/l(1);
        if vervp(2)==-Inf
            xx=lines(ii,1);
        end
        xx1=xx-verspan;
        xx2=xx+verspan;
    else
        l1=cross([vervp,1],[lines(ii,1:2),1]);
        l2=cross([vervp,1],[lines(ii,3:4),1]);
        xx1=(-l1(3)-l1(2)*yy)/l1(1);
        xx2=(-l2(3)-l2(2)*yy)/l2(1);
        if vervp(2)==-Inf
            xx1=lines(ii,1);
            xx2=lines(ii,3);
        end
    end
    spans(ii,1)=xx1;
    spans(ii,2)=xx2;
    if xx2<xx1
        spans(ii,1:2)=[xx2,xx1];
    end
    if sum(longind==ii)==0
        spans(ii,1:2)=[-1000,-1000];
    end
end
%compute the line segment signal
segsignal=zeros(1,size(img,2));
for ii=1:size(img,2)
    segsignal(1,ii)=length(intersect(find(spans(:,1)<=ii),find(spans(:,2)>=ii)));
end
%compute the color signal and the in-mask number signal
colorsignal=zeros(3,size(img,2));
inmasksignal=zeros(1,size(img,2));
yys=1:size(img,1);
imgr=img(:,:,1);
imgg=img(:,:,2);
imgb=img(:,:,3);
for ii=1:size(img,2)
    l=cross([vervp,1],[ii,size(img,1),1]);
    xxs=round((-l(3)-l(2)*yys)/l(1));
    if vervp(2)==-Inf
        xxs=ones(1,size(img,1))*ii;
    end
    inds=(xxs-1)*size(img,1)+yys;
    nowmask=mask(inds);
    inds=inds(nowmask==1);
    inmasksignal(1,ii)=length(inds);
    nowr=imgr(inds);
    nowg=imgg(inds);
    nowb=imgb(inds);
    if isempty(inds)
        colorsignal(1,ii)=-100;
        colorsignal(2,ii)=-100;
        colorsignal(3,ii)=-100;
    else
        colorsignal(1,ii)=mean(nowr);
        colorsignal(2,ii)=mean(nowg);
        colorsignal(3,ii)=mean(nowb);
    end
end
%display results
if display==1
    figure;
    plot(segsignal);
    figure;
    showcolor=zeros(20,size(img,2),3);
    for ii=1:size(img,2)
        showcolor(:,ii,1)=colorsignal(1,ii);
        showcolor(:,ii,2)=colorsignal(2,ii);
        showcolor(:,ii,3)=colorsignal(3,ii);
    end
    showcolor=uint8(showcolor);
    imshow(showcolor);
    figure;
    plot(inmasksignal);
end
end