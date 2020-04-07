function [ax,ay]=acceleration2(G, m, x, y)
%ACCELERATION Summary of this function goes here
%   Detailed explanation goes here
% input:
%  G - Gravitational constant
%  m - Vector of masses
%  x,y - Positions of bodies
% return:
%  ax, ay - vector of accelerations

%Initialization
N = length(m);

xd = x.'-x; % Difference in x
yd = y.'-y; % Difference in y
r  = sqrt(xd.^2 + yd.^2); % R distance
mm = m .* m.';

%tic;
Fx = -G .* mm .* (xd ./ (r.^3));
Fx(isnan(Fx))=0;  % no force on itself 

Fy = -G .* mm .* (yd ./ (r.^3));
Fy(isnan(Fy))=0;  % no force on itself 
%toc;

Fx_tot = sum(Fx).';
Fy_tot = sum(Fy).';
    
ax = Fx_tot ./ m;
ay = Fy_tot ./ m;


end
