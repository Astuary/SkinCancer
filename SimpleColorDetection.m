
function SimpleColorDetection()

close all;	% Close all figure windows except those created by imtool.

try
	
	fontSize = 16;
	figure;
	% Maximize the figure.
	set(gcf, 'Position', get(0, 'ScreenSize'));
	
	% Ask user if they want to use a demo image or their own image.
	message = sprintf('Do you want use a standard demo image,\nOr pick one of your own?');
	reply2 = questdlg(message, 'Which Image?', 'Demo','My Own', 'Demo');
	% Open an image.
	if strcmpi(reply2, 'Demo')
		% Read standard MATLAB demo image.
		% 	fullImageFileName = 'peppers.png';
		message = sprintf('Which demo image do you want to use?');
		selectedImage = questdlg(message, 'Which Demo Image?', 'Onions', 'Peppers', 'Canoe', 'Onions');
		if strcmp(selectedImage, 'Onions')
			fullImageFileName = 'onion.png';
		elseif strcmp(selectedImage, 'Peppers')
			fullImageFileName = 'peppers.png';
		else
			fullImageFileName = 'canoe.tif';
		end
	else
		% They want to pick their own.
		% Change default directory to the one containing the standard demo images for the MATLAB Image Processing Toolbox.
		originalFolder = pwd;
		folder = 'C:\Program Files\MATLAB\R2010a\toolbox\images\imdemos';
		if ~exist(folder, 'dir')
			folder = pwd;
		end
		cd(folder);
		% Browse for the image file.
		[baseFileName, folder] = uigetfile('*.*', 'Specify an image file');
		fullImageFileName = fullfile(folder, baseFileName);
		% Set current folder back to the original one.
		cd(originalFolder);
		selectedImage = 'My own image'; % Need for the if threshold selection statement later.
		
	end
	
	% Check to see that the image exists.  (Mainly to check on the demo images.)
	if ~exist(fullImageFileName, 'file')
		message = sprintf('This file does not exist:\n%s', fullImageFileName);
		uiwait(msgbox(message));
		return;
	end
	
	% Read in image into an array.
	[rgbImage storedColorMap] = imread(fullImageFileName);
    [rgbImage storedColorMap] = 
	[rows columns numberOfColorBands] = size(rgbImage);
	% If it's monochrome (indexed), convert it to color.
	% Check to see if it's an 8-bit image needed later for scaling).
	if strcmpi(class(rgbImage), 'uint8')
		% Flag for 256 gray levels.
		eightBit = true;
	else
		eightBit = false;
	end
	if numberOfColorBands == 1
		if isempty(storedColorMap)
			% Just a simple gray level image, not indexed with a stored color map.
			% Create a 3D true color image where we copy the monochrome image into all 3 (R, G, & B) color planes.
			rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
		else
			% It's an indexed image.
			rgbImage = ind2rgb(rgbImage, storedColorMap);
			% ind2rgb() will convert it to double and normalize it to the range 0-1.
			% Convert back to uint8 in the range 0-255, if needed.
			if eightBit
				rgbImage = uint8(255 * rgbImage);
			end
		end
	end
	% Display the original image.
	subplot(3, 4, 1);
	imshow(rgbImage);
	drawnow; % Make it display immediately.
	if numberOfColorBands > 1
		title('Original Color Image', 'FontSize', fontSize);
	else
		caption = sprintf('Original Indexed Image\n(converted to true color with its stored colormap)');
		title(caption, 'FontSize', fontSize);
	end
	
	% Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	redBand = rgbImage(:, :, 1);
	greenBand = rgbImage(:, :, 2);
	blueBand = rgbImage(:, :, 3);
	% Display them.
	subplot(3, 4, 2);
	imshow(redBand);
	title('Red Band', 'FontSize', fontSize);
	subplot(3, 4, 3);
	imshow(greenBand);
	title('Green Band', 'FontSize', fontSize);
	subplot(3, 4, 4);
	imshow(blueBand);
	title('Blue Band', 'FontSize', fontSize);
	message = sprintf('These are the individual color bands.\nNow we will compute the image histograms.');
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		% User canceled so exit.
		return;
	end
	
	fontSize = 13;
	
	% Compute and plot the red histogram.
	hR = subplot(3, 4, 6);
	[countsR, grayLevelsR] = imhist(redBand);
	maxGLValueR = find(countsR > 0, 1, 'last');
	maxCountR = max(countsR);
	bar(countsR, 'r');
	grid on;
	xlabel('Gray Levels');
	ylabel('Pixel Count');
	title('Histogram of Red Band', 'FontSize', fontSize);
	
	% Compute and plot the green histogram.
	hG = subplot(3, 4, 7);
	[countsG, grayLevelsG] = imhist(greenBand);
	maxGLValueG = find(countsG > 0, 1, 'last');
	maxCountG = max(countsG);
	bar(countsG, 'g', 'BarWidth', 0.95);
	grid on;
	xlabel('Gray Levels');
	ylabel('Pixel Count');
	title('Histogram of Green Band', 'FontSize', fontSize);
	
	% Compute and plot the blue histogram.
	hB = subplot(3, 4, 8);
	[countsB, grayLevelsB] = imhist(blueBand);
	maxGLValueB = find(countsB > 0, 1, 'last');
	maxCountB = max(countsB);
	bar(countsB, 'b');
	grid on;
	xlabel('Gray Levels');
	ylabel('Pixel Count');
	title('Histogram of Blue Band', 'FontSize', fontSize);
	
	% Set all axes to be the same width and height.
	% This makes it easier to compare them.
	maxGL = max([maxGLValueR,  maxGLValueG, maxGLValueB]);
	if eightBit
		maxGL = 255;
	end
	maxCount = max([maxCountR,  maxCountG, maxCountB]);
	axis([hR hG hB], [0 maxGL 0 maxCount]);
	
	% Plot all 3 histograms in one plot.
	subplot(3, 4, 5);
	plot(grayLevelsR, countsR, 'r', 'LineWidth', 2);
	grid on;
	xlabel('Gray Levels');
	ylabel('Pixel Count');
	hold on;
	plot(grayLevelsG, countsG, 'g', 'LineWidth', 2);
	plot(grayLevelsB, countsB, 'b', 'LineWidth', 2);
	title('Histogram of All Bands', 'FontSize', fontSize);
	maxGrayLevel = max([maxGLValueR, maxGLValueG, maxGLValueB]);
	% Trim x-axis to just the max gray level on the bright end.
	if eightBit
		xlim([0 255]);
	else
		xlim([0 maxGrayLevel]);
	end
	
	% Now select thresholds for the 3 color bands.
	message = sprintf('Now we will select some color threshold ranges\nand display them over the histograms.');
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		% User canceled so exit.
		return;
	end
	
	% Assign the low and high thresholds for each color band.
	if strcmpi(reply2, 'My Own') || strcmpi(selectedImage, 'Canoe') > 0
		% Take a guess at the values that might work for the user's image.
		redThresholdLow = graythresh(redBand);
		redThresholdHigh = 255;
		greenThresholdLow = 0;
		greenThresholdHigh = graythresh(greenBand);
		blueThresholdLow = 0;
		blueThresholdHigh = graythresh(blueBand);
		if eightBit
			redThresholdLow = uint8(redThresholdLow * 255);
			greenThresholdHigh = uint8(greenThresholdHigh * 255);
			blueThresholdHigh = uint8(blueThresholdHigh * 255);
		end
	else
		% Use values that I know work for the onions and peppers demo images.
		redThresholdLow = 85;
		redThresholdHigh = 255;
		greenThresholdLow = 0;
		greenThresholdHigh = 70;
		blueThresholdLow = 0;
		blueThresholdHigh = 90;
	end
	
	% Show the thresholds as vertical red bars on the histograms.
	PlaceThresholdBars(6, redThresholdLow, redThresholdHigh);
	PlaceThresholdBars(7, greenThresholdLow, greenThresholdHigh);
	PlaceThresholdBars(8, blueThresholdLow, blueThresholdHigh);
	
	message = sprintf('Now we will apply each color band threshold range to the color band.');
	reply = questdlg(message, 'Continue with Demo?', 'OK','Cancel', 'OK');
	if strcmpi(reply, 'Cancel')
		% User canceled so exit.
		return;
	end
	
	% Now apply each color band's particular thresholds to the color band
	redMask = (redBand >= redThresholdLow) & (redBand <= redThresholdHigh);
	greenMask = (greenBand >= greenThresholdLow) & (greenBand <= greenThresholdHigh);
	blueMask = (blueBand >= blueThresholdLow) & (blueBand <= blueThresholdHigh);
	
	% Display the thresholded binary images.
	fontSize = 16;
	subplot(3, 4, 10);
	imshow(redMask, []);
	title('Is-Red Mask', 'FontSize', fontSize);
	subplot(3, 4, 11);
	imshow(greenMask, []);
	title('Is-Not-Green Mask', 'FontSize', fontSize);
	subplot(3, 4, 12);
	imshow(blueMask, []);
	title('Is-Not-Blue Mask', 'FontSize', fontSize);
	% Combine the masks to find where all 3 are "true."
	% Then we will have the mask of only the red parts of the image.
	redObjectsMask = uint8(redMask & greenMask & blueMask);
	subplot(3, 4, 9);
	imshow(redObjectsMask, []);
	caption = sprintf('Mask of Only\nThe Red Objects');
	title(caption, 'FontSize', fontSize);
	
catch ME
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	errordlg(errorMessage);
end
return; % from SimpleColorDetection()
% ---------- End of main function ---------------------------------
%----------------------------------------------------------------------------
% Measure the mean intensity and area of each blob in each color band.

% Function to show the low and high threshold bars on the histogram plots.
function PlaceThresholdBars(plotNumber, lowThresh, highThresh)
try
	% Show the thresholds as vertical red bars on the histograms.
	subplot(3, 4, plotNumber);
	hold on;
	yAxisRangeValues = ylim;
	line([lowThresh, lowThresh], yAxisRangeValues, 'Color', 'r', 'LineWidth', 2);
	line([highThresh, highThresh], yAxisRangeValues, 'Color', 'r', 'LineWidth', 2);
	% Place a text label on the bar chart showing the threshold.
	fontSizeThresh = 14;
	annotationTextL = sprintf('%d', lowThresh);
	annotationTextH = sprintf('%d', highThresh);
	% For text(), the x and y need to be of the data class "double" so let's cast both to double.
	text(double(lowThresh + 5), double(0.85 * yAxisRangeValues(2)), annotationTextL, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	text(double(highThresh + 5), double(0.85 * yAxisRangeValues(2)), annotationTextH, 'FontSize', fontSizeThresh, 'Color', [0 .5 0], 'FontWeight', 'Bold');
	
	% Show the range as arrows.
	% Can't get it to work, with either gca or gcf.
	% 	annotation(gca, 'arrow', [lowThresh/maxXValue(2) highThresh/maxXValue(2)],[0.7 0.7]);
catch ME
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	errordlg(errorMessage);
end
return; % from PlaceThresholdBars()

%======================================================================================================================
% Gets a string describing the call stack where each line is the filename, function name, and line number in that file.
% Sample usage
% try
% 	% Some code that might throw an error......
% catch ME
% 	callStackString = GetCallStack(ME);
% 	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
% 		mfilename, callStackString, ME.message);
% 	WarnUser(errorMessage);
% end
function callStackString = GetCallStack(errorObject)
try
	theStack = errorObject.stack;
	callStackString = '';
	stackLength = length(theStack);
	if stackLength == 3
		% Some problem in the OpeningFcn
		% Only the first item is useful, so just alert on that.
		[folder, baseFileName, ext] = fileparts(theStack(1).file);
		baseFileName = sprintf('%s%s', baseFileName, ext);
		callStackString = sprintf('%s in file %s, in the function %s, at line %d\n', callStackString, baseFileName, theStack(1).name, theStack(1).line);
	else
		% Got past the OpeningFcn and had a problem in some other function.
		for k = 1 : length(theStack)-3
			[folder, baseFileName, ext] = fileparts(theStack(k).file);
			baseFileName = sprintf('%s%s', baseFileName, ext);
			callStackString = sprintf('%s in file %s, in the function %s, at line %d\n', callStackString, baseFileName, theStack(k).name, theStack(k).line);
		end
	end
catch ME
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from callStackString