function J = T2J( T )
R = T(1:3,1:3);
t = T(1:3,4);

J = [R, v2asm(t)*R; zeros(3), R];
