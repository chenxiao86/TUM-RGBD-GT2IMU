function T = pose2T( pose )
 
R = q2c(pose(1:4));
p = pose(5:7);

T = [R,-R*p;0,0,0,1];