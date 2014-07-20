function [Y]=RMFa(X,Window)
%takes in a signal X and window size Window and generates a running mean
%filter of X (F) and outputs a running mean filter for each column of X(Y).

inc=Window/2;
[m,n]=size(X);
pad=ones(inc,1);
for(j=1:n)
Z=[pad.*X(1,j); X(:,j); pad.*X(m,j)];
F=zeros(m,1);
for(i=(1+inc):m)
    F(i)=mean(Z(i-inc:i+inc));
end
Y(:,j)=X(:,j)-F;
end
return