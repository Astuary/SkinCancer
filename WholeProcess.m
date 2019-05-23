close all;                                  % Close all figures (except those of imtool.)
imtool close all;                           % Close all imtool figures.
clear;                                      % Erase all existing variables.
workspace;                                  % Make sure the workspace panel is showing.
fontSize = 14;                              % To change font size of figure texts

%folder = 'F:\BE - VIII\Project\Squamous Cell Carcinoma\ISIC-images\ISIC-images\Data';
%baseFileName = 'ISIC_0011726.jpg';

%folder = 'F:\BE - VIII\Project\Basal Cell Carcinoma\ISIC-images\ISIC-images\Data';
%baseFileName = 'ISIC_0001159.jpg';
%baseFileName = 'ISIC_0024332.jpg';

%folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
%baseFileName = 'ISIC_0000084.jpg';
%baseFileName = 'ISIC_0000085.jpg';
%baseFileName = 'ISIC_0000097.jpg';

folder = 'F:\BE - VIII\Project\Malignant Melanoma\ISIC-images\ISIC-images\UDA-1';   %error in 76, 282, 286
%baseFileName = 'ISIC_0000074.jpg';
baseFileName = 'ISIC_0000161.jpg';
%baseFileName = 'ISIC_0000148.jpg';

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

I = imread(fullFileName);                        %Same as 'I' variable.
[rows, columns, numberOfColorBands] = size(I);   % Get the dimensions of the image.  numberOfColorBands should be = 3.

figure;
subplot(2, 2, 1);                                       % Display the original color image.
imshow(I, []);
title('Original Color Image', 'FontSize', fontSize);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Enlarge figure to full screen.

% rgbImage = imerode(rgbImage, true(5));                %Erosion not given proper end results.

redChannel = I(:, :, 1);                         % Extract the individual red,
greenChannel = I(:, :, 2);                       % green, and
blueChannel = I(:, :, 3);                        % blue color channels.

subplot(2, 2, 2);
imshow(redChannel, []);
title('Red Channel', 'FontSize', fontSize);

subplot(2, 2, 3);
imshow(greenChannel, []);
title('Green Channel', 'FontSize', fontSize);

subplot(2, 2, 4);
imshow(blueChannel, []);
title('Blue Channel', 'FontSize', fontSize);
drawnow;

figure;

se = strel('disk',10);                       %Morphological Structure: long hair strands .
I2 = imbothat(redChannel,se);                %Bottom Hat Filter on Red Channel to get the long hair structures.

subplot(2, 3, 1);
imshow(I2);
title("Red Channel Bottom Hatted");         %Display After First Filter.

I3 = imadjust(I2, [0, 0.1], [0, 1.0]);       %Get a better contrast for light/thin white hair and black background.
subplot(2,3,2);                              %Black from 0.0 to 0.1 expanded into wider range.
imshow(I3);
title("Adjusted Contrast");

I4 = fibermetric(I3, 5, 'ObjectPolarity', 'dark', 'StructureSensitivity', 8);
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

I7 = bwareaopen(I7, 90);                     % black-white area open. the white areas having radius upto 90 pixels will be blackened
subplot(235);
imshow(I7);
title("Removing small areas");

I6 = imdilate(I7, true(5));                  %Thickened/Highlighted the hairs even more to make them distinct for later stages.               
subplot(2,3,6);
imshow(I6);
title("Dilated")
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;

figure;
[pixelCount, grayLevels] = imhist(redChannel);          % Compute and display the histogram.
subplot(2, 2, 1); 
bar(pixelCount);
grid on;
title('Histogram of red Channel', 'FontSize', fontSize);
xlim([0 grayLevels(end)]);                              % Scale x axis manually.

binaryImage = I6;
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
imshow(I, []);
title('Original Image', 'FontSize', fontSize);          % Displaying Original for Comparison.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;

figure;
subplot(2, 3, 1);
imshow(noHairImage);
title("RGB (Hairless) Image");                                             % Display the pre-processed image.

sharp = imsharpen(noHairImage);                                            % Sharpen image to increase contrast.
subplot(2, 3, 2);
imshow(sharp);
title("Sharpened Image");
        
sharpenedredchannel = sharp(:,:,1);                                        % Extract Red Channel.
subplot(2, 3, 4);
imshow(sharpenedredchannel);
title("Sharpened Red Channel");

sharpenedgreenchannel = sharp(:,:,2);                                      % Extract Green Channel.
subplot(2, 3, 5);
imshow(sharpenedgreenchannel);
title("Sharpened Green Channel");

sharpenedbluechannel = sharp(:,:,3);                                       % Extract Blue Channel.
subplot(2, 3, 6);
imshow(sharpenedbluechannel);
title("Sharpened Blue Channel");
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;

figure;

blacklevel = graythresh(sharpenedbluechannel);                             % Get black level of blue channel to get a threshold value for binarization.

threshold = sharpenedbluechannel > blacklevel*255;                         % Binarize the blue channel.
subplot(2, 2, 2);
imshow(threshold);
title("Thresholded");

subplot(2, 2, 1);
imshow(noHairImage);
title("Hairless Image");

sharpenedredchannel(threshold) = 255;
sharpenedgreenchannel(threshold) = 255;
sharpenedbluechannel(threshold) = 255;
newImage = cat(3, sharpenedredchannel, sharpenedgreenchannel, sharpenedbluechannel);                  % Segmentation of ROI to get a clear idea.
subplot(2, 2, 3);
imshow(newImage);
title("New Image");
subplot(224);
imshow(I);
title("Original Image");
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;

dim = size(threshold);                                                     % Get size of image.
border = ones(dim(1), dim(2));

ba_i = 1;
% Draw border around the ROI gotten from thresholding. Nevus' border will be highlighted.
for i = 1:dim(1)
    for j = 1:(dim(2)-1)
       if ((threshold(i ,j+1) == 0 && threshold(i, j) == 1) || (threshold(i ,j+1) == 1 && threshold(i, j) == 0) || ( ~(i == dim(1)) && threshold(i+1 ,j) == 1 && threshold(i, j) == 0) || (~(i == 1) && threshold(i-1 ,j) == 1 && threshold(i, j) == 0))
           border(i,j) = 0;
           boundary_array(ba_i, 1) = i;
           boundary_array(ba_i, 2) = j;
           ba_i = ba_i + 1;
       end
    end
end

figure; 
subplot(121);
imshow(border);
title("Bordered ROI");
subplot(122);
imshow(newImage);
title("ROI");
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;

start_i = 1;                                                              % init first row of ROI from top
start_j = 1;                                                              % init first column of ROI from left
end_i = dim(1);                                                           % init last row of ROI
end_j = dim(2);                                                           % init last column of ROI

% establish actual first column of ROI; start from center of ROI
flag = 0;
for j = floor(dim(2)/2):-1:1
    for i = 1:dim(1)
        
        if border(i,j) == 0
            flag = 1;
        end
    end
    if flag == 0
        start_j = j;
        break;
    end
    flag = 0;
end

% establish actual last column of ROI; start from center of ROI
flag = 0;
for j = floor(dim(2)/2):dim(2)
    for i = 1:dim(1)
        if border(i,j) == 0
            flag = 1;
        end
    end
    if flag == 0
        end_j = j;
        break;
    end
    flag = 0;
end

% establish actual first row of ROI; start from center of ROI
flag = 0;
for i = floor(dim(1)/2):-1:1
    for j = start_j:end_j
        if border(i,j) == 0
            flag = 1;
        end
    end
    if flag == 0
        start_i = i;
        break;
    end
    flag = 0;
end

% establish actual last row of ROI; start from center of ROI
flag = 0;
for i = floor(dim(1)/2):dim(1)
    for j = start_j:end_j
        if border(i,j) == 0
            flag = 1;
        end
    end
    if flag == 0
        end_i = i;
        break;
    end
    flag = 0;
end

cutout = border(start_i:end_i, start_j:end_j);                            % cutout of the border/edge of ROI
cutoutred = redChannel(start_i:end_i, start_j:end_j);                     % cutout of red channel of actual RGB image to create an RGB cutout
cutoutgreen = greenChannel(start_i:end_i, start_j:end_j);                 % cutout of green channel of actual RGB image to create an RGB cutout
cutoutblue = blueChannel(start_i:end_i, start_j:end_j);                   % cutout of blue channel of actual RGB image to create an RGB cutout

ds1 = DiceSorensenSimilarityCoefficient2(cutout, flipud(cutout));
ds2 = DiceSorensenSimilarityCoefficient2(cutout, fliplr(cutout));

figure; 
subplot(221);
imshow(border);
title("Original Bordered ROI");
subplot(222);
imshow(cutout);
title("Cutting out");
% subplot(223); 
% imshow(cutout);
cutoutRGB = cat(3, cutoutred, cutoutgreen, cutoutblue);
subplot(223); 
imshow(cutoutRGB);
imwrite(cutoutRGB, fullfile(folder, 'cutout.jpg'));

squarred_sum = 0;
cutout_dim = size(cutout);
[ellipse_array, ea_i] = Ellipse(cutout_dim(1), cutout_dim(2));
% figure; imshow(ellipse);

min_dist = Inf(ba_i-1,1);

for i = 1:ba_i-1
    for j = 1:ea_i-1
        temp = sqrt((boundary_array(i, 1) - ellipse_array(j, 1)).^2 + (boundary_array(i, 2) - ellipse_array(j, 2)).^2);
        if(min_dist(i) > temp)
            min_dist(i) = temp;
        end
    end
end

subplot(224);
boxplot(min_dist);
title("Box-plot of asymmetricity of edge of ROI");
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
h = findobj(gcf,'tag','Outliers');
outliercount = get(h,'YData');
drawnow;

sd = std(min_dist);

figure;
subplot(231);
imshow(cutout);
title("Cutout");
subplot(232);
imshow(flipud(cutout));
title("Cutout flip Up-Down");
subplot(233);
imshow(~xor(cutout, flipud(cutout)));
title("Superimposed Images");
subplot(234);
imshow(cutout);
title("Cutout");
subplot(235);
imshow(fliplr(cutout));
title("Cutout flip Left-Right");
subplot(236);
imshow(~xor(cutout, fliplr(cutout)));
title("Superimposed Images");

figure;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
subplot(2, 4, 1);
imshow(cutoutRGB);                                                        % Display the original image.
drawnow;                                                                  % Make it display immediately.

% Display them.
subplot(2, 4, 2);
imshow(cutoutred);
title('Red Band', 'FontSize', fontSize);
subplot(2, 4, 3);
imshow(cutoutgreen);
title('Green Band', 'FontSize', fontSize);
subplot(2, 4, 4);
imshow(cutoutblue);
title('Blue Band', 'FontSize', fontSize);

fontSize = 13;

% Compute and plot the red histogram.
hR = subplot(2, 4, 6);
[countsR, grayLevelsR] = imhist(cutoutred);
maxGLValueR = find(countsR > 0, 1, 'last');
maxCountR = max(countsR);
bar(countsR, 'r');
grid on;
xlabel('Gray Levels');
ylabel('Pixel Count');
title('Histogram of Red Band', 'FontSize', fontSize);

% Compute and plot the green histogram.
hG = subplot(2, 4, 7);
[countsG, grayLevelsG] = imhist(cutoutgreen);
maxGLValueG = find(countsG > 0, 1, 'last');
maxCountG = max(countsG);
bar(countsG, 'g', 'BarWidth', 0.95);
grid on;
xlabel('Gray Levels');
ylabel('Pixel Count');
title('Histogram of Green Band', 'FontSize', fontSize);

% Compute and plot the blue histogram.
hB = subplot(2, 4, 8);
[countsB, grayLevelsB] = imhist(cutoutblue);
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
maxCount = max([maxCountR,  maxCountG, maxCountB]);
axis([hR hG hB], [0 maxGL 0 maxCount]);

% Plot all 3 histograms in one plot.
subplot(2, 4, 5);
plot(grayLevelsR, countsR, 'r', 'LineWidth', 2);
grid on;
xlabel('Gray Levels');
ylabel('Pixel Count');
hold on;
plot(grayLevelsG, countsG, 'g', 'LineWidth', 2);
plot(grayLevelsB, countsB, 'b', 'LineWidth', 2);
title('Histogram of All Bands', 'FontSize', fontSize);
maxGrayLevel = max([maxGLValueR, maxGLValueG, maxGLValueB]);

% Assign the low and high thresholds for each color band.
% Take a guess at the values that might work for the user's image.
redThresholdLow = graythresh(cutoutred);
redThresholdHigh = 255;
greenThresholdLow = 0;
greenThresholdHigh = graythresh(cutoutgreen);
blueThresholdLow = 0;
blueThresholdHigh = graythresh(cutoutblue);
redThresholdLow = uint8(redThresholdLow * 255);
greenThresholdHigh = uint8(greenThresholdHigh * 255);
blueThresholdHigh = uint8(blueThresholdHigh * 255);
        
% Show the thresholds as vertical red bars on the histograms.
PlaceThresholdBars(6, redThresholdLow, redThresholdHigh);
PlaceThresholdBars(7, greenThresholdLow, greenThresholdHigh);
PlaceThresholdBars(8, blueThresholdLow, blueThresholdHigh);

[peaks, locsR] = findpeaks(smoothdata(countsR));
[peaks, locsG] = findpeaks(smoothdata(countsG));
[peaks, locsB] = findpeaks(smoothdata(countsB));
% [peaks1, locsR1] = findpeaks((countsR));
% [peaks2, locsG1] = findpeaks((countsG));
% [peaks3, locsB1] = findpeaks((countsB));
locsR
locsG
locsB
% max(locsR1)
% max(locsG1)
% max(locsB1)



colorcategory = [0, 0, 0, 0, 0];
i = 0; j = 0; k = 0;
for i = 1:size(locsR)
    for j = 1:size(locsG)
        for k = 1:size(locsB)
            if (locsR(i) >= 0 && locsR(i) <= 45 && locsG(j) >= 0 && locsG(j) <= 40 && locsB(k) >= 0 && locsB(k) <= 40) 
                colorcategory(1) = colorcategory(1) + 1;
            elseif (locsR(i) >= 45 && locsR(i) <= 155 && locsG(j) >= 0 && locsG(j) <= 100 && locsB(k) >= 0 && locsB(k) <= 50) 
                colorcategory(2) = colorcategory(2) + 1;
            elseif (locsR(i) >= 100 && locsR(i) <= 255 )  || (locsG(j) <= locsB(k) + 10 && locsG(j) >= locsB(k) - 10) || (locsB(k) <= locsG(j) + 10 && locsB(k) >= locsG(j) - 10)
                if locsG(j) >= 0 && locsG(j) <= 40 && locsB(k) >= 0 && locsB(k) <= 40
                    colorcategory(3) = colorcategory(3) + 1;
                else locsG(j) >= 70 && locsG(j) <= 110 && locsB(k) >= 70 && locsB(k) <= 110;
                    colorcategory(4) = colorcategory(4) + 1; 
                end              
            %elseif (locsR(i) >= 100 && locsR(i) <= 255 && locsG(j) >= 170 && locsG(j) <= 185 && locsB(k) >= 120 && locsB(k) <= 180) 
            else
                colorcategory(5) = colorcategory(5) + 1;
            end
        end
    end
end

colorcategory
t = colorcategory;

% xmin = min(colorcategory(colorcategory~=0));
% [m,k]=max(hist(colorcategory,max(colorcategory)-xmin+1));
% mode_x = xmin+k-1;
% m + 1

colorcategory = Dissimilarity(ds1, ds2, sd, colorcategory);                                                                                                         colorcategory = colorcategory+1; colorcategory = t;
ds1
ds2


max_count = 0;
max_count_index = 0;
for i = 1:length(colorcategory)
    if colorcategory(i) > max_count
        max_count = colorcategory(i);
        max_count_index = i;
    end
end

if max_count_index == 1 || colorcategory(1) ~= 0
    print = 'Color: Black';
    if outliercount > 0
        subtype = 'Malignant Melanoma';
    end
elseif max_count_index == 2 || colorcategory(2) ~= 0
    print = 'Color: Dark Red/ Brown';
    if outliercount > 0
        subtype = 'Malignant Melanoma';
    end
elseif max_count_index == 3
    print = 'Color: Bright Red';
    subtype = 'Squamous Cell Carcinoma';
elseif max_count_index == 4
    print = 'Color: Pink';
    subtype = 'Basal Cell Carcinoma';
elseif max_count_index == 5
    print = 'Color: Light Red/ Skin Color/ light Pink';
    subtype = 'Normal Skin';
end
print

length(outliercount)                                                                                                                                                                    
                                                                                                                                                                                                subtype1(folder)