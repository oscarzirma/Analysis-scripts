function [SpkR son soff t rF E] = get_spikeRates_REC(REC)
%This program detects spike rates for each trace in Neural.

thresh = 5;%spike detection treshold
highpass = 300;
epoch_dur = 0.15;%time in seconds following stim_on over which spike rates are calculated

n=length(REC);

for i=1:n
    x=REC(i).Neural;
    if ~isempty(x)
%r(i,:) = x(2,1:14000);
    r(i,1:length(x))=x(2,:);
    end
end
t=x(1,1:length(r(i,:)))./1000;
Fs=1/t(2);

rF=batchhighpassFilter(r,highpass,Fs);

E=batch_threshSpikes(rF,thresh,Fs);

[son soff]=photodiode_stim_times_REC(REC);

%%FIX FOR SAMPLE DELAY
son=son-.0105;
soff=soff-.0105;

for j=1:n
    x=E(j).spk-son(j);
    dur=soff(j)-son(j);%duration of stim presentation
    
    %get spike rate
    baseline=length(find(x<0))/son(j);%baseline spike rate before stim onset
    peristim=x(x>=0);%find spikes occurring following stimulus onset
%     stim_spikes=sum(peristim<(dur+epoch_dur))/(dur+epoch_dur);%-baseline;%find mean spike rate during stimulus presentation and the following 100 ms
    stim_spikes=sum(peristim<epoch_dur)/epoch_dur;%-baseline;%find mean spike rate during stimulus presentation and the following 100 ms
    SpkR(j)=stim_spikes;
end
