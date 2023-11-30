function g=pmc(f,ref,k,stepsize,nosteps,verbose,w,ip)
% Perona and Malik diffusion 

    if verbose
        figure(verbose);
        subplot(1,2,1);
        imshow(f);
        title('Original Image');
        drawnow;
    end
    g = f;
    [n,m]=size(f);
    N=n*m;

for i=1:nosteps
    
    g=gD(g,0.001,0,0);  % Apply this for Catte et al model
    gx=gD(g,k,1,0);     % Computing the gradient     
    gy=gD(g,k,0,1);     % k = Lamda contrast parameter= 1 default; 
    
    grad2=gx.*gx+gy.*gy;     % delU.sq
    c=C(grad2);  %  computing the diffusivity for PMC   (g(delU.sq))             
   

    % Compute the magnitude of the gradient.
    val=ip;
    switch val
       case 1
           % With  Weickert standard explicit scheme
           g=g+stepsize*snldStep(g,c,w,ip);

        otherwise disp('invalid choice');
    end
    
     if verbose
        figure(verbose);
        subplot(1,2,2);
        imshow(g);
        title('Perona and Malik Diffusion');
        drawnow;
     end        
end



