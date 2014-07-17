function S=makeCoordinates(radii,angles,struct)

k=1;
S=[];


for(i=1:length(radii))
    if(struct(i)~=0)
        if(mod(i,2)==0)
            for(j=1:8)
                S(k,:)=[radii(i) angles(j)];
                k=k+1;
            end
        end
        if(mod(i,2)==1)
            for(j=abs(1:8))
                S(k,:)=[radii(i) angles(9-j)];
                k=k+1;
            end
        end
    end
end