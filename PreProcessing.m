close all;
imtool close all;
clear;

%D = 'F:\BE - VIII\Project\Nisarg Bharathan Data\Train\Benign';
D = 'F:\BE - VIII\Project\PH2Data';
SourceFile = dir(fullfile(D,'*.bmp')); % pattern to match filenames.
DestinationFolder = 'F:\BE - VIII\Project\PH2DataPreProcessed';

for k = 1:numel(SourceFile)
    F = fullfile(D,SourceFile(k).name);
    DestinationFile = SourceFile(k).name;
    I = imresize(imread(F), [500 500]);
    %imshow(I)
    
    redChannel = I(:,:,1);                       %Extract Red Channel. It will be in Grayscale.
    %Note: In many cases, Blue channel in more effective because of the tint of lens of capturing device.
    
    se = strel('disk',10);                       %Morphological Structure: long hair strands .
    I2 = imbothat(redChannel,se);                %Bottom Hat Filter on Red Channel to get the long hair structures.
    
    I3 = imadjust(I2, [0, 0.1], [0, 1.0]);       %Get a better contrast for light/thin white hair and black background.
    
    %I4 = fibermetric(I3, 5, 'ObjectPolarity', 'dark', 'StructureSensitivity', 8);
    I4 = I3;                                     %Fiber Metric Filter for specifically long and thin fiber like objects but yet to get a satisfactory result.
    
    I5 = I4 > 200;                               %150 seems good too.
    
    I7 = medfilt2(I5);                           %Attempt at removing mole fragments.
    I7 = medfilt2(I7);
    I7 = medfilt2(I7);
    I7 = medfilt2(I7);
    I7 = medfilt2(I7);
    
    I7 = bwareaopen(I7, 90);
    
    I6 = imdilate(I7, true(5));                  %Thickened/Highlighted the hairs even more to make them distinct for later stages.
    
    
    [rows, columns, numberOfColorBands] = size(I);   % Get the dimensions of the image.  numberOfColorBands should be = 3.
    
    % rgbImage = imerode(rgbImage, true(5));                %Erosion not given proper end results.
    
    redChannel = I(:, :, 1);                         % Extract the individual red,
    greenChannel = I(:, :, 2);                       % green, and
    blueChannel = I(:, :, 3);                        % blue color channels.
    
    [pixelCount, grayLevels] = imhist(redChannel);          % Compute and display the histogram.
    
    binaryImage = I6;
    
    redChannel = regionfill(redChannel, binaryImage);       % Fill in the mask
    greenChannel = regionfill(greenChannel, binaryImage);
    blueChannel = regionfill(blueChannel, binaryImage);
    noHairImage = cat(3, redChannel, greenChannel, blueChannel);
     
    imwrite(noHairImage, fullfile(DestinationFolder, DestinationFile));
end