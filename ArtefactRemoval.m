close all;                                  % Close all figures (except those of imtool.)
imtool close all;                           % Close all imtool figures.
clear;                                      % Erase all existing variables.
workspace;                                  % Make sure the workspace panel is showing.
fontSize = 14;                              % To change font size of figure texts

%folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
folder = 'F:\BE - VIII\Project\Malignant Melanoma\ISIC-images\ISIC-images\UDA-1';
baseFileName = 'ISIC_0000004.jpg';
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

original_image = imread(fullFileName);
red_channel = original_image(:,:,1);
green_channel = original_image(:,:,2);
blue_channel = original_image(:,:,3);

figure;
subplot(331);
imshow(original_image);
title("Original RGB Image");
subplot(332);
imshow(red_channel);
title("Red Channel");
subplot(333);
imshow(green_channel);
title("Green Channel");
subplot(334);
imshow(blue_channel);
title("Blue Channel");

cie_image = rgb2xyz(original_image);
subplot(335);
imshow(cie_image);
title("CIE Image");

lab_image = rgb2lab(original_image);
subplot(336);
imshow(lab_image);
title("LAB Image");

lab_red_channel = lab_image(:,:,1);
lab_green_channel = lab_image(:,:,2);
lab_blue_channel = lab_image(:,:,3);

subplot(337);
imshow(lab_image(:,:,1),[0 100]);
title("L Component");

figure;
mask = lab_image(:,:,1) > 0.5;
imshow(mask);
