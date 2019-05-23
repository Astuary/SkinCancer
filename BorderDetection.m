%folder = 'F:\BE - VIII\Project\Benign\ISIC-images\ISIC-images\UDA-1';
folder = 'F:\BE - VIII\Project\Malignant\ISIC-images\ISIC-images\UDA-1';
file = 'ISIC_0000291.jpg'
fullFileName = fullfile(folder, file);

rgb = imread(fullFileName);
rgb = noHairImage;
figure;
subplot(2, 3, 1);
imshow(rgb);
title("RGB (Hairless) Image");

% hsv = rgb2hsv(rgb);
% subplot(3, 3, 2);
% imshow(hsv);
% title("HSV Image");

% greenchannel = hsv(:,:,2);
% subplot(2, 2, 3);
% imshow(greenchannel);
% title("Green Channel");

sharp = imsharpen(rgb);
subplot(2, 3, 2);
imshow(sharp);
title("Sharpened Image");

redchannel = sharp(:,:,1);
subplot(2, 3, 4);
imshow(redchannel);
title("Red Channel");

greenchannel = sharp(:,:,2);
subplot(2, 3, 5);
imshow(greenchannel);
title("Green Channel");

bluechannel = sharp(:,:,3);
subplot(2, 3, 6);
imshow(bluechannel);
title("Blue Channel");

threshold = bluechannel > 150;
subplot(3, 3, 2);
imshow(threshold);
title("Thresholded");

redchannel(threshold) = 255;
greenchannel(threshold) = 255;
bluechannel(threshold) = 255;
newImage = cat(3, redchannel, greenchannel, bluechannel);
subplot(3, 3, 3);
imshow(newImage);
title("New Image");

newImage = sharp;
newImage (threshold == 1) = 0;

subplot(3, 3, 7);
imshow(newImage);
title("New Image");

level = graythresh(rgb);
g = rgb2gray(rgb);
BW = imbinarize(g, level);
subplot(2, 3, 3);
imshow(BW);
title("Otsu Segmentation");

BW = imcomplement(BW);
BW = imfill(BW, 'holes');
subplot(2,3,4);
imshow(BW);
title("Tiny Holes Filled");
% % % B = bwboundaries(BW);
% % % hold on
% % % visboundaries(B);
% % % savefig(gcf,'foo.png');
[B,L] = bwboundaries(BW,'noholes');
subplot(2,3,5);
imshow(label2rgb(L, @white, [1.0 1.0 1.0]));
title("Edge Detection");
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3);
end

figure;
imshow(label2rgb(L, @white, [1.0 1.0 1.0]));
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3);
end
saveas(gcf,'boundary.png');

% mask = boundarymask(BW);
% subplot(3, 3, 5);
% imshow(mask);