% Q3. Linearized Lotka-Volterra (Predator-prey) model (with fishing)
clear;
clc;

%Inital condition
y0 = [10;5];    % (Initial Population of prey & predator respectively)
% Parameters
a = 4; b = 2; c = 1.5; d = 3; delta = 0.2;
% Equilibrium point
eq = [d+delta/c; a-delta/b];
% Solve the linearized system using ODE solver
soln = ode45(@lotka_linearize, [0 20], y0);
t = linspace(0,10,20);
y(:,1) = deval(soln,t,1);   % Prey population
y(:,2) = deval(soln,t,2);   % Predator population

% Plots
figure;
plot(t,y(:,1),'-o', 'LineWidth',1.5);
grid on;
hold on;
plot(t,y(:,2),'-o', 'LineWidth',2);
xlabel('Time');
ylabel('Population');
title('Linearized Lotka-Volterra Model (with fishing)');
legend('Prey', 'Predator');
hold off;

% Phase portrait
[t1, y1] = ode45(@lotka_linearize, [0 20], y0);
figure;
plot(y1(:, 1), y1(:, 2));
hold on;
title('Phase Portrait - Linearized Lotka-Volterra Model (with fishing)');
xlabel('Prey Population');
ylabel('Predator Population');
grid on;
plot(eq(1), eq(2), 'ro', 'MarkerFaceColor', 'red', 'MarkerSize', 5); % Eq. point
label = sprintf('(%.1f, %.1f)', eq(1), eq(2)); % Eq. point label
text(eq(1), eq(2), label, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
hold off;
legend('Phase portrait', 'Equilibrium Point'); % Legend

function lv_linearized = lotka_linearize(t, x)
    % Parameters
    a = 4; b = 2; c = 1.5; d = 3; delta = 0.2;
    % Equilibrium point
    eq = [d+delta/c; a-delta/b];
    x0 = eq(1);     % Equilibrium point for prey
    y0 = eq(2);     % Equilibrium point for predator

    % Jacobian at the equilibrium point
    J = [a - b * y0 - delta, -b * x0; c * y0, c * x0 - d - delta];

    % Linearized system
    lv_linearized = J * (x - [x0; y0]);
end