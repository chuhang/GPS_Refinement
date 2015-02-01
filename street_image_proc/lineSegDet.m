function [ lines ] = lineSegDet( img,display )
grayimg=rgb2gray(img);
addpath('./lsd-1.5/');
lines=lsd(double(grayimg));

if display==1
    imshow(img);
    hold on;
    for ii=1:length(lines)
        plot([lines(ii,1) lines(ii,3)],[lines(ii,2) lines(ii,4)],'Color','g','LineWidth',1);
    end
    hold off;
end
end