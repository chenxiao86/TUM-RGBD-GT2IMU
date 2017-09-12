clear all
close all
clc
addpath tools
load Bs

C = [6 0 0 0;
    5 3 -3 1;
    1 3 3 -2;
    0 0 0 1]/6;
dB0 = @(u) C(1,:)*[0; 1; 2*u; 3*u^2]/dT;
dB1 = @(u) C(2,:)*[0; 1; 2*u; 3*u^2]/dT;
dB2 = @(u) C(3,:)*[0; 1; 2*u; 3*u^2]/dT;
dB3 = @(u) C(4,:)*[0; 1; 2*u; 3*u^2]/dT;
ddB0 = @(u) C(1,:)*[0; 0; 2; 6*u]/dT/dT;
ddB1 = @(u) C(2,:)*[0; 0; 2; 6*u]/dT/dT;
ddB2 = @(u) C(3,:)*[0; 0; 2; 6*u]/dT/dT;
ddB3 = @(u) C(4,:)*[0; 0; 2; 6*u]/dT/dT;

dkT = dT;
dIT = dt;

pN = size(Te,3);
w = zeros(3,pN);
v = zeros(3,pN);
a = zeros(3,pN);
p = zeros(3,pN);

for i = 1:pN
    pt = (i-1)*dIT;
    
    %% calculating the time of the point
    l = floor(pt/dkT) + 1; % from the first knot
    u = pt/dkT - (l-1);
    
    %% interpolation

    
    Omg3 = logm( Tk(:,:,l+3)*Tk(:,:,l+2)^-1 );
    Omg2 = logm( Tk(:,:,l+2)*Tk(:,:,l+1)^-1 );
    Omg1 = logm( Tk(:,:,l+1)*Tk(:,:,l+0)^-1 );
    
    
    T3 = expm(B3(u)* Omg3 );
    T2 = expm(B2(u)* Omg2 );
    T1 = expm(B1(u)* Omg1 );
    T0 = Tk(:,:,l);      
    
    dT3 = dB3(u)*Omg3;
    dT2 = dB2(u)*Omg2;
    dT1 = dB1(u)*Omg1;
    
    ddT3 = ddB3(u)*Omg3 + dB3(u)^2*Omg3^2;
    ddT2 = ddB2(u)*Omg2 + dB2(u)^2*Omg2^2;
    ddT1 = ddB1(u)*Omg1 + dB1(u)^2*Omg1^2;
    
    dT = (dT3*T2*T1 + T3*dT2*T1 + T3*T2*dT1)*T0;
    dR = dT(1:3,1:3); dt = dT(1:3,4);
    ddT = (ddT3*T2*T1 + T3*ddT2*T1 + T3*T2*ddT1 + ...
        2*dT3*dT2*T1 + 2*dT3*T2*dT1 + 2*T3*dT2*dT1)*T0;
    ddt = ddT(1:3,4);

    Te = T3*T2*T1*T0;
    Re = Te(1:3,1:3); te = Te(1:3,4);
    
    w(:,i) = asm2v(Re'*dR);
    a(:,i) = Re'*ddt;
    v(:,i) = dt;
    p(:,i) = -Re'*te;
    

end
figure(1);
subplot(2,2,1); plot(w'); title('w')
subplot(2,2,2); plot(diff(diff(p'))/dIT/dIT); title('a')
subplot(2,2,3); plot(diff(p')/dIT); title('v')
subplot(2,2,4); plot(p'); title('p')

figure(2);
subplot(2,2,1); plot(w'); title('w')
subplot(2,2,2); plot(a'); title('a')
subplot(2,2,3); plot(v'); title('v')
subplot(2,2,4); plot(p'); title('p')
