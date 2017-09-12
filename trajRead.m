

fid = fopen(filename);

timeStamp(100000) = 0;
pose(7,100000) = 0;
i = 0;
while ~feof(fid)
    tline = fgetl(fid);
    if tline(1) == '#', continue, end
    i = i + 1;
    
    dataIn = str2num(tline);
    
    timeStamp(i) = dataIn(1);
    pose(:,i) = dataIn([5:8,2:4]);
    
end
lth = find(timeStamp ~= 0, 1, 'last' );
timeStamp = timeStamp(1:lth);
pose = pose(:,1:lth);
save('GT','timeStamp','pose')