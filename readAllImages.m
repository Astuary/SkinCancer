%clc;                                        % Clear the command window.
close all;                                  % Close all figures (except those of imtool.)
imtool close all;                           % Close all imtool figures.
clear;                                      % Erase all existing variables.
workspace;                                  % Make sure the workspace panel is showing.
fontSize = 14;                              % To change font size of figure texts

%folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
folder = 'F:\BE - VIII\Project\Malignant Melanoma\ISIC-images\ISIC-images\UDA-1';
 baseFileName = ['ISIC_0000002.jpg'; 'ISIC_0000004.jpg'; 'ISIC_0000013.jpg'; 'ISIC_0000022.jpg'; 'ISIC_0000026.jpg'; 'ISIC_0000029.jpg'; 'ISIC_0000030.jpg'; 'ISIC_0000031.jpg'; 'ISIC_0000035.jpg'; 'ISIC_0000036.jpg';
 'ISIC_0000040.jpg'; 'ISIC_0000043.jpg'; 'ISIC_0000046.jpg'; 'ISIC_0000049.jpg'; 'ISIC_0000054.jpg';
 'ISIC_0000056.jpg'; 'ISIC_0000070.jpg'; 'ISIC_0000074.jpg';  'ISIC_0000077.jpg'; 'ISIC_0000078.jpg'; 'ISIC_0000139.jpg'; 'ISIC_0000140.jpg'; 'ISIC_0000141.jpg'; 'ISIC_0000142.jpg'; 'ISIC_0000143.jpg'; 'ISIC_0000144.jpg'; 'ISIC_0000145.jpg'; 'ISIC_0000146.jpg'; 'ISIC_0000147.jpg'; 'ISIC_0000148.jpg'; 'ISIC_0000149.jpg'; 'ISIC_0000150.jpg'; 'ISIC_0000151.jpg'; 'ISIC_0000152.jpg'; 'ISIC_0000153.jpg'; 'ISIC_0000154.jpg'; 'ISIC_0000155.jpg'; 'ISIC_0000156.jpg'; 'ISIC_0000157.jpg'; 'ISIC_0000158.jpg'; 'ISIC_0000159.jpg'; 'ISIC_0000160.jpg'; 'ISIC_0000161.jpg'; 'ISIC_0000162.jpg'; 'ISIC_0000163.jpg'; 'ISIC_0000164.jpg'; 'ISIC_0000165.jpg'; 'ISIC_0000166.jpg'; 'ISIC_0000167.jpg'; 'ISIC_0000168.jpg'; 'ISIC_0000169.jpg'; 'ISIC_0000170.jpg'; 'ISIC_0000171.jpg'; 'ISIC_0000172.jpg'; 'ISIC_0000173.jpg'; 'ISIC_0000174.jpg'; 'ISIC_0000175.jpg'; 'ISIC_0000176.jpg'; 'ISIC_0000276.jpg'; 'ISIC_0000277.jpg'; 'ISIC_0000278.jpg'; 'ISIC_0000279.jpg'; 'ISIC_0000280.jpg'; 'ISIC_0000281.jpg';  'ISIC_0000283.jpg'; 'ISIC_0000284.jpg'; 'ISIC_0000285.jpg'; 'ISIC_0000286.jpg'; 'ISIC_0000287.jpg'; 'ISIC_0000288.jpg'; 'ISIC_0000289.jpg'; 'ISIC_0000290.jpg'; 'ISIC_0000291.jpg'; 'ISIC_0000292.jpg'; 'ISIC_0000293.jpg'; 'ISIC_0000294.jpg'; 'ISIC_0000295.jpg'; 'ISIC_0000296.jpg'];
  % Get the full filename, with path prepended.
%baseFileName = ['ISIC_0000000.jpg'; 'ISIC_0000001.jpg'; 'ISIC_0000003.jpg'; 'ISIC_0000005.jpg'; 'ISIC_0000006.jpg'; 'ISIC_0000007.jpg'; 'ISIC_0000008.jpg'; 'ISIC_0000009.jpg'; 'ISIC_0000010.jpg'; 'ISIC_0000011.jpg'; 'ISIC_0000012.jpg'; 'ISIC_0000014.jpg'; 'ISIC_0000015.jpg'; 'ISIC_0000016.jpg'; 'ISIC_0000017.jpg'; 'ISIC_0000018.jpg'; 'ISIC_0000019.jpg'; 'ISIC_0000020.jpg'; 'ISIC_0000021.jpg'; 'ISIC_0000023.jpg'; 'ISIC_0000024.jpg'; 'ISIC_0000025.jpg'; 'ISIC_0000027.jpg'; 'ISIC_0000028.jpg'; 'ISIC_0000032.jpg'; 'ISIC_0000033.jpg'; 'ISIC_0000034.jpg'; 'ISIC_0000037.jpg'; 'ISIC_0000038.jpg'; 'ISIC_0000039.jpg'; 'ISIC_0000041.jpg'; 'ISIC_0000042.jpg'; 'ISIC_0000044.jpg'; 'ISIC_0000045.jpg'; 'ISIC_0000047.jpg'; 'ISIC_0000048.jpg'; 'ISIC_0000050.jpg'; 'ISIC_0000051.jpg'; 'ISIC_0000052.jpg'; 'ISIC_0000053.jpg'; 'ISIC_0000055.jpg'; 'ISIC_0000057.jpg'; 'ISIC_0000058.jpg'; 'ISIC_0000059.jpg'; 'ISIC_0000060.jpg'; 'ISIC_0000061.jpg'; 'ISIC_0000062.jpg'; 'ISIC_0000063.jpg'; 'ISIC_0000064.jpg'; 'ISIC_0000065.jpg'; 'ISIC_0000066.jpg'; 'ISIC_0000067.jpg'; 'ISIC_0000068.jpg'; 'ISIC_0000069.jpg'; 'ISIC_0000071.jpg'; 'ISIC_0000072.jpg'; 'ISIC_0000073.jpg'; 'ISIC_0000075.jpg'; 'ISIC_0000079.jpg'; 'ISIC_0000080.jpg'; 'ISIC_0000081.jpg'; 'ISIC_0000082.jpg'; 'ISIC_0000083.jpg'; 'ISIC_0000084.jpg'; 'ISIC_0000085.jpg'; 'ISIC_0000086.jpg'; 'ISIC_0000087.jpg'; 'ISIC_0000088.jpg'; 'ISIC_0000089.jpg'; 'ISIC_0000090.jpg'; 'ISIC_0000091.jpg'; 'ISIC_0000092.jpg'; 'ISIC_0000093.jpg'; 'ISIC_0000094.jpg'; 'ISIC_0000095.jpg'; 'ISIC_0000096.jpg'; 'ISIC_0000097.jpg'; 'ISIC_0000098.jpg'; 'ISIC_0000099.jpg'; 'ISIC_0000100.jpg' ];
euclideanDist = 0;
  
for z = 1:1:78
    z
    fullFileName = fullfile(folder, char(baseFileName(z,:)));
    I = imread(fullFileName);                    %Get RGB Image.
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
    I7 = I5;                                     % To skip median filter.

    I6 = imdilate(I7, true(5));                  %Thickened/Highlighted the hairs even more to make them distinct for later stages.               

    rgbImage = imread(fullFileName);                        %Same as 'I' variable.
    [rows, columns, numberOfColorBands] = size(rgbImage);   % Get the dimensions of the image.  numberOfColorBands should be = 3.

    % rgbImage = imerode(rgbImage, true(5));                %Erosion not given proper end results. 

    redChannel = rgbImage(:, :, 1);                         % Extract the individual red, 
    greenChannel = rgbImage(:, :, 2);                       % green, and 
    blueChannel = rgbImage(:, :, 3);                        % blue color channels.

    [pixelCount, grayLevels] = imhist(redChannel);          % Compute and display the histogram.

    binaryImage = I6;          

    redChannel = regionfill(redChannel, binaryImage);       % Fill in the mask
    greenChannel = regionfill(greenChannel, binaryImage);
    blueChannel = regionfill(blueChannel, binaryImage);
    noHairImage = cat(3, redChannel, greenChannel, blueChannel);

    rgb = noHairImage;                                                         % Taking input from 'hairremove.m'
    sharp = imsharpen(rgb);                                                    % Sharpen image to increase contrast.     
    redchannel = sharp(:,:,1);                                                 % Extract Red Channel.
    greenchannel = sharp(:,:,2);                                               % Extract Green Channel.
    bluechannel = sharp(:,:,3);                                                % Extract Blue Channel.


    blacklevel = graythresh(bluechannel);                                      % Get black level of blue channel to get a threshold value for binarization.

    threshold = bluechannel > blacklevel*255;                                  % Binarize the blue channel.


    redchannel(threshold) = 255;
    greenchannel(threshold) = 255;
    bluechannel(threshold) = 255;
    newImage = cat(3, redchannel, greenchannel, bluechannel);                  % Segmentation of ROI to get a clear idea.

    dim = size(threshold);                                                     % Get size of image.
    a = [dim(1), dim(2)];

    for i = 1:dim(1)
        for j = 1:dim(2)
            a(i,j) = 1;                                                        % Allocate memeory for a new white image.
        end
    end

    % Draw border around the ROI gotten from thresholding. Nevus' border will be highlighted.
    for i = 1:dim(1)
        for j = 1:(dim(2)-1)
           if ((threshold(i ,j+1) == 0 && threshold(i, j) == 1) || (threshold(i ,j+1) == 1 && threshold(i, j) == 0) || ( ~(i == dim(1)) && threshold(i+1 ,j) == 1 && threshold(i, j) == 0) || (~(i == 1) && threshold(i-1 ,j) == 1 && threshold(i, j) == 0))
               a(i,j) = 0;
    %            a(i,j+1) = 0;
    %            if ~(i == 1)
    %                a(i-1,j)=0;
    %            end
    %            if ~(i == dim(1))
    %                a(i+1,j)=0;
    %            end
    %            if ~(j == 1)
    %                a(i,j-1)=0;
    %            end
           end
        end
    end

    aBW = im2bw(a);                                                              % Convert RGB(all the it has only B&W) to binary.
    border = a;

    start_i = 1;
    start_j = 1;
    end_i = dim(1);
    end_j = dim(2);
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

    cutout = [(end_i - start_i + 1), (end_j - start_j + 1)];

    for i = start_i:end_i
        for j = start_j:end_j
            cutout(i-start_i+1, j-start_j+1) = border(i,j);
        end
    end


    cutoutud = flipud(cutout);
    cutoutlr = fliplr(cutout);

    squarred_sum = 0;
    cutout_dim = size(cutout);
    ellipse = Ellipse(cutout_dim(1), cutout_dim(2));

    for i = 1:cutout_dim(1)
        for j = 1:cutout_dim(2)
            squarred_sum = squarred_sum + (cutout(i,j) - ellipse(i,j)).^2;
        end
    end

    euclideanDist = sqrt(squarred_sum) + euclideanDist;

end
 
euclideanDist/78