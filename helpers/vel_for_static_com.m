function [Vx, Vy] = vel_for_static_com(M,m,vx, vy)
%UNTITLED What is the velocity needed for a body to make the system's
%center of mass static
%   input:
%   M - mass of body
%   m - mass of all other bodies 
%   v - velocity of all other bodies
%   output:
%   V- velocity for M to achieve static center of mass
    mvx = m*(vx).'; 
    mvy = m*(vy).';
    Vx = -mvx / M;
    Vy = -mvy / M;
end

