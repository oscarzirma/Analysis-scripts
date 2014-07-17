function E = batch_detect_bursts(E)
%this function will detect burst in each E.spk and append three new fields
%to the E struct array: burst start time, stop time, and number of spikes.

for ii=1:length(E)
    [E(ii).burst_start E(ii).burst_stop E(ii).burst_spikes] = detect_bursts(E(ii).spk);
end