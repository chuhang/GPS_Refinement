function [ newimg,mask ] = segSel( img,L )
% selL=L(round(size(L,1)/2),round(size(L,2)/2));
middley=round(size(L,1)/2);
middlex=round(size(L,2)/2);
middle=L(middley-10:middley+10,middlex-10:middlex+10);
Ls=unique(middle);
mask=(L==Ls(1));
for ii=1:length(Ls)
    mask=mask|(L==Ls(ii));
end
imgr=img(:,:,1);
imgg=img(:,:,2);
imgb=img(:,:,3);
newr=zeros(size(img,1),size(img,2));
newg=zeros(size(img,1),size(img,2));
newb=zeros(size(img,1),size(img,2));
newr(mask)=imgr(mask);
newg(mask)=imgg(mask);
newb(mask)=imgb(mask);
newimg=img;
newimg(:,:,1)=newr;
newimg(:,:,2)=newg;
newimg(:,:,3)=newb;
end