m = 10;
a = .2;
t = 1e4;
i = 9999;

d = (m + (2*a*m)/(1-a))*(t/i)^((1-a)/2)- (2*a*m)/(1-a);

display(['a = ' num2str(a) ', i = ' num2str(i) ': d = ' num2str(d)])