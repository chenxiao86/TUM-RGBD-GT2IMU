
g = [0;0;-9.8];
pBC = [0.04;0.02;-0.03];
qBC = [0.02;-0.01;-0.01;1]; qBC = qBC/norm(qBC);
Cbc = q2c(qBC);
na = 0.01;
ng = 0.001;

nba = 5e-4;
nbg = 2e-5;
ba = 1e-2*randn(3,1);
bg = 1e-4*randn(3,1);


%% 
j = 0;
% v0 = (pose(5:7,2) - pose(5:7,1))/dIMUt;
v0 = -(Re(:,:,3)'*te(:,3) - Re(:,:,1)'*te(:,1))/2/dIT;

iN = ceil((pN-2)/3);
wC(3,iN) = 0;
aC(3,iN) = 0;
wB(3,iN) = 0;
aB(3,iN) = 0;

am = zeros(3, iN);
wm = zeros(3, iN);


R(3,3,iN) = 0;
for i = 2:3:pN-1
    %% calculate the dynamic data for camera
    j = j+1;
    wC1 = logm( Re(:,:,i)*Re(:,:,i-1)')/dIT;
    wC2 = logm( Re(:,:,i+1)*Re(:,:,i)')/dIT;
    wC(:,j) = asm2v(-(wC1+wC2))/2;
    aC(:,j) = -Re(:,:,i)*(Re(:,:,i-1)'*te(:,i-1) + Re(:,:,i+1)'*te(:,i+1) - 2*Re(:,:,i)'*te(:,i))/dIT/dIT;
    
    %% calculate the dynamic data for IMU
    wB(:,j) = Cbc'*wC(:,j);
    aB(:,j) = Cbc'*Re(:,:,i)*( ...
        -Re(:,:,i-1)'*(te(:,i-1) + Cbc*pBC)...
        -Re(:,:,i+1)'*(te(:,i+1) + Cbc*pBC)...
        +2*Re(:,:,i)'*(te(:,i) + Cbc*pBC)...
        )/dIT/dIT;
    
    %% IMU signal simulation
    ba = ba + nba*randn(3,1);
    bg = bg + nbg*randn(3,1);
    
    am(:,j) = aB(:,j) - Cbc'*Re(:,:,i)*g + ba + na*randn(3,1);
    wm(:,j) = wB(:,j) + bg + ng*randn(3,1);
    
end


figure(3); subplot(2,1,1);plot(wC')
figure(3); subplot(2,1,2);plot(aC')
figure(103); subplot(2,1,1);plot(wB')
figure(103); subplot(2,1,2);plot(aB')

% save('IMU','a','w','dIMUt','v0','iN','R')