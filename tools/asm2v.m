function v = asm2v(asm)

if length(asm) == 3
    v(1,1) = asm(3,2);
    v(2,1) = asm(1,3);
    v(3,1) = asm(2,1);
else
    v(1:3,1) = asm(1:3,4);
    v(4,1) = asm(3,2);
    v(5,1) = asm(1,3);
    v(6,1) = asm(2,1);
end