function [ thetaout,xout,yout ] = solvePosOrienNew( pt1,pt2,pt3,pos1,pos2,pos3,f )
x1=pt1(1);y1=pt1(2);
x2=pt2(1);y2=pt2(2);
x3=pt3(1);y3=pt3(2);
%syms tx1 tx2 tx3 ty1 ty2 ty3 tf tpos1 tpos2 tpos3
% thetares=subs(Solution3pts.phi,{tx1 tx2 tx3 ty1 ty2 ty3 tf tpos1 tpos2 tpos3},{x1 x2 x3 y1 y2 y3 f pos1 pos2 pos3});
% xres=subs(Solution3pts.x,{tx1 tx2 tx3 ty1 ty2 ty3 tf tpos1 tpos2 tpos3},{x1 x2 x3 y1 y2 y3 f pos1 pos2 pos3});
% yres=subs(Solution3pts.y,{tx1 tx2 tx3 ty1 ty2 ty3 tf tpos1 tpos2 tpos3},{x1 x2 x3 y1 y2 y3 f pos1 pos2 pos3});
[ thetares,xres,yres ] = solutionSub( x1,x2,x3,y1,y2,y3,pos1,pos2,pos3,f );
sel=1;
if size(thetares,1)==2
    if (thetares(1)>=0) && (thetares(1)<pi)
        sel=1;
    else
        sel=2;
    end
    thetaout=thetares(sel);
    xout=xres(sel);
    yout=yres(sel);
end
if size(thetares,1)==1
    thetaout=thetares(sel);
    xout=xres(sel);
    yout=yres(sel);
end
if size(thetares,1)==0
    thetaout=NaN;
    xout=NaN;
    yout=NaN;
end
if y2<yout
    thetaout=thetaout+pi;
end
end