function Events=batch_threshSpikes(N,thresh,Fs)
%A batch function to run a set of traces in the rows of N through the spike
%thresh program. thresh is in # of standard deviations.

inter_Event=.0004;%inter-event delay in s
pad = 8;%amount of waveform snippet to include in ms

[m n]=size(N);

for i=1:m
[Events(i).spk Events(i).wv]=threshSpikes(N(i,:),median(N(i,:))+thresh*median(abs(N(i,:))/.6745),inter_Event,Fs,pad);
end

return