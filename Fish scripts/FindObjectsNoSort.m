function [C]=FindObjectsNoSort(ImageArray,mn,mx)
%takes in an image array and returns a matrix with pellet coordinates of
%each frame. frames are in rows and pellets are in columns ([x1 y1 x2
%y3...]). Pellets are considered to be any particle with size at least mn
%and no greater than mx.

k=size(ImageArray,3);

C=zeros(k,2);

for(i=1:k)
    bw=bwlabel(ImageArray(:,:,i));
    r=regionprops(bw);
    
    r([r.Area]<mn)=[];
    r([r.Area]>mx)=[];%remove regions with areas less than mn and greater than mx
    
    z=zeros(k,2);
    
    c=[r.Centroid];
    
    n=size(C,2);
    m=size(c,2);
    
    while(m>n)
        C=[C z];%resize centroid position matrix
        n=size(C,2);
    end
    
    while(m<n)
        c=[c 0 0];
        m=size(c,2);
    end

    
    for(j=1:(m/2))
    
    C(i,:)=c;
    

    end
end


    
return
    
    
    
    
    