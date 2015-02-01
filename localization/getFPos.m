function [ f,pos1,pos2,pos3 ] = getFPos( inpos1,inpos2,inpos3,horiVPHeight,verVP )
halfheight=329;
halfwidth=558;
%scalefactor=26;
h1=horiVPHeight-halfheight;
h2=-verVP+halfheight;
f=sqrt(h1*h2);
h=h1+h2;
x=(h-sqrt(h*h-4*f*f))/2;
y=(h+sqrt(h*h-4*f*f))/2;
if h1<h2
    tilt=atan(x/f);
else
    tilt=atan(y/f);
end
ratio=1/cos(tilt);
pos1=(inpos1-halfwidth)/(ratio);
pos2=(inpos2-halfwidth)/(ratio);
pos3=(inpos3-halfwidth)/(ratio);
%f=f/scalefactor;
end