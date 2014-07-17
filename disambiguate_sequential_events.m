function event2 = disambiguate_sequential_events(event,minimum_interval)
%accepts an event array, which is a vector of times, and will concatenate
%all times that are sequentially within the minimum interval to a single
%time at the center of the block of times. For example:
%minimum_interval = .1
%event = [.15 .2 .28 .4 .46 .8]
%event2 = [.21 .43 .8]

n = length(event);
start = 1;

j=1;

for i=1:n-1
    if event(i+1)>(event(i)+minimum_interval)
                 event2(j) = mean(event(start:i));
                % size(event(start:i))
        %event2(j) = event(start);
        j=j+1;
        start = i+1;
    end
end

event2(j) = mean(event(start:end));