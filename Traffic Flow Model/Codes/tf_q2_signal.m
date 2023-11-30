% Traffic flow model for speed-density relation follows the car following model
clear;
clc;

rhoMax = 1;     % Maximum rho
rhoMin = 0;     % Minimum rho

h = 0.1;       % space step size
k = 0.1;       % time step size
x = -1:h:1;     % Road - (-1 to 1)
x_divs = length(x);         % No. of space steps

total_time= 3;              % Total time under consideration
t_steps = total_time / k;   % No. of time steps

% Initial conditions
rho0 = linspace(0.1, 0.5, x_divs);

u = zeros(t_steps, x_divs);     % Array to store u

% Initial and boundary conditions for u
u(1,:) = rho0; 
u(:,1) = u(1,1)*ones(t_steps,1);

% Signal 
x_signal = 0.2;     % Position of signal
x_signal_idx = floor((x_signal - x(1))/h);  % Index of signal position in x array

signal_times = [0.5, 1.5, 2.5];             % Signal timings (in min.)
signal_time_idx = signal_times/k;           % Index of signal time in time array

% Apply boundary condition (1)
for i = 1:2:length(signal_time_idx)-1
   u(signal_time_idx(i):signal_time_idx(i+1), x_signal_idx) = -1;
   u(signal_time_idx(i):signal_time_idx(i+1), x_signal_idx + 1) = 1;
end

% Numerical calculation using Godunov method
for t = 1:t_steps-1
    % Apply boundary condition (2)
    for i = 1:2:length(signal_time_idx)-1
       u(signal_time_idx(i):signal_time_idx(i+1), x_signal_idx) = -1;
       u(signal_time_idx(i):signal_time_idx(i+1), x_signal_idx + 1) = 1;
    end

    for i = 2:x_divs - 1
        u(t+1,i) = u(t,i) - (k/h)*(f(u_star(t,i, u,@f, @df))-f(u_star(t,i-1, u,@f, @df)));  
    end
end
u(:,1) = u(:,2);
u(:,end) = u(:,end-1);

% Get rho value from u
rho_tab =  u; 


% Plotting at different cases
figure;
% First subplot - when green light (initial cond.)
subplot(2, 2, 1);
plot(x, rho_tab(1,:), 'LineWidth', 1.5); 
% Add labels and title
xlabel('Road');
ylabel('Traffic density');
title('t = 0, Uniform traffic flow (Green signal)');
% Display grid
grid on;
hold on;
% Add a vertical line at signal position
xline(x_signal, 'g--', 'LineWidth', 2); % Signal position
hold off;

% Second subplot - when red light
subplot(2, 2, 2);
plot(x, rho_tab(10,:), 'LineWidth', 1.5);
% Add labels and title
xlabel('Road');
ylabel('Traffic density');
title('During Red signal');
grid on;
hold on;
% Add a vertical line at signal position
xline(x_signal, 'r--', 'LineWidth', 2);
hold off;

% Third subplot - when red light (just before green light)
subplot(2, 2, 3);
plot(x, rho_tab(15,:), 'LineWidth', 1.5); 
% Add labels and title
xlabel('Road');
ylabel('Traffic density');
title('Just before Green signal');
grid on;
hold on;
% Add a vertical line at signal position
xline(x_signal, 'r--', 'LineWidth', 2);
hold off;

% forth subplot
subplot(2, 2, 4);
plot(x, rho_tab(25,:), 'LineWidth', 1.5); 
% Add labels and title
xlabel('Road');
ylabel('Traffic density');
title('Traffic flow 1 min after signal turned green');
grid on;
hold on;
% Add a vertical line at signal position
xline(x_signal, 'g--', 'LineWidth', 2);
hold off;



% Function for u_star calculation used in Godunov scheme
function u_star_out = u_star(n, i, u, f, df)
    gradF = df(u(n, i));        % Gradient of flux for given u(n,i)
    gradF1 = df(u(n, i + 1));   % Gradient of flux for given u(n,i+1)
    % Apply different conditions...
    if gradF >= 0 && gradF1 >= 0
        u_star_out = u(n, i);
    elseif gradF < 0 && gradF1 < 0
        u_star_out = u(n, i + 1);
    elseif gradF >= 0 && gradF1 < 0
        s = (f(u(n, i + 1))-f(u(n, i)))/(u(n, i + 1)- u(n, i)) ;
        if s >= 0
            u_star_out = u(n, i);
        else
            u_star_out = u(n, i + 1);
        end
    else
        u_star_out = 0;
    end
end

% Flux function for car following model
function result = f(rho)
    rhoCrit = 0.45; % Critical rho
    rhoJam = 1;     % Jam rho
    vMax = 0.95;   % Max velocity
    
    if rho <= rhoCrit
        result = rho * vMax;
    elseif rhoCrit < rho && rho < rhoJam
        result = vMax * (1 - rho / rhoJam);
    elseif rho >= rhoJam
        result = 0;
    end
end

% Derivative of flux
function result = df(rho)
    rhoCrit = 0.45; % Critical rho
    rhoJam = 1;     % Jam rho
    vMax = 0.95;   % Max velocity
    
    if rho <= rhoCrit
        result = vMax;
    elseif rhoCrit < rho && rho < rhoJam
        result = -vMax / rhoJam;
    elseif rho >= rhoJam
        result = 0;
    end
end

