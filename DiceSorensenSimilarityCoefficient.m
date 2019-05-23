% Dice Sorensen Similarity Coefficient demo
% Reference for a bunch of similar similarity and dissimilarity coefficents:
% http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.1334&rep=rep1&type=pdf
function DiceSorensenSimilarityCoefficient()
%clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 15;

% Check that user has the specified Toolbox installed and licensed.
hasLicenseForToolbox = license('test', 'image_toolbox');   % license('test','Statistics_toolbox'), license('test','Signal_toolbox')
if ~hasLicenseForToolbox
	% User does not have the toolbox installed, or if it is, there is no available license for it.
	% For example, there is a pool of 10 licenses and all 10 have been checked out by other people already.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

%grayImage = GetImage();
grayImage = rgb2gray(imread('F:\BE - VIII\Project\Malignant\ISIC-images\ISIC-images\UDA-1\ISIC_0000173.jpg'));
grayImage = rgb2gray(imread('F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1\ISIC_0000039.jpg'));

% Display the image.
subplot(3, 3, 1);
imshow(grayImage, []);
title('Original Grayscale Image', 'FontSize', fontSize, 'Interpreter', 'None');

% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 

% Let's compute and display the histogram.
[pixelCount, grayLevels] = imhist(grayImage);
subplot(3, 3, 2:3); 
bar(grayLevels, pixelCount, 'BarWidth', 1); % Plot it as a bar chart.
grid on;
title('Histogram of original image', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Gray Level', 'FontSize', fontSize);
ylabel('Pixel Count', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
xticks(0:10:255);

% Get the thresholds from which we'll use to create two binary images:
[lowThreshold, highThreshold] = GetThresholds(pixelCount, grayLevels)

% Put lines up on the histogram showing the thresholds.
line([lowThreshold, lowThreshold], ylim, 'LineWidth', 2, 'Color', 'r');
line([highThreshold, highThreshold], ylim, 'LineWidth', 2, 'Color', 'r');

% Create the binary images.
binaryImage1 = grayImage > lowThreshold;
binaryImage2 = grayImage > highThreshold;

binaryImage1 = cutout;
binaryImage2 = cutoutlr;

% Display the image.
subplot(3, 3, 4);
imshow(binaryImage1, []);
caption = sprintf('Binary Image 1 thresholded at %d', lowThreshold);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
% Display the image.
subplot(3, 3, 5);
imshow(binaryImage2, []);
caption = sprintf('Binary Image 2 thresholded at %d', highThreshold);
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

% AND these together
andImage = binaryImage1 & binaryImage2;

% Just for fun, compute and show the OR and XOR.
% They're not used in the computation for the similarity coefficient though.
% OR these together
orImage = binaryImage1 | binaryImage2;
% XOR these together
xorImage = xor(binaryImage1, binaryImage2);

% Display the image.
subplot(3, 3, 7);
imshow(andImage, []);
caption = sprintf('Binary Image 1 AND Binary Image 2');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
% Display the image.
subplot(3, 3, 8);
imshow(orImage, []);
caption = sprintf('Binary Image 1 OR Binary Image 2');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
% Display the image.
subplot(3, 3, 9);
imshow(xorImage, []);
caption = sprintf('XOR : 1 or 2, but not both');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

% Compute the Disc Sorensen Coefficient for similarity.
numPixelsPresentInBoth = nnz(andImage);
dsCoefficient = 2 * numPixelsPresentInBoth / (nnz(binaryImage1) + nnz(binaryImage2))
message = sprintf('The Dice Sorensen Similarity Coefficient = %.2f', dsCoefficient);
uiwait(helpdlg(message));


%===============================================================================
% Ask the user to pick one of the demo images that ships with the Image Processing Toolbox.
function grayImage = GetImage()
% Get the name of the demo image the user wants to use.
% Let's let the user select from a list of all the demo images that ship with the Image Processing Toolbox.
folder = fileparts(which('cameraman.tif')); % Determine where demo folder is (works with all versions).
% Demo images have extensions of TIF, PNG, and JPG.  Get a list of all of them.
imageFiles = [dir(fullfile(folder,'*.TIF')); dir(fullfile(folder,'*.PNG')); dir(fullfile(folder,'*.jpg'))];
for k = 1 : length(imageFiles)
% 	fprintf('%d: %s\n', k, files(k).name);
	[~, baseFileName, extension] = fileparts(imageFiles(k).name);
	ca{k} = [baseFileName, extension];
end
% Sort the base file names alphabetically.
[ca, sortOrder] = sort(ca);
imageFiles = imageFiles(sortOrder);
button = menu('Use which gray scale demo image?', ca); % Display all image file names in a popup menu.
% Get the base filename.
baseFileName = imageFiles(button).name; % Assign the one on the button that they clicked on.
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);

%===============================================================================
% Read in a standard MATLAB gray scale demo image.
% Check if file exists.
if ~exist(fullFileName, 'file')
	% The file doesn't exist -- didn't find it there in that folder.  
	% Check the entire search path (other folders) for the file by stripping off the folder.
	fullFileNameOnSearchPath = baseFileName; % No path this time.
	if ~exist(fullFileNameOnSearchPath, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
grayImage = imread(fullFileName);
% Get the dimensions of the image.  
% numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
[rows, columns, numberOfColorChannels] = size(grayImage);
if numberOfColorChannels > 1
	% It's not really gray scale like we expected - it's color.
	% Use weighted sum of ALL channels to create a gray scale image.
	grayImage = rgb2gray(grayImage); 
	% ALTERNATE METHOD: Convert it to gray scale by taking only the green channel,
	% which in a typical snapshot will be the least noisy channel.
	% grayImage = grayImage(:, :, 2); % Take green channel.
end


%===============================================================================
% Get the thresholds from which we'll use to create two binary images:
function [lowThreshold, highThreshold] = GetThresholds(pixelCount, grayLevels)
cdf = cumsum(pixelCount);
cdf = cdf / cdf(end);
lowPercentage = 20;
lowThresholdIndex = find(cdf > lowPercentage / 100, 1, 'first'); 
lowThreshold = grayLevels(lowThresholdIndex);
highPercentage = 40;
highThresholdIndex = find(cdf > highPercentage / 100, 1, 'first'); 
highThreshold = grayLevels(highThresholdIndex);