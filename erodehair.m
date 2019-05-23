folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
file = 'ISIC_0000095.jpg'
fullFileName = fullfile(folder, file);

I = imread(fullFileName);
figure;
subplot(3,3,1);
imshow(I);
title("Original");

I1 = imerode(I, true(10));
subplot(3,3,2);
imshow(I1);
title("Eroded");

red = I1(:,:,1);
subplot(3,3,3);
imshow(red);
title("Red Channel");

I2 = imadjust(red, [0.0, 0.5], [0, 1.0]);
subplot(3,3,4);
imshow(I2);
title("Adjust Contrast");

I3 = I2 > 250; 
subplot(3,3,5);
imshow(I3);
title("Thresholded");

I4 = medfilt2(I3);
I4 = medfilt2(I4);
I4 = medfilt2(I4);
I4 = medfilt2(I4);
I4 = medfilt2(I4);
subplot(3,3,6);
imshow(I4);
title("Median Filter");

I5 = imdilate(I4, true(5));
subplot(3,3,7);
imshow(I5);
title("Dilated");