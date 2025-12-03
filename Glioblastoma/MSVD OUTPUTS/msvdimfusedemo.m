%function[] = msvdfusdemo()
% MSVD based image fusion demo 

%       Defence Science Journal, Vol. 61, No.5, pp.479-484, Sep. 2011.
close all;
clear all;
home;

% reference image (ground truth)
%imt = imresize(imt,[256 256]);
%imt = im2bw(imt);
%images to be fused
im1 = im2double(imread('D:\Glioblastoma\M-P20(CT).jpg'));
im1 = rgb2gray(im1);
im1 = imresize(im1,[256 256]);
%im1 = im2bw(im1);
im2 = im2double(imread('D:\Glioblastoma\M-P20(MRI).jpg'));
im2 = rgb2gray(im2);
im2 = imresize(im2,[256 256]);
%im2 = im2bw(im2);

%display images to be fused
figure(1); imshow(im1,[]);
figure(2); imshow(im2,[]);

%apply MSVD
[X1, U1] = MSVD(im1);
[X2, U2] = MSVD(im2);

%fusion starts
X.LL = 0.5*(X1.LL+X2.LL);

D  = (abs(X1.LH)-abs(X2.LH)) >= 0; 
X.LH = D.*X1.LH + (~D).*X2.LH;
D  = (abs(X1.HL)-abs(X2.HL)) >= 0; 
X.HL = D.*X1.HL + (~D).*X2.HL;
D  = (abs(X1.HH)-abs(X2.HH)) >= 0; 
X.HH = D.*X1.HH + (~D).*X2.HH;

%XX = [X.LL, X.LH; X.HL, X.HH];
U = 0.5*(U1+U2);

%apply IMSVD
imf = IMSVD(X,U);

%display fused image
figure(3); imshow(imf,[]);
imwrite(imf,'msvdfm1.jpg');

%error image
imd = imt-imf;
figure(4); imshow(imd,[]);

addpath('D:\Glioblastoma\MSVD');
savepath; % Optional: Save the updated path for future sessions


% fusion quality evaluation metrics
[RMSE,PFE,MAE,CORR,SNR,PSNR,MI,QI,SSIM] = pereval(imt,im1,im2,imf);
fprintf('\n   Fusion Quality Evaluation Metrics:\n');
fprintf('\nroot mean square error           (RMSE): %3f2',RMSE);
fprintf('\nPersentage fit error              (PFE): %3f2',PFE);
fprintf('\nmean absolute error               (MAE): %3f2',MAE);
fprintf('\nCorrelation                      (CORR): %3f2',CORR);
fprintf('\nsignal to noise ration            (SNR): %3f2',SNR);
fprintf('\npeak signal to noise ration      (PSNR): %3f2',PSNR);
fprintf('\nmutual information                 (MI): %3f2',MI);
fprintf('\nquality index                      (QI): %3f2',QI);
fprintf('\nmeasure of structural similarity (SSIM): %3f2',SSIM);
fprintf('\n\n');
M = mean(imf(:))*100
 E = entropy(imf)     % Entropy calculation
 S = standarddeviation(imf)        % Standard deviation
 ma = mi(im1,imf);
 mb = mi(im2,imf);
 ff = ma+mb
 ref = im2double(imread('D:\\Glioblastoma\\outputs\\fused_image_M20.jpg'));
 PSNR = PeakSignaltoNoiseRatio(ref,imf)  %PSNR calculation
 RMSE = MeanSquareError(ref,imf)          %RMSE calculation
