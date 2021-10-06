clc;
clear;
close all;
%% partie 2 Exploration des données fournies
% Question 1
for num=1:5 %on parcoure les cinq images
    image_name=strcat('00',num2str(num),'.bmp'); %on declare le nom de l'image sans brouillard exp : "001.bmp"
    image = imread(image_name);
    image_avec_brouillard_name=strcat('U00',num2str(num),'.bmp'); %on declare le nom de l'image sans brouillard exp : "U001.bmp"
    image_avec_brouillard = imread(image_avec_brouillard_name);
    deux_images = [image image_avec_brouillard]; %on met cote a cote les deux images
    figure('Name',strcat('couple image',num2str(num)));
    imshow(deux_images);
end

% Question 2
load('BDD_vehicule.mat','BDD_vehicule','BDD_vehiculesmall','Search_Pattern'); %on lit les trois variables qui seront stoché dans le workspace

%% Question 3 
figure('Name','Vehicule');
k=0;
for scale=1:7
    for j=1:7
        k=k+1; %indice du numéro de l'image dans la figure
        subplot(7,7,k);
        x=BDD_vehicule{k,1}; %indexage de la base de donnée qui est de type cell en utilisant {}
        imshow(x);
        hold on;
    end
end
figure('Name','Vehicule petite');
k=0;
for scale=1:7
    for j=1:7
        k=k+1;
        subplot(7,7,k);
        x=BDD_vehiculesmall{k,1};
        imshow(x);
        hold on;
    end
end