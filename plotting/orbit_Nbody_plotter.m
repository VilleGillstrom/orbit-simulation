function [] = orbit_Nbody_plotter(x,y,vx,vy,ax,ay,t, G, m, body_labels)
    
   plot_orbit(x,y,vx,vy,ax,ay,t,m, body_labels);   
   % plot_ek_ep(x,y, vx, vy,  m, G, t);
   plot_p(vx, vy,  m, t, body_labels);
    
  %  plot_ek(vx, vy,  m, t)
   % plot_ep(x, y, G, m, t)
end

% plot rorelsemängd
function plot_p(vx, vy,  m, t, labels)
    N = length(m);
    steps = length(vx);
    P = zeros(N,steps,1);
    Px = zeros(N,steps,1);
    Py = zeros(N,steps,1);
   
    p_tot = zeros(steps,1);
    p_totx = zeros(steps,1);
    p_toty = zeros(steps,1);
    p_tot2 = zeros(steps,1);
    plotLabels = labels;
    
    for i = 1:steps
        for n = 1:N
            xx = m(n)*vx(n,i);
            yy = m(n)*vy(n,i);
            Px(n,i) = xx;
            Py(n,i) = yy;
            P(n,i) =  sqrt(xx^2 + yy^2);
        end
       % p_tot(i) = sum(P(:,i));
        p_totx(i) = sum(Px(:,i));
        p_toty(i) = sum(Py(:,i));
        p_tot2(i) = sqrt(sum(Px(:,i))^2 + sum(Py(:,i))^2);
    end

    figure
    title("Momentum") 
    hold on
    grid on
    xlabel('t') 
    ylabel('p') 
    
   
  %  plot(t, P); 
  % plot(t, Px); 
    
  %  plot(t,p_tot)
   % plot(t,p_totx)
    %plot(t,p_toty)
    plot(t,p_tot2)
    
    plotLabels{N+1} = 'Sum';
    legend(plotLabels,'Location','northeast')
    
    
end

% plot orbits
function plot_orbit(x,y,vx,vy,ax,ay,t,m, labels)
    N = length(m);

    %Mass centrum
    rcmx = zeros(length(t),1);
    rcmy = zeros(length(t),1);
    
    msum = sum(m);
    for i = 1:length(t)
        mrx = 0;
        mry = 0;
        for n = 1:N
            mrx = mrx + (m(n) *x(n,i));
            mry = mry + (m(n) *y(n,i));
        end
        
        rcmx(i) = (1/ msum) * mrx;
        rcmy(i) = (1/ msum) * mry;
    end
     
    
    figure
    title("N orbits")
    hold on
    axis equal
    grid on
    xlabel('x (m)') 
    ylabel('y (m)') 
    
    s = ceil(length(x) / 10);
    plotLabels = labels;
    for i = 1:N 
        plot(x(i,:),y(i,:));
    end
    % Plots velocity and acceleration
    %quiver(x(1:s:end),y(1:s:end), vx(1:s:end),vy(1:s:end),1,'r'); plotLabels{end+1} = 'Velocity'; 
    %quiver(x(1:s:end),y(1:s:end), ax(1:s:end),ay(1:s:end),1,'g'); plotLabels{end+1} = 'Acceleration'; 
        
   % plot center of mass 
    plot(rcmx,rcmy,'.');
    plotLabels{end+1} = 'Center of mass';  
    legend(plotLabels,'Location','southwest')
end




% plot Ek
function plot_ek(vx, vy, m, t)
    Ek = compute_Ek(m, vx, vy);
    
    figure
    title("Kinetic energy")
    hold on
    grid on
    xlabel('t (s)') 
    ylabel('Energy (J)')
    plot(t, Ek);
    legend(["Ek"],'Location','northeast');
end

% plot Ep
function plot_ep(x, y, G, m, t)
    Ep = compute_Ep(m, x, y, G);
    
    figure
    title("Potential energy")
    hold on
    grid on
     xlabel('t (s)') 
    ylabel('Energy (J)') 
  
    plot(t, Ep);
    legend(["Ep"],'Location','northeast');
end

% plot Ek, Ep and Ek+Ep
function plot_ek_ep(x,y,vx, vy,  m, G, t)
    Ek = compute_Ek(m, vx, vy);
    Ep = compute_Ep(m, x, y, G);
    
    figure
    title("Potential and kinetic energy")
    hold on
    grid on
    xlabel('t (s)') 
    ylabel('Energy (J)')

    plot(t, Ek);
    plot(t, Ep);
    plot(t, Ep + Ek);
    
    legend(["Ek", "Ep", "Ek + Ep"],'Location','northeast')
    
end

% Compute Ek
function [Ek] = compute_Ek(m, vx, vy)
    Ek_N = (m(:) .* ((vx.^2 + vy.^2)) / 2);
    %Ek_N = ((m(:) .* vx.^2) / 2) + ((m(:) .* vy.^2) / 2);
    % Total kinetic energy
    Ek = sum(Ek_N).'; % Transpose to match Ep shape
end

% Compute Ep
function [Ep] = compute_Ep(m, x, y, G)
    steps = length(x); % Total timesteps
    N = length(m);     % Number of bodies
    Ep = zeros(steps,1);
    r=@(x1,y1,x2,y2) (sqrt(((x1-x2)^2) + ((y1-y2)^2)));
    for i = 1:steps
        Epi = 0; % Ep for timestep i
         for n = 1:N
            mi = m(n);
            xi = x(n,i);
            yi = y(n,i);
            for k = n+1:N
                xj = x(k,i);
                yj = y(k,i);
                mj = m(k);
                rij = r(xi,yi,xj,yj); 
                Epi = Epi + (mi*mj/ rij);

            end
        end
       Ep(i) = -G * Epi;
    end
end