clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------Données---------%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%les points sont représenté par
%couple de coordonnées
%numéros
%la classe 1->A et 2->B
C = [1 3 1 1;2 4 4 1;8 3 3 2;6 5 2 2];%les points classées
nb_classes = 2;
ppv = 3;%nb des plus proches voisins à considere
%les points à classées avec numéro 0 à la 4eme colonne
%indique que le point n'appartient pas encore de classe
N = [6 3 5 0; 
    2 2 6 0;
    8 1 7 0;
    8 5 13 0;
    7 4 11 0;
    4 3 8 0;
    4 4 9 0;
    3 1 12 0;
    3 2 14 0;
    5 2 10 0];
%on trie les points puisque l'ordre influe le classement
[~,idx] = sort(N(:,3));
N = N(idx,:);
nb_N = size(N,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------algorithme K-PPV---------%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%on parcoure les points à classer
for i = 1:nb_N	
    %on extrait les coordonnées du point (x y) les 2 premieres colonnes
    coord = N(i,1:2);
    nb_C= size(C,1);
    dist=ones(nb_C,2);%varible qui va contenir en prmier colonne tous les distances 
                      %du point considéré (à classer) avec les points déja classé 
                      %et en 2eme colonne leurs classe associé
    dist(:,2) =  C(:,4);
    %on parcoure les points déja classés
    for j = 1 : nb_C 
        %calcule des distances euclidiennes
        dist(j, 1) =  norm(C(j,1:2)-coord); 
    end
    %on trie la variable dist par rapport la 1er colonne
    %et on change alors l'ordre du 2eme colonne
    [~,index] = sort(dist(:,1));
    dist = dist(index,:);
    %on extrait les voisins les plus proches qui se situe en top de dist
    %aprés la trie, et on s'interesse uniquement à leurs classes associées
    k_pt_voisin = dist(1:ppv,2);
    %on peut utiliser les differents cas 
    % if length(find(k_pt_voisin==1)) >=2 ...
    %mais dans le cas generale si on a plusieurs classes
    %on calcule le nombre d'occurence des classes 1, 2..nb_classes dans ces points voisins
    occ = zeros(nb_classes,1);
    for k=1:nb_classes
        occ(k) = length(find(k_pt_voisin==k));
    end
    %on cherche le maximum des occurences
    [nb,index] = max(occ); %on peut appliquer autre fonction que le max par exemple le mean
    %on incrémente les points classées en respectant la structure des données
    C = [C; [N(i,1:3) index]];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------affichage---------%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%on trie par rapport aux numéro de classes
[~,index] = sort(C(:,4));
sortedC = C(index,:);
colors=['r','g','b','m','k'];%pour diferencier les classes 
                             %je suppose qu'il ya 5 classe au maximum
                             %si on a seuleument 2 alors
                             %les points du classe 1 seront colorés par 'rouge'
                             %et les points du classe 2 seront colorés par 'vert'
%on calcule le nombre des points dans chaque classe
nb_ell = zeros(nb_classes,1);
for k=1:nb_classes
    nb_ell(k) = length(find(sortedC(:,4)==k));
end
%on trace dans une figure nommé K-ppv
figure('Name','K-ppv');
ind = 1; %variable pour sauter entre les points de chaque classes
for i=1:nb_classes
    %on extrait les points du meme classe
    CC = sortedC(ind:ind+nb_ell(i)-1,:);
    X = CC(:,1);
    Y = CC(:,2);
    label =  num2str(CC(:,3));
    scatter(X,Y,'filled',colors(i)); %'MarkerFaceColor',[.3*floor(i/4) .8*floor(i/4/2) mod(i,2)]); %si on a plusieurs classes
    text(X,Y,label,'VerticalAlignment','bottom','HorizontalAlignment','right');
    xlim([min(C(:,1))-2 max(C(:,1))+2]);
    ylim([min(C(:,2))-2 max(C(:,2))+2]);
    hold on;
    ind = ind+nb_ell(i);%on saute au classe suivant
end
