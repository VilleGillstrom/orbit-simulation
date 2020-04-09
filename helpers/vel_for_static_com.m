function [Vx, Vy] = vel_for_static_com(M,m,vx, vy)
%VEL_FOR_STATIC_COM Get the velocity needed for a body with mass M 
% to make the system's center of mass static
%   input:
%   M - mass of body
%   m - mass of all bodies 
%   v - velocity of all bodies
%   output:
%   V- velocity for M to achieve static center of mass
%
%   mwe: To get velocity for a body with M = 10 to make the center 
%   of mass static in a system with two existing bodies
%   [vx, vy] = vel_for_static_com(10,[5, 1],[-0.2,0], [0,0.75])
%   
    mvx = m*(vx).'; 
    mvy = m*(vy).';
    Vx = -mvx / M;
    Vy = -mvy / M;
end

