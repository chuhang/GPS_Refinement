function [ thetaout,xout,yout ] = solveBlock( pts,pos1,pos2,pos3,f,display )
[ thetaout(1,1),xout(1,1),yout(1,1) ] = solvePosOrienNew( pts(1,:),pts(2,:),pts(3,:),pos1,pos2,pos3,f(1) );
[ thetaout(2,1),xout(2,1),yout(2,1) ] = solvePosOrienNew( pts(2,:),pts(3,:),pts(4,:),pos1,pos2,pos3,f(1) );
[ thetaout(3,1),xout(3,1),yout(3,1) ] = solvePosOrienNew( pts(3,:),pts(4,:),pts(1,:),pos1,pos2,pos3,f(1) );
[ thetaout(4,1),xout(4,1),yout(4,1) ] = solvePosOrienNew( pts(4,:),pts(1,:),pts(2,:),pos1,pos2,pos3,f(1) );
if display==1
    figure;
    hold on;
    plot([pts(1,1),pts(2,1)],[pts(1,2),pts(2,2)],'k-');
    plot([pts(2,1),pts(3,1)],[pts(2,2),pts(3,2)],'k-');
    plot([pts(3,1),pts(4,1)],[pts(3,2),pts(4,2)],'k-');
    plot([pts(4,1),pts(1,1)],[pts(4,2),pts(1,2)],'k-');
    plot(xout(1,1),yout(1,1),'.');
    plot(xout(2,1),yout(2,1),'.');
    plot(xout(3,1),yout(3,1),'.');
    plot(xout(4,1),yout(4,1),'.');
end
end