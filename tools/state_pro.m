function [dX] = state_pro(X, a_m, w_m, g)
q = X(1:4); 
vB = X(5:7);

C = q2c(q);

w = w_m;
wx = [0, -w(3), w(2);
    w(3), 0, -w(1);
    -w(2), w(1), 0];
omg = [-wx, w;-w',0];

dq = 0.5* omg * q;

dvB = C' * (a_m) + g;
dpB = vB;

dX = [dq; dvB; dpB];
