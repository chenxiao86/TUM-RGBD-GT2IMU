clear all
close all
clc
addpath tools
load GT

dT = 0.2;
% dT = 1;


sN = 3000;
pose = pose(:,1:sN);
tS = timeStamp(1:sN)-timeStamp(1);
tl = tS(end);
for i = 1:sN
    T = pose2T(pose(:,i));
    p0(:,i) = T(1:3,4);
    q0(:,i) = c2q(T(1:3,1:3));
end

%% prepare for the knots
kN = ceil(tl/dT)+1;
kT = (-1:kN)*dT;
pk = zeros(7, kN+2);

%% initialize the knots
Tk = zeros(4,4,kN+2);
for i = 1:kN+2
    [~,loc] = min( abs( kT(i)-tS ) );
%     pk(:,i) = pose(:, loc) + 0.01*randn(7,1);
    pk(:,i) = pose(:, loc);
    Tk(:,:,i) = pose2T(pk(:,i));
end


%% parameter of B-spline
B0 = @(u) 1;
B1 = @(u) (5 + 3*u - 3*u.^2 + 1*u.^3)/6;
B2 = @(u) (1 + 3*u + 3*u.^2 - 2*u.^3)/6;
B3 = @(u) (0 + 0*u + 0*u.^2 + 1*u.^3)/6;

%% minimizing

r = zeros(6*sN,1);
itrN = 50;
score = zeros(1,itrN);
for i = 1: itrN
    Jcb = sparse(zeros(6*sN, 6*(kN+2))); % a sparse matrix
    %% calculating the predicted sample point
    for j = 1:sN
        %% calculating the time of the point
        l = floor(tS(j)/dT) + 1; % from the first knot
        u = tS(j)/dT - (l-1);
        
        %% interpolation
        T3 = expm(B3(u)* logm( Tk(:,:,l+3)*Tk(:,:,l+2)^-1 ) ); R3 = T3(1:3,1:3); t3 = T3(1:3,4);
        T2 = expm(B2(u)* logm( Tk(:,:,l+2)*Tk(:,:,l+1)^-1 ) ); R2 = T2(1:3,1:3); t2 = T2(1:3,4);
        T1 = expm(B1(u)* logm( Tk(:,:,l+1)*Tk(:,:,l+0)^-1 ) ); R1 = T1(1:3,1:3); t1 = T1(1:3,4);
        T0 = Tk(:,:,l);                                        R0 = T0(1:3,1:3); t0 = T0(1:3,4);
        
        Te = T3*T2*T1*T0;
        
        %% residual
        Tm = pose2T(pose(:,j));
        dTme = Tm*Te^-1;
        dz = asm2v( logm(dTme) );
        r( (j-1)*6 + (1:6) ) = dz;
        
        %% jacobian
        J0 = B0(u)*T2J(T3*T2*T1) - B1(u)*T2J(T3*T2 * Tk(:,:,l+1)*Tk(:,:,l+0)^-1);
        J1 = B1(u)*T2J(T3*T2)    - B2(u)*T2J(T3    * Tk(:,:,l+2)*Tk(:,:,l+1)^-1);
        J2 = B2(u)*T2J(T3)       - B3(u)*T2J(        Tk(:,:,l+3)*Tk(:,:,l+2)^-1);
        J3 = B3(u)*eye(6);
        Jcb( (j-1)*6 + (1:6) , (l-1)*6 + (1:24) ) = [J0,J1,J2,J3];
        

        
        
    end
    
    %% solve
    dtheta = inv(Jcb'*Jcb)*Jcb'*r;
    for j = 1:kN+2
        
        Tk(:,:,j) = expm(v2asm(dtheta( (j-1)*6 + (1:6) ) )) * Tk(:,:,j);
        %%pk(:,j) = asm2v(logm(Tk(:,:,j)));
        
    end
    r'*r
    score(i) = r'*r;
    if i > 1
        if (score(i-1) - score(i))/score(i) < 0.01 && score(i) < score(i-1)
            score(i+1:end) = [];
            break
        end
    end
    i
end
score
%% continuous trajectory
dt = 0.01;
pN = ceil((kN-1)*dT/dt);
pp = zeros(3,pN);
qq = zeros(4,pN);
Te = zeros(4,4,pN);
tIMU = (0:pN-1)*dt;
for i = 1:pN
    pt = (i-1)*dt;
    
    %% calculating the time of the point
    l = floor(pt/dT) + 1; % from the first knot
    u = pt/dT - (l-1);
    
    %% interpolation
    T3 = expm(B3(u)* logm( Tk(:,:,l+3)*Tk(:,:,l+2)^-1 ) ); R3 = T3(1:3,1:3); t3 = T3(1:3,4);
    T2 = expm(B2(u)* logm( Tk(:,:,l+2)*Tk(:,:,l+1)^-1 ) ); R2 = T2(1:3,1:3); t2 = T2(1:3,4);
    T1 = expm(B1(u)* logm( Tk(:,:,l+1)*Tk(:,:,l+0)^-1 ) ); R1 = T1(1:3,1:3); t1 = T1(1:3,4);
    T0 = Tk(:,:,l);                                        R0 = T0(1:3,1:3); t0 = T0(1:3,4);
    
    Te(:,:,i) = T3*T2*T1*T0;
    pp(:,i) = Te(1:3,4,i);
    qq(:,i) = c2q(Te(1:3,1:3,i));
end


%% 
figure(1)
subplot(3,1,1); plot(kT, squeeze(Tk(1,4,:))); hold on; plot(tS, p0(1,:)); plot((0:pN-1)*dt, pp(1,:))
subplot(3,1,2); plot(kT, squeeze(Tk(2,4,:))); hold on; plot(tS, p0(2,:)); plot((0:pN-1)*dt, pp(2,:))
subplot(3,1,3); plot(kT, squeeze(Tk(3,4,:))); hold on; plot(tS, p0(3,:)); plot((0:pN-1)*dt, pp(3,:))

figure(2)
subplot(3,1,1); hold on; plot(tS, q0(1,:)); plot((0:pN-1)*dt, qq(1,:))
subplot(3,1,2); hold on; plot(tS, q0(2,:)); plot((0:pN-1)*dt, qq(2,:))
subplot(3,1,3); hold on; plot(tS, q0(3,:)); plot((0:pN-1)*dt, qq(3,:))

save('Bs','kT','Tk','dT','tIMU','Te','dt','B0','B1','B2','B3','tl')