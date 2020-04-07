function [] = orbit_Nbody_plotter(x,y,vx,vy,ax,ay,t, G, m)
    plot_orbit(x,y,vx,vy,ax,ay,t,m);   
   % plot_ek_ep(x,y, vx, vy,  m, G, t);
   % plot_p(x,y, vx, vy,  m, G, t);
end


function [] = plot_p(x,y,vx, vy,  m, G, t)
    N = length(m);
    steps = length(vx);
    P = zeros(N,steps,1);
    p_tot = zeros(steps,1);
    for i = 1:steps
        for n = 1:N
            xx = m(n)*vx(n,i);
            yy = m(n)*vy(n,i);
            P(n,i) =  xx + yy;
            
        end
        p_tot(i) = sum(P(:,i));
    end
    
    figure
    title("Momentum") 
    hold on
    grid on
    xlabel('t') 
    ylabel('p') 
    
    planets = ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"] 
    plotLabels = cell(1,N+1);
    for  i = 1:N
        plot(t, P(i,:));  
        plotLabels{i} = planets(i);
   
    end
    plot(t,p_tot)
    plotLabels{N+1} = "Sum";
    legend(plotLabels,'Location','northeast')
    
    
    %legend({'y = Ek','y = Ep','y = Ep+Ek'},'Location','northeast')
    
end

function [] = plot_orbit(x,y,vx,vy,ax,ay,t,m)
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
    xlabel('x') 
    ylabel('y') 
    
    s = ceil(length(x) / 10);
    plotLabels = cell(1,N);
    for i = 1:N
        a = x(i,:);
        b = y(i,:);
        plot(a,b) ;
        plotLabels{i} = num2str(i);
        %quiver(x(1:s:end),y(1:s:end), vx(1:s:end),vy(1:s:end),1,'r')
        %quiver(x(1:s:end),y(1:s:end), ax(1:s:end),ay(1:s:end),1,'g')
    end
   % plot mass centrum
    
    plot(rcmx,rcmy,'.');
    plot(rcmx, rcmy);
    legend(plotLabels,'Location','southwest')
    
  
    
    % plot satellite velocity and acceleration vectors
   % 
  
end

function [] = plot_ek_ep(x,y,vx, vy,  m, G, t)
	
    
    N = length(m);
    steps = length(vx);
    Ek = zeros(N, steps,1);
    Ep = zeros(N, steps,1);
    
    Ek_tot = zeros(steps,1);
    Ep_tot = zeros(steps,1);
    
    for i = 1:steps
        for n = 1:N
            vxx = vx(n,i);
            vyy = vy(n,i);
            v = (vxx + vyy);
            Ek(n,i) = ((m(n) * v^2) / 2);  
        end
        Ek_tot(i) = sum(Ek(:,i));
    end
    
    r=@(x1,y1,x2,y2) (sqrt(((x1-x2)^2) + ((y1-y2)^2)));
    
    foo = 0;
    for i = 1:steps
        foo = 0;
        for n = 1:N
            mi = m(n);
            for k = n+1:N
                xi = x(n,i);
                yi = y(n,i);
                xj = x(k,i);
                yj = y(k,i);
                mj = m(k);
                
                
                rij = r(xi,yi,xj,yj);
                Ep(n,i) = Ep(n,i) + (mi*mj/ rij);
                %Ep(k,i) = Ep(k,i) + m(n)*m(k) / rij;
                foo = foo + (mi*mj/ rij);
            end
        end
        
        %Ep_tot(i) = -G * sum(Ep(:,i));
        Ep_tot(i) = -G * foo;
    end
    
   
    figure
    title("Energy in system")
    hold on
    grid on
    xlabel('t') 
    planets = ["Sun", "Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"];
    plotLabels = cell(1,N);
    title("Ek")
    plot(t, Ek_tot);
    figure
    title("Ep")
    hold on
    plot(t, Ep_tot);
    for  i = 1:N
          
       % plot(t, Ep(i,:));
      % plot(t, Ek(i,:));  
       % plot(t, Ep(i,:));
        plotLabels{i} = planets(i);
    end
    %legend(plotLabels,'Location','northeast')
   % plot(t, Ek, 'r'); 
    %plot(t, Ep, 'b');
   % plot(t, Ep+Ek, 'g');
    
   % legend({'y = Ek','y = Ep','y = Ep+Ek'},'Location','northeast')
end