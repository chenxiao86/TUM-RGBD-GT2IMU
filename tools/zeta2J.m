function J = zeta2J( zeta )

if length(zeta) > 3
    phi = zeta(4:6);
else
    phi = zeta;
    
theta = norm(phi);
if theta == 0
    J = eye(3);
    return
end

a = phi/theta;

J = sin(theta)/theta + (1-sin(theta)/theta)*a*a' + (1-cos(theta)/theta)*v2asm(a);