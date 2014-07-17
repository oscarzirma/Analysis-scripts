function compare_spike_rates_for_combining_datasets
%this function will compare spike rates to determine whether data sets are
%statistically indistinguishable (using t-test) and can be combined. 

[f1,d1]=uigetfile(pwd,'Select first spkr_for_comparison.mat file');

load([d1 f1]);

A_lo = stim_driven_spikes_loC;
A_hi = stim_driven_spikes_hiC;

[f2,d2]=uigetfile(pwd,'Select second spkr_for_comparison.mat file');

load([d2 f2]);

B_lo = stim_driven_spikes_loC;
B_hi = stim_driven_spikes_hiC;


[h_lo p_lo ]=ttest2(A_lo,B_lo);
[h_hi p_hi ]=ttest2(A_hi,B_hi);

display(['For low contrast, p = ' num2str(p_lo)])
display(['For high contrast, p = ' num2str(p_hi)])
