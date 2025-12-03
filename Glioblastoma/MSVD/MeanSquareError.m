function RMSE = MeanSquareError(origImg, distImg)

% origImg=rgb2gray(origImg);
% distImg=rgb2gray(distImg);

origImg = double(origImg);
distImg = double(distImg);

[M N] = size(origImg);
error = origImg - distImg;
RMSE = sqrt(sum(sum(error .* error)) / (M * N));