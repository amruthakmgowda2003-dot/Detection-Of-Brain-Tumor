function PSNR = PeakSignaltoNoiseRatio(x, y)

x= double(x);
y = double(y);
[M N] = size(x);

err = x - y;
err = err(:);
MSE = sum(sum(err .* err)) / (M * N);
PSNR= 10 * log10(255*255/MSE);