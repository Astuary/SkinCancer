function [ellipse_array, ea_i] = Ellipse(x,y)
   
    aE = floor(x/2);
    bE = floor(y/2);

    ellipse = ones(x,y);
    ea_i = 1;
    
    for i = 0:(aE-1)
        j = floor(sqrt(((aE*aE*bE*bE) - (i*i*bE*bE))/(aE*aE))+0.5);
        ellipse(aE+i, bE+j) = 0;
        ellipse(aE+i, bE-j+1) = 0;
        ellipse(aE-i, bE+j) = 0;
        ellipse(aE-i, bE-j+1) = 0;
        ellipse_array(ea_i, 1) = aE + i;
        ellipse_array(ea_i, 2) = bE + j;
        ea_i = ea_i + 1;
        ellipse_array(ea_i, 1) = aE + i;
        ellipse_array(ea_i, 2) = bE - j + 1;
        ea_i = ea_i + 1;
        ellipse_array(ea_i, 1) = aE - i;
        ellipse_array(ea_i, 2) = bE + j;
        ea_i = ea_i + 1;
        ellipse_array(ea_i, 1) = aE - i;
        ellipse_array(ea_i, 2) = bE - j + 1;
        ea_i = ea_i + 1;
    end

    for j = 0:(bE-1)
        i = floor(sqrt(((aE*aE*bE*bE) - (j*j*aE*aE))/(bE*bE))+0.5);
        ellipse(aE+i, bE+j) = 0;
        ellipse(aE+i, bE-j) = 0;
        ellipse(aE-i+1, bE+j) = 0;
        ellipse(aE-i+1, bE-j) = 0;
        ellipse_array(ea_i, 1) = aE + i;
        ellipse_array(ea_i, 2) = bE + j;
        ea_i = ea_i + 1;
        ellipse_array(ea_i, 1) = aE + i;
        ellipse_array(ea_i, 2) = bE - j;
        ea_i = ea_i + 1;
        ellipse_array(ea_i, 1) = aE - i - 1;
        ellipse_array(ea_i, 2) = bE + j;
        ea_i = ea_i + 1;
        ellipse_array(ea_i, 1) = aE - i - 1;
        ellipse_array(ea_i, 2) = bE - j;
        ea_i = ea_i + 1;
    end

    %figure; imshow(ellipse);
end