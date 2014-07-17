function [F,Y]=RMFa(X,Window)
%takes in a signal X and window size Window and generates a running mean
%filter of X (F) and outputs X-F (Y).

inc=Window/2;
pad=ones(inc,1);
n=length(X);
Z=[pad.*X(1); X; pad.*X(n)];

for(i=(1+inc):n)
    F(i)=mean(Z(i-inc:i+inc));
end
Y=X-F';
return