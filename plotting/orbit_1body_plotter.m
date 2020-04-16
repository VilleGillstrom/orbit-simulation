function [] = orbit_1body_plotter(x,y,vx,vy,ax,ay,t, M, G, m)
    plot_orbit(x,y,vx,vy,ax,ay,t,m,M);   
    plot_ek_ep(x,y, vx, vy, M, m, G, t);
    plot_p(x,y, vx, vy, M, m, G, t);
end


function [] = plot_p(x,y,vx, vy, M, m, G, t)

    steps = length(vx);
    P = zeros(steps,1);
    
    for i = 1:steps
        P(i) = sqrt(m*vx(i)^2 + m*vy(i)^2);
    end
    
    
    figure
    title("Momentum") 
    hold on
    grid on
    xlabel('t (s)') 
    ylabel('p (kg*m/s)') 
    
    plot(t, P, 'b'); 

    
    
    
    
end



function [] = plot_orbit(x,y,vx,vy,ax,ay,t,m,M)
	
    %Mass centrum
    rcmx = zeros(length(x),1);
    rcmy = zeros(length(x),1);
    for i = 1:length(x)
        rcmx(i) = (1 / (m+M)) * (m*x(i) + M * 0);
        rcmy(i) = (1 / (m+M)) * (m*y(i) + M * 0);
    end
     
    
    figure
    title("Satellite in orbit")
    hold on
    axis equal
    grid on
    xlabel('x (m)') 
    ylabel('y (m)') 
    
    % plot planet
    plot(0,0,'o')
    % plot satellite path
    plot(x,y,'b') 
    
    % plot mass centrum
    plot(rcmx, rcmy, 'k');
    
    % plot satellite velocity and acceleration vectors
    s = ceil(length(x) / 10);
    quiver(x(1:s:end),y(1:s:end), vx(1:s:end),vy(1:s:end),1,'r')
    quiver(x(1:s:end),y(1:s:end), ax(1:s:end),ay(1:s:end),1,'g')
end

function [] = plot_ek_ep(x,y,vx, vy, M, m, G, t)

    r=@(x1,y1,x2,y2) (sqrt(((x1-x2)^2) + ((y1-y2)^2)));
    
    steps = length(vx);
    Ek = zeros(steps,1);
    Ep = zeros(steps,1);
    
    for i = 1:steps
        Ek(i) = (m * (vx(i)^2 + vy(i)^2) / 2) + (M * (0) / 2);
        Ep(i) = -G * (M*m) / r(0,0,x(i),y(i));
    end
    
    figure
    title("Energy in system")
    hold on
    grid on
    xlabel('t (s)') 
    ylabel('Energy (J)') 
    
    plot(t, Ek, 'r'); 
    plot(t, Ep, 'b');
    plot(t, Ep+Ek, 'g');
    
    legend({'y = Ek','y = Ep','y = Ep+Ek'},'Location','northeast')
end