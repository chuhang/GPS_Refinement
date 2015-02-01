function [ L ] = imgSegmentation( img,display )
%convert to gray
I=rgb2gray(img);
%detect gradient
hy=fspecial('sobel');
hx=hy';
Iy=imfilter(double(I),hy,'replicate');
Ix=imfilter(double(I),hx,'replicate');
gradmag=sqrt(Ix.^2+Iy.^2);
%opening and closing
se=strel('disk',20);
Io=imopen(I,se);
Ie=imerode(I,se);
Iobr=imreconstruct(Ie,I);
Ioc=imclose(Io,se);
Iobrd=imdilate(Iobr,se);
Iobrcbr=imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr=imcomplement(Iobrcbr);
fgm=imregionalmax(Iobrcbr);
se2=strel(ones(5,5));
fgm2=imclose(fgm,se2);
fgm3=imerode(fgm2,se2);
fgm4=bwareaopen(fgm3,20);
%compute background markers
bw=im2bw(Iobrcbr,graythresh(Iobrcbr));
D=bwdist(bw);
DL=watershed(D);
bgm=DL==0;
%watershed
gradmag2=imimposemin(gradmag,bgm|fgm4);
L=watershed(gradmag2);
%visualize
Lrgb=label2rgb(L,'jet','w','shuffle');
if display==1
    figure,imshow(I),hold on
    himage=imshow(Lrgb);
    set(himage,'AlphaData',0.5);
end
end