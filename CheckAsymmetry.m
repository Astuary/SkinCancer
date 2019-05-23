border = a;                                                               % border/edge of ROI

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

figure; 
subplot(221);
imshow(border);
title("Original Bordered ROI");
subplot(222);
imshow(cutout);
title("Cutting out");

cutoutud = flipud(cutout);
cutoutlr = fliplr(cutout);
subplot(223);
imshow(cutoutud);
title("Flipping ROI up-down");
subplot(224);
imshow(cutoutlr);
title("Flipping ROI left-right");

% cutout_hist = imhist(cutout);
% cutoutud_hist = imhist(cutoutud);
% cutoutlr_hist = imhist(cutoutlr);

% cutout_dim = size(cutout);
% squarredsum1 = 0;
% squarredsum2 = 0;
% squarredsum3 = 0;
% for i = 1:cutout_dim(1)
%     for j = 1:cutout_dim(2)
%         squarredsum1 = (cutoutud(i,j) - cutout(i,j)).^2 + squarredsum1;
%         squarredsum2 = (cutoutlr(i,j) - cutout(i,j)).^2 + squarredsum2;
%         squarredsum3 = (cutoutud(i,j) - cutoutlr(i,j)).^2 + squarredsum3;
%     end
% end
% 
% cutout_dist_ud = sqrt(squarredsum1);
% cutout_dist_ud
% cutout_dist_ud = sqrt(squarredsum2);
% cutout_dist_ud
% cutout_dist_ud = sqrt(squarredsum3);
% cutout_dist_ud

% figure;
% binaryImage1 = cutout(:, 1 : end/2);
% subplot(331); imshow(binaryImage1);
% binaryImage2 = cutout(:, end/2+1 : end );
% binaryImage2 = fliplr(binaryImage2);
% subplot(332); imshow(binaryImage2);
% binaryImage1_dim = size(binaryImage1);
% squarredsum4 = 0;
% squarredsum5 = 0;
% for i = 1:binaryImage1_dim(1)
%     for j = 1:binaryImage1_dim(2)
%         squarredsum4 = (binaryImage1(i,j) - binaryImage2(i,j)).^2 + squarredsum4;
%         squarredsum5 = (binaryImage1(i,j) - binaryImage2(i,j)).^2 + squarredsum5;
%     end
% end
% squarredsum4_sqrt = sqrt(squarredsum4);
% squarredsum4_sqrt

squarred_sum = 0;
cutout_dim = size(cutout);
[ellipse_array, ea_i] = Ellipse(cutout_dim(1), cutout_dim(2));


% for i = 1:cutout_dim(1)
%     for j = 1:cutout_dim(2)
%         squarred_sum = squarred_sum + (cutout(i,j) - ellipse(i,j)).^2;
%     end
% end
% 
% euclideanDist = sqrt(squarred_sum);

% figure; imshow(ellipse);
figure; imshow(cutout);
cutoutRGB = cat(3, cutoutred, cutoutgreen, cutoutblue);
figure; imshow(cutoutRGB);
imwrite(cutoutRGB, fullfile(folder, 'cutout.jpg'));

min_dist = Inf(ba_i-1,1);

for i = 1:ba_i-1
    for j = 1:ea_i-1
        temp = sqrt((boundary_array(i, 1) - ellipse_array(j, 1)).^2 + (boundary_array(i, 2) - ellipse_array(j, 2)).^2);
        if(min_dist(i) > temp)
            min_dist(i) = temp;
        end
    end
end

figure;
asd = boxplot(min_dist);