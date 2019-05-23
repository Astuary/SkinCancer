clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;
% Read in a standard MATLAB color demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
baseFileName = 'football.jpg';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
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

fullFileName = 'F:\BE - VIII\Project\Malignant Melanoma\ISIC-images\ISIC-images\UDA-1\ISIC_0000013.jpg';
rgbImage = imread(fullFileName);
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows columns numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(2, 2, 1);
imshow(rgbImage, []);
title('Original Color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Convert to hsv color space.
hsv = rgb2hsv(rgbImage);
% Display the color channels.
hueImage = hsv(:, :, 1);
saturationImage = hsv(:, :, 2);
valueImage = hsv(:, :, 3);
subplot(2, 2, 2);
imshow(hueImage, []);
title('Hue Channel', 'FontSize', fontSize);
subplot(2, 2, 3);
imshow(saturationImage, []); 
title('Saturation Channel', 'FontSize', fontSize);
subplot(2, 2, 4);
imshow(valueImage, [])
title('Value Channel', 'FontSize', fontSize);
% Look at the histogram of the hue channel
% so we can see where the blue is
[pixelCounts values] = hist(hueImage, 500);
figure;
subplot(2, 2, 1);
bar(values, pixelCounts);
title('Histogram of Hue Channel', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Blue looks like it's in the 0.4 to 0.7 region.  
% Amplify that by increasing saturation for those pixels.
% Find blue pixels.  They have to have the right hue but not be too bright.
bluePixels = hueImage > 0.4 & hueImage < 0.7 & valueImage < 0.8;
subplot(2, 2, 2);
imshow(bluePixels);
title('Map of Blue Pixels', 'FontSize', fontSize);
% Multiply the saturation channel by 1.5 for those pixels.
saturationImage(bluePixels) = saturationImage(bluePixels) * 3.5;
subplot(2, 2, 3);
imshow(saturationImage);
title('New Saturation Channel', 'FontSize', fontSize);
% Combine back to form new hsv image
hsvImage = cat(3, hueImage, saturationImage, valueImage);
% Convert back to RGB color space.
rgbImage = hsv2rgb(hsvImage);
subplot(2, 2, 4);
imshow(rgbImage);
title('RGB Image with Enhanced Blue', 'FontSize', fontSize);