folder = 'F:\BE - VIII\Project\Malignant\ISIC-images\ISIC-images\UDA-1';
file = 'ISIC_0000145.jpg'
fullFileName = fullfile(folder, file);

rgb = imread(fullFileName);

figure;
imshow(rgb);
title("RGB Image");

[xar, xhr, xvr, xdr] = dwt2(rgb(:,:,1), 'db2');
[xag, xhg, xvg, xdg] = dwt2(rgb(:,:,2), 'db2');
[xab, xhb, xvb, xdb] = dwt2(rgb(:,:,3), 'db2');

xa(:,:,1) = xar; xa(:,:,2) = xag; xa(:,:,3) = xab;
xh(:,:,1) = xhr; xh(:,:,2) = xhg; xh(:,:,3) = xhb;
xv(:,:,1) = xvr; xv(:,:,2) = xvg; xv(:,:,3) = xvb;
xd(:,:,1) = xdr; xd(:,:,2) = xdg; xd(:,:,3) = xdb;

figure; imshow(xa/255);
figure; imshow(xh);
figure; imshow(xv);
figure; imshow(xd);
X1 = [xa*0.003 log10(xv)*0.3; log10(xh)*0.3 log10(xd)*0.3];
%X1 = [xa ,xv; xh, xd];
figure; imshow(X1);

[xaar, xhhr, xvvr, xddr] = dwt2(xa(:,:,1), 'db2');
[xaag, xhhg, xvvg, xddg] = dwt2(xa(:,:,2), 'db2');
[xaab, xhhb, xvvb, xddb] = dwt2(xa(:,:,3), 'db2');

xaa(:,:,1) = xaar; xaa(:,:,2) = xaag; xaa(:,:,3) = xaab;
xhh(:,:,1) = xhhr; xhh(:,:,2) = xhhg; xhh(:,:,3) = xhhb;
xvv(:,:,1) = xvvr; xvv(:,:,2) = xvvg; xvv(:,:,3) = xvvb;
xdd(:,:,1) = xddr; xdd(:,:,2) = xddg; xdd(:,:,3) = xddb;

figure; imshow(xaa/255);
figure; imshow(xhh);
figure; imshow(xvv);
figure; imshow(xdd);
[m, n] = size(xhh);
X2 = imresize(X1, [386, 514]);
%X11 = [xaa*0.001 log10(xvv)*0.3; log10(xhh)*0.3 log10(xdd)*0.3];
X11 = [xaa*0.001 log10(xvv)*0.3; log10(xhh)*0.3 log10(xdd)*0.3];
%X11 = [X2, xvv; xhh, xdd];
figure; imshow(X11);
figure; imshow(log10(xaa)*0.3);
