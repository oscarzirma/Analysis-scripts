function N_no_dupes=remove_Dupes(N)
%Takes a matrix containing individual traces in rows and removes
%consecutive duplicate rows.

j=1;
[m n]=size(N);

for i=1:m-1
    if sum(N(i,:)-N(i+1,:))
        N_no_dupes(j,:)=N(i,:);j=j+1;
    end
end

return