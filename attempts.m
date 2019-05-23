folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
%folder = 'F:\BE - VIII\Project\Malignant\ISIC-images\ISIC-images\UDA-1';
baseFileName = 'ISIC_0000095.jpg';
fullFileName = fullfile(folder, baseFileName);

I = imread(fullFileName);
%I = imread('ISIC_0000043.jpg');
redChannel = I(:,:,1);

se = strel('disk',10);
I2 = imbothat(redChannel,se);
subplot(2, 3, 1);
imshow(I2);
title("Red Channel Bottom Hatted");
I3 = imadjust(I2, [0, 0.1], [0, 1.0]);
subplot(2,3,2);
imshow(I3);
title("Adjust Contrast");
%I4 = fibermetric(I3, 5, 'ObjectPolarity', 'dark', 'StructureSensitivity', 8);
I4 = I3;
subplot(2,3,3);
imshow(I4);
title("Fiber Metric");
I5 = I4 > 200; %150 seems good
subplot(2,3,4);
imshow(I5);
title("Thresholded");

I7 = medfilt2(I5);
I7 = medfilt2(I7);
I7 = medfilt2(I7);
I7 = medfilt2(I7);
I7 = medfilt2(I7);
subplot(2,3,5);
imshow(I7);
title("Median Filter");

I6 = imdilate(I7, true(5));
subplot(2,3,6);
imshow(I6);
title("Dilated");
% subplot(2,3,6);
% imshow(I);
% title("Original");