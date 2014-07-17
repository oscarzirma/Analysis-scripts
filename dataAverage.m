function G=dataAverage(D,n)
%takes in a matrix D and averages every n columns, placing the average in G

s=size(D);
for(j=1:(s(2))/n)
    G(:,j)=mean(D(:,((j-1)*n+1):j*n),2);
end

  