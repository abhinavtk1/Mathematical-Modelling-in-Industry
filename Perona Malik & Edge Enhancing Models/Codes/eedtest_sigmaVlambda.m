%% EED Model- contrast parameter λ & smoothing parameter σ relation
clc;
clear;

a=imread('cameraman.tif'); % reading the image
a=im2double(a); % normalizing the instensity values to lie between o and 1

ref=a;
ad=imnoise(a,'gaussian',0.01); % adding Gaussian noise of mean zero and variance 0.01
timestep=0.2; % timestep size used in numerical approximation
Niter=60; % number of iterations 

sigma = [0.1, 1, 3];                    % Sigma - smoothing parameter
lambda = [0.001, 0.01, 0.1, 1, 10];     % Lambda - contrast parameter

subplotno = 0;
for i=1:3
    for j=1:5
        b = eed(ad,sigma(i),lambda(j),timestep,Niter,0,1);     % Edge Enhancing function
        % Display the image in a subplot
         subplotno = subplotno+1;
         subplot(3, 5, subplotno); % 3 rows, 5 columns of subplots 
         imshow(b);
         title(['σ = ',num2str(sigma(i)),',  λ = ', num2str(lambda(j))]);
    end
end
sgtitle('EED Model- contrast parameter λ & smoothing parameter σ relation')

% Arguments
% 1 is the noisy image, 
% 2 is the scale - (variance in Gaussian), 
% 3 is the lambda value = contrast parameter, 
% 4 is the timestep size, 5 is the no of iterations, 
% 6 is the value to show the plot, 
% 7 is the w value used in numerical approximation
% 8 corresponding to choice of the numerical scheme. 
