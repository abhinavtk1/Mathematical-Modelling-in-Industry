% Q1 ode45 solver for Lotka-Volterra Model - with fishing
clc;
clear;

%Inital condition
y0 = [10;5];    % (Initial Population of prey & predator respectively)
% Parameters
a = 4; b = 2; c = 1.5; d = 3; delta = 0.2; 

soln = ode45(@lotka,[0 20], y0);    % Solution of ode
t = linspace(0,10,20);
y(:,1) = deval(soln,t,1);   % Prey population
y(:,2) = deval(soln,t,2);   % Predator population
% Equilibrium point
eq = [d+delta/c; a-delta/b];

% Plots
figure;
plot(t,y(:,1),'-o', 'LineWidth',1.5);
grid on;
hold on;
plot(t,y(:,2),'-o', 'LineWidth',2);
legend('Prey','Predator');
xlabel('Time');
ylabel('Population');
title('Predator/Prey Populations Over Time with Fishing')
hold off;

% Phase plot
[t1, y1] = ode45(@lotka,[0 20], y0);
figure;
plot(y1(:,1),y1(:,2));
hold on;
title('Phase portrait with Fishing');
xlabel('Prey Population');
ylabel('Predator Population');
plot(eq(1), eq(2), 'ro', 'MarkerFaceColor', 'red', 'MarkerSize', 5); % Eq. point
label = sprintf('(%.1f, %.1f)', eq(1), eq(2)); % Eq. point label
text(eq(1), eq(2), label, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
hold off;
legend('Phase portrait', 'Equilibrium Point'); % Legend

% Lotka-Volterra (Predator-prey) function
function lv = lotka(t,x)
    lv = [0;0];
    % Parameters
    a = 4; b = 2; c = 1.5; d = 3; delta = 0.2; 
    lv(1) = a*x(1) - b*x(1)*x(2) - delta*x(1); % Rate of change of prey population
    lv(2) = c*x(1)*x(2) - d*x(2) - delta*x(2); % Rate of change of predator population
end