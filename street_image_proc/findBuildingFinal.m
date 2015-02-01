function [ finalprob,leftbound,rightbound ] = findBuildingFinal( img,segsignal,colorsignal,inmasksignal,display )
%prior probability
ind=1:size(img,2);
%IMPORTANT PARAMETER: sigma of prior distribution
priorsigma=80;
priorprob=exp(-(ind-size(img,2)/2).^2/(priorsigma^2));
priorprob=max(priorprob)-priorprob;
priorprob=priorprob/sum(priorprob);

%line segment probability
segprob=zeros(1,size(img,2));
for ii=2:(size(img,2)-1)
    if (segsignal(1,ii)==0) && ((segsignal(1,ii-1)>0)||(segsignal(1,ii+1)>0))
        segprob(1,ii)=1;
    end
end
%IMPORTANT PARAMETER: sigma of gaussian filter
linesigma=15;
filtersize=100;
x=linspace(-filtersize/2,filtersize/2,filtersize);
gaussFilter=exp(-x.^2/(2*linesigma^2));
gaussFilter=gaussFilter/sum(gaussFilter);
segprob=conv(segprob,gaussFilter,'same');
if sum(segprob)>0
    segprob=segprob/sum(segprob);
end

%color derivative probability
colorprob=zeros(1,size(img,2));
for ii=2:(size(img,2)-1)
    diff1=sqrt((colorsignal(1,ii)-colorsignal(1,ii-1))^2+(colorsignal(2,ii)-colorsignal(2,ii-1))^2+(colorsignal(3,ii)-colorsignal(3,ii-1))^2);
    diff2=sqrt((colorsignal(1,ii)-colorsignal(1,ii+1))^2+(colorsignal(2,ii)-colorsignal(2,ii+1))^2+(colorsignal(3,ii)-colorsignal(3,ii+1))^2);
    colorprob(1,ii)=max([diff1,diff2]);
end
%IMPORTANT PARAMETER: sigma of gaussian filter
linesigma=2;
filtersize=10;
x=linspace(-filtersize/2,filtersize/2,filtersize);
gaussFilter=exp(-x.^2/(2*linesigma^2));
gaussFilter=gaussFilter/sum(gaussFilter);
colorprob=conv(colorprob,gaussFilter,'same');
colorprob=colorprob/sum(colorprob);

%mask width probability
maskprob=zeros(1,size(img,2));
windowsize=5;
for ii=1:size(img,2)
    xmin=max([1,ii-windowsize]);
    xmax=min([size(img,2),ii+windowsize]);
    window=inmasksignal(1,xmin:xmax);
    maskprob(1,ii)=(max(window)-min(window))/50;
    if maskprob(1,ii)>1
        maskprob(1,ii)=1;
    end
end
%IMPORTANT PARAMETER: sigma of gaussian filter
linesigma=2;
filtersize=10;
x=linspace(-filtersize/2,filtersize/2,filtersize);
gaussFilter=exp(-x.^2/(2*linesigma^2));
gaussFilter=gaussFilter/sum(gaussFilter);
maskprob=conv(maskprob,gaussFilter,'same');
maskprob=maskprob/sum(maskprob);

%final probability
finalprob=priorprob+segprob+colorprob+maskprob;
leftfinal=finalprob(1,1:round((size(img,2)/2)));
rightfinal=finalprob(1,round((size(img,2)/2)):size(img,2));
leftbound=find(leftfinal==max(leftfinal));
rightbound=find(rightfinal==max(rightfinal))+round((size(img,2)/2))-1;

%display results
if display==1
    figure;
    plot(priorprob);
    figure;
    plot(segprob);
    figure;
    plot(colorprob);
    figure;
    plot(maskprob);
    figure;
    plot(finalprob);
end
end