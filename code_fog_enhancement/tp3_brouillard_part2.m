%% partie 7 Travail à effectuer
close all;
clc
% Question 1
%Koschmieder law
%I = I0*(1-V/Is) + V 

% Question 2
%I0estim=Is*(I - V)/(Is - V);

% Question 3
ima = imread('F01.png');
imadgray = double(ima)./255.0;
figure('Name','F0 image');
imshow(imadgray);
%sky is the upper zone of the photo. There's no trees 
%ciel=imadgray(1:20,40:end-40); 
%Is = max(ciel(:));
%Is = mean(ciel(:)); %i think this hypothesis is more robust
sorted_I = sort(imadgray(:));
n = 500; %nb of pixels to consider
Is = mean(sorted_I(end-n:end)); %mean of the n highest intensity witch locate 
                                %in the tail of the vector thanks to sort
% Question 4
dx = 5; dy = 66;
imad_filtred_med = medfilt2(imadgray,[dx dy],'symmetric'); %padding
figure('Name','lissage par filtre median');
imshow(imad_filtred_med);
V = .95*min(imadgray,imad_filtred_med);

% Question 5
ima_est=Is*(imadgray - V)./(Is - V);
figure('Name','restauration');
imshow(ima_est);

% Question 6
ima_est = ima_est.^(.4);
figure('Name','correction gamma');
imshow(ima_est);

% Question 7
%we change at question 3 of this part 
%”F00.png” =>  ”F01.png”

%% Question 8
ima = imread('F03.png');
figure('Name','F03 image');
imshow(ima);
imadgray = rgb2gray(double(ima)./255.0);
figure('Name','F03 image gray');
imshow(imadgray);
Is = imadgray(1,1,1);
dx = 5; dy = 66;
imad_filtred_med = medfilt2(imadgray,[dx dy],'symmetric'); %padding
V = .95*min(imadgray,imad_filtred_med);
ima_est=Is*(imadgray - V)./(Is - V);
ima_est = ima_est.^(.6);
figure('Name','correction gamma F03 image');
imshow(ima_est);