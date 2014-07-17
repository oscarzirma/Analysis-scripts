function S=makeCoordinatesv2(radii,angles8,angles15,struct)

k=1;
S=[];


for(i=1:length(radii))
    if(struct(i)==8)
        if(mod(i,2)==0)
            for(j=1:8)
                S(k,:)=[radii(i) angles8(j)];
                k=k+1;
            end
        end
        if(mod(i,2)==1)
            for(j=abs(1:8))
                S(k,:)=[radii(i) angles8(9-j)];
                k=k+1;
            end
        end
    end
    if(struct(i)==15)
        if(mod(i,2)==0)
            for(j=1:15)
                S(k,:)=[radii(i) angles15(j)];
                k=k+1;
            end
        end
        if(mod(i,2)==1)
            for(j=abs(1:15))
                S(k,:)=[radii(i) angles15(16-j)];
                k=k+1;
            end
        end
    end
end