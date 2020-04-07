function [ax,ay]=acceleration(G, m, x, y)
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

Fx = zeros(N,N,1);
Fy = zeros(N,N,1);
ax = zeros(N,1);
ay = zeros(N,1);

r=@(x1,y1, x2,y2) sqrt((x1-x2)^2+(y1-y2)^2);

%Compute forces
for i=1:N
    xi = x(i);
    yi = y(i);
    for j=1:N
        if i == j
            continue
        end      
        xj = x(j);
        yj = y(j);    
        rij = r(xi, yi, xj,yj);
       
        Fx(i,j) = (-G * m(i) * m(j) * (( xi - xj ) /  rij^3)); 
        Fy(i,j) = (-G * m(i) * m(j) * (( yi - yj ) /  rij^3)); 
    end 
end

% Forces to accelerations
for  i=1:N
    Fx_tot = sum(Fx(i,:));
    Fy_tot = sum(Fy(i,:));
    
    ax(i) = Fx_tot / m(i);
    ay(i) = Fy_tot / m(i);
end
end
