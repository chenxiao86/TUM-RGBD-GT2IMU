function dX = RK4( X, fx, dT)
%RK4 此处显示有关此函数的摘要
%   此处显示详细说明

k1 = fx(X);
k2 = fx(X + dT/2 * k1);
k3 = fx(X + dT/2 * k2);
k4 = fx(X + dT * k3);

dX = dT/6 * (k1 + 2*k2 + 2*k3 + k4);

