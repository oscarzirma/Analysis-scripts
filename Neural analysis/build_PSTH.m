function [t,psth]=build_PSTH(E,trigger)
%this function will build a sliding window psth centered at the trigger time point


time_step=.005;
window_size = .015;
start_time = -1;
end_time   = 1;
num_bins=(end_time-start_time)/time_step+1;
t=start_time:time_step:end_time;

n=length(E);
psth=zeros(n,num_bins);

for i=1:n
    x=E(i).spk-trigger(i);
    j=1;
    u=start_time;
    while u<end_time
        psth(i,j)=sum(x>u&x<=u+window_size)/window_size;
        j=j+1;
        u=u+time_step;
    end
end