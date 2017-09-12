% clear all
close all
% clc
addpath tools
load Bs
% time 0 is the start time of the Ground-truth

dkT = dT;
dIMUt = 0.01;
dIT = dIMUt/3;

%% trajectory generation
pN = ceil(tl/dIT)+3; %from -1 to ceil(tl/dIT) + 1

Re = zeros(3,3,pN);
qe = zeros(4,pN);
te = zeros(3,pN);
for i = 1:pN
    pt = (i-2)*dIT;
    
    %% calculating the time of the point
    l = floor(pt/dkT) + 1; % from the first knot
    u = pt/dkT - (l-1);
    
    %% interpolation
    if l>0
        TKl0 = Tk(:,:,l+0);
    else
        TKl0 = Tk(:,:,1);
    end

    
    Omg3 = logm( Tk(:,:,l+3)*Tk(:,:,l+2)^-1 );
    Omg2 = logm( Tk(:,:,l+2)*Tk(:,:,l+1)^-1 );
    Omg1 = logm( Tk(:,:,l+1)*TKl0^-1 );
    
    T3 = expm(B3(u)* Omg3 );
    T2 = expm(B2(u)* Omg2 );
    T1 = expm(B1(u)* Omg1 );
    T0 = TKl0;      
    

    Te = T3*T2*T1*T0;
    Re(:,:,i) = Te(1:3,1:3);
    qe(:,i) = c2q(Te(1:3,1:3));
    te(:,i) = Te(1:3,4);
    
    i/pN
    
end
load GT
figure(101);plot(((1:pN)-2)*dIT,-qe(1,:)); hold on; plot(timeStamp-timeStamp(1),pose(1,:))
figure(102);plot(((1:pN)-2)*dIT,-te(1,:)); hold on; plot(timeStamp-timeStamp(1),pose(5,:))