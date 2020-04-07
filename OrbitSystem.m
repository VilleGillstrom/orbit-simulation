classdef OrbitSystem < handle
    %SYSTEM Helper class to create and run simulations
  
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
        t % t timesteps
    end
    
    methods
        function obj = system( G,m, x0, y0, vx0,vy0)
            obj.G = G;
            obj.m = m;
            obj.x0 = x0;
            obj.y0 = y0;
            obj.vx0 = vx0;
            obj.vy0 = vy0;
        end

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
        
        function plot(obj)
            orbit_Nbody_plotter(obj.x,obj.y,obj.vx,obj.vy,obj.ax,obj.ay, obj.t, obj.G, obj.m)
        end
    end
    
    methods(Static)
        function os = SimpleSystem()
            os = OrbitSystem;
            os.G = 1.0;
            os.m = [10, 1];
            os.x0 = [0,10];
            os.y0 = [0,0];
            os.vx0 = [0,0];
            os.vy0 =  [-0.075, 0.75];
        end
        
        function os = ISS()
            orbital_speed = @(G,M,R) sqrt(G*M./R);
            
            os = OrbitSystem;
            os.G = 6.67408*10^-11;
            os.m = [5.972*10^24, 450*10^3];
            os.x0 = [0, 400*10^3];
            os.y0 = [0, 0];
            os.vx0 = [0, 0];
            os.vy0 =  [0, 7700];
        end
        % orbital_speed(os.G, 5.97E2, 408*10^3)
        
        function os = SolarSystem()
            orbital_speed = @(G,M,R) sqrt(G*M./R);
            
            %masses 
             m= [1.99E30
                3.31E24
                4.87E24
                5.97E24
                6.39E23
             %   1.90E27
             %   5.68E26
             %   8.68E25
            %   1.02E26
                  
            ];
            
            x = [
                0 %sun
                5.79E10
                1.08E11
                1.50E11
                2.28E11
               % 7.79E11
              %  1.43E12
              %  2.87E12
              %  4.50E12
             ];
            
            y = [0 0  0 0 0 ];       % 0 0 0 0
            vx = [0 0  0 0 0 ]; %0 0 0 0
        
            os = OrbitSystem;
            os.G = 1.0;
  
            vy = orbital_speed(os.G, m(1),  x);
            vy(1) = 0; % The sun
            os.m = m;
            os.x0 = x;
            os.y0 = y;
            os.vx0 = vx;
            os.vy0 =  vy;
        end
        
        
    end
end
