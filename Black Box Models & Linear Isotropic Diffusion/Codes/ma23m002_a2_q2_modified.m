%% Q2. Formulate the Cascading cups model as Black box model.

clear;
clc;
rng(111);
N = 5 ;                     % Number of cups
C = 100 + 100*rand();       % Capacity of each cup generated randomly between 100 to 200
T = 10 + 10*rand();         % Total time taken for the process generated randomly between 10 to 20

timeSpan = [0, T];          % Time interval for consideration
W1_0 = 0.0;                 % W1 value for t = 0
W2_0 = 0.0;                 % W2 value for t = 0
W3_0 = 0.0;                 % W3 value for t = 0
W4_0 = 0.0;                 % W4 value for t = 0
W5_0 = 0.0;                 % W5 value for t = 0

% Using ode45 to solve the system of ODEs for wine quantity in all the cups
[t, W] = ode45(@(t, W) myODESystem(t, W, C, T), timeSpan, [W1_0, W2_0, W3_0, W4_0, W5_0]);

% Display the final quantity of wine in each cup at time T.
disp(['Quantity of wine in Cup 1 at time T: ', num2str(W(end,1))]);
disp(['Quantity of wine in Cup 2 at time T: ', num2str(W(end,2))]);
disp(['Quantity of wine in Cup 3 at time T: ', num2str(W(end,3))]);
disp(['Quantity of wine in Cup 4 at time T: ', num2str(W(end,4))]);
disp(['Quantity of wine in Cup 5 at time T: ', num2str(W(end,5))]);

%Plot the values of W
figure;
plot(t, W,'LineWidth', 1.5);
xlabel('Time t');
ylabel('Wine quantity');
title('Wine quantity vs t for all the cups');
legend('cup 1', 'cup 2', 'cup 3', 'cup 4', 'cup 5','Location','northwest');


% Define the ODE function for series of cups
function dWdt = myODESystem(t, W, C, T)
    W1 = W(1);
    W2 = W(2);
    W3 = W(3);
    W4 = W(4);
    W5 = W(5);

    % Rate of change of wine in cup i = Inflow from i-1 to i - Outflow from i to i+1 
    dW1dt = -W1/T + C/T;        % Rate of change of wine quantity in cup 1
    dW2dt = W1/T - W2/T;        % Rate of change of wine quantity in cup 2
    dW3dt = W2/T - W3/T;        % Rate of change of wine quantity in cup 3
    dW4dt = W3/T - W4/T;        % Rate of change of wine quantity in cup 4
    dW5dt = W4/T - W5/T;        % Rate of change of wine quantity in cup 5
    dWdt = [dW1dt; dW2dt; dW3dt; dW4dt; dW5dt];
end

