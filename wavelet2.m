folder = 'F:\BE - VIII\Project\Malignant\ISIC-images\ISIC-images\UDA-1';
file = 'ISIC_0000013.jpg'
fullFileName = fullfile(folder, file);

I = imread(fullFileName);
% figure;
% imshow(I);
% title("RGB Image");

[Iar, Ihr ,Ivr, Idr] = dwt2(I(:,:,1), 'db2');
[Iag, Ihg ,Ivg, Idg] = dwt2(I(:,:,2), 'db2');
[Iab, Ihb ,Ivb, Idb] = dwt2(I(:,:,3), 'db2');

% figure; imshow(Iar);
% figure; imshow(Ihr);
% figure; imshow(Ivr);
% figure; imshow(Idr);

Ia = cat(3, Iar, Iag, Iab);
Ih = cat(3, Ihr, Ihg, Ihb);
Iv = cat(3, Ivr, Ivg, Ivb);
Id = cat(3, Idr, Idg, Idb);

O = [Ia*0.003 log10(Ih)*100; log10(Iv)*100, log10(Id)*100];
figure; 
imshow(O);
O = imresize(O, [194, 257]);

[Iaar, Iahr ,Iavr, Iadr] = dwt2(Ia(:,:,1), 'db2');
[Iaag, Iahg ,Iavg, Iadg] = dwt2(Ia(:,:,2), 'db2');
[Iaab, Iahb ,Iavb, Iadb] = dwt2(Ia(:,:,3), 'db2');

Iaa = cat(3, Iaar, Iaag, Iaab);
Iah = cat(3, Iahr, Iahg, Iahb);
Iav = cat(3, Iavr, Iavg, Iavb);
Iad = cat(3, Iadr, Iadg, Iadb);

O1 = [O Iah; Iav Iad];
figure; 
imshow(O1);