%Partie 5 question 2
%cette fonction trace la courbe ROC pour une extraction donn�e
function [fpr,tpr]=ROC(extraction)
ideal = imread('01DR.png');
tpr=[];fpr=[];
for s_marquage = 0:0.01:1;
    imask = 0*extraction;
    imask( extraction > s_marquage) = 1;
    tp = sum(sum(ideal & imask));           % tp: # pixels o� r�ellement (ou encore id�alement on marquage
                                            %      est valeur 1 ET on a reussi � l'extraire cad = 1 en extraction
                                            % => correctement extraits
    fn = sum(sum(ideal & not(imask)));      % fp: # pixels o� r�element il y a marquage cad 1 en ideal
                                            %     alors qu�il est 0 en extraction
                                            % => non extraits
    tn = sum(sum(not(ideal) & not(imask))); % tn: # pixels o� r�ellement (ou encore id�alement) on n'a pas de marquage
                                            %      donc valeur 0 ET on a aussi rien extrait cad = 0 en extraction
                                            % => aucun marquage n�est extrait
    fp = sum(sum(not(ideal) & imask));      % fp: # pixels o� r�element il abscnt cad 0 en ideal
                                            %     alors qu�on a extrait cad 1 en extraction
                                            % => extrait alors qu�il est absent
    tpr = [tpr tp/(tp+fn)];
    fpr = [fpr fp/(fp+tn)];
end
plot(fpr,tpr);
end