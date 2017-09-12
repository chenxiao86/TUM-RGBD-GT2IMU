function R = q2c( q )
%Q2R 此处显示有关此函数的摘要
%   此处显示详细说明

v = q(1:3); q4 = q(4); qx = [0, -q(3), q(2); q(3), 0, -q(1); -q(2), q(1), 0];

R = (2*q4^2 - 1)*eye(3) - 2*q4*qx + 2*v*reshape(v,1,3);%这个公式有问题
% R = (2*q4^2 - 1)*eye(3) + 2*q4*qx + 2*v*reshape(v,1,3);%很可能应该是这样的
% R = R';
% 
% qr = q(4);qi = q(1); qj = q(2); qk = q(3);
% R = [1-2*qj^2-2*qk^2, 2*(qi*qj-qk*qr), 2*(qi*qk+qj*qr);
% 2*(qi*qj+qk*qr), 1-2*qi^2-2*qk^2, 2*(qj*qk-qi*qr);
% 2*(qi*qk-qj*qr), 2*(qj*qk+qi*qr), 1- 2*qi^2-2*qj^2];