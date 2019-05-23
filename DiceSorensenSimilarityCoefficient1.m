binaryImage1 = cutout;
binaryImage2 = cutout;

binaryImage1 = cutout(:, 1 : end/2);
binaryImage2 = cutout(:, end/2+1 : end );

% Display the image.
subplot(3, 3, 4);
imshow(binaryImage1, []);
caption = sprintf('Binary Image 1 thresholded at');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
% Display the image.
subplot(3, 3, 5);
imshow(binaryImage2, []);
caption = sprintf('Binary Image 2 thresholded at');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

% AND these together
andImage = binaryImage1 & binaryImage2;

% Just for fun, compute and show the OR and XOR.
% They're not used in the computation for the similarity coefficient though.
% OR these together
orImage = binaryImage1 | binaryImage2;
% XOR these together
xorImage = xor(binaryImage1, binaryImage2);

% Display the image.
subplot(3, 3, 7);
imshow(andImage, []);
caption = sprintf('Binary Image 1 AND Binary Image 2');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
% Display the image.
subplot(3, 3, 8);
imshow(orImage, []);
caption = sprintf('Binary Image 1 OR Binary Image 2');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
% Display the image.
subplot(3, 3, 9);
imshow(xorImage, []);
caption = sprintf('XOR : 1 or 2, but not both');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');

% Compute the Disc Sorensen Coefficient for similarity.
numPixelsPresentInBoth = nnz(andImage);
dsCoefficient = 2 * numPixelsPresentInBoth / (nnz(binaryImage1) + nnz(binaryImage2))
message = sprintf('The Dice Sorensen Similarity Coefficient = %.2f', dsCoefficient);
uiwait(helpdlg(message));