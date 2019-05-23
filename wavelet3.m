folder = 'F:\BE - VIII\Project\Malignant Melanoma\ISIC-images\ISIC-images\UDA-1';
file = 'ISIC_0000013.jpg'
fullFileName = fullfile(folder, file);

I = medfilt2(rgb2gray(imread(fullFileName)));

[Ia, Ih, Iv, Id] = dwt2(I, 'haar');
I = imresize(I, 0.5);

O = [I log10(Ih)*200; log10(Iv)*200 log10(Id)*200];
% O = [I Ih; Iv Id];
figure; imshow(O);
figure; imshow(Ia*0.002);
O = imresize(O, 0.25);

[Iaa, Iah, Iav, Iad] = dwt2(Ia, 'haar');
O1 = [O log10(Iah)*200; log10(Iav)*200 log10(Iad)*200];
figure; imshow(O1);
figure; imshow(Iaa*0.002);
O1 = imresize(O, 0.5);

[Iaaa, Iaah, Iaav, Iaad] = dwt2(Iaa, 'haar');
O2 = [O1 log10(Iaah)*10; log10(Iaav)*200 log10(Iaad)*200];
figure; imshow(O2);
figure; imshow(Iaaa*0.002);

bw = (Iaaa*0.002) > 0.95;
figure; imshow(bw);

