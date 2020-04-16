function [x,y,vx,vy,ax,ay,t]=orbit_Nbody(G,m,x0,y0,vx0,vy0,dt,tmax)
%ORBIT_NBODY Orbit of N Bodies


%Calculating time steps

t = 0:dt:tmax;
steps=floor(tmax/dt);

N = length(m);
%preallocate memory (increases performance)
x=zeros(N,steps,1);
y=zeros(N,steps,1);
vx=zeros(N,steps,1);
vy=zeros(N,steps,1);
ax=zeros(N,steps,1);
ay=zeros(N,steps,1);

%set initial conditions
x(:,1)= x0(:);
y(:,1)= y0(:);
vx(:,1)= vx0(:);
vy(:,1)= vy0(:);

ax(:,1) = acceleration(G, m,x(:,1) ,y(:,1) );
ay(:,1) = acceleration(G, m,x(:,1) ,y(:,1) );

for i=1:steps      

    % update position
    x(:,i+1) = x(:,i) + vx(:,i) * dt + ((ax(:,i))*dt^2) / 2;
    y(:,i+1) = y(:,i) + vy(:,i) * dt + ((ay(:,i))*dt^2) / 2;
   
    % update acceleration
    [ax(:,i+1),ay(:,i+1)] = acceleration(G, m,x(:,i) ,y(:,i) );

    % update velocity
    vx(:, i+1) = vx(:,i) + ((ax(:,i) + ax(:,i+1)) / 2) * dt;
    vy(:, i+1) = vy(:,i) + ((ay(:,i) + ay(:,i+1)) / 2) * dt;
       
  
end
end


