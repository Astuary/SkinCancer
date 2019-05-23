function [category] = Dissimilarity(ds1, ds2, sd, color)

if ds1 < 0.5 && ds2 < 0.5 && sd > 1 && color == 1
    category = 1;
elseif ds1 < 0.5 && ds2 < 0.5 && sd > 1 && color == 2
    category = 2;
elseif ds1 > 0.4 && ds1 < 0.8 && ds2 > 0.4 && ds2 < 0.8 && sd < 1.5 && sd > 0.5
    category = 3;
elseif ds1 > 0.6 && ds1 <= 1 && ds2 > 0.6 && ds2 <= 1
    category = 4;
else
    category = 5;
end