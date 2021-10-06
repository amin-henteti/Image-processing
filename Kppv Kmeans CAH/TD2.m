clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------Données---------%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%les points sont représenté par
%couple de coordonnées
%numéros
%la classe 0->non-classées
A=[2 10 1 0;
    2 5 2 0;
    8 4 3 0;
    5 8 4 0;
    7 5 5 0;
    6 4 6 0;
    1 2 7 0;
    4 9 8 0];
%on ajoute autres points aléatoire à classer
n = 100;
new_points = [randint(n,2,[1 40]) [size(A,1)+1:size(A,1)+n]' 0*[size(A,1)+1:size(A,1)+n]'];
A = [A;new_points];
%on donne les numéros des points qui représentent les centres intiaux des classes
centre = [1 4 7]';
k = length(centre);
Mu = A(centre,1:2);%on extrait les coordonnées des centres
%Mu = [Mu [1:k]'];%on ajoute le numéro de classe assosié à chaque centre
%initialisation
nb_ele = ones(k,1);
Mu_old = 0*Mu;
iter = 0;
dist_parasite = 50;%distance à partir de laquelle le point sera ignoré (très loin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------algorithme K-Means---------%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while sum(norm(Mu - Mu_old)) > 1e-4 % tant les centre ne varie pas
    %on enregistre les centres
    Mu_old = Mu;
    %on parcourt les points
    for i=1:length(A)
        %on extrait les coordonnées
        x = A(i,1:2);
        % k est nombre des centres et donc des clesses
        dist = zeros(k,1);%varible qui va contenir tous les distances 
                          %du point considéré avec les centres des classes   
        for j=1:k
            dist(j) =  norm(Mu(j,:)-x);
        end
        %on cheche la distance minimale et son indice associé
        [mini,index] = min(dist);
        if mini<dist_parasite
            A(i,4) = index; %on classe le point
        else
            A(i,4) = 0; % points reste non classé
        end
    end
    %on fait le mise à jour des centres des classes 
    for j=1:k
        %on extrait les points qui ont le meme classe j
        class = find(A(:,4)==j);
        class_pts = A(class,1:2);
        nb_ele(j) = size(class_pts,1);
        Mu(j,:) = sum(class_pts,1)/nb_ele(j);%le centre de gravité des points du classe
    end
    iter = iter+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%affichage
%on trie par rapport aux numéro de classes
[~,index] = sort(A(:,4));
sortedA = A(index,:);
colors=['r','g','b','m','k'];%pour diferencier les classes 
                             %je suppose qu'il ya 5 classe au maximum
                             %si on a seuleument 2 alors
                             %les points du classe 1 seront colorés par 'rouge'
                             %et les points du classe 2 seront colorés par 'vert'
                             
if sortedA(1,4)==0 %il y a des points parasites qui sont placé au début parce que on a fait le trie
    Mu = [ [0 0]; Mu]; % associé le point O comme centre des non-classé 
                       %(choix arbitraire en supposant que O n' est pas aussi un autre centre des classe 1 à k
    k=k+1;%on incremente le nombre des classes puisque les non-classés forment une nouvelle classe 0
    nb_ele = [ size(A,1)-sum(nb_ele) ;nb_ele]; % ajouter le nombre des points de classe 0
    colors=['y', colors];% ajouter couleur jaune aux points de classe 0
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------affichage---------%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%on trace dans une figure nommé K-means
figure('Name','K-means');
ind = 1;%variable pour sauter entre les points de chaque classes
for i=1:k
    %on extrait les points du meme classe
    AA = sortedA(ind:ind+nb_ele(i)-1,:);
    X = AA(:,1);
    Y = AA(:,2);
    label =  num2str(AA(:,4));
    scatter(X,Y,'filled',colors(i));%'MarkerFaceColor',[.3*floor(i/4) .8*floor(i/4/2) mod(i,2)]);
    %text(X,Y,label,'VerticalAlignment','bottom','HorizontalAlignment','right');
    xlim([min(A(:,1))-2 max(A(:,1))+2]);
    ylim([min(A(:,2))-2 max(A(:,2))+2]);
    hold on
    %on trace le centre de cette classe i par un point de rayon plus grand
    scatter(Mu(i,1),Mu(i,2),200,colors(i),'filled');
    %text(Mu(i,1),Mu(i,2),num2str(i),'VerticalAlignment','bottom','HorizontalAlignment','left');
    hold on;
    ind = ind+nb_ele(i);%on saute au classe suivant
end
