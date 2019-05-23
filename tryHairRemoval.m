I = imread('ISIC_0000043.jpg');
redChannel = I(:,:,1);
count = 0;

for i = 1:10
    se = strel('disk', i);
    I1 = imbothat(redChannel, se);
    I2 = imadjust(I1);
    for j = 1:10
        for k = 1:15
            I3 = fibermetric(I2, j, 'ObjectPolarity', 'dark', 'StructureSensitivity', k);
            for l = 0.0:0.1:1.0
                disp(l);
               I4 = I3 > l;
               for m = 1:5
                  I5 = imdilate(I4, true(m));
                  %figure;
                  imshow(I5, []);
                  count = count + 1;
                  title("Disk: "+i+" FIber: "+j+" Sens: "+k+" Thresh: "+l+" Dilate: "+m);
                  pause;
               end
               
            end
        end
    end
end