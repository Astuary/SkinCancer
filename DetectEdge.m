%folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
% folder = 'F:\BE - VIII\Project\Malignant\ISIC-images\ISIC-images\UDA-1';   % Path to the folder where the image will be found.
% file = 'ISIC_0000292.jpg'                                                  % Image Name.
% fullFileName = fullfile(folder, file);                                     % Get a full path.

%rgb = imread(fullFileName);
rgb = noHairImage;                                                         % Taking input from 'hairremove.m'
figure;
subplot(2, 3, 1);
imshow(rgb);
title("RGB (Hairless) Image");                                             % Display the pre-processed image.

% hsv = rgb2hsv(rgb);
% subplot(3, 3, 2);
% imshow(hsv);
% title("HSV Image");

% greenchannel = hsv(:,:,2);
% subplot(2, 2, 3);
% imshow(greenchannel);
% title("Green Channel");

sharp = imsharpen(rgb);                                                    % Sharpen image to increase contrast.
subplot(2, 3, 2);
imshow(sharp);
title("Sharpened Image");
        
redchannel = sharp(:,:,1);                                                 % Extract Red Channel.
subplot(2, 3, 4);
imshow(redchannel);
title("Red Channel");

greenchannel = sharp(:,:,2);                                               % Extract Green Channel.
subplot(2, 3, 5);
imshow(greenchannel);
title("Green Channel");

bluechannel = sharp(:,:,3);                                                % Extract Blue Channel.
subplot(2, 3, 6);
imshow(bluechannel);
title("Blue Channel");

figure;

blacklevel = graythresh(bluechannel);                                      % Get black level of blue channel to get a threshold value for binarization.

threshold = bluechannel > blacklevel*255;                                  % Binarize the blue channel.
subplot(2, 2, 2);
imshow(threshold);
title("Thresholded");

subplot(2, 2, 1);
imshow(rgb);
title("Original Hairless Image");

redchannel(threshold) = 255;
greenchannel(threshold) = 255;
bluechannel(threshold) = 255;
newImage = cat(3, redchannel, greenchannel, bluechannel);                  % Segmentation of ROI to get a clear idea.
subplot(2, 2, 3);
imshow(newImage);
title("New Image");
subplot(224);
imshow(I);
title("Original Image");

% newImage = sharp;
% newImage (threshold == 1) = 0;

% subplot(2, 2, 4);
% imshow(newImage);
% title("New Image");

% % [B,L] = bwboundaries(threshold,'noholes');
% % subplot(2,3,5);
% % imshow(label2rgb(L, @white, [1.0 1.0 1.0]));
% % title("Edge Detection");
% % hold on
% % % for k = 1:length(B)
% % %    boundary = B{k};
% % %    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3);
% % % end
% % visboundaries(B);
% % 
% % figure;
% % imshow(label2rgb(L, @white, [1.0 1.0 1.0]));
% % hold on
% % for k = 1:length(B)
% %    boundary = B{k};
% %    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3);
% % end

dim = size(threshold);                                                     % Get size of image.
a = [dim(1), dim(2)];

for i = 1:dim(1)
    for j = 1:dim(2)
        a(i,j) = 1;                                                        % Allocate memeory for a new white image.
    end
end

ba_i = 1;
% Draw border around the ROI gotten from thresholding. Nevus' border will be highlighted.
for i = 1:dim(1)
    for j = 1:(dim(2)-1)
       if ((threshold(i ,j+1) == 0 && threshold(i, j) == 1) || (threshold(i ,j+1) == 1 && threshold(i, j) == 0) || ( ~(i == dim(1)) && threshold(i+1 ,j) == 1 && threshold(i, j) == 0) || (~(i == 1) && threshold(i-1 ,j) == 1 && threshold(i, j) == 0))
           a(i,j) = 0;
           boundary_array(ba_i, 1) = i;
           boundary_array(ba_i, 2) = j;
           ba_i = ba_i + 1;
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

% aBW = im2bw(a);                                                              % Convert RGB(all the it has only B&W) to binary.
% 
% figure;
% GreenAndBlueChannel = 255 * uint8(aBW);
% redChan = 255 * ones(size(aBW), 'uint8'); % Green Everywhere.
% rgbI = cat(3, redChan, GreenAndBlueChannel, GreenAndBlueChannel);          % Change Black border to red for better visualization.
% imshow(rgbI);

figure; imshow(a);
figure; imshow(newImage);