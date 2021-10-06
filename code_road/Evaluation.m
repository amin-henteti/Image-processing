function [ tpr,fpr ] = Evaluation( Soust,imask,imar )
%--fp: pixels où un marquage est extrait alors qu’il est absent--%
fp=0;
[l,c]=size(Soust)
for i=1:l
    for j=1:c
        if ((imask(i,j)==1)&&(imar(i,j)==0)) 
            fp=fp+1;        
        end
    end
end    
%--tp: pixels de marquage correctement extraits--%
tp=0;
for i=1:l
    for j=1:c
        if (imar(i,j)==imask(i,j)==1)
            tp=tp+1;        
        end
    end
end  
%--fn: pixels de marquage non extraits--%
fn=0;
for i=1:l
    for j=1:c
        if (Soust(i,j)==1 && imask(i,j)==0)
            fn=fn+1;        
        end
    end
end 
%--tn: pixels où aucun marquage n’est extrait--%
tn=0;
for i=1:l
    for j=1:c
       if (imask(i,j)==0)
            tn=tn+1;        
        end
    end
end 
 tpr=tp/(tp+fn);
 fpr=fp/(fp+tn);%on nepeut pas évaluer la dtection en se basent sur l'un des deux
end

