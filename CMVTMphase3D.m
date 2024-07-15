% This file is intended for use with MATLAB R2019a
clear;
close all;
format long

tspan=0:0.01:5000; 
Y1=[0.1 0.1 0.1];

[t,y]=odeRK4(@C3D,tspan,Y1);

figure(1)
set(0,'defaultfigurecolor','w');
plot3(y(100:end,1), y(100:end,2), y(100:end,3),'r'); hold on
xlabel('$x_1$','Interpreter','latex'); ylabel('$x_2$','Interpreter','latex'); 
zlabel('$x_3$','Interpreter','latex'); set(gca,'TickLabelInterpreter','latex');

%% ------------- system ------------ %%
function dy=C3D(~,X)
    dy=zeros(3,1); 
    x1 = X(1); x2 = X(2); x3 = X(3);
    
    % seed chaotic system, IC (0,5,0)
      a = 1;
%     dy1=x2;
%     dy2=-x1-x2*x3;
%     dy3=x2^2-a;
    
    % 8-fold chaotic system, IC (0.1,0.1,0.1)
    dy1=(x1*((x2*(a - 16*x1^2*x3^2*((x1^2 - x3^2)^2 - x2^2)^2))/(2*((x1^2 - x3^2)^2 + x2^2)) + (x1*x3*(x1^2 - x3^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2 + 8*x1*x2*x3*((x1^2 - x3^2)^2 - x2^2)*(x1^2 - x3^2)))/(2*((x1^2 - x3^2)^2 + x2^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2))))/(2*(x1^2 + x3^2)) - (x3*((x1^2 - x3^2)^2 - x2^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2 - 8*x1*x2*x3*((x1^2 - x3^2)^2 - x2^2)*(x1^2 - x3^2)))/(4*(x1^2 + x3^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2));
    dy2=((x1^2 - x3^2)*(a - 16*x1^2*x3^2*((x1^2 - x3^2)^2 - x2^2)^2))/(2*((x1^2 - x3^2)^2 + x2^2)) - (x1*x2*x3*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2 + 8*x1*x2*x3*((x1^2 - x3^2)^2 - x2^2)*(x1^2 - x3^2)))/(2*((x1^2 - x3^2)^2 + x2^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2));
    dy3=- (x3*((x2*(a - 16*x1^2*x3^2*((x1^2 - x3^2)^2 - x2^2)^2))/(2*((x1^2 - x3^2)^2 + x2^2)) + (x1*x3*(x1^2 - x3^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2 + 8*x1*x2*x3*((x1^2 - x3^2)^2 - x2^2)*(x1^2 - x3^2)))/(2*((x1^2 - x3^2)^2 + x2^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2))))/(2*(x1^2 + x3^2)) - (x1*((x1^2 - x3^2)^2 - x2^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2 - 8*x1*x2*x3*((x1^2 - x3^2)^2 - x2^2)*(x1^2 - x3^2)))/(4*(x1^2 + x3^2)*(4*x1^2*x3^2 + ((x1^2 - x3^2)^2 - x2^2)^2));
 
    dy=[dy1;dy2;dy3];
end

function varargout = odeRK4(fx,tspan,y0)
    y0 = y0(:);
    nn = length(y0);
    
    h = tspan(2)-tspan(1);
    N = length(tspan);
    t = ones(N,1)*nan;
    y = ones(N,nn)*nan;
    
    t(1) = tspan(1);
    y(1,:) = y0;
    
    for i=1:N
        
        if isnan(y(i,1))
            break
        end
        
        t0 = t(i);
        y0 = transpose(y(i,:));
        
        k1 = fx(t0,y0);
        k2 = fx(t0+h/2,y0+h*k1/2);
        k3 = fx(t0+h/2,y0+h*k2/2);
        k4 = fx(t0+h,y0+h*k3);
        
        y0 = y0+h*(k1+2*k2+2*k3+k4)/6;
        
        t(i+1) = t0+h;
        y(i+1,:) = reshape(y0,1,nn);    
    end
    
    if nargout == 1
        varargout = {y};
    elseif nargout == 2
        varargout = {t,y};
    else
        error('error');
    end

end
