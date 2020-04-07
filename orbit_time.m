function [time] = orbit_time(x,y,t)
%ORBIT_BODY Time to orbit

x0 = x(1);
y0 = y(1);
v0 = [x0, y0] / norm([x0, y0]);

time = 0;                      % Accumulated time
hasReachedHalfOrbit = false;   % Has reached halfway
cp = 1;           % Precious dot product

for i = 2:length(t)
    r = [x(i), y(i)] / norm([x(i), y(i)]); % Current vector to sattelite
    time = time + (t(i) - t(i-1)); % Accumulate time
    
    % Dot product between initial orhogonal vector and current 
    % satellite position
    c = dot(v0, r); 
 
    if(hasReachedHalfOrbit == false)
        if(cp < c )
            hasReachedHalfOrbit = true;
        end        
    else
        if(cp > c )
            %We have now reached full orbit           
            return;
        end
    end    
    cp = c; % Store current dot as previous
end

