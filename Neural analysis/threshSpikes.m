function [spiketimes waveform]=threshSpikes(trace,thresh,interval,Fs,pad)
%input a voltage trace and a threshold and returns 'spikes' found at
%threshold crossings. interval defines the minimum distance between spikes in s.
%default value would be .005 s. Fs is sample rate in samples per second. Find
%only positive spikes. Returns a matrix containing the waveforms surrouding
%each spike at pad samples.

f=abs(trace)>thresh;

waveform=[];
j=1;
k=1;
spk=[];
while j<length(f)
    
    if(f(j)==0)
        j=j+1;
    elseif(f(j)==1)
        spk(k)=j;
        k=k+1;
        while((j<length(f))&&(f(j)==1))
            j=j+1;
        end
        j=round(j+interval*Fs);
    end
end

spk=spk./Fs;



for i=1:length(spk)
    in=round(spk(i)*Fs);
    if(in-pad+1<1)
        in=pad;
    elseif(in+2*pad>length(trace))
        in=length(trace)-2*pad;
    end
    waveform(i,:)=trace(in-pad+1:in+pad*2);
end

spiketimes=spk';

end