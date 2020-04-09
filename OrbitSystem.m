classdef OrbitSystem < handle
    %OrbitSystem Helper class to create and run simulations
  
    properties
        % Needed to run simulation
        G  % Gravity constant
        m  % Masses of system
        x0 % Initial x
        y0 % Initial y
        vx0 % Initial vx
        vy0 % Initial vy
        
        % Result from last run of simulate()
        x % x positions [x(3,5) is 3rd body's x position at timestep 5]
        y % y positions [y(3,5) is 3rd body's x position at timestep 5]
        vx % x velocities [vx(3,5) is 3rd body's x velocity at timestep 5]
        vy % y velocities [vy(3,5) is 3rd body's y velocity at timestep 5]
        ax % x accelerations [ax(3,5) is 3rd body's x acceleration at timestep 5]
        ay % y accelerations [ay(3,5) is 3rd body's y acceleration at timestep 5]
        t % t times
        
        % Extra
        plot_labels % Name for each body
    end
    
    methods
        function obj = OrbitSystem( )
            obj.m   = zeros(0,1);
            obj.x0	= zeros(0,1);
            obj.y0	= zeros(0,1);
            obj.vx0	= zeros(0,1);
            obj.vy0	= zeros(0,1);
            obj.plot_labels	= strings(0,1);
        end

        % Add a body to the model
        function add_body(obj, body)
            idx = length(obj.m) + 1;
            obj.m(idx)              = body.m;
            obj.x0(idx)             = body.x;
            obj.y0(idx)             = body.y;
            obj.vx0(idx)            = body.vx;
            obj.vy0(idx)            = body.vy;
            obj.plot_labels(idx)    = body.plot_label;
        end
        
        % Run a simulation, returns and saves result(to self)
        function [x,y,vx,vy,ax,ay,t] = simulate(obj, dt, tmax)
            [x,y,vx,vy,ax,ay,t] = ... 
                orbit_Nbody(obj.G, obj.m, obj.x0, obj.y0, obj.vx0,obj.vy0,dt,tmax); 
             obj.x = x;
             obj.y = y;
             obj.vx = vx;
             obj.vy = vy;
             obj.ax = ax;
             obj.ay = ay;
             obj.t  = t;
        end
         
        % Create plots
        function plot(obj)
            orbit_Nbody_plotter(obj.x,obj.y,obj.vx,obj.vy,obj.ax,obj.ay, obj.t, obj.G, obj.m, obj.plot_labels)
        end
        
        % Change the velocity on body at idx to make center of mass static
        % Pick the sun or big center planet
        function staticify_center_of_mass(obj, body_idx)
            [vx_, vy_] = vel_for_static_com(obj.m(body_idx), obj.m,obj.vx0, obj.vy0);
            obj.vx0(body_idx) = obj.vx0(body_idx) + vx_;
            obj.vy0(body_idx) = obj.vy0(body_idx) + vy_;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Various models           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Static)
        %The base case from assignment
        function os = SimpleSystem()
            os = OrbitSystem;
            os.G = 1.0;
            planet      = struct('plot_label', 'planet', 'm', 10, 'x', 0, 'y',0, 'vx', 0, 'vy', 0);
            satellite   = struct('plot_label', 'satellite' ,'m', 1, 'x', 10, 'y',0, 'vx', 0, 'vy', 0.75);

            os.add_body(planet);
            os.add_body(satellite)
            
            % This line adds celocity to the planet nr 1
            % to make center of  mass unchanging
          %  os.staticify_center_of_mass(1);
            
        end
        
        %REQUIRES SMALL dt ~0.00001
        function os = ISS() 
            os = OrbitSystem;
            os.G = 6.67408*10^-11;
            earth = struct('plot_label', 'Earth', 'm', 5.972E24,'x',   0,'y',0,'vx', 0, 'vy',    0);
            iss   = struct('plot_label', 'ISS', 'm',   450E03,'x', 6771E3,'y',0,'vx', 0, 'vy', 7700);
            
            os.add_body(earth);
            os.add_body(iss);
            os.staticify_center_of_mass(1);
        end   
        
        %Faked orbit
        function os = SolarSystem()
            orbital_speed = @(G,M,R) sqrt(G*M./R);
            os = OrbitSystem;
            %planets = ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"] 
            %os.G = 1.0;
            os.G = 6.67408*10^-11;
            %Source google searches: <planet> mass, <planet> distance from sun
            sun     = struct('plot_label', 'Sun','m', 1.989E30, 'x', 0, 'y',0, 'vx', 0, 'vy', 0);
                      
            mercury = struct('plot_label', 'Mercury','m', 3.285E23, 'x', 67.162E9, 'y',0, 'vx', 0);
            mercury.vy = orbital_speed(os.G, sun.m,  mercury.x);
            
            venus   = struct('plot_label', 'Venus','m', 4.876E24, 'x', 107.57E9, 'y',0, 'vx', 0);
            venus.vy = orbital_speed(os.G, sun.m,  venus.x);
            
            earth   = struct('plot_label', 'Earth','m', 5.972E24, 'x', 149.77E9, 'y',0, 'vx', 0);
            earth.vy = orbital_speed(os.G, sun.m,  earth.x);
           
            mars    = struct('plot_label', 'Mars','m', 6.390E23, 'x', 220.82E9, 'y',0, 'vx', 0);
            mars.vy = orbital_speed(os.G, sun.m,  mars.x);
           
            jupiter = struct('plot_label', 'Jupiter','m', 1.898E27, 'x', 777.11E9,  'y',0, 'vx', 0);
            jupiter.vy = orbital_speed(os.G, sun.m,  jupiter.x);
            
            saturn  = struct('plot_label', 'Saturn','m', 5.683E26, 'x', 1.4967E12, 'y',0, 'vx', 0);
            saturn.vy = orbital_speed(os.G, sun.m,  saturn.x);
           
            uranus  = struct('plot_label', 'Uranus','m', 8.681E25, 'x', 2.963E12,  'y',0, 'vx', 0);
            uranus.vy = orbital_speed(os.G, sun.m,  uranus.x);
           
            neptune = struct('plot_label', 'Neptune','m', 1.024E26, 'x', 4.4769E12, 'y',0, 'vx', 0);
            neptune.vy = orbital_speed(os.G, sun.m,  neptune.x);
            
            
           
            os.add_body(sun);
            os.add_body(mercury);
            os.add_body(venus);
            os.add_body(earth);
            os.add_body(mars);
           % os.add_body(jupiter);
           % os.add_body(saturn);
           % os.add_body(uranus);
           % os.add_body(neptune);
           
           
            os.staticify_center_of_mass(1);
        end
   
         function os = SolarSystemTwoSuns()
            orbital_speed = @(G,M,R) sqrt(G*M./R);
            os = OrbitSystem;
            %planets = ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"] 
            os.G = 1.0;
            %Source google searches: <planet> mass, <planet> distance from sun
            sun     = struct('plot_label', 'Sun','m', 1.989E30, 'x', 0, 'y',0, 'vx', 0, 'vy', 0);
            sun2     = struct('plot_label', 'Sun2','m', 1.989E30, 'x', -220.82E9*5, 'y',0, 'vx', 0, 'vy', 0);          
            sun2.vy = orbital_speed(os.G, sun.m,  -sun2.x);
           
            
            mercury = struct('plot_label', 'Mercury','m', 3.285E23, 'x', 67.162E9, 'y',0, 'vx', 0);
            mercury.vy = orbital_speed(os.G, sun.m,  mercury.x);
            
            venus   = struct('plot_label', 'Venus','m', 4.876E24, 'x', 107.57E9, 'y',0, 'vx', 0);
            venus.vy = orbital_speed(os.G, sun.m,  venus.x);
            
            earth   = struct('plot_label', 'Earth','m', 5.972E24, 'x', 149.77E9, 'y',0, 'vx', 0);
            earth.vy = orbital_speed(os.G, sun.m,  earth.x);
           
            mars    = struct('plot_label', 'Mars','m', 6.390E23, 'x', 220.82E9, 'y',0, 'vx', 0);
            mars.vy = orbital_speed(os.G, sun.m,  mars.x);
           
            jupiter = struct('plot_label', 'Jupiter','m', 1.898E27, 'x', 777.11E9,  'y',0, 'vx', 0);
            jupiter.vy = orbital_speed(os.G, sun.m,  jupiter.x);
            
            saturn  = struct('plot_label', 'Saturn','m', 5.683E26, 'x', 1.4967E12, 'y',0, 'vx', 0);
            saturn.vy = orbital_speed(os.G, sun.m,  saturn.x);
           
            uranus  = struct('plot_label', 'Uranus','m', 8.681E25, 'x', 2.963E12,  'y',0, 'vx', 0);
            uranus.vy = orbital_speed(os.G, sun.m,  uranus.x);
           
            neptune = struct('plot_label', 'Neptune','m', 1.024E26, 'x', 4.4769E12, 'y',0, 'vx', 0);
            neptune.vy = orbital_speed(os.G, sun.m,  neptune.x);
            
            
           
            os.add_body(sun);
            os.add_body(sun2);
            os.add_body(mercury);
            os.add_body(venus);
            os.add_body(earth);
            os.add_body(mars);
           % os.add_body(jupiter);
           % os.add_body(saturn);
           % os.add_body(uranus);
           % os.add_body(neptune);
           
           
           os.staticify_center_of_mass(1);
        end
        
    end
end
