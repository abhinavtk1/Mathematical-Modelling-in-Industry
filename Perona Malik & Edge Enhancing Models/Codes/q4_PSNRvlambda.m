% A3q4 - PSNR vs Contrast parameter (lambda)
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
lambda = logspace(-5,0,n)';    % Lambda - contasrt parameter           
ldpsnr = zeros(1,n);
pmcpsnr = zeros(1,n);
eedpsnr = zeros(1,n);
% Apply LD, PMC and EED for each noisy images and report respective PSNR values

%% Change img and noise for different conditions
img = img1;                 % img = img1, img2, img3, img4, img5
noise = "poisson";         % noise type = gaussian, salt & pepper, speckle, poisson

for i = 1:n                 
    output_linear = imgaussfilt(imnoise(img, noise),0.5);    %Filter the image with Linear Diffusion ( usingGaussian filter) with sigma = 0.5
    ldpsnr(i) = psnr(output_linear,img);

    output_pmc =pmc(imnoise(img, noise),img,lambda(i),timestep,Niter,0,w,1); %Filter the image with Perona Malik diffusion for different lambda
    pmcpsnr(i) = psnr(output_pmc,img);
   
    output_eed = eed(imnoise(img, noise),1,lambda(i),timestep,Niter,0,1);   % Filter the image with Edge Enhancing Diffusion for different lambda
    pmcpsnr(i) = psnr(output_pmc,img);
    eedpsnr(i) = psnr(output_eed,img);
end

figure(1);
plot(lambda, ldpsnr, 'b-', 'LineWidth', 1);
hold on;
plot(lambda, pmcpsnr, 'r-', 'LineWidth', 1);
hold on;
plot(lambda, eedpsnr, 'g-', 'LineWidth', 1);
hold off;
xlabel('Contrast parameter, Lambda');
ylabel('PSNR');
title(['Plot of Lambda vs PSNR for noise: ', noise]);
legend('LD', 'PMC', 'EED');
