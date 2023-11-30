% A3q3 - PSNR vs variance
clc;
clear;

% Importing 5 images
img1 = im2double(imread('cameraman.tif')); % reading the image and normalizing the instensity values b/w 0 and 1
img2 = im2double(imread('tomo.jpg'));
img3 = im2double(im2gray(imread('triangle.jpg'))); % converting color img to greyscale 
img4 = im2double(im2gray(imread('onion.png')));
img5 = im2double(imread('eight.tif'));

 
timestep = 0.2; % timestep size used in numerical approximation
Niter = 60; % number of iterations 

alpha=2.7;              % Used in Numerical approximation of pmc
w= exp(4*alpha/9);      % Used in Numerical approximation of pmc

n = 100;                    % No. of variance values
var = logspace(-5,0,n)';    % Variance for the noise           
ldpsnr = zeros(1,n);
pmcpsnr = zeros(1,n);
eedpsnr = zeros(1,n);
% Apply LD, PMC and EED for each noisy images and report respective PSNR values

%% Change img and noise for different conditions
img = img1;                 % img = img1, img2, img3, img4, img5
noise = "gaussian";         % noise type = gaussian, salt & pepper, speckle

for i = 1:n                 
    output_linear = imgaussfilt(imnoise(img, noise,var(i)),0.5);    %Filter the image with Linear Diffusion ( usingGaussian filter) with sigma = 0.5
    ldpsnr(i) = psnr(output_linear,img);

    output_pmc =pmc(imnoise(img, noise,var(i)),img,0.05,timestep,Niter,0,w,1); %Filter the image with Perona Malik diffusion with lambda = 0.05
    pmcpsnr(i) = psnr(output_pmc,img);
   
    output_eed = eed(imnoise(img, noise,var(i)),1,0.05,timestep,Niter,0,1);   % Filter the image with Edge Enhancing Diffusion with lambda = 0.05
    eedpsnr(i) = psnr(output_eed,img);
end

figure(1);
plot(var, ldpsnr, 'b-', 'LineWidth', 1);
hold on;
plot(var, pmcpsnr, 'r-', 'LineWidth', 1);
hold on;
plot(var, eedpsnr, 'g-', 'LineWidth', 1);

xlabel('Variance in noise');
ylabel('PSNR');
title(['Plot of Variance vs PSNR for noise: ', noise]);
legend('LD', 'PMC', 'EED');
