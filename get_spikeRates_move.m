function [SpkR t rF E] = get_spikeRates_move(Neural,tm)
%This program detects spike rates for each trace in Neural.
%Relative to the timing of movement
%tm is vector of movement times

thresh = 4;%spike detection treshold
highpass = 400;
epoch_dur = 0.2;%time in seconds following stim_off over which spike rates are calculated

n=length(Neural);

for i=1:n
    x=cell2mat(Neural(i));
    if ~isempty(x)

    r(i,1:length(x))=x(2,:);
    end
end
t=x(1,:)./1000;
Fs=1/t(2);

rF=batchhighpassFilter(r,highpass,Fs);

E=batch_threshSpikes(rF,thresh,Fs);


%%FIX FOR SAMPLE DELAY
tm=tm-.0105;

for j=1:n
    x=E(j).spk-tm(j)-epoch_dur;
    
    %get spike rate
    peristim=x(x>=0);%find spikes occurring following stimulus onset
    stim_spikes=sum(peristim<(epoch_dur))/(epoch_dur);%-baseline;%find mean spike rate during stimulus presentation and the following 100 ms
    SpkR(j)=stim_spikes;
end
