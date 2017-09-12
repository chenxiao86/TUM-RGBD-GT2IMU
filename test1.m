clear all
close all
clc
addpath tools
% 验证对于se(3)上的B样条函数，对控制点位姿的微分是否推导正确。Tt =
% exp(B*log(T1^-1*T2))。其中对T1增加一个扰动，查看Tt的扰动。推导的方程为
% 扰动=exp(B*log(T1^-1*exp(dZeta)^-1*T1))，其中dZeta = dT^。

q1 = randn(4,1); q1 = q1/norm(q1);
p1 = randn(3,1);
T1 = [q2c(q1),p1;0,0,0,1];

dth12 = 0.1*randn(3,1);
dp12 = 0.1*randn(3,1);
Zeta12 = [v2asm(dth12),dp12;0,0,0,0];
Td = expm(Zeta12);
T2 = Td*T1;

dth = 1e-4*randn(3,1);
dp = 1e-4*randn(3,1);
dZeta = [v2asm(dth),dp;0,0,0,0];
dT = expm(dZeta);
T1n = dT*T1;
T2n = dT*T2;

B = 0.9;
Tt = expm(B*logm(T2*T1^-1));
Tt1n = expm(B*logm(T2*T1n^-1));
Tt2n = expm(B*logm(T2n*T1^-1));

aa1 = Tt1n*Tt^-1 - eye(4)
bb1 = Td*expm(-B*logm(dT))*Td^-1 - eye(4)


aa2 = Tt2n*Tt^-1 - eye(4)
bb2 = expm(B*logm(dT)) - eye(4)

% dd = expm(B*logm((dT)^-1)) - eye(4)

% (aa-bb)./aa
% TT = expm(B*log())

%%
dj = 0.01*randn(6,1);
dJ = expm(v2asm(dj));

dK = Td*expm(-B*v2asm(dj))*Td^-1;
dk = asm2v(logm(dK))

R = Td(1:3,1:3); t = Td(1:3,4);
-B*[R,v2asm(t)*R;zeros(3),R]*dj



