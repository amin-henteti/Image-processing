clc;
close all;
%% partie 3 Travail à effectuer
% Question 1
%I(d) = I0*exp(-k*d) +Is*(1-exp(-k*d));
%d=lambda./(v-vh);
%=> I(v) = I0*exp(-k*lambda./(v-vh)) +Is*(1-exp(-k*lambda./(v-vh)));

% Question 2
v =[1:0.05:20]; vh = 0; lambda = 500; 
k = 0.02; Is = 1.0; I0 = 0.2;
I = I0*exp(-k*lambda./(v-vh)) +Is*(1-exp(-k*lambda./(v-vh)));
figure('Name',' modèle théorique I(v) ');
plot(v,I);
xlabel('v'); ylabel('I');

% Question 3
%k = 2*(vi-vh)/lambda;

% Question 4

ima = imread('F00.png');
if size(ima,3) ==3 %image en couleur
    imad = rgb2gray(double(ima)/255.0);
else
    imad = double(ima)/255.0;
end
data = 0*zone2;%profil(imad);
figure('Name','data');
plot(data(:,1),data(:,2));

%% Question 5
zone1 = 0*zone2;%profil(imad);
zone2 = profil(imad);
zone3 = 0*zone2;%profil(imad);
figure('Name','zones');
plot(zone1(:,1),zone1(:,2));
hold on;
plot(zone2(:,1),zone2(:,2));
hold on;
plot(zone3(:,1),zone3(:,2));
legend('voie de gauche','voie centrale','chevauchement route et champs');

%% partie 4 Distance de visibilité
%close all;
%clc;
%% Question 1
dzone2 = 0*zone2;
dzone2(:,1) = zone2(:,1);
dzone2(1:end-1,2) = zone2(2:end,2)-zone2(1:end-1,2);
figure('Name','derive profil zone centrale');
plot(dzone2(:,1),dzone2(:,2));

%% Question 2
fil_moy = fspecial('average',[1 21]);
len_fil = length(fil_moy);
result = 0*zone2;
result(:,1) = zone2(:,1); %enregistre de l'axe des abscisse
%Gestion des bords
bordure1 = zone2(1:len_fil,2);       %on prend les premiers pixels du bord de face
bordure1 = bordure1(end:-1:1);       %on inverse l'ordre des colonnes
bordure2 = zone2(end-len_fil:end,2); %on prend les premiers pixels du bord du queue
bordure2 = bordure2(end:-1:1);       %on inverse l'ordre des colonnes
extend_boundary = [bordure1; zone2(:,2); bordure2]; %j'ajoute des bordures aux bords
figure('Name','boundaries');
plot(zone2(:,1),zone2(:,2),'*');
hold on
%hyp : len_fil < zone2(1,1) vrai en general 
%      parce que len_fil est au maximum 40
%      alors que zone2(1,1) est de l'ordre de 100
x1 = zone2(1:len_fil,1)-len_fil+1;
x2 = zone2(:,1);
x3 = zone2(end-len_fil:end,1)+len_fil;
extend_x_axis = [x1;x2;x3];
plot(extend_x_axis , extend_boundary);
legend('normal','avec bordures');
result_with_boundary = conv(extend_boundary,fil_moy,'same'); %option same donne vecteur résultat de meme taille que le premier vecteur en entré
result(:,2)= result_with_boundary(len_fil+1:end-len_fil-1); %enleve des bordures ajouté
figure('Name','lissing');
plot(result(:,1),result(:,2));
hold on;
plot(zone2(:,1),zone2(:,2));
legend('lisse','original');

%% Question 3
dresult = 0*zone2;
dresult(:,1) = zone2(:,1);
dresult(1:end-1,2) = result(2:end,2)-result(1:end-1,2);
dresult(end,2) = dresult(end-1,2);
figure('Name','derive profil zone centrale');
plot(dresult(:,1),dresult(:,2));
%As the courbe is always descending like the model
% so the extrema that we are intressted in is a minima
[mini,ind] = min(dresult(:,2));
vi = dresult(ind,1); %this varies with respect to the width of filter that smooths the profil
hold on
scatter(vi,mini,'filled');%plot the estremum point

%% Question 4
figure('Name','horizon');
imad(425:430,:)=0;
imshow(imad)
vh = 425;lambda = 500;
k=2*(vi-vh)/lambda
dvisible = 3.0/k

% Question 5
%we change at question 4 part 2  
%”F00.png” =>  ”F01.png” and another time =>  ”F02.png” 
% and we execute the same lines of codes

% Question 6

