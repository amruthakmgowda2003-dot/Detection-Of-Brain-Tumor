%********************* MSVD Fusion ***********************%

clc;
close all;
clear all;

%*************** Image Reading *****************%

%*************** JPEG IMAGES ********************%
image1 = im2double(imread('D:\Glioblastoma\M-P12(CT).jpg'));
image1 = imresize(image1,[256 256]);
image1 = rgb2gray(image1);
image1 = im2bw(image1);
image2 = im2double(imread('D:\Glioblastoma\M-P12 (MRI).jpg'));
image2 = imresize(image2,[256 256]);
image2 = rgb2gray(image2);
image2 = im2bw(image2);
wname = 'haar';

figure(1); subplot(2,2,1);
imshow(image1,[]);
figure(1); subplot(2,2,2);
imshow(image2,[]);

% ************ MSVD Decomposition Level 1 **************%
%*%

[a1,c1,b1,d1] = dwt2(image1,wname);
[aa1,cc1,bb1,dd1] = dwt2(a1,wname);
[aaa1,ccc1,bbb1,ddd1] = dwt2(aa1,wname);


figure(2);
imshow([a1 c1; b1 d1], []);
figure(3);
imshow([[aa1 cc1;bb1 dd1] c1; b1 d1],[]);
figure(4);
imshow([[[aaa1 ccc1; bbb1 ddd1] cc1; bb1 dd1] c1 ;b1 d1],[]);

% ************ MSVD Decomposition Level 2 **************%
%*%

[a2,c2,b2,d2] = dwt2(image2,wname);
[aa2,cc2,bb2,dd2] = dwt2(a2,wname);
[aaa2,ccc2,bbb2,ddd2] = dwt2(aa2,wname);


figure(5);
imshow([a2 c2; b2 d2], []);
figure(6);
imshow([[aa2 cc2;bb2 dd2] c2; b2 d2],[]);
figure(7);
imshow([[[aaa2 ccc2; bbb2 ddd2] cc2; bb2 dd2] c2 ;b2 d2],[]);


 %********************** MSVD Fusion *******************%
 
 %*Third level fusion*%
 
 aaa_fuse = 0.5*(aaa1+aaa2);
 D = (abs(ccc1)-abs(ccc2))>=0;
 ccc_fuse = D.*ccc1+(~D).*ccc2;
 D = (abs(bbb1)-abs(bbb2))>=0;
 bbb_fuse = D.*bbb1+(~D).*bbb2;
 D = (abs(ddd1)-abs(ddd2))>=0;
 ddd_fuse = D.*ddd1+(~D).*ddd2;
 
 %*Second level fusion*%
 
 D = (abs(cc1)-abs(cc2))>=0;
 cc_fuse = D.*cc1+(~D).*cc2;
 D = (abs(bb1)-abs(bb2))>=0;
 bb_fuse = D.*bb1+(~D).*bb2;
 D = (abs(dd1)-abs(dd2))>=0;
 dd_fuse = D.*dd1+(~D).*dd2;
 
 %*First level fusion%
 
 D = (abs(c1)-abs(c2))>=0;
 c_fuse = D.*c1+(~D).*c2;
 D = (abs(b1)-abs(b2))>=0;
 b_fuse = D.*b1+(~D).*b2;
 D = (abs(d1)-abs(d2))>=0;
 d_fuse = D.*d1+(~D).*d2;
 
 %Inverse MSVD%
 
 level_2 = idwt2(aaa_fuse,ccc_fuse,bbb_fuse,ddd_fuse,wname);
 level_1 = idwt2(level_2,cc_fuse,bb_fuse,dd_fuse,wname);
 fused_image = idwt2(level_1,c_fuse,b_fuse,d_fuse,wname);
 figure(1); subplot(2,2,3:4);
 imshow(fused_image,[]);
 
 
output_file = sprintf('D:\\Glioblastoma\\outputs\\fused_image_ME.jpg');
imwrite(fused_image, output_file);

 
 %*Statistical Parameters Analysis%
 
 M = mean(fused_image(:))*100
 E = entropy(fused_image)     % Entropy calculation
 S = standarddeviation(fused_image)        % Standard deviation
 ma = mi(image1,fused_image)
 mb = mi(image2,fused_image)
 ff = ma+mb
% Sk = skewness(fused_image(:))*100
% ref = im2double(imread('REFm1.jpg'));
 %ref = im2bw(ref);
% PSNR = PeakSignaltoNoiseRatio(ref,fused_image)  %PSNR calculation
% RMSE = MeanSquareError(ref,fused_image)          %RMSE calculation