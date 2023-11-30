function g = eed(f,scale, k, stepsize,nosteps,verbose,ip)      
% Edge Enhancing diffusion
      
    if verbose
        figure(verbose);
        subplot(1,2,1);
        imshow(f);
        title('Original Image');
        drawnow;
    end
    
    % Diffusion tensor D = D(delu) = (v1, v2)diag(l1, l2)(v1T, v2T)
    % D = G^T.diag(c1,c2).G ; G = (gx, gy) 
    g = f;
    for i = 1:nosteps
        %Calculating gx, gy and gw at given scale for diffusion tensor; 
        gx = gD( g, scale, 1, 0 );      % Computing the gradient
        gy = gD( g, scale, 0, 1 );

        grad2 = gx.*gx+gy.*gy;  
        gw = sqrt(grad2);

        %Calculating c1 and c2
        c2 = exp(-(gw/k).^2);
        c1 = (1/5)*c2;

        %Calculating diffusion tensor components for tnldStep function  
        a = (c1.*gx.^2 + c2.*gy.^2)./grad2;
        b = (c2-c1).*gx.*gy./grad2;
        c = (c1.*gy.^2 + c2.*gx.^2)./grad2;

        g = g + stepsize * tnldStep( g, a, b, c, ip);

        %If verbose show edge enhanced diffusion
        if verbose
            figure(verbose);
            subplot(1,2,2);
            imshow(g);
            title('Edge Enhancing Diffusion');
            drawnow;
        end
    end