img=imread('example_street_image.jpg');
cd ./street_image_proc/
run
imgproc_results=[finalcornerpos,horiVPHeight,vervp(2)];
clearvars -EXCEPT imgproc_results
cd ..
load('example_mapdata.mat');
cd ./localization/
[ thetaall,xall,yall,visibleall ] = solveOneLocData( mapimg,blocks,imgproc_results,1,1 );
cd ..
