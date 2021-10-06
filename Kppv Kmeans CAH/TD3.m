clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------Données---------%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%les points sont représenté par
%couple de coordonnées
A = [2 0;
     0 1;
     0 2; 
     3 4;
     5 4];
 A_init = A;
 n = size(A,1);
 %initialisation vecteur poids
 p = ones(n,1);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------algorithme CAH---------%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 while n~=1 %il reste plus qu"un element dans la liste des points/ou classe
     W = 100*ones(n,n); %evite le zeros comme minimum
                        % 100 est arbitraire
     %on calcule la matrice de distance par l’écart de Ward
     for i = 1:n
         for j=i+1:n
             W(i,j) = (p(i)*p(j))/(p(i)+p(j))*norm(A(i,1:2)-A(j,1:2))^2;
             %W(j,i) = W(i,j);%symetrie qu'on peut ignorer
         end
     end
    [~,idx]=min(W(:));%on cherche le minimum de cette matrice
    [min1,min2]=ind2sub(size(W),idx);%on prend le couple qui réalise ce minimum
    %calcule centre de gravité
    G=(p(min1)*A(min1,:)+ p(min2)*A(min2,:))/(p(min1)+ p(min2));
    n = n-1;%décremente le size de la liste des points A
    %on ajoute le centre de gravité et son soids associé
    A = [A; G]    ; p = [p; p(min1)+p(min2)];
    %on supprime les points et leurs poids associé remplcé par le centre de gravité
    A(min1,:) = []; p(min1) = [];
    A(min2,:) = []; p(min2) = [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%----------affichage---------%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%on trace dans une figure nommé K-means
figure('Name','CAH');

colors=['r','g','b','m','k'];
X = A_init(:,1);
Y = A_init(:,2);
%label =  num2str(AA(:,3));
scatter(X,Y,'filled',colors(1)); 
%text(X,Y,label,'VerticalAlignment','bottom','HorizontalAlignment','right');
xlim([min(A_init(:,1))-2 max(A_init(:,1))+2]);
ylim([min(A_init(:,1))-2 max(A_init(:,2))+2]);
hold on;
scatter(G(1),G(2),'filled',colors(2)); 
