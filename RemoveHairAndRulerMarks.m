%clc;                                        % Clear the command window.
close all;                                  % Close all figures (except those of imtool.)
imtool close all;                           % Close all imtool figures.
clear;                                      % Erase all existing variables.
workspace;                                  % Make sure the workspace panel is showing.
fontSize = 14;                              % To change font size of figure texts

%folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
%folder = 'F:\BE - VIII\Project\Malignant Melanoma\ISIC-images\ISIC-images\UDA-1';   %error in 76, 282, 286
%folder = 'F:\BE - VIII\Project\Nisarg Bharathan Data\Train\Malignant';
folder = 'F:\BE - VIII\Project\Squamous Cell Carcinoma\ISIC-images\ISIC-images\Data';

baseFileName = 'ISIC_0024242.jpg';

fullFileName = fullfile(folder, baseFileName);  % Get the full filename, with path prepended.

if ~exist(fullFileName, 'file')
  % Didn't find it there.  Check the search path for it.
  fullFileName = baseFileName; % No path this time.
  if ~exist(fullFileName, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end

I = imread(fullFileName);                    %Get RGB Image.
redChannel = I(:,:,1);                       %Extract Red Channel. It will be in Grayscale.
%Note: In many cases, Blue channel in more effective because of the tint of lens of capturing device.

se = strel('disk',10);                       %Morphological Structure: long hair strands .
I2 = imbothat(redChannel,se);                %Bottom Hat Filter on Red Channel to get the long hair structures.

subplot(2, 3, 1);
imshow(I2);
title("Red Channel Bottom Hatted");         %Display After First Filter.

I3 = imadjust(I2, [0, 0.1], [0, 1.0]);       %Get a better contrast for light/thin white hair and black background.
subplot(2,3,2);                              %Black from 0.0 to 0.1 expanded into wider range.
imshow(I3);
title("Adjusted Contrast");

%I4 = fibermetric(I3, 5, 'ObjectPolarity', 'dark', 'StructureSensitivity', 8);
I4 = I3;                                     %Fiber Metric Filter for specifically long and thin fiber like objects but yet to get a satisfactory result.
% subplot(2,3,3);                              %Skipping this filter for now.
% imshow(I4);
% title("Fiber Metric Filtered (Skipped)");

I5 = I4 > 200;                               %150 seems good too.
subplot(2,3,3);                              %Thresholding: Grayscale --> Binary.
imshow(I5);                                  %Only Hair and Black Background. Still some fragments of Background mole can be seen.
title("Thresholded");

I7 = medfilt2(I5);                           %Attempt at removing mole fragments.
I7 = medfilt2(I7);
I7 = medfilt2(I7);
I7 = medfilt2(I7);
I7 = medfilt2(I7);
%I7 = I5;                                     % To skip median filter.
subplot(2,3,4);
imshow(I7);
title("Median Filtered");

I7 = bwareaopen(I7, 90);
subplot(235);
imshow(I7);
title("Removing small areas");

I6 = imdilate(I7, true(5));                  %Thickened/Highlighted the hairs even more to make them distinct for later stages.               
subplot(2,3,6);
imshow(I6);
title("Dilated")

set(gcf, 'units','normalized','outerposition',[0 0 1 1]);


rgbImage = imread(fullFileName);                        %Same as 'I' variable.
[rows, columns, numberOfColorBands] = size(rgbImage);   % Get the dimensions of the image.  numberOfColorBands should be = 3.

figure;
subplot(2, 2, 1);                                       % Display the original color image.
imshow(rgbImage, []);
title('Original Color Image', 'FontSize', fontSize);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Enlarge figure to full screen.

% rgbImage = imerode(rgbImage, true(5));                %Erosion not given proper end results. 

redChannel = rgbImage(:, :, 1);                         % Extract the individual red, 
greenChannel = rgbImage(:, :, 2);                       % green, and 
blueChannel = rgbImage(:, :, 3);                        % blue color channels.

subplot(2, 2, 2);
imshow(redChannel, []);
title('Red Channel', 'FontSize', fontSize);

subplot(2, 2, 3);
imshow(greenChannel, []);
title('Green Channel', 'FontSize', fontSize);

subplot(2, 2, 4);
imshow(blueChannel, []);
title('Blue Channel', 'FontSize', fontSize);

figure;
[pixelCount, grayLevels] = imhist(redChannel);          % Compute and display the histogram.
subplot(2, 2, 1); 
bar(pixelCount);
grid on;
title('Histogram of red Channel', 'FontSize', fontSize);
xlim([0 grayLevels(end)]);                              % Scale x axis manually.
% Threshold the image
% binaryImage = redChannel < 100;
% binaryImage = imdilate(binaryImage, true(5));

binaryImage = I6;
% binaryImage = bwareaopen(binaryImage, 200);
subplot(2, 2, 2);
imshow(binaryImage, []);
title('Binary Image', 'FontSize', fontSize);            % Display Binary Image.

redChannel = regionfill(redChannel, binaryImage);       % Fill in the mask
greenChannel = regionfill(greenChannel, binaryImage);
blueChannel = regionfill(blueChannel, binaryImage);
noHairImage = cat(3, redChannel, greenChannel, blueChannel);

subplot(2, 2, 3);
imshow(noHairImage, []);
title('No Hair Image', 'FontSize', fontSize);           % Display Final Result.

subplot(2, 2, 4);
imshow(rgbImage, []);
title('Original Image', 'FontSize', fontSize);          % Displaying Original for Comparison.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% se = strel('disk',10);
% hairs = imbothat(redChannel1,se);
% %figure; imshow(hairs);
% hairs = imadjust(hairs);
% figure; imshow(hairs);
% hairs = fibermetric(hairs, 5, 'ObjectPolarity', 'dark', 'StructureSensitivity', 8);
% figure; imshow(hairs);
% hairs = hairs > 0.6;
% figure; imshow(hairs);
% hairs = imdilate(hairs, true(5));
% figure; imshow(hairs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%