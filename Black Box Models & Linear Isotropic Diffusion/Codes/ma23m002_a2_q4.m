%% Q4. Consider the third question in Assignment-2. Formulate the model as Black box model

clear;
clc;
% Load data of Q3 - Sigma & PSNR.
data_str = load('q3_data.mat','data');
data = data_str.data(4:end,:);      
n = height(data);                   %% Size of data

% Split the data into training (90%) and testing (10%)
rng(123);  % Set different random seed

% Partition data for train and test
partition = cvpartition(n, 'HoldOut', 0.10);        
trainData = data(training(partition), :);
testData = data(test(partition), :);            
X_train =trainData(:,1);                        % Train data for fitting model
X_test = testData(:,1);                         % Test data for prediction
y_train = trainData(:,2);                       % Train data output for fit function
y_test = testData(:,2);                         % Test data output for error calculation
model = fitlm(X_train,y_train);                 % Fitting a linear model using fitlm function
testPredicted = predict(model, X_test);         % Predicting the test data's output using out fitted model

% Calculate model's performance on the test data
errorsq = sum((testPredicted - y_test).^2);                 % Sum of squared errors
RMSE = sqrt(errorsq / length(testPredicted));               % Root Mean Squared Error
disp(['Root Mean Squared Error (RMSE) on test data: ', num2str(RMSE)]);

% Plot the data points
figure(1);
scatter(X_train, y_train,50, 'r','*');  % Red points

hold on;  % Hold the plot for adding the regression line

% Plot the fitted regression line
yPrediction = predict(model, X_train);              % Predicted values using the model for regression line
plot(X_train, yPrediction, 'b', 'LineWidth', 1);    % Regression line

xlabel('Sigma');
ylabel('PSNR');
title('Linear Regression Model Fit');
legend({'Data points', 'Regression Line'}, 'Location', 'Northeast');
hold off;
