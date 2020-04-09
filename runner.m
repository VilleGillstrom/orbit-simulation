
%run_orbit_1body()


%os = OrbitSystem.ISS();
%tic; os.simulate(50,32*10E6); toc;
%tic; os.plot();toc;
%[iss] = orbit_time(os.x(1,:), os.y(1,:),os.t)

os = OrbitSystem.SolarSystem();
tic; os.simulate(50,32*10E6); toc;
tic; os.plot();toc;
[mercury_time] = orbit_time(os.x(2,:), os.y(2,:),os.t)
[venus_time] = orbit_time(os.x(3,:), os.y(3,:),os.t)
[earth_time] = orbit_time(os.x(4,:), os.y(4,:),os.t)
[mars_time] = orbit_time(os.x(5,:), os.y(5,:),os.t)


%Runs orbit_1body with base stuff
function run_orbit_1body() 
    G=1;
    m=0.01;
    M=10;
    x0=10;
    y0=0;
    vx0=0;
    vy0=0.75;
    dt=0.001;
    tmax=100;

 [x,y,vx,vy,ax,ay,t] = orbit_1body(G, M, x0, y0, vx0,vy0, dt , tmax);
 %[time] = orbit_time(x,y,t)
 orbit_1body_plotter(x,y,vx,vy,ax,ay,t, M, G, m)
end