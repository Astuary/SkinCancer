folder = 'F:\BE - VIII\Project\Malignant Melanoma\ISIC-images\ISIC-images\UDA-1';
%folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
%folder = 'F:\BE - VIII\Project\Basel Cell Carcinoma\ISIC-images\ISIC-images\Data'
%folder = 'F:\BE - VIII\Project\Squamous Cell Carcinoma\ISIC-images\ISIC-images\Data';

baseFileName = ['ISIC_0000002.jpg'; 'ISIC_0000004.jpg'; 'ISIC_0000013.jpg'; 'ISIC_0000022.jpg'; 'ISIC_0000026.jpg'; 'ISIC_0000029.jpg'; 'ISIC_0000030.jpg'; 'ISIC_0000031.jpg'; 'ISIC_0000035.jpg'; 'ISIC_0000036.jpg'; 'ISIC_0000040.jpg'; 'ISIC_0000043.jpg'; 'ISIC_0000046.jpg'; 'ISIC_0000049.jpg'; 'ISIC_0000054.jpg'; 'ISIC_0000056.jpg'; 'ISIC_0000070.jpg'; 'ISIC_0000074.jpg'; 'ISIC_0000076.jpg'; 'ISIC_0000077.jpg'; 'ISIC_0000078.jpg'; 'ISIC_0000139.jpg'; 'ISIC_0000140.jpg'; 'ISIC_0000141.jpg'; 'ISIC_0000142.jpg'; 'ISIC_0000143.jpg'; 'ISIC_0000144.jpg'; 'ISIC_0000145.jpg'; 'ISIC_0000146.jpg'; 'ISIC_0000147.jpg'; 'ISIC_0000148.jpg'; 'ISIC_0000149.jpg'; 'ISIC_0000150.jpg'; 'ISIC_0000151.jpg'; 'ISIC_0000152.jpg'; 'ISIC_0000153.jpg'; 'ISIC_0000154.jpg'; 'ISIC_0000155.jpg'; 'ISIC_0000156.jpg'; 'ISIC_0000157.jpg'; 'ISIC_0000158.jpg'; 'ISIC_0000159.jpg'; 'ISIC_0000160.jpg'; 'ISIC_0000161.jpg'; 'ISIC_0000162.jpg'; 'ISIC_0000163.jpg'; 'ISIC_0000164.jpg'; 'ISIC_0000165.jpg'; 'ISIC_0000166.jpg'; 'ISIC_0000167.jpg'; 'ISIC_0000168.jpg'; 'ISIC_0000169.jpg'; 'ISIC_0000170.jpg'; 'ISIC_0000171.jpg'; 'ISIC_0000172.jpg'; 'ISIC_0000173.jpg'; 'ISIC_0000174.jpg'; 'ISIC_0000175.jpg'; 'ISIC_0000176.jpg'; 'ISIC_0000276.jpg'; 'ISIC_0000277.jpg'; 'ISIC_0000278.jpg'; 'ISIC_0000279.jpg'; 'ISIC_0000280.jpg'; 'ISIC_0000281.jpg'; 'ISIC_0000282.jpg'; 'ISIC_0000283.jpg'; 'ISIC_0000284.jpg'; 'ISIC_0000285.jpg'; 'ISIC_0000286.jpg'; 'ISIC_0000287.jpg'; 'ISIC_0000288.jpg'; 'ISIC_0000289.jpg'; 'ISIC_0000290.jpg'; 'ISIC_0000291.jpg'; 'ISIC_0000292.jpg'; 'ISIC_0000293.jpg'; 'ISIC_0000294.jpg'; 'ISIC_0000295.jpg'; 'ISIC_0000296.jpg'];
% Get the full filename, with path prepended.
%baseFileName = ['ISIC_0000000.jpg'; 'ISIC_0000001.jpg'; 'ISIC_0000003.jpg'; 'ISIC_0000005.jpg'; 'ISIC_0000006.jpg'; 'ISIC_0000007.jpg'; 'ISIC_0000008.jpg'; 'ISIC_0000009.jpg'; 'ISIC_0000010.jpg'; 'ISIC_0000011.jpg'; 'ISIC_0000012.jpg'; 'ISIC_0000014.jpg'; 'ISIC_0000015.jpg'; 'ISIC_0000016.jpg'; 'ISIC_0000017.jpg'; 'ISIC_0000018.jpg'; 'ISIC_0000019.jpg'; 'ISIC_0000020.jpg'; 'ISIC_0000021.jpg'; 'ISIC_0000023.jpg'; 'ISIC_0000024.jpg'; 'ISIC_0000025.jpg'; 'ISIC_0000027.jpg'; 'ISIC_0000028.jpg'; 'ISIC_0000032.jpg'; 'ISIC_0000033.jpg'; 'ISIC_0000034.jpg'; 'ISIC_0000037.jpg'; 'ISIC_0000038.jpg'; 'ISIC_0000039.jpg'; 'ISIC_0000041.jpg'; 'ISIC_0000042.jpg'; 'ISIC_0000044.jpg'; 'ISIC_0000045.jpg'; 'ISIC_0000047.jpg'; 'ISIC_0000048.jpg'; 'ISIC_0000050.jpg'; 'ISIC_0000051.jpg'; 'ISIC_0000052.jpg'; 'ISIC_0000053.jpg'; 'ISIC_0000055.jpg'; 'ISIC_0000057.jpg'; 'ISIC_0000058.jpg'; 'ISIC_0000059.jpg'; 'ISIC_0000060.jpg'; 'ISIC_0000061.jpg'; 'ISIC_0000062.jpg'; 'ISIC_0000063.jpg'; 'ISIC_0000064.jpg'; 'ISIC_0000065.jpg'; 'ISIC_0000066.jpg'; 'ISIC_0000067.jpg'; 'ISIC_0000068.jpg'; 'ISIC_0000069.jpg'; 'ISIC_0000071.jpg'; 'ISIC_0000072.jpg'; 'ISIC_0000073.jpg'; 'ISIC_0000075.jpg'; 'ISIC_0000079.jpg'; 'ISIC_0000080.jpg'; 'ISIC_0000081.jpg'; 'ISIC_0000082.jpg'; 'ISIC_0000083.jpg'; 'ISIC_0000084.jpg'; 'ISIC_0000085.jpg'; 'ISIC_0000086.jpg'; 'ISIC_0000087.jpg'; 'ISIC_0000088.jpg'; 'ISIC_0000089.jpg'; 'ISIC_0000090.jpg'; 'ISIC_0000091.jpg'; 'ISIC_0000092.jpg'; 'ISIC_0000093.jpg'; 'ISIC_0000094.jpg'; 'ISIC_0000095.jpg'; 'ISIC_0000096.jpg'; 'ISIC_0000097.jpg'; 'ISIC_0000098.jpg'; 'ISIC_0000099.jpg'; 'ISIC_0000100.jpg'  ];
%baseFileName = ['ISIC_0024234.jpg'; 'ISIC_0024259.jpg'; 'ISIC_0024275.jpg'; 'ISIC_0024277.jpg'; 'ISIC_0024301.jpg';  'ISIC_0024332.jpg'; 'ISIC_0001159.jpg'; ];
%baseFileName = ['ISIC_0011593.jpg'; 'ISIC_0011726.jpg'; 'ISIC_0024211.jpg'; 'ISIC_0024212.jpg'; 'ISIC_0024242.jpg';  'ISIC_0024244.jpg';];

for z = 1:1:80
    z
    fullFileName = fullfile(folder, char(baseFileName(z,:)));
    [rgbImage, storedColorMap] = imread(fullFileName);
    [rows, columns, numberOfColorBands] = size(rgbImage);
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
    
    redBand = rgbImage(:, :, 1);
    greenBand = rgbImage(:, :, 2);
    blueBand = rgbImage(:, :, 3);

    [countsR, grayLevelsR] = imhist(redBand);
    maxGLValueR = find(countsR > 0, 1, 'last');
    maxCountR = max(countsR);
    
    % Compute and plot the green histogram.
    [countsG, grayLevelsG] = imhist(greenBand);
    maxGLValueG = find(countsG > 0, 1, 'last');
    maxCountG = max(countsG);
    
    % Compute and plot the blue histogram.
    [countsB, grayLevelsB] = imhist(blueBand);
    maxGLValueB = find(countsB > 0, 1, 'last');
    maxCountB = max(countsB);
    
    % Set all axes to be the same width and height.
    % This makes it easier to compare them.
    maxGL = max([maxGLValueR,  maxGLValueG, maxGLValueB]);
    if eightBit
        maxGL = 255;
    end
    maxCount = max([maxCountR,  maxCountG, maxCountB]);
    %axis([hR hG hB], [0 maxGL 0 maxCount]);
    
    % Plot all 3 histograms in one plot.
    %subplot(8, 10, z);
    plot(grayLevelsR, countsR, 'r', 'LineWidth', 2);
    grid on;
    %xlabel('Gray Levels');
    %ylabel('Pixel Count');
    hold on;
    plot(grayLevelsG, countsG, 'g', 'LineWidth', 2);
    plot(grayLevelsB, countsB, 'b', 'LineWidth', 2);
    title(z, 'FontSize', fontSize);
    maxGrayLevel = max([maxGLValueR, maxGLValueG, maxGLValueB]);
    % Trim x-axis to just the max gray level on the bright end.
    if eightBit
        xlim([0 255]);
    else
        xlim([0 maxGrayLevel]);
    end
end