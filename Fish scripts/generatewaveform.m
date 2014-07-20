function W=generatewaveform(Duration,Cycles,Frequencies,Amplitudes,Samplerate)
%Generates a waveform that is the sum of sine waves, each of which is
%modulated by a gaussian. If cycles=3, the waveform will have 3 cycles in
%it.
%the duration is the total length (in seconds), frequencies is a
%vector of frequencies, and samplerate is the sample rate in hz. The
%program also aligns all of the sine waves before modulating them and
%adding them so that they all peak at the same point in time (phase is
%aligned at maximum amplitude)

t=(0:(1/Samplerate):Duration);%set up time vector
mid=round(length(t)/2);%mid point of t

R=zeros(length(Frequencies),length(t));%set up raw waveform matrix
M=zeros(size(R));

for(i=1:length(Frequencies))%generate raw traces
    x=sin(Frequencies(i)*2*pi*t);
    if(max(x)<1)
        x=x.*(ones(size(t))*(1/max(x)));
    end
    while(x(mid)~=1)%align phases of traces at the midpoint
        for(j=1:length(t)-1)
            x(j)=x(j+1);
        end
        x(length(t))=0;
    end
    sigma=1/Frequencies(i);
    g=Amplitudes(i)*exp(-(t-t(mid)).^2/((Cycles/3)*sigma^2));
    y=x.*g;
    R(i,:)=y;
   end
W=R;