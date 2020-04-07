function [x,y,vx,vy,ax,ay,t]=orbit_1body(G,m,x0,y0,vx0,vy0,dt,tmax)
%G gravitationskonstanten
%m massa hos planeten
%x0,y0 satellitens position vid t=0
%vx0,vy0 plantens hastighet vid t=0
%dt längden på tidsteget
%tmax totala simuleringstiden

%Calculating time steps

t = 0:dt:tmax;

steps=floor(tmax/dt);
%preallocate memory (increases performance)
x=zeros(steps,1);
y=zeros(steps,1);
vx=zeros(steps,1);
vy=zeros(steps,1);
ax=zeros(steps,1);
ay=zeros(steps,1);

%set initial conditions
x(1)= x0;
y(1)= y0;

vx(1)= vx0;
vy(1)= vy0;

% define a function for calculating the distance between two points
r=@(x,y) sqrt((x)^2+(y)^2);

%define functions for calculating acceleration based on position
acx=@(x,y) -G * m * (x) / (r(x,y)^3);
acy=@(x,y) -G * m * (y) / (r(x,y)^3);

ax(1) = acx(x(1), y(1));
ay(1) = acy(x(1), y(1));

%simulate orbit
for i=1:steps      

    % update position
    x(i+1)= x(i) + vx(i) * dt + ((ax(i))*dt^2) / 2;
    y(i+1)= y(i) + vy(i) * dt + ((ay(i))*dt^2) / 2;

    % update acceleration
    ax(i+1) = acx(x(i+1), y(i+1));
    ay(i+1) = acy(x(i+1), y(i+1));

    % update velocity
    vx(i+1) = vx(i) + ((ax(i) + ax(i+1)) / 2) * dt;
    vy(i+1) = vy(i) + ((ay(i) + ay(i+1)) / 2) * dt;
end
end
