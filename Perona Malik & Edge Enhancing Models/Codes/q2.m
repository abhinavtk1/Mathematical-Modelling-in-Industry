% Linear diffusion, PMC, EED for cameraman image and their outputs
clc;
clear;

a=imread('cameraman.tif'); % reading the image
a=im2double(a); % normalizing the instensity values to lie between o and 1

ref=a;
ad=imnoise(a,'gaussian',0.01); % adding Gaussian noise of mean zero and variance 0.01
timestep=0.2; % timestep size used in numerical approximation
Niter=60; % number of iterations 

alpha=2.7;              % Used in Numerical approximation of pmc
w= exp(4*alpha/9);      % Used in Numerical approximation of pmc

output_linear = imgaussfilt(ad,1);    %Filter the image with Linear Diffusion ( usingGaussian filter) with sigma = 1
output_pmc =pmc(ad,ref,0.5,timestep,Niter,0,w,1); %Filter the image with Perona Malik diffusion with lambda = 0.5
output_eed = eed(ad,1,0.05,timestep,Niter,0,1);   % Filter the image with Edge Enhancing Diffusion with lambda = 0.05

% PSNR - Metric to understand the quality of cleaning
psnr_linear = psnr(output_linear,ad);         % PSNR value for Linear diffusion with sigma = 1
psnr_pmc = psnr(output_pmc,ad);             % PSNR value for Perona Malik diffusion with lambda = 0.5
psnr_eed = psnr(output_eed,ad);          % PSNR value for Edge Enhancing diffusion with lambda = 0.05

figure(1);
montage({ad,output_linear});    % Compare noise and output image of Linear diffusion
title('Noisy Image Vs. Linear Diffusion (σ = 1) ');

figure(2);
montage({ad,output_pmc});    % Compare noise and output image of PMC
title('Noisy Image Vs. Perona Malik diffusion (λ = 0.5) ');

figure(3);
montage({ad,output_eed});    % Compare noise and output image of EED
title('Noisy Image Vs. Edge Enhancing diffusion (λ = 0.05) ');

fprintf('PSNR Value for Linear diffusion with (σ = 1) = %.2f \n',psnr_linear);
fprintf('PSNR Value for PMC with (λ = 0.5) = %.2f \n',psnr_pmc);
fprintf('PSNR Value for EED with (λ = 0.05) = %.2f \n',psnr_eed);
