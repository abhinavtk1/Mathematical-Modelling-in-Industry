%%Implement Linear Isotropic Diffusion using inbuilt Gaussian filter function.
clear;
clc;

Img = imread('cameraman.tif');        %%Take input image
J = imnoise(Img,'speckle');           %add noise to image

n = 100;                            % No. of sigma values
sigma = linspace(0.001,10,n)';      % sigma = Smoothing parameter
peaksnr = zeros(n,1);               % Initialize PSNR - Metric to understand the quality of cleaning

for i=1:n
    Jfilt = imgaussfilt(J,sigma(i));    %Filter the image with a Gaussian filter with standard deviation sigma(i) to smoothen the noise
    peaksnr(i) = psnr(Jfilt,J);         % PSNR - Metric to understand the quality of cleaning
end

data = [sigma peaksnr];

figure(1);
plot(sigma, peaksnr, 'k-o', "MarkerFaceColor",'r',"MarkerSize",5);
xlabel('Sigma');
ylabel('PSNR');
title('Plot of Sigma vs PSNR');


Jfilt1 = imgaussfilt(J,1);  % Filtered image for sigma = 1
Jfilt5 = imgaussfilt(J,5);  % Filtered image for sigma = 5
 
figure(2);
montage({J,Jfilt1});    % Compare noise and filtered image
title('Noisy Image Vs. Gaussian Filtered Image (σ = 1) ');

figure(3);
montage({J,Jfilt5});    % Compare noise and filtered image
title('Noisy Image Vs. Gaussian Filtered Image (σ = 5)');
