clc;
%clear;
close all;

%% Partie 3 Détection à plusieurs échelles dans une image

%il faut charger les données 
load('BDD_vehicule.mat','BDD_vehicule','BDD_vehiculesmall','Search_Pattern');

%% Question 0 : 
%comprendre ROI et la fonction rectangle et voir la difference entre
%le repere de définition du rectangle et celle de l'image


image = imread('001.bmp'); % reset image original
figure('Name','rectangle et image');
subplot(121);
imshow(image);
rectangle('Position',[111 58 50 200],'EdgeColor','r');
subplot(122);
rectangle('Position',[111 55 50 200],'EdgeColor','r'); %on trace le meme rectangle mais pas sur l'image
axis([1 size(image,2) 1 size(image,1)]);

%% bloc des commandes connaitre l'utilisation de ROI
ROI = Search_Pattern(1).ROI; %on considere la zone d'interet à l'echelle = 4
image = imread('001.bmp');
figure('Name','ROI');
subplot(121);
image(ROI(1):ROI(1)+ROI(3),ROI(2):ROI(2)+ROI(4),:)=0.5; %valeur arbitraire pour rend tous les pixels de cette zone à valeur constante
imshow(image);
rectangle('Position',ROI,'EdgeColor','r');
%il faut inverser les ordres d'indexage
image = imread('001.bmp'); % reset image original
image(ROI(2):ROI(2)+ROI(4),ROI(1):ROI(1)+ROI(3),:)=0.5;
subplot(122);
imshow(image);
rectangle('Position',ROI,'EdgeColor','r');

%% Question 1
skip = 0; %ignorer l'execution du code de cette question
close all
scale_list=[4 6 8 12];
if ~skip
for num=1:5
    for b=1:2
        %on utilise indice (1) pour image sans brouillard
        %et indice(2) pour image avec brouillard
        if b==1
            image_name=strcat('00',num2str(num),'.bmp');
        else
            image_name=strcat('U00',num2str(num),'.bmp');
        end
        image = imread(image_name);
        image = double(image)./255.0; %transformer en double
        fig_to_file = figure('Name',image_name); %pour permettre de l'enrgeistrer directement en le faisant comme entré pour la fonction saveas
        imshow(image);
        
        for i=1:length(scale_list)
            scale = scale_list(i);
            Spattern = Search_Pattern(i); % evite repetition
            for col=Spattern.ROI(1):Spattern.StepX:Spattern.ROI(1)+Spattern.ROI(3)
                for row=Spattern.ROI(2):Spattern.StepY:Spattern.ROI(2)+Spattern.ROI(4)
                    rectangle('Position',[col row 6*scale 5*scale],... %rectangle fait le dessin dans meme repere que l'image  
                      'EdgeColor',Spattern.color);                     
                end
            end
        end
        saveas(fig_to_file,strcat('rect',image_name(1:end-4),'.jpg')); %end-4 pour enlever .bmp
    end
end
end
%% Question 2 calcul du score de dissemblance
%close all
scale_list=[4 6 8 12];
image_name = '001.bmp'; %puis '002.bmp' ensuite '003.bmp'
image = imread(image_name);
image = double(image)./255.0;
figure('Name',strcat('detection ',image_name));
imshow(image);
for i=1:length(scale_list)
    scale = scale_list(i);
    Spattern = Search_Pattern(i); % eviter repetition
    for col=Spattern.ROI(1):Spattern.StepX:Spattern.ROI(1)+Spattern.ROI(3)
        for row=Spattern.ROI(2):Spattern.StepY:Spattern.ROI(2)+Spattern.ROI(4)
            imagette = image(row:row+5*scale,col:col+6*scale,:); %on extrait imagette de dim [5*scale, 6*scale]
            imagette = imagette - mean(imagette(:)); %annuler intensité moyenne
            %réduire à la taille [5,6,3] on a 3 couleurs RGB => 
            %on fait la redimentionnement pour tous les 3 couleurs
            resized_imagette = zeros(5,6,3); %initialisation
            for ind_couleur=1:3
                resized_imagette(:,:,ind_couleur) = imresize(imagette(:,:,ind_couleur),[5 6]); %on diminue  la dimension de chaque couleur
            end
            %calculer les distances
            score=[];
            for j=1:51
                imagette_ref=BDD_vehiculesmall{j,1};
                score=[score norm(resized_imagette(:)-imagette_ref(:),2)];%les indices des pixels s'arrange 
                                                                          %lorsque on convertit les deux images en un vecteur par (:)
            end
            score = sort(score); %trie ascendant donc les minimums sont aux premiers indices
            dissamblance_score = sum(score(1:3))/3; %par enonce

            if dissamblance_score < Spattern.Thresh
                fprintf('ditection of %s at [%d %d %d %d]\n',image_name,col,row,6*scale,5*scale)
                rectangle('Position',[col row 6*scale 5*scale],...
                 'EdgeColor',Spattern.color);
                    
            end
        end
    end
end


%% Question 3
close all;
scale_list=[4 6 8 12];
for num=1:5
    image_name=strcat('00',num2str(num),'.bmp');
    image = imread(image_name);
    image = double(image)./255.0;
    fig_to_file = figure('Name',strcat('detection ',image_name));
    imshow(image);
    for i=1:length(scale_list)
        scale = scale_list(i);
        Spattern = Search_Pattern(i); % eviter repetition
        for col=Spattern.ROI(1):Spattern.StepX:Spattern.ROI(1)+Spattern.ROI(3)
            for row=Spattern.ROI(2):Spattern.StepY:Spattern.ROI(2)+Spattern.ROI(4)
                imagette = image(row:row+5*scale,col:col+6*scale,:); %on extrait imagette de dim [5*scale, 6*scale]
                imagette = imagette - mean(imagette(:)); %annuler intensité moyenne
                %réduire à la taille [5,6,3] on a 3 couleurs RGB => on
                %fait le redimentionnement pour tous les 3 couleurs
                resized_imagette = zeros(5,6,3); %initialisation
                for ind_couleur=1:3
                    resized_imagette(:,:,ind_couleur) = imresize(imagette(:,:,ind_couleur),[5 6]); %on diminue  la dimension de chaque couleur
                end
                %calculer les distances
                score=[];
                for j=1:51
                    imagette_ref=BDD_vehiculesmall{j,1};
                    score=[score norm(resized_imagette(:)-imagette_ref(:),2)];
                end
                score = sort(score); %trie ascendant donc les minimums sont aux premiers indices
                dissamblance_score = sum(score(1:3))/3; %par enonce
                if dissamblance_score < Spattern.Thresh
                    rectangle('Position',[col row 6*scale 5*scale],...
                     'EdgeColor',Spattern.color);
                end
            end
        end
        saveas(fig_to_file,strcat('detect',image_name(1:end-4),'.jpg')); %end-4 pour enlever .bmp
    end
end


%% Question 4
close all;
scale_list=[4 6 8 12];
for num=1:5
    image_name=strcat('00',num2str(num),'.bmp');
    image = imread(image_name);
    image = double(image)./255.0;
    fig_to_file = figure('Name',strcat('detection ',image_name));
    imshow(image);
    for i=1:length(scale_list)
        scale = scale_list(i);
        Spattern = Search_Pattern(i); % eviter repetition
        for col=Spattern.ROI(1):Spattern.StepX:Spattern.ROI(1)+Spattern.ROI(3)
            for row=Spattern.ROI(2):Spattern.StepY:Spattern.ROI(2)+Spattern.ROI(4)
                imagette = image(row:row+5*scale,col:col+6*scale,:); %on extrait imagette de dim [5*scale, 6*scale]
                imagette = imagette - mean(imagette(:)); %annuler intensité moyenne
                %réduire à la taille [5,6,3] on a 3 couleurs RGB => on
                %fait le redimentionnement pour tous les 3 couleurs
                resized_imagette = zeros(5,6,3); %initialisation
                for ind_couleur=1:3
                    resized_imagette(:,:,ind_couleur) = imresize(imagette(:,:,ind_couleur),[5 6]); %on diminue  la dimension de chaque couleur
                end
                %calculer les distances
                score=[];
                for j=1:51
                    imagette_ref=BDD_vehiculesmall{j,1};
                    score=[score norm(resized_imagette(:)-imagette_ref(:),2)];
                end
                score = sort(score); %trie ascendant donc les minimums sont aux premiers indices
                dissamblance_score = sum(score(1:3))/3; %par enonce
                facteur = 0.92;
                if facteur*dissamblance_score < Spattern.Thresh
                    rectangle('Position',[col row 6*scale 5*scale],...
                     'EdgeColor',Spattern.color);
                end
            end
        end
    end
    saveas(fig_to_file,strcat('detect',image_name(1:end-4),'.jpg')); %end-4 pour enlever .bmp
end


%% Question 5
close all
scale_list=[4 6 8 12];
for num=1:5
    image_name=strcat('U00',num2str(num),'.bmp');
    image = imread(image_name);
    image = double(image)./255.0;
    fig_to_file = figure('Name',strcat('detection ',image_name));
    imshow(image);
    for i=1:length(scale_list)
        scale = scale_list(i);
        Spattern = Search_Pattern(i); % eviter repetition
        for col=Spattern.ROI(1):Spattern.StepX:Spattern.ROI(1)+Spattern.ROI(3)
            for row=Spattern.ROI(2):Spattern.StepY:Spattern.ROI(2)+Spattern.ROI(4)
                imagette = image(row:row+5*scale,col:col+6*scale,:); %on extrait imagette de dim [5*scale, 6*scale]
                imagette = imagette - mean(imagette(:)); %annuler intensité moyenne
                %réduire à la taille [5,6,3] on a 3 couleurs RGB => on
                %fait le redimentionnement pour tous les 3 couleurs
                resized_imagette = zeros(5,6,3); %initialisation
                for ind_couleur=1:3
                    resized_imagette(:,:,ind_couleur) = imresize(imagette(:,:,ind_couleur),[5 6]); %on diminue  la dimension de chaque couleur
                end
                %calculer les distances
                score=[];
                for j=1:51
                    imagette_ref=BDD_vehiculesmall{j,1};
                    score=[score norm(resized_imagette(:)-imagette_ref(:),2)];
                end
                score = sort(score); %trie ascendant donc les minimums sont aux premiers indices
                dissamblance_score = sum(score(1:3))/3; %par enonce
                facteur = 0.9;
                if dissamblance_score < Spattern.Thresh
                    rectangle('Position',[col row 6*scale 5*scale],...
                     'EdgeColor',Spattern.color);
                end
            end
        end
    end
    saveas(fig_to_file,strcat('detect',image_name(1:end-4),'.jpg')); %end-4 pour enlever .bmp
end