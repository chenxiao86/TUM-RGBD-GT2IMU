function asm = v2asm(v)

if length(v) == 3
    asm = [0,-v(3),v(2);v(3),0,-v(1);-v(2),v(1),0];
else
    asm = [0,-v(6),v(5),v(1);
        v(6),0,-v(4),v(2);
        -v(5),v(4),0,v(3);
        0,0,0,0];
end