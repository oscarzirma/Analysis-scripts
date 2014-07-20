function mr=realign_markers(m)
%this program will realign markers, switching them back when they jitter.
%input is a trace of markers from a single trial.

[len dim mar]=size(m);%len is length in time of marker array, dim is the number of dimensions (i.e.3), mar is the number of markers

mr=m;

for i=1:len-1 
    for j=1:mar
        if(abs(mr(i+1,1,j)-mr(i,1,j))>.05) 
            for k=1:mar
                comp(k)=sqrt((mr(i,1,j)-m(i+1,1,k))^2+(mr(i,2,j)-m(i+1,2,k))^2+(mr(i,1,j)-m(i+1,1,k))^2)
            end
            [y ind]=min(abs(comp));mr(i+1,:,j)=m(i+1,:,ind);
            
            clear comp
        end
    end
end
