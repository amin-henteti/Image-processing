clc;
clear;
close all;
%% partie 2 Lecture et affichage d’une image
% Question 1
ima = imread('01D.png');

% Question 2
figure('Name','ima');
imshow(ima);

% Question 3
imad = double(ima);
figure('Name','imad');
imshow(imad);
imad = imad./255.0;
figure('Name','imad/255');
imshow(imad);

% Question 4
imagray = rgb2gray(ima);
imadgray = rgb2gray(imad);
ima_diff = abs(double(imagray) - 255*imadgray);
diff_fig = figure('Name','ima_diff');
imshow(ima_diff);

% Question 5
saveas(diff_fig,'ima_diff.png');


%% partie 3 Propriétés d’une image
% Question 1
pixel = imadgray(232,212); % = 0.3288
size(imadgray) % = 258 330
[nl,nc,nb] = size(imadgray);

% Question 2
maxlig = ones(nl,1);
for i=1:nl
    maxlig(i) = max(imadgray(i,:));
end
minlig = min(imadgray,[],2);
moylig = mean(imadgray,2);
figure('Name','max min moy des lignes');
plot(maxlig);hold on;
plot(minlig);hold on;
plot(moylig);
legend('maxlig','minlig','moylig');

% Question 3
%x(:) transforme le variable matricielle x en un vecteur
moyima = mean(imadgray(:)); % =0.5961  
maxima = max(imadgray(:));  % =0.9984
minima = min(imadgray(:));  % =0.1706
sumima = sum(imadgray(:));  % =5.0748e+04


%% partie 4 Extraction des marquages
% Question 1
avg_filter = fspecial('average',[3 15]);
imad_filtred_avg = imfilter(imadgray,avg_filter);
figure('Name','imad_filtred_avg');
imshow(imad_filtred_avg);

% Question 2
imad_filtred_med = medfilt2(imadgray,[3 60]);
figure('Name','imad_filtred_med');
imshow(imad_filtred_med);

%compare_avg_med = abs(imad_filtred_avg-imad_filtred_med);
%figure('Name','compare_avg_med');
%imshow(compare_avg_med);


% Question 3
extraction_by_med = abs(imad_filtred_med-imadgray);
figure('Name','extraction_by_med');
imshow(extraction_by_med);

% Question 4
s_marquage = .22;
imask = 0*imad_filtred_med;
%extraction_by_med_and_threshold
imask( extraction_by_med > s_marquage) = 1;
figure('Name','imask');
imshow(imask);

%% Question 5
%close all;
rectangle = strel('rectangle',[5 23]);
imad_morph_rect = imopen(imadgray,rectangle);
figure('Name','imad_morph_rect');
imshow(imad_morph_rect);
extraction_by_morph_rect = imadgray-imad_morph_rect;
figure('Name','extraction_by_morph_rect');
imshow(extraction_by_morph_rect);
s_marquage = 0.25;
imask_morph_rect = 0*extraction_by_morph_rect;
imask_morph_rect( extraction_by_morph_rect > s_marquage) = 1;
imaskfig = figure('Name','imask_morph_rect');
imshow(imask_morph_rect);


% partie 5 Evaluation de l'extraction
%close all
% Question 1
ideal = imread('01DR.png');
tp = sum(sum(ideal & imask_morph_rect));
fn = sum(sum(ideal & not(imask_morph_rect)));
fp = sum(sum(not(ideal) & imask_morph_rect));
tn = sum(sum(not(ideal) & not(imask_morph_rect)));
tpr = tp/(tp+fn);
fpr = fp/(fp+tn);
%%
% Question 2
figure('Name','courbe ROC');
ROC(extraction_by_med); %I made a function to plot ROC courbe
                        %so that the same codes (that are in 
                        %the previous question), i dont repeat them 
                        %in the next question
% Question 3
figure('Name','courbe ROC');
ROC(extraction_by_med);
hold on;%plot in the same figure as the precedent so it would be easier to compare
ROC(extraction_by_morph_rect);
%make another morphological opning
octa = strel('octagon',3*6);
imad_morph_octa = imopen(imadgray,octa);
extraction_by_morph_octa = abs(imad_morph_octa-imadgray);
hold on;%plot in the same figure as the precedent so it would be easier to compare
ROC(extraction_by_morph_octa);
legend('median','morph rect','morph octa');
% -------------------------------------------------------------------------

