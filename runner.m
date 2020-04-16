%run_orbit_1body()


%run_simplesystem();
%run_iss();
%run_solarsystem();
sse = run_solarsystem_ellipse();
%run_solarsystem_twosuns();
%return;


function [os] = run_simplesystem() 
    os = OrbitSystem.SimpleSystem();
    tic; os.simulate(0.01,100); toc;
    tic; os.plot();toc;
end

function [os] = run_iss()
    os = OrbitSystem.ISS();
    tic; os.simulate(0.1,10000); toc;
    tic; os.plot();toc;
    [iss_time] = orbit_time(iss.x(2,:), iss.y(2,:),iss.t) / (60)
end

function [os] = run_solarsystem_ellipse()
    os = OrbitSystem.SolarSystemEllipse();
   % tic; os.simulate(50, (594E5) ); toc;
    tic; os.simulate(1000, (1.44E6 * 60*60) ); toc;
    tic; os.plot();toc;
    
   % [mercury_time] = orbit_time(os.x(2,:), os.y(2,:),os.t) / (60 *60)
   % [venus_time] = orbit_time(os.x(3,:), os.y(3,:),os.t)/ (60 *60)
   % [earth_time] = orbit_time(os.x(4,:), os.y(4,:),os.t)/ (60 *60)
   % [mars_time] = orbit_time(os.x(5,:), os.y(5,:),os.t)/ (60 *60)
end

function [os] = run_solarsystem()
    os = OrbitSystem.SolarSystem();
    tic; os.simulate(200, (594E5 ) ); toc;
   
    tic; os.plot();toc;
    
    [mercury_time] = orbit_time(os.x(2,:), os.y(2,:),os.t)
    [venus_time] = orbit_time(os.x(3,:), os.y(3,:),os.t)
    [earth_time] = orbit_time(os.x(4,:), os.y(4,:),os.t)
    [mars_time] = orbit_time(os.x(5,:), os.y(5,:),os.t)
end

function [os] = run_solarsystem_twosuns()
    os = OrbitSystem.SolarSystemTwoSuns();
    tic; os.simulate(50,32*10E6); toc;
    tic; os.plot();toc;
end

%Runs orbit_1body with base stuff
function run_orbit_1body() 
    G=1;
    m=0.01;
    M=10;
    x0=10;
    y0=0;
    vx0=0;
    vy0=0.75;
    dt=0.01;
    tmax=400;

 [x,y,vx,vy,ax,ay,t] = orbit_1body(G, M, x0, y0, vx0,vy0, dt , tmax);
 %[time] = orbit_time(x,y,t)
 orbit_1body_plotter(x,y,vx,vy,ax,ay,t, M, G, m)
end