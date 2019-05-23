close all;
imtool close all;
clear;

%D = 'F:\BE - VIII\Project\Nisarg Bharathan Data\Train\Benign';
D = 'F:\BE - VIII\Project\RemovableDisksCrops\center';
SourceFile = dir(fullfile(D,'ISIC*.jpeg')); % pattern to match filenames.
mkdir('F:\BE - VIII\Project\RemovableDisksCrops\center-tint');
DestinationFolder = 'F:\BE - VIII\Project\RemovableDisksCrops\center-tint';

for k = 1:numel(SourceFile)
    F = fullfile(D,SourceFile(k).name);
    DestinationFile = SourceFile(k).name;
    I = imread(F);
     
    %noHairImage = imrotate(I, 180);
    %noHairImage = imcrop(I, [1, 1, 223, 224]);
    %noHairImage = flipud(I);
    %noHairImage = fliplr(I);
    
%     hsvImage = rgb2hsv(I);
%     hsvImage(:,:,2) = hsvImage(:,:,2) * .2;
%     noHairImage = hsv2rgb(hsvImage);

    red = I(:,:,1);
    green = I(:,:,2);
    blue = I(:,:,3) + 40;
    noHairImage = cat(3, red, green, blue);
    
    imwrite(noHairImage, fullfile(DestinationFolder, DestinationFile));
end