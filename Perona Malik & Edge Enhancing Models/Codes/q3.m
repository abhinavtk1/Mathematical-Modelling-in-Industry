% A3-q3
clc;
clear;

% Importing 5 images
img1 = im2double(imread('cameraman.tif')); % reading the image and normalizing the instensity values b/w 0 and 1
img2 = im2double(imread('tomo.jpg'));
img3 = im2double(im2gray(imread('triangle.jpg'))); % converting color img to greyscale 
img4 = im2double(im2gray(imread('onion.png')));
img5 = im2double(imread('eight.tif'));

n_img = 5; % No. of images
n_noise = 10;   % No. of noisy images for each image

% Declare a cellArray of size 5x10 to store noisy images of each image
cellArray = cell(n_img,n_noise);

% Adding Gaussian noise, Poisson, Salt & Pepper noise and speckle noise with different variances 

cellArray(1,1) = {img1};                            % original image1
cellArray(1,2) = {imnoise(img1, 'gaussian',0.01)};  % image with noise
cellArray(1,3) = {imnoise(img1, 'gaussian',0.1)}; 
cellArray(1,4) = {imnoise(img1, 'gaussian',0.5)}; 
cellArray(1,5) = {imnoise(img1, 'poisson')}; 
cellArray(1,6) = {imnoise(img1, 'salt & pepper',0.01)};
cellArray(1,7) = {imnoise(img1, 'salt & pepper',0.05)}; 
cellArray(1,8) = {imnoise(img1, 'salt & pepper',0.1)}; 
cellArray(1,9) = {imnoise(img1, 'speckle',0.01)}; 
cellArray(1,10) = {imnoise(img1, 'speckle',0.1)}; 

cellArray(2,1) = {img2};                            % original image2
cellArray(2,2) = {imnoise(img2, 'gaussian',0.01)};  % image with noise
cellArray(2,3) = {imnoise(img2, 'gaussian',0.1)}; 
cellArray(2,4) = {imnoise(img2, 'gaussian',0.5)}; 
cellArray(2,5) = {imnoise(img2, 'poisson')}; 
cellArray(2,6) = {imnoise(img2, 'salt & pepper',0.01)};
cellArray(2,7) = {imnoise(img2, 'salt & pepper',0.05)}; 
cellArray(2,8) = {imnoise(img2, 'salt & pepper',0.1)}; 
cellArray(2,9) = {imnoise(img2, 'speckle',0.01)}; 
cellArray(2,10) = {imnoise(img2, 'speckle',0.1)}; 

cellArray(3,1) = {img3};                            % original image3
cellArray(3,2) = {imnoise(img3, 'gaussian',0.01)};  % image with noise
cellArray(3,3) = {imnoise(img3, 'gaussian',0.1)}; 
cellArray(3,4) = {imnoise(img3, 'gaussian',0.5)}; 
cellArray(3,5) = {imnoise(img3, 'poisson')}; 
cellArray(3,6) = {imnoise(img3, 'salt & pepper',0.01)};
cellArray(3,7) = {imnoise(img3, 'salt & pepper',0.05)}; 
cellArray(3,8) = {imnoise(img3, 'salt & pepper',0.1)}; 
cellArray(3,9) = {imnoise(img3, 'speckle',0.01)}; 
cellArray(3,10) = {imnoise(img3, 'speckle',0.1)}; 

cellArray(4,1) = {img4};                            % original image4
cellArray(4,2) = {imnoise(img4, 'gaussian',0.01)};  % image with noise
cellArray(4,3) = {imnoise(img4, 'gaussian',0.1)}; 
cellArray(4,4) = {imnoise(img4, 'gaussian',0.5)}; 
cellArray(4,5) = {imnoise(img4, 'poisson')}; 
cellArray(4,6) = {imnoise(img4, 'salt & pepper',0.01)};
cellArray(4,7) = {imnoise(img4, 'salt & pepper',0.05)}; 
cellArray(4,8) = {imnoise(img4, 'salt & pepper',0.1)}; 
cellArray(4,9) = {imnoise(img4, 'speckle',0.01)}; 
cellArray(4,10) = {imnoise(img4, 'speckle',0.1)}; 

cellArray(5,1) = {img5};                            % original image5
cellArray(5,2) = {imnoise(img5, 'gaussian',0.01)};  % image with noise
cellArray(5,3) = {imnoise(img5, 'gaussian',0.1)}; 
cellArray(5,4) = {imnoise(img5, 'gaussian',0.5)}; 
cellArray(5,5) = {imnoise(img5, 'poisson')}; 
cellArray(5,6) = {imnoise(img5, 'salt & pepper',0.01)};
cellArray(5,7) = {imnoise(img5, 'salt & pepper',0.05)}; 
cellArray(5,8) = {imnoise(img5, 'salt & pepper',0.1)}; 
cellArray(5,9) = {imnoise(img5, 'speckle',0.01)}; 
cellArray(5,10) = {imnoise(img5, 'speckle',0.1)}; 

% Initialize psnr array to store psnr values
psnr_array = zeros(5,10,3);

% Apply LD, PMC and EED for each noisy images and report respective PSNR values 

timestep = 0.2; % timestep size used in numerical approximation
Niter = 60; % number of iterations 

alpha=2.7;              % Used in Numerical approximation of pmc
w= exp(4*alpha/9);      % Used in Numerical approximation of pmc

for i = 1:n_img
    for j = 1:n_noise   % 
        output_linear = imgaussfilt(cellArray{i,j},0.5);    %Filter the image with Linear Diffusion ( usingGaussian filter) with sigma = 0.5
        output_pmc =pmc(cellArray{i,j},cellArray{i,1},0.05,timestep,Niter,0,w,1); %Filter the image with Perona Malik diffusion with lambda = 0.05
        output_eed = eed(cellArray{i,j},1,0.05,timestep,Niter,0,1);   % Filter the image with Edge Enhancing Diffusion with lambda = 0.05
        psnr_array(i,j,1) = psnr(output_linear,cellArray{i,1});         % PSNR value for Linear diffusion with sigma = 0.5
        psnr_array(i,j,2) = psnr(output_pmc,cellArray{i,1});             % PSNR value for Perona Malik diffusion with lambda = 0.05
        psnr_array(i,j,3) = psnr(output_eed,cellArray{i,1});          % PSNR value for Edge Enhancing diffusion with lambda = 0.05

    end
end
