function x=freqsweep(cycles,frequencies,Srate)
%takes in the number of cylces, a vector of frequencies, and a sample rate
%and outputs a sweep containing those frequencies.


 t=0:1/Srate:((cycles*(Srate/frequencies(1)))/Srate);
 f=sin(2*pi*frequencies(1)*t);
 x=f;

for(i=2:length(frequencies))
    arp=(cycles*(Srate/frequencies(i)))/Srate;
    t=0:(1/Srate):arp;
    f=sin(2*pi*frequencies(i)*t);
    
    overlap=round(((Srate/(frequencies(i)*8))+(Srate/(frequencies(i-1)*8)))/2);
    %the overlap will be the average duration of 1/8th of a cycle between
    %frequencies
    
    index=length(x);
    
    
    x((index-overlap+1):index)=x((index-overlap+1):index)+f(1:overlap);
    
    x=[x f((overlap+1):length(f))];
end
return