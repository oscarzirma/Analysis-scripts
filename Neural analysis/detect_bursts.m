function [start, stop, spikes] = detect_bursts(s)
%given an array of spike times, this function will divide it into bursts, returning
%the start and end times of each burst as well as the number of spikes in
%each burst

minimum_inter_burst_interval = .005;
maximum_intraburst_spike_interval = .002;


sd = diff(s);

stop_index = find(sd>minimum_inter_burst_interval);
stop = s(stop_index);

start_index = [];

jj=1;
for ii=1:length(stop_index)
   k = stop_index(ii);
    while k>1&&(sd(k-1)-sd(k)<maximum_intraburst_spike_interval)
        k=k-1;
    end
    start_index(jj)=k;
    jj=jj+1;
end
start = s(start_index);

spikes =stop_index-start_index'+1;
