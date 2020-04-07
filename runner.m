G=1;
m=0.01;
M=10;
x0=10;
y0=0;
vx0=0;
vy0=0.75;
dt=0.001;
tmax=100;

%[x,y,vx,vy,ax,ay,t] = orbit_1body(G, M, x0, y0, vx0,vy0, dt , tmax);
%[time] = orbit_time(x,y,t)
%orbit_1body_plotter(x,y,vx,vy,ax,ay,t, M, G, m)

%simple = OrbitSystem.SimpleSystem();
%[x,y,vx,vy,ax,ay,t] = simple.simulate(0.001, 100);
%simple.plot()

%return;


solar = OrbitSystem.ISS();
tic; solar.simulate(0.000001,50); toc;
solar.plot()