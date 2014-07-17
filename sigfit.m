function [coeff x y]=sigfit(X,Y)
%given x and y values, will return a sigmoidal (logistic) fit

x=0.1*X(1):0.1*X(1):10*X(end);

%f1 = @(a,x) (a(1)./(a(2)+exp(a(3).*x)));
f1 = @(a,x) (a(1).*x./(a(2)+a(3).*x));

%a0=[max(Y) 1 -1];
a0=[max(Y) .01 10];


a=nlinfit(X,Y,f1,a0);

coeff=a;
y=f1(a,x);
