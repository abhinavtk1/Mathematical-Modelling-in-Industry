% Test eed model

clc;
clear;

a=imread('cameraman.tif'); % reading the image
a=im2double(a); % normalizing the instensity values to lie between o and 1

ref=a;
ad=imnoise(a,'gaussian',0.01); % adding Gaussian noise of mean zero and variance 0.01
timestep=0.2; % timestep size used in numerical approximation
Niter=60; % number of iterations 

b = eed(ad,1,0.05,timestep,Niter,1,1);     % Edge Enhancing function

% Arguments
% 1 is the noisy image, 
% 2 is the scale - (variance in Gaussian), 
% 3 is the lambda value = contrast parameter, 
% 4 is the timestep size, 5 is the no of iterations, 
% 6 is the value to show the plot, 
% 7 is the w value used in numerical approximation
% 8 corresponding to choice of the numerical scheme. 
