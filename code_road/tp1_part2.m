clc;
clear;
close all;
%% partie 6 Calcul de disparités
close all;
% Question 1

imaG=imread('01G.png');
imaD=imread('01D.png');
[nl,nc,nb]=size(imaG);
imaGD = [imaG imaD];
width = 3; %line width 
imaGD(110:110+width,:,:)=0; %black line 
imaGD(:,9*20:9*20+width,:)=0;
imaGD(:,9*20+nc:9*20+nc+width,:)=0;
figure('Name','géométrie épipolaire 1');
imshow(imaGD)
imaGD = [imaG imaD]; %undo plotted lines
imaGD(11*20:11*20+width,:,:)=0;
imaGD(:,6*20:6*20+width,:)=0;
imaGD(:,6*20+nc:6*20+nc+width,:)=0;
figure('Name','géométrie épipolaire 2');
imshow(imaGD)

% Question 2
%First we convert the images to gray scale
imaGgray = rgb2gray(double(imaG)./255);
imaDgray = rgb2gray(double(imaD)./255);
%we apply median filter to imaG
imaG_filtred_med = medfilt2(imaGgray,[3 54]);
extractionG_by_med = abs(imaG_filtred_med-imaGgray);
s_marquage = .17;
imaskG = 0*imaG_filtred_med;
imaskG( extractionG_by_med > s_marquage) = 1;
figure('Name','MLT G');
imshow(imaskG);
%apply MLT to imaD
imaD_filtred_med = medfilt2(imaDgray,[3 54]);
extractionD_by_med = abs(imaD_filtred_med-imaDgray);
s_marquage = .17;
imaskD = 0*imaD_filtred_med;
imaskD( extractionD_by_med > s_marquage) = 1;
figure('Name','MLT D');
imshow(imaskD);
%find centers
centreG = 0*imaskG;
centreD = 0*imaskG;
for i= 1:nl
    centreG(i,:) = bwmorph(imaskG(i,:),'shrink',inf);
    centreD(i,:) = bwmorph(imaskD(i,:),'shrink',inf);
end
figure('Name','centre G');
imshow(centreG);
figure('Name','centre D');
imshow(centreD);

%% Question 3

half_window_size = 8 ; %we have the same sliding on either side of a midpoint : center
% Pad images to avoid going out of bounds
imaGgray_pad = im2double(padarray(imaGgray,[half_window_size,half_window_size], 'replicate'));
imaDgray_pad = im2double(padarray(imaDgray,[half_window_size,half_window_size], 'replicate'));

diparity_image = zeros(nl,nc); 
max_disparite = 80; %maximum disparity value
tabD = []; tabG = [];%save the centers
vert_profil = zeros(size(imaGgray,1),1); %this will be used in the next part for 2D histogram

for i=1:nl
    %Find the nonzero elements in a matrix.
    tabG = find(centreG(i,:));
    tabD = find(centreD(i,:));
    vert_profil(i) = length(tabG);
    %disparity for imaGgray
    for j=tabG
        regionG = imaGgray_pad(i:i+2*half_window_size, j:j+2*half_window_size);  % window with corner the position of the center at i horizental and j the vertical 
        diparite_G = [1e6 0]; %structure take in first column the value of correlation between two regions
                              %the left and the slided one window on the right
                              %should be initialized with big number second is the disparity value
        for d = 0:max_disparite
            if j<d+1   
                break   %running out of bounds
            else
                regionD = imaDgray_pad(i:i+2*half_window_size, j-d:j-d+2*half_window_size); %sliding window over image D
                correlation = sum(sum((regionG - regionD).^2)); %euclidian distance to compare between region
                if correlation < diparite_G(1)
                    diparite_G = [correlation d];
                end
            end
        end
    end
    diparity_image(i,j)=diparite_G(2);
end

figure('Name','carte de disparité');

[vG uG] = ind2sub([nl nc],find(diparity_image)); %get the positions of non zeros disparity values
disp = zeros(size(vG));
for h = 1:length(vG)
    disp(h) = diparity_image(vG(h),uG(h));
end

scatter3(vG,uG,disp);
xlabel('vG');ylabel('uG');zlabel('disparité');title('carte de disparité');


%% Partie 7 Détection des obstacles

% Question 1

figure('Name','histogramme 2D');
%scatter3(vG,disp,vert_profil);
%xlabel('uG');ylabel('vG');zlabel('disparité');title('histogramme 2D');

