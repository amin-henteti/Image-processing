function [ ug,vg,disp ] = Appariement( imaG,imaD )
ug=[];
vg=[];
disp=[];
for i=1:258
    for j=1:330
        lg=j-2;
        ld=j+2;
        if lg<1
            lg=1
        end
        if ld>330
            ld=330;
        end
        for x=lg:ld
                if (imaG(i,j)==imaD(i,x))
                    ug=[ug,i];
                    vg=[vg,x];
                    disp=[disp,abs(j-x)];
                end
        end    
    end
end
end

