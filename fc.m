clc;
clear all;
clear all;


%IMPORTING IMAGE

originalimage=imread('2.jpg');
[rows,coloums]=size(originalimage);
%originalimage=rgb2gray(originalimage);
originalimage=im2double(originalimage);
originalimage=imadjust(originalimage);


% ADDING GAUSSIAN NOISE 

 variance=0.005;
    mean=0;
  img_noise=imnoise(originalimage,'gaussian',mean,variance);
%subplot(1,2,1);imshow(originalimage); 
%title('Original Image');
%subplot(1,2,2);imshow(img_noise); 
%title('Noisy Image');





%APPLYING DWT

wavename='haar';
[Ca,Ch,Cv,Cd]=dwt2(img_noise,wavename);
[aa,hh,vv,dd]=dwt2(Ca,wavename);
DWT1=cat(3,Ca,Ch,Cv,Cd);
DWT2=cat(3,aa,hh,vv,dd);
figure,montage(DWT1,[]);
title('PARENT DWT'); %PARENT DWT
figure,montage(DWT2,[]);
title('CHILD DWT'); %CHILD DWT

  %noise variance(eq 8)                                 
sigmanoise=median(abs(Ch(:)))/0.6745;             

%padding subbands(horizontal, vertical and diagonal)

PADDEDH=padarray(Ch,[1 1],0,'both');
PADDEDV=padarray(Cv,[1 1],0,'both');
PADDEDD=padarray(Cd,[1 1],0,'both');

%calculating threshold value for all coeffiencts of each subbands
thres_h=threshold(PADDEDH,sigmanoise);
thres_v=threshold(PADDEDV,sigmanoise);
thres_d=threshold(PADDEDD,sigmanoise);
% 
%applying bivariate shrinkage function
Ch=bivariate(Ch,hh,thres_h);
Cv=bivariate(Cv,vv,thres_v);
Cd=bivariate(Cd,dd,thres_d);



%APPLYING WEINER FILTER
aa = wiener2(aa,[5,5]);
Ca=idwt2(aa,hh,vv,dd,'haar');
Ca=wiener2(Ca,[5,5]);
img_denoised =idwt2(Ca,Ch,Cv,Cd,'haar');


for i=1:512
    for j=1:512
        sf(i,j)=img_denoised(i,j)-img_noise(i,j);
    end
end 
ss= svd_denoising(sf,1)
for k=1:512
    for l=1:512
        img_denoised(k,l)=img_denoised(k,l)+ss(k,1);
    end
end
figure;
subplot(1,2,1);imshow(img_noise); 
title('Noisy CT Image:');
subplot(1,2,2);imshow(img_denoised); 
title('Denoised CT Image');

