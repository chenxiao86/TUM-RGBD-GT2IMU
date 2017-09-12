
%% exam the IMU data.
X(:,1) = [pose(1:4,1)./sign(pose(4,1));v0;pose(5:7,1)];
g0 = [0;0;0];

it = (0:iN-1)*dIMUt;
for i = 1:iN
    X(:,i+1) = X(:,i) + RK4(X(:,i), @(x) state_pro(x, aC(:,i), wC(:,i), g0), dIMUt);
%     X(:,i+1) = X(:,i) + RK4(X(:,i), @(x) state_pro(x, aB(:,i), wB(:,i), g0), dIMUt);
    X(1:4,i+1) = X(1:4,i+1)/norm(X(1:4,i+1));
end

%% visualize the results
figure(4);
subplot(3,1,1);plot(it, X(1,2:end)); hold on; plot(timeStamp-timeStamp(1),pose(1,:)./sign(pose(4,:)))
subplot(3,1,2);plot(it, X(2,2:end)); hold on; plot(timeStamp-timeStamp(1),pose(2,:)./sign(pose(4,:)))
subplot(3,1,3);plot(it, X(3,2:end)); hold on; plot(timeStamp-timeStamp(1),pose(3,:)./sign(pose(4,:)))

figure(5);
subplot(3,1,1);plot(it(2:end), diff(X(8,2:end))); hold on; plot(timeStamp(2:end)-timeStamp(1),diff(pose(5,:)))
subplot(3,1,2);plot(it(2:end), diff(X(9,2:end))); hold on; plot(timeStamp(2:end)-timeStamp(1),diff(pose(6,:)))
subplot(3,1,3);plot(it(2:end), diff(X(10,2:end))); hold on; plot(timeStamp(2:end)-timeStamp(1),diff(pose(7,:)))

figure(6);
subplot(3,1,1);plot(it, X(8,2:end)); hold on; plot(timeStamp-timeStamp(1),pose(5,:))
subplot(3,1,2);plot(it, X(9,2:end)); hold on; plot(timeStamp-timeStamp(1),pose(6,:))
subplot(3,1,3);plot(it, X(10,2:end)); hold on; plot(timeStamp-timeStamp(1),pose(7,:))