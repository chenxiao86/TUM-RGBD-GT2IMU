
load GT
t0 = timeStamp(1);

fidC = fopen('data_C.txt','w');
fidB = fopen('data_B.txt','w');
fidm = fopen('data.txt','w');

fwrite(fidC,sprintf('# timestamp wx wy wz ax ay az \n'));
fwrite(fidB,sprintf('# timestamp wx wy wz ax ay az \n'));
fwrite(fidm,sprintf('# timestamp wx wy wz ax ay az \n'));
for i = 1:iN

    time = t0 + (i-1)*dIMUt;
    
    fwrite(fidC,sprintf('%4f %4f %4f %4f %4f %4f %4f\n', time, wC(1,i), wC(2,i), wC(3,i), aC(1,i), aC(2,i), aC(3,i) ));
    fwrite(fidB,sprintf('%4f %4f %4f %4f %4f %4f %4f\n', time, wB(1,i), wB(2,i), wB(3,i), aB(1,i), aB(2,i), aB(3,i) ));
    fwrite(fidm,sprintf('%4f %4f %4f %4f %4f %4f %4f\n', time, wm(1,i), wm(2,i), wm(3,i), am(1,i), am(2,i), am(3,i) ));
    
    
end