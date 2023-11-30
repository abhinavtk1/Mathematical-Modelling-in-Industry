%% Formulate The number of cherries in a can problem as Black box model.

clear;
clc;
rng(321);                           % Set a random seed
n = 1000;                           % No. of samples

lb_r = 10;  % Lower bound of the cherry radius
ub_r = 20;  % Upper bound of the cherry radius
lb_R = ub_r + 1;  % Lower bound of the can radius
ub_R = 100;  % Upper bound of the can radius
lb_h = 10;   % Lower bound of the can height
ub_h = 100;   % Upper bound of the can height
ub_n = 100; % Upper bound for the no. of cherries
lb_n = 0; % Lower bound of no. of cherries

cherryR = betarnd(3,3,n,1) * (ub_r - lb_r) + lb_r;      % Generating random numbers for cherry radius from a normal distribution
canR = betarnd(3,3,n,1) * (ub_R - lb_R) + lb_R;         % Generating random numbers for can radius from a normal distribution
canH = betarnd(3,3,n,1) * (ub_h - lb_h) + lb_h;         % Generating random numbers for can height from a normal distribution
nCherry = betarnd(3,3,n,1) * (ub_n - lb_n) + lb_n;         % Generating random numbers for n from a normal distribution

% Table with data for surface plot
% Here there are two independent variables, x1 = cherryR , 
% x2 = canR.^2.*canH and a dependent variable n - no. of cherries
data = table(cherryR, canR.^2.*canH, nCherry, 'VariableNames', {'x1', 'x2', 'n'});    

% Split the data into training (85%) and testing (15%)
rng(111);  % Set different random seed
partition = cvpartition(n, 'HoldOut', 0.15);    % Splitting using cvpartition
trainData = data(training(partition), :);       % train data
testData = data(test(partition), :);            % test data

X_train = table2array(trainData(:,1:2));                % converting train data table to array for fit function
X_test = table2array(testData(:,1:2));                  % converting test data table to array for prediction
y_train = table2array(trainData(:,3));                  % converting train output to array for fit function
y_test = table2array(testData(:,3));                    % converting test output to array for prediction
model = fit(X_train,y_train,'lowess');                  % Fitting the model with Lowess smoothing model

% Surface plot
figure(1);
plot(model,X_train,y_train)                                 
xlabel('Cherry radius');
ylabel('Cylinder radius^2 * height');
zlabel('No. of cherries');
title('Surface plot for Black Box Model');

y_predicted = feval(model, X_test);     % Predict values for test data using our fitted model

% Calculate model's performance on the test data
error = sum((y_test - y_predicted).^2);
RMSE = sqrt(error / length(y_predicted));    % Root Mean Squared Error

disp(['Max. number of cherries predicted using fitted model =', num2str(round(max(y_predicted)))]);
disp(['Root Mean Squared Error (RMSE) on test data: ', num2str(RMSE)]);