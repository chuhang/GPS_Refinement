#Matlab Code & Dataset for 
###GPS Refinement and Camera Orientation Estimation from a Single Image and a 2D Map
-Hang Chu


###How to use
* Run the script demo.m. If everything works, two figures will show up. The first shows a building image and the identified corner edges. The second shows the location and orientation with the correct corner correspondence (the big blue * and the blue line), the visible location hypotheses with incorrect corner correspondences, the red dot marks the building in the street image.

* The code was written and tested under Windows 7(64 bit) and Matlab R2012a.

* Tips if you can't run the demo: 

	* If you are working under a different system and the demo doesn't run correctly, but you still want to test the full algorithm. You might want to consider: 1. Recompile what is in ./streetimage\_proc/lsd1.5/. 2. Use your own vanishing point detection code to replace ./streetimage_proc/vpdetect.exe.

	* "What?! That's too complicated!" or "You lier! I tried everything but this crap still doesn't work!" Don't worry, if you look at the code in demo.m you will find out the outcome of street image processing is pretty simple: a 5-d vector called "imgproc\_results". Check its data structure description below, compose your own "imgproc\_results", and proceed. Everything in the ./localization/ folder are pure Matlab and will definitely work.

###Data structure
* "imgproc\_results": 1-by-5 row vector. The first three dimensions are x coordinates of the intersections of the left, middle, and right corner edges and the horizon; The fourth dimension is the y coordinate of the horizon; The fifth dimension is the y coordinate of the vertical vanishing point.
* "blocks": a 1-by-k struct. k is the number of building blocks. The struct member pts are coordinates of building block corners.
		
	* Note 1: for simplicity I limit the number of corners of a building block to 4, this isn't general. However, the program can be easily extended to being able to process more than 4 corners.
	* Note 2: in my implementation I always arrange my "blocks" such that the first 3 corner points of the first block has the correct corner correspondence. This is just my strange, non-intuitive way of labelling the ground-truth. In a real-world application where we don't know which corners are the correct correspondence, read the gps position and use the closest hypothesis as the refinement result. 
* "thetaall": a 4k-by-1 vector. The orientation of all hypothesis.
* "xall", "yall": 4k-by-1 vectors. The location of all hypothesis.
* "visibleall": 4k-by-1 vector. The visibility check results of all hypothesis.
	
###The dataset
* Street building images:
	* 390 images from Google Street View, collected from 11 unique locations. 3 pairs of locations are quite near to each other, and share the similar regional map.
	* Note: as my corner detection algorithm relies heavily on line detection, I manually enhanced some corner edges in some images so that at least one line segment can be detected at each corner location.
* Maps:
	* Stored as .mat files. In each file, "mapimg" is the regional map, "blocks" are the corner points of buildings in the regional map, "groundtruth_loc" is the ground truth location where the street images are taken.